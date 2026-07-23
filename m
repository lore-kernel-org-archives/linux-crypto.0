Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52D13B42E0
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 09:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798458; cv=none; b=UE9qOMq/8q+StjkDDWbv2WmP3GrxD3C2EWiaY60I6W/+HhPSzIwx89cCIK6XPSOQQJGRy6kk39eTk2a8xFr1fN+j59gzCsWhsagny1uc6kaDr5bJR0PpVDPSZRm4iB1JDGc4UDxmymL0aGdQzaicxZJV40rcnsOdp7yzq6KG6sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798458; c=relaxed/simple;
	bh=Ua5UAJT40e/0GEzjCwqx4EwOBnaqa4Dvcx7XveV6T1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LAacJ/DzKLsgeOxrIropURqGTVA1p7CFpXHj/kExqT5fav0GD22V5Y/DV6bHD1uW9TsAemHxRman/jlAA2M2rZZpDDVm7V9Oy++wVGD8WrkbNkju7wSY7Cjer3ppkpaFRwXwRu3Gu9CR7XrDHcaeli8tMuw2hPnkoI7zkgGNTiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RDocfRy2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KBNnoh1O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RDocfRy2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KBNnoh1O"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qX4k3261006
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 09:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lz7QXf+iBwT8QlIH9Oun8AGxaHA1wq8IUAehzHZTWo0=; b=RDocfRy2yCHEjccW
	RZsU+gVIqtmV1JA9knlL2qUoDyjx1MFmf4ZpdDgtcCPjCkD41+MaINpGGNqlssH2
	+RmCqQkCtNsfKC32m93P87q3wDV+LDgGF+Z0o4QaWHMltGFdL21fLRpZDlzauFXC
	ITws8oIBPGRDOjpHlJXTDMGYhCkRRLnR7REkcGMvmQ5r3mayMxGo9gP2+fL8cgmV
	Z1dSeukTeYYt02iGWv623uus3oOA3IZwhBqSbmORWl0Fu2ucPZ/owlrRo6jRBkjz
	Kv/Qggw2S/sze037UCDDCVLHPys0Bk3UshoaJP5hWMv2/77YZzunLT9ZY95mpTCD
	vFMC6g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkafw1du3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 09:20:53 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dff6253so2907825ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 02:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784798453; x=1785403253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lz7QXf+iBwT8QlIH9Oun8AGxaHA1wq8IUAehzHZTWo0=;
        b=KBNnoh1OepJ51gFeGzV51v3Pm/20EQBNNXnaRe2943hktt0R3cCRamdx+NyAWOtQTl
         tWAYg8esJmpjT3A6DPmaIANM6lUKfp8ebgF4clA/PqI7L/H9f+duBDYyuDtn+N4L20MN
         BPseUD1D+KLZ8BiOecbyBq5lu/nvfo5VNjKbKeuQPFV0n5/HpSw0jGjB6uB0K5Dh1oGd
         tyd1mM+1Rj3WkzKDmihsSt8qW0HKhSOf1xfTsouX7Px7gny4dXVx3/bRq0WpjxNJpY8+
         0TVZ908NhxMqfve/xqY+yAcdmx21jOuZet+B7YmLg4t9p9Mt5LQbP/ANtjf20aKiZJuo
         3Ofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798453; x=1785403253;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lz7QXf+iBwT8QlIH9Oun8AGxaHA1wq8IUAehzHZTWo0=;
        b=iedWmQja2193NIECyCV9sKjCA95sG2kI+lh5QY4YvAxaaHuHjMN2E5pIZhTyPnZC8G
         MKVDScP7QSGW6vci/2uNsmPEA3ecgdgKOOgwSSM9uFKKaWuEF61eMUqnn4fepqyfv+DV
         dNTucxhaBGz+J1wtfSfQY7NWQvn/7jf4jV0l6hWpZoGtfH5tE+dkgXRNNUncy3XiuOQx
         ws/qsJvaWhtS5KHbBCPp0ZGAEghcZAnsP6c8Yj/QEnmB9+5UMLWFkDkxkoUqKgykmDoH
         c9tNE1XnNQS1OlkVz7aEGXBD97NE21PM5NSZhv4+kD3IdKdGsS1/oBDn2V8SvX1tIaTA
         SIOw==
X-Forwarded-Encrypted: i=1; AHgh+RpLHyboXliE+VGbpK1rABL2G07GPXHiI2yReO8hPZwudorHW41k7Dh4e8Drc8Zgr3EYObGAvKOdjStPAj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiWSrxt8mX3gNpVbsV6C6aGra2nvEJ6/9fXL+tg+GNMdQOMfjP
	8D3G1QEKVmCgv8KL9eXn+bIexNeUsDV14SW1z2NJYpNRsMfIBcXgcOTeLgTpy2yB/XnvAQ8iOG+
	Oak68c2lDRlUWeExdD6Y4C2hhqodpW8CNqkjGOpJ0c1klR375R0FIxTahjmZ1+8gBG+Y=
X-Gm-Gg: AR+sD10U7F/oZKwX77A54A0ZRieBFuYK6CLThmIKz6YzRSd4d9tleK4LWn+a9y7ntJp
	cqxYN3qp4MELJxzdnIXeaKNwruyMOMj4Ow02I/zbKqGnqRWm8d2GjxcH2jAPxOMLGzUe7gw/Tu8
	w/z49x3EXZby1GA7wb3WES+pRDS1tBAU800PY6Z8RrAWB6Nyf3YzOXcx/8KdWQyWR4tb3i/2N9V
	a8JjFdMQ0OXCf1agmLvPgOLdE+rC+ay63QwT/1RGgvsWHpPxVLaFgoxDyvnfLXhVYvc+UmjRBnh
	gx43waMl1zE54OrtS1SyKeCnTGhGmBPtuEJ4ss++vrpVRDirsbFfAYEJGADnJVpxng+5o96SyKy
	7KBc6ZjkH7nxCeJ4nbHgX9wb8bnP2XDDR7HU=
X-Received: by 2002:a17:903:1c1:b0:2cf:18e5:1d18 with SMTP id d9443c01a7336-2cfa958568amr21289935ad.29.1784798453107;
        Thu, 23 Jul 2026 02:20:53 -0700 (PDT)
X-Received: by 2002:a17:903:1c1:b0:2cf:18e5:1d18 with SMTP id d9443c01a7336-2cfa958568amr21289495ad.29.1784798452670;
        Thu, 23 Jul 2026 02:20:52 -0700 (PDT)
Received: from [10.217.219.142] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f011570sm29930365ad.35.2026.07.23.02.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 02:20:52 -0700 (PDT)
Message-ID: <eb99f98a-db4b-40a6-9c5b-9f9eb6986d28@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 14:50:43 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 12/14] crypto: qce - Map crypto memory for DMA
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov
 <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-12-1be02deffda9@oss.qualcomm.com>
 <773715fd-823f-4564-ba42-c60bc8284b45@oss.qualcomm.com>
 <CAMRc=MdLMQgJsxAMXLBkZNWUiz9fYh0j=C5ErbFoDLV=VfPUzg@mail.gmail.com>
Content-Language: en-US
From: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
In-Reply-To: <CAMRc=MdLMQgJsxAMXLBkZNWUiz9fYh0j=C5ErbFoDLV=VfPUzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=XNkAjwhE c=1 sm=1 tr=0 ts=6a61dcf5 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=JVr4EG2OP6aRYF85f9oA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: ajWsvLO9IlCC38WpONspOtsxRhkNgbE-
X-Proofpoint-GUID: ajWsvLO9IlCC38WpONspOtsxRhkNgbE-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5MiBTYWx0ZWRfX5FymZkzJYcSh
 xpBH/Kh5BlSV/6q0ulqaIO0s934hnNepvrD7y3hE68UbN1eop2oGEJ8TX9uPnBqUMd5HnxdOMfA
 CsDiRySOUI8jFNtibi3h0OGUpwm83DQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5MiBTYWx0ZWRfX6xSf8E5PYsf9
 OYjWHOMn9vqKCBVm1Q+obaMaM2BnAZkrKRodzEpjjLExHh/1Zuh5m9l8y9X6FKam4pWYHFg8DkH
 miYB2S32Z7NujrnCAltv5JSCkDjfEPg44Wf4uBCS1LhEdOvke6FX+chiUqGaKUU/pPuzAiI93az
 Ui8X/KgaKYFB1p1AGaBBRkjTWYetxJ+S//+gM0w+iLJtRRAsOhjo9l5nINqHyYY6JBIymBRVljK
 eYithImNq7nuXfQ8XWfY6ybNxaJ3+Ec7emH7ztC5Whp3VE5rvHRHvEri7s0zexFpXtisV6GSP+K
 qPFBbWlvlAQuwACLmNmnF+PNoLSpNuX2q8wG3z9IzCJmQ0DiHrrCIbi+4U7xN8nKFqcWfjl9yay
 qhjMSA769fZLG7sZZwekr/UlcJ6D/1OA9/iM7IQZLspQPK8Z2jdRYtSHrW031kW5W2VG69+gASy
 wW9m8iLFiRhZSPRsKlQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230092



On 7/22/2026 2:47 PM, Bartosz Golaszewski wrote:
> On Tue, 21 Jul 2026 20:20:05 +0200, Mukesh Savaliya
> <mukesh.savaliya@oss.qualcomm.com> said:
>>
>>
>> On 7/21/2026 7:03 PM, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> [...]
>>
>>>    static int qce_crypto_probe(struct platform_device *pdev)
>>>    {
>>>    	struct device *dev = &pdev->dev;
>>>    	struct qce_device *qce;
>>> +	struct resource *res;
>>>    	int ret;
>>>
>>>    	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
>>> @@ -204,7 +213,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>>    	qce->dev = dev;
>>>    	platform_set_drvdata(pdev, qce);
>>>
>>> -	qce->base = devm_platform_ioremap_resource(pdev, 0);
>>> +	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
>>>    	if (IS_ERR(qce->base))
>> Would you like to add any debug/error log ?
>>>    		return PTR_ERR(qce->base);
>>>
>>> @@ -254,6 +263,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>>    	qce->async_req_enqueue = qce_async_request_enqueue;
>>>    	qce->async_req_done = qce_async_request_done;
>>>
>>> +	qce->dma_size = resource_size(res);
>>> +	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
>>> +					 DMA_BIDIRECTIONAL, 0);
>>> +	qce->base_phys = res->start;
>>> +	ret = dma_mapping_error(dev, qce->base_dma);
>>> +	if (ret)
>> Would you like to add any debug/error log ?
> 
> No, I don't think this is needed and at v23 this really is useless bikeshedding
> and doesn't add anything to the discussion and only delays getting
> this upstream.
> 
Okay, got it. Thanks !

> Bartosz
> 
>>> +		return ret;
>>> +
>>> +	ret = devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
>>> +	if (ret)
>> same here
>>> +		return ret;
>>> +
>>>    	return devm_qce_register_algs(qce);
>>>    }
>>>
>>
>> [...]
>>
>>

