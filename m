Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B4D3D34AE
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840940; cv=none; b=dYNp4nWEeqIrnrP/4T+SrIA1yfcOQ4xlmmC16XFkwRUiNnsOthFJGJ7Q/eoaqbb+Ho9UYcEBz5ExNf+1S/kKm87hdQHkE6d/ySTdJ4vjeYEl9D75/JHoi/6P9wsgPgrymQRVE/CuEaGI4+FhIcid4uPQhYeainZj5ywmcMm4efM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840940; c=relaxed/simple;
	bh=1Yz/EcUmW9zfWne8Xzd09ymy+W7uXt8JQ3e5p3N3gFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iir6a2FLuu493joWupZSNmv30iQqeXFAzhPkwvHtC8AA5yXS265hUEybJNc38uE/Nx88AGD8iww6V4GtmFMaD/eBCzgx1jfbbrDTUmyDhfTgYvx6AL+FK6xW3dxmTSFbMO3R1W3MyXbLTkbK/XfYrD74sO5CQrUGavI6fD/xrjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f4O24kUA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BUQBS6St; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f4O24kUA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BUQBS6St"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F5E4aZ1848041
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	79VlzIrGeomGTJq0ibBMeq77VXZ65QnBt/A7OAjU0As=; b=f4O24kUA34Vv7HOK
	RcRvTPqIziAR3TczZDBVZvIoVjJfDfjMQwX+3oc/9Q7mlNXg9frsIBZmcY/N+aZ9
	pzLmEhbWjAo49/b4dODJtzDGdt5gcOmsWFC7HZ//1I2LIcg2EVJwN/d6t7oCVr08
	0dIHF5m1Bb747di1bvKknY91SHo1gU4aFvYfHpDGMTqww8LGVqDhzYYmzzaOOTDH
	L5HXB/839pOiZlLgRTCiDg5KvYRbNV4h1JvGzq16YFxc/GRhvRcMlF7n3sWH3Ofe
	CIJcRmB9yMou5F4YzRv4dgmOuIkLv3mrD+UOSmDYPC5L2Q0+fy0i0Bt1BF7Ue7FE
	s/gxZg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1t2t42-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:28:58 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bd5b20aaa6so19911475ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778840937; x=1779445737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=79VlzIrGeomGTJq0ibBMeq77VXZ65QnBt/A7OAjU0As=;
        b=BUQBS6St+38pOFAxSOGIPtd5V3d5lJzMiM7KIyVb4FzG2rBtt69Yl9yQegAo5UlV7r
         b4jvPw+EFxt32gT9C23kXaVYo4zB8wx8RRcQxxrVcPvEKJaA4QFrosHHr6tYPZ7CfmcW
         GM/8hFTnsUdAWG2MdPd4HidsNUyOafjNNvRpnKY7QT/9fXbq1k9u/L/ml534Dakt+8Jb
         XPViAFBfoFB55vB9ghTtXtLZOvtlbNfc52o7rg+mSogNtoGs7cr40wdgJKZLM4QPc3RZ
         MUfa1yEjmXqdpa0y4R0iaYck2ZmMUJyKeLwsiJ8Gnq5Z+nWvGTd2QAgxceuFNdMl9wpM
         NOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778840937; x=1779445737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=79VlzIrGeomGTJq0ibBMeq77VXZ65QnBt/A7OAjU0As=;
        b=C0yYvWmuWVLkIQOahYmLe7TmTnX+NujQupwmqG2lV07olIXmQ5lunvkIQttA11Fbbf
         KLd1opnO/EoVLqe0qgsNhHh82/X+aJyyhxwIC8EJxvY919u9i45WpkQxAENSK97//Cyy
         Ym/jI3j5p0be4fUVzi1NV6CSvgjXb14jU2oqjoLkcsR3sRnBu89ZMYxUqdIQM41x32xP
         j32gHJJ2a559qG7oRRCOowqci4Ow8p5NuTSp/blYUHMp4IXyFWXm5UxgKgxjA/Rj86Go
         Nbs2VeAbUbyYT7xQ/l3pWUaJH3BXPNh9LqpT9nnf9Vq/Uu0zSotDEUw8ZaCnvw0aU+iU
         Sgnw==
X-Forwarded-Encrypted: i=1; AFNElJ8BnCOErq70vDyS1977RhzjK0TVNx4xiOO87EbBKycjl9wgM/4DZdzYnjH49uPEGrBRJ/+tQwTLd8Fd8IE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAn+YDyAWXKZElxnpL1DAJSCJ4OUiRGim3R9rcooSD7B2ked2r
	6pxhLXTBJZhbjsD9HX5x0H5nDK3dolBFshhlKH3V82vVImFVpKZOlTQfly0yTcUUG3ZOCn7P7OT
	zu9EUQiTG8TVgpTLh5/oRc/3jfCtMpxQ2pey7FP7jZwxF7j2X8P70pP9UCTv3Pzsx0zo=
X-Gm-Gg: Acq92OFxHKCC9aA8ohntpW+VEcQEUgg9vq2HBtxoRto3/PcZRn3H3usI6rlmA7EvbLI
	XBNqapc66U3xs4AtUg/GJgAY9Z0Aq07NGkWc96AYj6gzr3LT3MYfZ91Lk4KO9i731SXMl9nxCUH
	IcVRU7i0BK5x6ygJUISrwZN1TU6Umu5pP+huyB/OArBZvGFNXctq3NrmrqpI/apJByD33YZ+les
	Dd2hLL4gi7puCg9f85tDB46q7/uxGBokJQAFS72jPXu3GQBdKoFqmVpbWoHv7sBMkXB5EUmhFZ8
	BR/dCMLMrvUXr+/iZVAUxdE+xqfh1nR6+3HOP7YB6z0xx5isUBcNFWamSCj6tKn4UvGtbZZn7YQ
	j+wrOtqyQ0z4FjSneTpVJa/qyim+xwzHsmjDaE819PEuHJvvuF5ChmbJo6M5xRNk=
X-Received: by 2002:a05:6a20:918a:b0:39b:e321:67ea with SMTP id adf61e73a8af0-3b22ecac1eemr3942668637.45.1778840937348;
        Fri, 15 May 2026 03:28:57 -0700 (PDT)
X-Received: by 2002:a05:6a20:918a:b0:39b:e321:67ea with SMTP id adf61e73a8af0-3b22ecac1eemr3942638637.45.1778840936857;
        Fri, 15 May 2026 03:28:56 -0700 (PDT)
Received: from [10.217.222.91] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb062941sm6648770a12.2.2026.05.15.03.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 03:28:56 -0700 (PDT)
Message-ID: <54fbc2bd-811b-4b35-987a-1dd5e6ea447c@oss.qualcomm.com>
Date: Fri, 15 May 2026 15:58:50 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: shikra: Enable ice support
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
 <20260515-shikra_ice_ufs-v1-2-b1b6ced70559@oss.qualcomm.com>
 <8ed6604f-f959-4b20-8b23-ded130426f36@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <8ed6604f-f959-4b20-8b23-ded130426f36@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=D7Z37PRj c=1 sm=1 tr=0 ts=6a06f56a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=iVyd5dlQVcev7GM2eQkA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEwNSBTYWx0ZWRfX474H2PG3zQVY
 nuQo2DtgCgQ8qloomvxmqdFMtWEqZfyaUikv+slC2ddiCxW1H5dM96WlSbRWBif80jbQii1kiu2
 VS8W0fUZqqi1Cf7ohkfvMannVb/C/UzYEX5td0rvCERM0rswBeXF0pxkJz5y/uVJiLdTzL+4/aL
 /ovx8r6dSt4MmsRzaDYAP+SD1E75rTO/yf563sGMDxVwHhUwEpbHOE8/J+zmVDqFi1jjwRDxEax
 vIb6Q++vD/71Bgn4SY9CjUnjui+f6kKivt/HLvnzbI17FFhP63L4jnyP86t6Gi9oQr+2FRNgppQ
 jXJEimSl0aClHrqfCiDTxZexDqLRaFaqSH0nF4j5lj6GU8HtH3IFD9XmFibNmvOIByW5ZXDUQ83
 wTpVhs/YJxcGnmOo3uYQJicUHR++COgd2Tq1mtf7R9spNKYy160Y9BopvY4Zf7N7cVVgic+f5gp
 GMFen0CDULvjB+GlsHA==
X-Proofpoint-ORIG-GUID: 3acHpSifvQfK204G3yQvZ2XphH6S3agl
X-Proofpoint-GUID: 3acHpSifvQfK204G3yQvZ2XphH6S3agl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605150105

On 15-05-2026 15:54, Konrad Dybcio wrote:
> On 5/14/26 10:30 PM, Kuldeep Singh wrote:
>> Add UFS inline crypto engine(ICE) support for shikra.
> 
> s/ufs/SDCC

My bad! Thanks for pointing.
I leveraged commit message and made this mistake.

Will send v2 with updated commit message.

-- 
Regards
Kuldeep

