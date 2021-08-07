from selenium import webdriver
from selenium.webdriver.chrome.options import Options
#添加sleep 延时执行函数
from time import sleep
#声明调用模拟鼠标事件函数
from selenium.webdriver.common.action_chains import ActionChains
#声明调用模拟键盘输入函s
from selenium.webdriver.common.keys import Keys
#定义一个打卡函数，并定义变量url用来接收传入的cookie
chrome_options = Options()  
chrome_options.add_argument("--headless")
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--no-sandbox')
#账号cookie
#获取chromedriver位置并使用chrome打开网页
url='http://bpa.lypt.edu.cn/xgh5/stu/index.html?/Zon89+k4+2hJnUj0YpTvF20aMhmGhJQhunhXShMLNtRyL9KQZmB3VkgMYT83O049WT8VL5OcNyE5IdO3bbgEf+2Bu0+HXGwZkQ+i6FN26vNAwqWATXckcUWg2REnGtnPfb1DlXADVFHqGm7uvhhcP2lmkJpTvBcShbFkNlBRDpzIMiUOoEsC3vnr43U5Wrla0wKT8kRvpn7EicKI73t+w=='
brower=webdriver.Chrome(executable_path="./chromedriver", chrome_options=chrome_options)
brower.get(url)
#网页预加载
sleep(5)
#更改打卡位置
brower.find_element_by_xpath("./html/body/div[1]/section[1]/div[1]/ul[1]/li[6]/textarea[@id='jzdq_xxdz']").send_keys("洛阳市洛龙区洛阳职业技术学院")
x=brower.find_element_by_xpath("./html/body/div[1]/section[1]/div[1]/ul[1]/li[6]/textarea[@id='jzdq_xxdz']").get_attribute('value')
print(x)
#获取勾选按钮值
mouse = brower.find_element_by_xpath("./html/body/div[1]/section[9]/div[1]/ul[1]/li[1]/label[1]/input[1]")
#首次点击取消外层覆盖
ActionChains(brower).move_to_element(mouse).click(mouse).double_click(mouse).perform()
#模拟鼠标移动到确认属实按钮并再次点击按钮
ActionChains(brower).move_to_element(mouse).click(mouse).double_click(mouse).perform()
#获取提交表单按钮
a=brower.find_element_by_id('tj')
#模拟鼠标移动并点击
ActionChains(brower).move_to_element(a).click(a).double_click(a).perform()
#页面缓冲时间
sleep(2)
#关闭页面
brower.close()
#推出浏览器
brower.quit()
