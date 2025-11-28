Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA532693C
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764331321; cv=none; b=Q8vv+C1KQFLUMIeDOYGAwbWrNZWjtU46Y3/bB8xlNJ/s+NHI5Y8siopyxr0BupI4IhtrIMkHqwCvAWvipjpaRPEF6MOEgsrpIDnhsyN0KdVQrIKYvx94IDkLdn/OOfgppaw6uMU/c5iWChH4KS255fwoAPqM9Ai7TI/Z30yR4l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764331321; c=relaxed/simple;
	bh=ez6ZfBget/ZewewfGMj0lv8Jx9KTi+eO6/TTC4iDF2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HXgZeLHTiw6l3PTrVWvK7i8vU491kroTh0kGGae+81xHGHRLuoO+X0oXYIk6p3zSgnza+Y0UXrk3VV/HBXIuOuY71JwADjAhAgeaNViQsoDrXyMUv3zNlfvM0OjY3+0yZuTLAlR4BZ+Jx8/lL/azsumCCHpRiDABi0Fa898u/pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JXsQknLY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bAeNRBvR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JXsQknLY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bAeNRBvR"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS8O5Qa3476509
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dPCghTC+1R1BRMrdVA14dsXuUuNhg9EncFVCyRzjMJE=; b=JXsQknLY4lYccr1a
	Ah14v73Awx5xRA3ydzj1yzKZX9/zcB2u2JmYLblZCS7KwMh0ke3+dIdTl7Q22ZM9
	AHQbpV/20OIqIba1GlYVfClHecurNl9L3oQ+cS9JqM9QYOBmAmwnkTGIXxbRawif
	rBYIV74O+3S2EQDSw4q9v8THh0PW2kn0tCcmiGHRKL28Ghwd43qjgT+Ut2qSr/eG
	sQpvrmjG9Z6/PQE+++2DynW9LgGu7UcRBDZHkxwGLZR7CTqUg0dDhrydf0dU3I/C
	az9R/MMoSyXJhqqPqJgSGZtia0Tr4hRN0kWdOgFTA8QtwwGObh9IiBOyEB+nTwrw
	/d2yoQ==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aptpua9j5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:01:58 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5dbcf8b5a0dso196052137.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 04:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764331318; x=1764936118; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dPCghTC+1R1BRMrdVA14dsXuUuNhg9EncFVCyRzjMJE=;
        b=bAeNRBvRz37LT89zzldFOdLqhsilMPN5SGcmU1Qa1ejiXtAG5yQ1YxKMnOrVmyxe4L
         jeeF0/cx7ovp9lk3kAz2Pbg1y5vGWmN+5+xSLV7PWJjpSlbV91zdNYR9H2WnGEcAdJW4
         jta0SGY6inwBsnDE2IhqbzIgf34x9/w3ipDas5tbaopfragmydifBpSv9KgMlzhW5gYt
         cAYSzAJ/b98Bx+rLSS753SEgjSbdkHpThdsGauFPiR6b4GgZ5x1t8n3pa6VT12TJjy9k
         iaK5yz+fUq4LjX8QZfHZZYjXjkrblO5kXEvv9oa2uuZT14sm76wlYV0ymWjlOlENcIXz
         PKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764331318; x=1764936118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dPCghTC+1R1BRMrdVA14dsXuUuNhg9EncFVCyRzjMJE=;
        b=b3Wmu7LvCsuXg0jF9FPt5s4IvXy0u0rShC3E3V4KMQGhJ7isgpIHXb+ToShFjmckb9
         LkUVgiSkTdZpoGB1IFkaLigWxh0ZsxV7cB6iEAIxnATlM2gJPQ8hE8f2bmbsXEOoWKkq
         bFDSdr2eXDGR67lHedeVDDo27I2UdwfHcA0tC0eg+gyMWWNnGt+awU5z0EqeuYWHBDoO
         2sQgs9jm3TNyjLA/0UZHk2qw50k67eDZOgel/K+JUPFa1L3L/TqSWcMZcJpgVVNUCxpQ
         DuXYQje4TW/sE7gJMv5qOn2Ol7gtX4BgI2h7y3gJOpwFk1gwks+g4EaxDjQ2jYAnMGmv
         615A==
X-Forwarded-Encrypted: i=1; AJvYcCUJWPKdT3xrTIhCYD8cJIemgiX1dzeh3qSMF3Nmnw+iU33EC8hF6W0kWNWouYCKSxkw9JbafZUsZKhH/wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAREHI5zxrDU+00Gpj0JOlFxmA73pPBoCzHQspdv2OMNkizRKU
	CJjk3lJ7DXIZ3LQBdrTGw0MXgzO2uJ2F9j7cnvTHFgRjgCNKBh2Qulxzggiir5443LRWyla+NG4
	me3tuRmJDk3N6Mbc3H7EG389bUVx1i/bKfcxQKSQi0u4Q0NLBNlY4LMLwD/dWn8g3vXY=
X-Gm-Gg: ASbGncsJGuNHfIMXqp1FQrXkLXWry1cLaf6BtVkwa1b6pvPoehG8BfK+EUW5UWkDJEb
	iHjS35RfDwslyuDysfH/lkrRCpDPdmkXAXy1g/wu+vCx7/PUM6dspJe67nvP1Km4tAxMxCWxFY2
	+vJ6lWaJp5hz54DRDKxhaih6B/T9Mk3Ks7B82CSliffF1jBpdRAWXScOoVuNZB3pyP+/57R2Bwg
	4FnXQnWS8b9pWyWfZrmgoMNsMuQKQYdpdfRXxLvSYewdc0Q72rUVDg6mdXcXWchW5aADvXjDKdx
	NNDXE3OeALXMwd2HrTU39PRyweQ86qPhdSODZ8EwZPC8zKpW5RHupvo7W7Ed//Hxo1vm+YwTWuU
	vEWENMi1HvtCcRSIEkc04nwPf60npB9gAb0KIsnIJ2lA45QkmbRskSHGbTt+BbTbwjb8=
X-Received: by 2002:a05:6102:4411:b0:5df:9ae0:45e2 with SMTP id ada2fe7eead31-5e1de35e7b3mr4803439137.3.1764331317593;
        Fri, 28 Nov 2025 04:01:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEn3muLP/KsUJgciuhct1kPT54VeocYtfrXUW3eNc73Ai5lFIVKCQGnCEe+b0zevi9VvUlV/w==
X-Received: by 2002:a05:6102:4411:b0:5df:9ae0:45e2 with SMTP id ada2fe7eead31-5e1de35e7b3mr4803262137.3.1764331315925;
        Fri, 28 Nov 2025 04:01:55 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751035d4csm4018538a12.21.2025.11.28.04.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 04:01:54 -0800 (PST)
Message-ID: <b1d8234a-6d29-49f6-bfc7-bdc738895d79@oss.qualcomm.com>
Date: Fri, 28 Nov 2025 13:01:52 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/11] crypto: qce - Remove unused ignore_buf
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-5-9a5f72b89722@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-5-9a5f72b89722@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 4TAtd7UmDS0vDeFK6LEwXxxVrxkfImGC
X-Proofpoint-ORIG-GUID: 4TAtd7UmDS0vDeFK6LEwXxxVrxkfImGC
X-Authority-Analysis: v=2.4 cv=WIZyn3sR c=1 sm=1 tr=0 ts=69298f36 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jrMBgjXTAAAA:20 a=KKAkSRfTAAAA:8
 a=wXQIig4NBtMv4ZYXLh4A:9 a=QEXdDO2ut3YA:10 a=-aSRE8QhW-JAV6biHavz:22
 a=cvBusfyB2V15izCimMoJ:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA4OCBTYWx0ZWRfX70WbLVqcqjyW
 cZ/dmFwhhvCe/EaABa7xah6a6emAMK+Ju/+KyUvSGUNSIHSakBEcV5iyR73jHmOnbCz6gqcQyZa
 igs++2qCDE4ISe7Jx2imJvLUpPpZztTfmwp61VIPdT1JMPY80qGpXUGMUFRwp3zw7QmozL7mIeH
 Z+Q6DreRNV1b3XZAmYzPQ9ND//7XdZJ9ykA31WKcRcHxh459cEW4iruAM0xVarHZpL/OqpTHg3w
 491hzgGQJVQzjS8HlP4oVwF9Mo5ojCQizRdRRO4Mws/lFOhmUDeHtNuvGFjB8B0bVhlRV1roJ22
 66kIVaGnjXBuVpLy/l0ZzQRLJxIoHu8xW86wQU5qpWdAu7bVPZZpOfqcGBvuKyeKBUbXpnI5Ksd
 FZNuM+kvZ7cUmNdhGkkXOmY+EjJQ/A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280088

On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> It's unclear what the purpose of this field is. It has been here since
> the initial commit but without any explanation. The driver works fine
> without it. We still keep allocating more space in the result buffer, we
> just don't need to store its address. While at it: move the
> QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
> compilation unit.

It's apparently used downstream, at a glance to work around some oddities

https://github.com/cupid-development/android_kernel_xiaomi_sm8450/blob/lineage-22.2/drivers/crypto/msm/qce50.c

Konrad
