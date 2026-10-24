Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792849572;
	b=A1PI4FMbPsS7A8UPEBKMGXMzrcUOgfwTX2QLTHc+NRJok8fZRmgk0x5AdDuN+wZr79cY
	 n5+9n6qfljI7/FxFZu2wmB+amvDU1eDFBMazsNJJ6D9tBd3zq9OhD77zW5ViKTP5mDz8u
	 WPcCw8POCzHF6cJ/tCKMpxJeJHgF77cSAT0CvC6Ur01yE05FoJQd2jXqWKqp8V7mRqOTU
	 JrZ/1hl4ga1ZdLkJMuExjfPLW8yzb9h/+c4HR8JO9Nd7r/MjCXKqDJJMuMC595yHE6sDU
	 xpjALWI/U4q2frsKFU/aLVvCrPXIzTk5qpSb3zSvp9tRF9M8hlYrDcXGXr0N5UkzGBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792849572;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=fg0PYiPhEEa2RvF2n3hYUMcD35Bigy3qAux6hc+eWp0=;
	b=rLjtHbnwqQx4Indk1WfA9IO/ruAJoCngZumA6oT3Bro+1BgH/R/P6iGxs2et28khqFG3
	 9PJ3y+H3ChfoxefnulxGLEcG4O16TqDw4zm6Aw1Ilj0RcT23BieVyWKBu0KcqcxXoTcMl
	 MzoZJU7sFLMaunnvqv8LyRQeXILcw98W6wO81dp+UWZNaxq5Me2HEu78WtguPiCidnjhl
	 9R/2uHo0Bo5Xz333aBs1T9zjO6HMXA6qgfOGjatMNay1s20om+ZFIZTPwmBP3d3eQDDYH
	 0dDzcREG5v1hopnXHKknNc7EyJdpL9Il4eXMTQB7Nqr6xB1WJOT+SoAqF/ajk32lHNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CaYHtWgJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cNE9hJTa;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27CF606A31F
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27CF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CaYHtWgJ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cNE9hJTa
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69O8oNB6819848
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fg0PYiPhEEa2RvF2n3hYUMcD35Bigy3qAux6hc+eWp0=; b=CaYHtWgJNFOJxoy8
	xStFCKPun07V89l0j6nxgP2m4hPgi/CC4mqxiOIhpokVu34ezvxu7MbykzR9cW8A
	/qL9emOQcyy09hMcfYidldlPrnezvh26m1RTWOSGYLq5RfWM9d7yaXXAbHG5YeoG
	WCiqYNWRxpXyfu/k1vd6Tn7zgeOANpcMgJ3Yvfj1SKOde+q8+J+e7m9Yo6iMiEQh
	SEhRLJdupZeuIVUtKJPJswjhTYwyu4MDA93gjFsKg7w6lIAUPTDCKjuZCQAlFjoQ
	2C7QjYqkLXmv1JjI1el+dJqnKejlzOlrY0Ts6dTCAz4R9mGqap6l72ey7WSn73AH
	CJGYIw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgm0gh57u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:10 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35c902e0da2so3203330eec.1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792849569; x=1793454369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fg0PYiPhEEa2RvF2n3hYUMcD35Bigy3qAux6hc+eWp0=;
        b=cNE9hJTa8tw4HvhgqO3E+L26PNqrdrMGJAsxQPzjlW692xy8kAY+bExaFTCvZ/0Ok/
         HyEU0fN5SzMcVe3K9ekPLjwZBIxBjz2Zz0KA4W4c6jSFNfjV+iNc3ISpRXWfFb1LgdeM
         ND0jEv77QD+Fia4j7gItyCHDNgJ9tMm136P6swDNzT5VbmuFaUBwjf5mhQ5AU6fKKD7E
         H00FE09sEC9NMZj6ZM/CQiA9o2FObFBh5spVAjhVIuCYNijd+rIpZGgmMZTWDtbCUz2G
         mINtGHbzNgizeR5BOuayytB+rJi57sz1V9G3njViWALpddl2JXWjIqQ8bqfdZCOV7y46
         Tn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792849569; x=1793454369;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fg0PYiPhEEa2RvF2n3hYUMcD35Bigy3qAux6hc+eWp0=;
        b=ry/Cvuqo5HB+SEA69SpgtSdOyDN33Jtld/uLUjXa3yXrDaq6lFpmj5hZRegXka8ukb
         RveCqUQKJ0suBOqIK5aUmpVKQcG/coMpPdYDQ1hkWeb9d1l6HW9dxmjn0RzJVhPC162t
         jxQRE7lw46UL9Q2tw0YHzaPgjjZ053HgPrAOVkypMrfFXvqGFAopFIagq6d82KOVb0Jj
         ayduWoxQ7vz4T5IktiJQE1yXSrpBk71k7FrH3/206eCtS1PvIa3mfPYI3U7yvzHSrGbm
         srV9x3EkBFPHrdi9zYUV8V4kqAHoAwosOm7bVWdikLRL1oSqka+tQcBGPquvQxBnB9od
         TTIQ==
X-Forwarded-Encrypted: i=1; AKwUvByyOKjb9iPTfVpO1er1W32jz0sp6aoZPN8w1G65h6j+EiHgEieJ8E+m0Y50E/nbg7QPRsT9Iui3es7Xw4Y=@vger.kernel.org
X-Gm-Message-State: AFq9FYKSapsGJTJncZbp3dv3RPtz5s/1k4F+wGExLQQm9P57zCSS6HIj
	Va6WEqkMkhPAyUj8cokZKcKx5z2V2kqZ65CXFXunVzifZOdFjhzAqRKN4QblU5a5kcDm0zJeMvW
	F4omKGwWinaRHk+hMl23q4I2BtIk9A+A/pJFNKpzUBUSBZxYRWRgPcM9QvxUVwjCGrXo=
X-Gm-Gg: AYBFou0h5bXig3hDxQznI5S/xuuikGCnXT1cDqzddzMqg4/p/aAZ0P4lzA1ui9BfLtD
	TutsmG5R4iXaqXdriNvLQuOTwJ/fF/lgMwua5dNQZGp+zGx5NvdQjPGeKeIuYjTNt/BLYhD11xx
	lMPqRU4oQfGLselx11+F/4/AUO403MlgALzZjYPmGnl1KOPhAGUJDiZl8cZIu5XxMJFFCKZVwH1
	Ib821LUquRuux5FpPIsOx2D7lh3QETucNx+xaUaQZDJNf3LkD32NcOON+/DIzLAdqzASv66a4tZ
	tOj4Wb5a4lhzhtN8+4eCyUMt2dgCdW1H7GHInzWSZFVz9/ItbcDFXDAvrZwooh+znxDrlC0LANm
	lo4csEt/Bmf8UOOv01JX2JzO7XWplbg==
X-Received: by 2002:a05:7022:51e:b0:14e:d0ba:75af with SMTP id a92af1059eb24-1994d8b728amr3780703c88.6.1792849569366;
        Sat, 24 Oct 2026 06:46:09 -0700 (PDT)
X-Received: by 2002:a05:7022:51e:b0:14e:d0ba:75af with SMTP id a92af1059eb24-1994d8b728amr3780649c88.6.1792849568780;
        Sat, 24 Oct 2026 06:46:08 -0700 (PDT)
Received: from [192.168.29.10] ([49.37.153.119])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0d98660sm7294224c88.9.2026.10.24.06.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 06:46:08 -0700 (PDT)
Message-ID: <c4fc0651-e9f4-49dc-a43a-6223e1ca9997@oss.qualcomm.com>
Date: Sat, 24 Oct 2026 19:16:00 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] firmware: qcom: Add a generic ICE service
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-1-b035be7aab0a@oss.qualcomm.com>
 <6b539621-20a4-42a4-bf1f-1fd58f803581@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <6b539621-20a4-42a4-bf1f-1fd58f803581@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: KNEXlATYh5qpx-2wOdyBcXExIRjqVSNw
X-Authority-Analysis: v=2.4 cv=UfTE26SN c=1 sm=1 tr=0 ts=6adcb6a2 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=hZ1hWxSZf3UX9FuxeSnJ0A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=vk6uEdKFTZbF_VcgUCgA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: KNEXlATYh5qpx-2wOdyBcXExIRjqVSNw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfX6HsiTTrHvoUk
 6Xvhs1gxBrsCAzohzcEuxRlZuFa2HFQweo0XG/eojfvjZ3Hmb1zb6+ClQYirQkTwyJ1N7vcZX3e
 vnDIRd+UvU0BAXdZbjC/zPbHLZo4xRWAmGLYcECBh0/Gyi0JHhAUkhy3icOJh9Gy9pUdSkeUKuH
 G7g0gJPH7Hghu5AaJyg5I/fXr2Ek1FreujdbPtZrT2dV50xLiUH/riZJma76XDWQC1rKNvDVs2X
 tfbGjB7FtI/re/z9REA80aPPrM0WIPJmwXnHAfyN2Ljle1t8Ed2vcS2QkXSNfhJjYyRfa4Zq2V+
 eAbDTemYr6AjFhAGDCEbRycEBlXmuyRnfwRsUrqi6xTh8xHi7I6ABn65HtKHLmFgw0J2RVeY/OX
 VhdyWP7M0L2sw92J22ZNZ+wdoM24qF4gIj4IEvfR1JvdympiFO4R6OH2nZ9kYyhyBfFcgdkXMoI
 9DdCTT+kBZxhDCeM6gg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfX+6UYXpiH3lQR
 gXMCrazXc2Ou8tSKv8Lqa+vkn+ENJDau5qJg2C008yOGE1coiIOL2vIhRCSiP85V05yL5hIPeiM
 Axd84sWQJvmuTdpJpm1GVHDwFKT4Ukc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-24_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610240054

Hi Konrad,

On 22-10-2026 01:15 pm, Konrad Dybcio wrote:
> On 10/21/26 5:43 PM, Harshal Dev wrote:
>> Qualcomm platforms such as the IQ-9075 EVK now boot with both QTEE and
>> OPTEE. However, the Qualcomm Inline Crypto Engine (ICE) driver
>> currently only makes SCM calls into QTEE. With the arrival of ICE
>> support on OPTEE for Qualcomm platforms, there is a need for a generic
>> layer which re-directs the call to the correct TEE at runtime.
>>
>> Add a generic ICE service which acts as a common layer with different
>> TEE backends plugged in whether it's an SCM implementation or a proper
>> TEE bus based implementation (such as for OPTEE).
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
> 
> [...]
> 
>> +bool qcom_ice_svc_ops_registered(void)
>> +{
>> +	/*
>> +	 * The barrier for ops_ptr is intended to synchronize the data stores
>> +	 * for the ops data structure when client drivers are in parallel
>> +	 * checking for ICE service availability.
>> +	 */
>> +	return !!smp_load_acquire(&ops_ptr);
>> +}
>> +EXPORT_SYMBOL_GPL(qcom_ice_svc_ops_registered);
>> +
>> +bool qcom_ice_svc_available(void)
>> +{
>> +	if (!ops_ptr)
> 
> Should this also be a barrier read?
>

It does not need to be. The client (ICE driver in this case) should always
call qcom_ice_svc_ops_registered() first before calling any other function
exported by this ICE service. That's the contract. If that is followed then
ops_ptr always contains its actual value (either NULL, or pointing to the
TEE or SCM driver back-end).

We could use a barrier here, but then we should use a barrier in every other
exported function here as well, which feels like an overkill.

Let me know if any concerns.

Regards,
Harshal
 
> Konrad

