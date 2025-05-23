Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2A021CC6D;
	Fri, 23 May 2025 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012423; cv=none; b=QVr/9EX4p5MeMePx5XYUzPa265PFTyWjs4S8bvYTdQtASsAUKDfCvF5/9kbvL8AZKNg04SVV9gbbDeP9JwQno3Jx0rc5bbbOHzDNFZvKin5JQVDg1NqZtlSq6RnPUf278JeWJ1szhGwrJeXWn6aX5HCFOV5oSbaBtHhdwm6Ye7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012423; c=relaxed/simple;
	bh=T9/tAeP4YKdYCP4h29Es2EdUCCgZ+08Jf1BmwbD9Q2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4A6QEC0O5oEjR1L5laPe4wkOU4ot4BUCRielW5X4xW2c9eORiWEBhsbfSljdF26pQWWEzmNF5QyUpX8s0woeMU9zi0PoobRXt4i0ww0J2W2MACeQclkXIYgKBgOvbdd3zdYVTWOq5Rbdr+1p0mEwdkTLT7NB+igRCcbKZOhg+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WtPZFK/C; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WtPZFK/C"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NBeiwu009197;
	Fri, 23 May 2025 15:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RWEAJA
	GS38psiO/YoWeQbIFEFiVDlt71fPfC2rYyLzs=; b=WtPZFK/Cr0YuXrl9oFR9df
	KnzdJzav1AVYbJmQjsDu+Q5bUW/ZRLXDgPqAxp/cHGs/XyN+B00X4UigT54rL0FQ
	AtC8yEqTW1qMOIX9T6VHuoj52chpGzIEr3ve8sJ05EhTPJUSDqcY7/+ezYgGNHKZ
	R/tbxGWxSkI0CR7qe2cPLtZ/g9yEobyoGYpyXmAH7jTCuOI52yqG3/Q0+icYkp+T
	9CUutLAryTOmoHr+vCqw0kjTKnyW+EEZZAP3IwYThdX5gMZIGwSc1s45ZHGGLF1W
	uZFPE8UaY4MbhCuh0hpIaWnGkrfy/d/N/vgJWq4UgdKqtjixVEoZyNMdKvBleiQQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t55366t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:00:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NEsH0c024710;
	Fri, 23 May 2025 15:00:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkrf266-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:00:18 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NF0EqR10879458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 15:00:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 839C720040;
	Fri, 23 May 2025 15:00:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FB4E20043;
	Fri, 23 May 2025 15:00:14 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 15:00:13 +0000 (GMT)
Message-ID: <4506644c-9c96-4e8a-bdbf-55265bc44608@linux.ibm.com>
Date: Fri, 23 May 2025 17:00:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/6] s390/crypto: Add protected key hmac subfunctions
 for KMAC
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-3-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0fJdugjVTqhzTRrDpy6qzpfq2HsiVzLg
X-Proofpoint-ORIG-GUID: 0fJdugjVTqhzTRrDpy6qzpfq2HsiVzLg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzMCBTYWx0ZWRfXwOsJn0X5HD2o YqCj5rgDyioJKvPO/MqglvpCsHRrmeSSlvK0uk0rvjh4kqlyzGC0FVf8zzGxAXrtGA1ZMR/mcsx WRCKpld8tzVE9CYjYwGQLfKI9RtDARFXlW4CRIWeVHfpu+OjsZjMsmIWLgmAUSuw9NNJo0/q221
 WwnxBApp6+QPQ3SyLLuMc/GmcoclLETXU0FXJFd8G86ilCQ+hN+BPPyJuOOPy2t4u4w1D67oDRw QZ2Wkj3Xycsx2fz6G5qmozUYKB3k62XWNOyXe94drClsYH4w2Qklfz1WJNi0yvzSY/9g1BljdjE AlLi7d/q+BXKzh+WmUvNn2zzBC/TJGzN401StadgWjB0h1HOP5jqZso85yQeaRTPnBOH8shVSXj
 I2H/U2yMD/bUtWdr5HMJiOOiZ4SVtrsafofC5+2KGMIh9lYB2zbgVttXL+Yo+9pXHBHrjmDD
X-Authority-Analysis: v=2.4 cv=BOmzrEQG c=1 sm=1 tr=0 ts=68308d83 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=677
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230130

On 22/05/2025 10:57, Harald Freudenberger wrote:
> From: Holger Dengler <dengler@linux.ibm.com>
> 
> The CPACF KMAC instruction supports new subfunctions for
> protected key hmac. Add defines for these 4 new subfuctions.
> 
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

