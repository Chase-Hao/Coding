import requests
import json
import csv
import time
#from requests.exceptions import RequestException,Timeout
from multiprocessing import Pool

time0=time.clock()
url = "https://m.haodf.com/jibing/ajaxGetDoctorList"
header = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
}

def requrl(d, i):
    payload = {
        "diseaseId": d,  # 肺癌24，高血压44,冠心病45，脑梗塞1992，糖尿病33
        "nowPage": i,
        "pageSize": 20,
        # "options[province]": "北京",
        # "options[city]":"北京"
    }
    session_request = requests.session()
    # time1 = time.clock()
    try:
        result = session_request.post(url, data=payload, headers=header)
    except Exception as err:
        print(i, err)
        time.sleep(2)
        result = session_request.post(url, data=payload, headers=header)
    # time2 = time.clock()
    jsons = json.loads(result.content)
    return jsons

def main(d):
    print(d)
    i = 1
    e = 0
    path = 'E:/python scripts/haodf/doctorId_' + str(d) + '.csv'
    print(path)
    jsons = requrl(d, i)
    while jsons.get('data').get('renderHtml') != 'blank':
        try:
            #time3 = time.clock()
            docLists = jsons.get('data').get('otherInfo').get('docListInfo')
            for list in docLists:
                #list = jsons.get('data').get('otherInfo').get('docListInfo')[j]
                info = (str(d), list.get('doctorName'), list.get('doctorId'),
                        list.get('doctorEducate'), list.get('doctorGrade'), list.get('doctorGradeEducate'),
                        list.get('cityOfHospital'), list.get('hospitalName'), list.get('facultyName'), list.get('specialize'),
                        list.get('attitude'), list.get('effect'), list.get('hot'), list.get('isAfterDeath'),
                        list.get('onlineAppointment'), list.get('voteCntIn2Years'), list.get('voteCount'))
                print('--正在存储', info)
                try:
                    with open(path, 'a+', newline='', encoding='utf_8_sig') as f:
                        csv_write = csv.writer(f)
                        csv_write.writerow(info)
                        f.close()
                except UnicodeEncodeError as err:
                    print(err)
                    info = (str(d), list.get('doctorName'), list.get('doctorId'),
                            list.get('doctorEducate'), list.get('doctorGrade'), list.get('doctorGradeEducate'),
                            list.get('cityOfHospital'), list.get('hospitalName'), list.get('facultyName'),
                            'specialize',
                            list.get('attitude'), list.get('effect'), list.get('hot'), list.get('isAfterDeath'),
                            list.get('onlineAppointment'), list.get('voteCntIn2Years'), list.get('voteCount'))
                    print('--正在存储', info)
                    with open(path, 'a+', newline='') as f:
                        csv_write = csv.writer(f)
                        csv_write.writerow(info)
                        f.close()
            i += 1
            jsons = requrl(d, i)
        except Exception as err:
            e += 1
            print(e,d,err)
            i += 1
            jsons = requrl(d, i)
            continue
        #result = requests.post(url, data=payload)
        #print("初始化时间：",time1-time0,"--请求时间：",time2-time1,"--json时间：",time3-time2)


if __name__=='__main__':
    pool = Pool(5)
    print(1)
    pool.map(main,[24,44,45,1992,33])