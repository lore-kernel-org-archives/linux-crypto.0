Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792945282;
	b=OWZZ1dERMayNvcp8GM+LW6dlrdHaptUW5WP2zlLwkGu8Yw2X8HPh0ivCa3F/pL5D+Qgb
	 E/9cqGWdJ965xvLkbcar5z0Pz9YxwAcshBtCRA2HIssQ/9QE3PA/eNmXnsHVTQXGoKxKl
	 gj487czVpaaVPhce1PjUl9+u5HQmg0HtxkhwHEhdxeCrIyh/vqwnUZCI+yQNfWwojC/RD
	 +SiW4vpBamlPSj1xPCgXfJVJ1SUlGcOF6PXhf5UiBPrXCh8Eol2Dy3sStJEOtoNmp9y6p
	 pNCzwr6lYl+TKCGQZyqb52b2vJeLGFYBObg+8vD/Rg2hC+aHeNNhJIZoEKClQ+NeHVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792945282;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=73ZPodarEYb3e7DUBak9R1h+ccxHlOqbpZwPQev5M5I=;
	b=zmSodl9E0fTvZp5o2BVtsWJ74xIn26RCVxBfbvFVzFneSly74MqiSrr7ETu5gGlW67fq
	 mrD6+Q7xscp0pylENk2W9U2vEqgm7+pVBRQtJUKEVM5TDlyoEpEd+pOeGhZvtKa+PNxqg
	 anyAKjxYGiL/UX1I6f3MMSh+RZnfZ9p7ioqA8qTLJgQ2oYciCIOHixXTy0WXoSFiey3vE
	 iaLP+Ba/EE4kzecs2e+wrdNbcqH1c0t83MjSI0ROSy301aqfUGaAKv58TnDoVOkwN3aW1
	 5U4cIjMfpOJx0ligTMlKgm9wx/i803zvxQ4U9otRxC+jSSluU7nUKLXVxz3IZnytJPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oP9Qdc+L;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YUEQH8g0;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD91606A31B
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BD91606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oP9Qdc+L;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YUEQH8g0
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69PFjX6C658850
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	73ZPodarEYb3e7DUBak9R1h+ccxHlOqbpZwPQev5M5I=; b=oP9Qdc+Lcq869ppe
	qb1vpEuShHoPv9ei2TrG5it9ThELhu++oReJwGkGCB8rZe96vNFka9dWxVWbj/JA
	OA9lCYfFfgkCYOo0+RSxFi0ms5FFTED87bNKRS2PTxRZcBE6YnWnB9zHLf7dmIKU
	cziH0eTlsDu4k4kgk0SAKd3fSGkN5J/wjneZ1PLjp+eBz9pt2G92Ig+YuWfxKMLi
	w7zZ78WaVzT0gSAxq5/RYzS0u1tlzkO91GC9+qHlY/Hiy0xqa4A2tciVfIJP8QsQ
	IwdQXNbNnlkxKNd5YiFggHTUQacorNgSfW2Fw0ORPMukKUKUnKbhHc1EN2ngIPdu
	tHSBvA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgj1pbs7x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:21:20 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-154e9d2d94fso5713005c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 09:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792945279; x=1793550079; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=73ZPodarEYb3e7DUBak9R1h+ccxHlOqbpZwPQev5M5I=;
        b=YUEQH8g0Jui0rLijciwQbCjFHLRNOoTsqt3RRl5H7G0EMqUAhXiag0dOiQ7P+3VSQB
         /pIsoDAdaeGGEG0Ax8YxjqN9s1PaFkZQ/nVPGs4EywTXstGn5EILP4ktv0iDruaCHjRH
         Fpg1ZDSgwUgxuE8Lbmn0Uok3wnKJ97w++P/Th5Cf/JZxMDvAOecAbY1OBtXnOxjM8HiX
         KZiWDSVyWnCKt2+KtPTS0XVDZuiJIQtlNHyXbVcBw2pA3WHOofm7fpYYEUnLZTaTV3A1
         unn9FGmvKZzxk2j2vo5giplocGQe3gAa562vGLCAyTGcdv/4z/miP3YaF6vZO+nqltSI
         343w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792945279; x=1793550079;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=73ZPodarEYb3e7DUBak9R1h+ccxHlOqbpZwPQev5M5I=;
        b=0OesWv1uO4T+hLcKLlJKrgjdc2QoK5VuYQ5Q2ThUVUNFYfnK5tgHPRRZMLldc0pgAD
         92Uu3WNFdPaH9zIObAYpau7Ci0dyhDaffBJ6haSmhxf0KWugzYC+wLm7cXjGNz8jwflI
         vyNeXggrbEzVSTivNGW6ifYfc6jYsfDw0Wjr/rBGqv9KhoVq87TzH2uvNs72ud0vWjmV
         D2OLEuH91gf6HzlitmIrHxN/sodsex1xhZo6hKuYc7lprA4aJcsdnw95J6jbs4MEolan
         wHLuHxYhNw78Cr53qWERGF9D0kCyDF6dwlgqvBgckeYZl6Y0pjrW0JIYiOCHkPHTu/U1
         XJZw==
X-Forwarded-Encrypted: i=1; AKwUvBzTHqEhaboDxy33KQ5cSXnsGix8i1kF1W4+q058LhrN2dbrHNmwG8GJsmMezDGHnkG5Bp0oZnBNItuoprw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJNixmftuPekSmXTMUSiz6b/W4eUvIYcL/H/iPTjrQHe96v5OIe
	utcL1H3muVQjkOrTyOaWEcq6rgdS4EKvkvvU523WB3GXQRnt1Yrk943eQRBvaMe/if4PDweVEpQ
	Jc0uiykO4ZTdlk0HGXKh+Mjb9kOYxyLrw9woLF/Q6gTLZSUuxxWgJxhHMpXLALqveQXc=
X-Gm-Gg: AYBFou1mHbNkjCEO6rfDCHiftwR1iCUY6y3inTqZCkV0P8F2YT74uLgvTEm2p0e1PmE
	slpe3sEPiu91IFXk8SjYkEW4uN+y0769gac78hbWu1H5Sg3RkdSnFSQhaLRz8jFxio7ObyA35Cx
	G3dR9saOjfQdlQXr5pwEJiKJOH65lLgASZ3HWhFH8cdL4vJJH4RDf9M+My/VE8p13LqGxVdS9N0
	16VJFh1MsWQ5vWZp/japSmI1BsA2npPWiCK0u5Whx/kFGFnFiNvFbv2FJwgZCy5bYE0h0pqw9ei
	DBROh+9OBqAIBSKe+FCmDsgpAn4MOdON0E0q6CanOM9rGekdu8gZvqJZZqqHYf62dMhpkPvANZX
	tg4xRfitE6ElMi8J6mYyjQ6l+jBPwKA==
X-Received: by 2002:a05:701b:4544:20b0:190:f24b:9491 with SMTP id a92af1059eb24-19b5804d78amr4459203c88.12.1792945279277;
        Sun, 25 Oct 2026 09:21:19 -0700 (PDT)
X-Received: by 2002:a05:701b:4544:20b0:190:f24b:9491 with SMTP id a92af1059eb24-19b5804d78amr4459173c88.12.1792945278640;
        Sun, 25 Oct 2026 09:21:18 -0700 (PDT)
Received: from [192.168.29.10] ([49.37.153.119])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a2a5a515sm15581495c88.19.2026.10.25.09.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 09:21:18 -0700 (PDT)
Message-ID: <da0ad591-7111-4e8f-9d31-3466f6b93ff7@oss.qualcomm.com>
Date: Sun, 25 Oct 2026 21:51:12 +0530
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
Subject: Re: [PATCH 3/5] firmware: qcom: Add an TEE bus based ICE back-end
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
 <0b389532-a917-49fc-a827-3b90d3ffd95b@oss.qualcomm.com>
 <48e7d80c-ddd3-4a53-82d8-588c3c439709@oss.qualcomm.com>
Content-Language: en-US
Organization: Qualcomm
In-Reply-To: <48e7d80c-ddd3-4a53-82d8-588c3c439709@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI1MDA2NSBTYWx0ZWRfXyyQeH1yqY0KR
 JJzAAFVR/EakEmUpJSf6wAR/9bz0b4HoD/qbxuiMebPNbTC2LxjnLKy7M/PyLFNLj8cc64P5XhA
 abJw7i2Psg+NDFhWH6d1yBUTQgKNQq8=
X-Proofpoint-GUID: WR3hm2Amyo4-vDi9HX7iNaXaumHWGqDR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI1MDA2NSBTYWx0ZWRfX2PbAMDkOmoL8
 rH2yk4CX2Bti3wW6+MDH29MaqzSYCXX95zWjdaXdgmQaFrx5Bea8wF6AzIvEjB/uImQK1RyUsb9
 2Rq3vzVTI2DqTvL+6nslnIyqGkKm7E9ZRQavMP6NIK14a9xwZyCMwYvr7jFBRhqz1GIYjPRsEm0
 ZD5y0iUx/O3h6WBfrhfTjv36ryszq5eGJFJDTxXv4YmMeoJvG2O3unlAwmFktgmcFhiphCvx6dV
 Of3wYjmJzt/LWVhPegIC6HqnZVJDyqKmCEcICfDgSUHzb9YIAeQAkFnM9bZ4uUCNbSB1M54o02T
 S7ecwAlgSXVyRTZ5qUUcCOLsBDakBx3xM1vQtJMy9GOUWf71rYWVyKZNCL9lH2K5jItubYQAcdy
 MN/fDpK9qr8AF3k//hkcXZvzLQeq78seYuXqcn+b1QM1+bTEnMmBFawntC8yHtoJzOMVfch3u5k
 ZwPQqTulTyOGSxDm7qA==
X-Proofpoint-ORIG-GUID: WR3hm2Amyo4-vDi9HX7iNaXaumHWGqDR
X-Authority-Analysis: v=2.4 cv=D5vSufRj c=1 sm=1 tr=0 ts=6ade2c80 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=hZ1hWxSZf3UX9FuxeSnJ0A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=ve44vtD2qhli23QWqmcA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-25_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610250065

Hi Konrad,

On 24-10-2026 07:16 pm, Harshal Dev wrote:
> Hi Konrad,
> 
> On 22-10-2026 01:21 pm, Konrad Dybcio wrote:
>> On 10/21/26 5:43 PM, Harshal Dev wrote:
>>> Add support for a TEE client driver which forwards calls from the Inline
>>> Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
>>> Psuedo-TA.
>>>
>>> The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
>>> Hardware Key Manager v1 is supported.
>>>
>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> ---
>> [...]
>>
>>> +	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
>>> +	if (ret < 0 || inv_arg.ret != 0) {
>>> +		dev_err(dev,
>>> +			"ICE generate_key failed, ret=%d, err=0x%x\n",
>>> +			ret, inv_arg.ret);
>>> +		ret = ret ?: -EINVAL;
>>> +		goto out;
>>> +	}
>>> +
>>> +	buf = tee_shm_get_va(key_shm, 0);
>>
>> This can return an ERR_PTR()
>>
>>
> 
> Ack. 
>>> +	out_size = param[0].u.memref.size;
>>
>> This returned size is not validated, there are a couple occurences
>> of that
>>
>>
>>
> 
> Ack, will fix in qcom_ice_tee_wrapped_key_call() as well. 
>>> +
>>> +	memcpy(lt_key, buf, lt_key_size);
>>> +	memzero_explicit(buf, out_size);
>>> +out:
>>> +	tee_shm_free(key_shm);
>>
>> LLM is concerned about freeing the key without zeroing the memory
>> first
>>
> 
> When the TEE invoke call fails, the TEE must not touch the out_buf.
> We trust the TEE to behave correctly, since it is a 'Trusted' EE after all. :)
> 
> When we fail after a successful call from the TEE, we must clear the buffer.
> I will check for returned size and ERR_PTR() and clear the out_buf in that
> case.
> 
> Ack. 
>>> +static int qcom_ice_tee_probe(struct tee_client_device *ice_dev)
>>> +{
>>> +	struct device *dev = &ice_dev->dev;
>>> +	struct qcom_ice_tee_private *data;
>>> +	struct tee_ioctl_open_session_arg sess_arg = {
>>> +		.clnt_login = TEE_IOCTL_LOGIN_REE_KERNEL,
>>> +	};
>>> +	int ret, err = -ENODEV;
>>> +
>>> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>>> +	if (!data)
>>> +		return -ENOMEM;
>>> +
>>> +	data->ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
>>> +	if (IS_ERR(data->ctx))
>>> +		return -ENODEV;
>>> +
>>> +	export_uuid(sess_arg.uuid, &ice_dev->id.uuid);
>>> +	ret = tee_client_open_session(data->ctx, &sess_arg, NULL);
>>> +	if (ret < 0 || sess_arg.ret != 0) {
>>> +		dev_err(dev,
>>> +			"tee_client_open_session failed, ret=%d, err=0x%x\n",
>>> +			ret, sess_arg.ret);
>>> +		err = ret ?: -EINVAL;
>>> +		goto out_ctx;
>>
>> Should we care about the specific retval that comes from the TEE?
>>
> 
> Traditionally TEE client drivers do not map the TEE error codes to kernel ones
> since a 1-1 mapping is not always possible. Also, since the ICE client driver whose
> calls land into this API via the intermediate ICE service would not know whether
> it is calling into QTEE or OPTEE, any error-code mapping we create here would
> possibly conflict with the ones returned from QTEE.
> 
> So returning a generic error code while printing the specific TEE error in the log
> helps keep things simple and easy to debug.
> 
> I'm open to any alternative suggestions.
> 
>  
>>> +	}
>>> +
>>> +	data->session_id = sess_arg.session;
>>> +	dev_set_drvdata(dev, data);
>>> +
>>> +	qcom_ice_ops_tee.dev = dev;
>>> +	qcom_ice_svc_ops_register(&qcom_ice_ops_tee);
>>
>> This can fail (but it currently returns void)
>>
> 
> Practically it can never fail because if the platform boots with OPTEE, QCOM_SCM never

[...]

> Hypothetically it could fail. If it fails:

[...]

> I can cover this hypothetical scenario by making the function return a failure which
> QCOM_SCM ignores but this driver interprets as fatal. But it could open another Pandora's
> box of compiler/static analysis tool warnings.
> 
> Let me know.

I'd like to backtrack on this one particular comment. I think it's better to simply
return a value as suggested by you and print it when it isn't fatal in the case of
QCOM_SCM driver. In the case of ICE TEE, I'll fail probe here when it returns error.

Ack.

Regards,
Harshal
> Regards,
> Harshal 
>> Konrad
> 

