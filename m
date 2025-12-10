Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370CB2222AC
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 07:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765350016; cv=none; b=U7oINtCh0rR5ewemsY9QPcNFiFeZG4A+1CDnitB99u2lLcqI2XOWBOFdnaz40g7pOkKS3Dr1d3EdpL/B/MZiKqlJpWzYuwGnoZmRY2kzFTHYgG89rR3UVWYagudS76n16rV7XtpP7xYSmnniYe8AaEgQRz2RCOYaNNC7DhHYqgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765350016; c=relaxed/simple;
	bh=rUmcIlJPM8NvWL3GHufkoMzIIX7U/SolxSRdXeA4icI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oi1+xP5wQgRGcDgopGdofMrYxVr0uG+FAHTmhlSY1B8nPkPQikBn3bSJRrjXsR/RjSUYq05j8cFA0c0Ix9ZiS33obR+pBtFPSgiukPGaMX5Qv/Y633Qri82A/HvQGhgDCk89IoCUjz58P278UibK/pUuURPanzyKIiIGI7LUDD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XUPv0jtC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HrioXzWE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XUPv0jtC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HrioXzWE"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA6Dnk12175660
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 07:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KXXmJgIAlrzTswFyFBD/MVsLVO8F+Y/m0cm8jzVc/lw=; b=XUPv0jtCs4KX7TBO
	5cYJgr4sw9J5U4//NDv6y7buEEi1zkCZSq/Hl4KEuDhH/qEuQdKXcua0zujMl2Kd
	/zaH8RXUfUfgkIEpBQiHZuT8WmE/v6i+Och37c28iepFzo8ITAdbyMwnliBZAORJ
	5b7et8FDsU6GpXnoSPbh24o0r8bhDg8Ju1+EK1gxrcs96UZKEE/ILz8SEEQkE+n7
	aNs8ZjSaITSBy3Wpin3CQuHnWVFd3F8MUW4m0UJe6TDrt8c0X9fbbonokPVrAm1D
	5l7v8TkX+4MLYjNZNeNkvGfBT+p1XysQEUBi3a2MZqKQnh67tEAKYXQyvsARJIYu
	5fhbuQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay1xwrc11-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 07:00:13 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34943d156e4so17032196a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 23:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765350013; x=1765954813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KXXmJgIAlrzTswFyFBD/MVsLVO8F+Y/m0cm8jzVc/lw=;
        b=HrioXzWEy3H9zl6mD7yg1vCWayPN9trHQ8ntUXZBTRkZw4SPT+bMvyiPRD2mbJZaVN
         9QyLfSFb9x7pLPKO8wb1S6P58tzIEOZxWyBCOC7VxCntd3su7CRkK2f2c3uMmfupzItq
         D5mVE5XnVcNDTMjJVNzI8ag8Lhk5ul+jZwZGXnbdaNKsrFU1VyTJDhyOuVsnWVbmZ4Oc
         hCdKZ6cXjfI4heorD4XqF1Nf94W57QWf1AVFwFRPQ7B3o3ADjXMic62xKczFTtubGDxq
         uPZTiSmMVT1/eCGgdpdNqgxpvt3emJiyIlcPOWAPdIFGLuBGbiE4gqDRFVOWQZVAakbn
         WoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765350013; x=1765954813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KXXmJgIAlrzTswFyFBD/MVsLVO8F+Y/m0cm8jzVc/lw=;
        b=GPsB0QVl6B4pFBJD1QPRLFnVsCrXT9K/ExiE45X7NjeR1WrgG8ZagwGD19tiMWj399
         Kgo8h7Xo7qB0WZXEzWHpXMmFjPeqt2ObfXqRttB/Jd14g8QrIRWMaWgW5gOyYU4U4sGa
         1uH+F+LRXGCWoEMfh2OA6qmvXI2DGNWVA/4+LsILa1HMXFg91ALSjq1OJnpDHLYNbtaw
         xW5hJTgm4+peIzJOMl7armqYz2XBsHo0KfTZeGT6Gums37FFn/xV4ATHFMUjfI8ud9oz
         b01sd+SDtFs4P3Q1CloXVBQq4OVxdA7F/DqT8GQxyzx//3rFRJxosKykFEk9h/Jg3Lok
         29UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZt1s/cQAy2rvK8+egLevPOD1aLNerZPDhwde5Ngp4gXg6wNM11COoKGONUuSI1ueRwUQl6ArgfQ4k9iw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Z8yw2z2vlhJz+q5WUMg/Z2jb9KvTb8o9M9aT+rT9BRXEDLAA
	JfKLMRzxqrQaD+IiS2pGHm9NfeHK/rf9pF07OMHhYXIHS4rOUz45h8JO2BSvGH/ulsrzSaii9Xq
	U7BzhlSAvj0XQJZB5jhrLVMf9VcpW39KGiWRWyNlfv29h8aq1vstmRU/yoWLnrKVuXm4=
X-Gm-Gg: ASbGncvc3UXUVp/5mhRSkTKXo0rMy3VjjaS5R8LFR2vGdI1enwYbimCwDfvYcQiBeX8
	dVzjNOtu9PW2KAl8crzsAsnlLHqkWiJXiSgl6Kh5wZFb39Ys/6Ws8oF1Cknt/1nCpU47pC7qsGk
	n95YnfBQmq60yMUqoVBP0xFx9dII8JlCelWHI/YXzyNZp5K3Ln1a8OElDTlz060CSATHOwslwTa
	b9Yp7N4uymLDrt+852DveEk42yZqZxZp5+3apiuXZbn9OHtRLYkOjMjhbvjyfy2ou08P+k/UT1d
	Bkhu5Kt1aaD/FetMExDeMSGkYplCf3u3e9vNKbjE+Q64CSIuEf1KBxdp/i1fAtUHb2lFnVLXhaZ
	/0p5tfo4OZC4WumJgHhQ9DEJ0TCQoa7ZziHI6spE=
X-Received: by 2002:a05:6a20:9148:b0:366:14b0:1a32 with SMTP id adf61e73a8af0-366e2eb8437mr1455326637.64.1765350012889;
        Tue, 09 Dec 2025 23:00:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWagaxJnC96AYCNL0/D8CTLUP5DQ6UVBIWEeINoy2090Julw4wBdbucvsVEIc65wrN36wFRw==
X-Received: by 2002:a05:6a20:9148:b0:366:14b0:1a32 with SMTP id adf61e73a8af0-366e2eb8437mr1455284637.64.1765350012439;
        Tue, 09 Dec 2025 23:00:12 -0800 (PST)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6a2d19492sm16643326a12.31.2025.12.09.23.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 23:00:11 -0800 (PST)
Message-ID: <e4a7b827-9687-4952-9625-16df3a2bdb8a@oss.qualcomm.com>
Date: Wed, 10 Dec 2025 12:30:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,prng: document x1e80100
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20251210-trng_dt_binding_x1e80100-v2-0-f678c6a44083@oss.qualcomm.com>
 <20251210-trng_dt_binding_x1e80100-v2-1-f678c6a44083@oss.qualcomm.com>
 <bd5e550a-bd31-4785-ae95-f14b28c6ff7f@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <bd5e550a-bd31-4785-ae95-f14b28c6ff7f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA1OSBTYWx0ZWRfX/5qQMuc943gd
 b17VVh7MtPicp0DgkEfG9y8zhUsmrRmiyVHEZ83kxjOoXNc+HlRbcdnurH6Fzv6QZTEuOhWaHgW
 VwTp1yu5xGoe7NIokdEBSL99+8RbUbbca7hIHR4fgJyfylH3AVkecSEHvRO+WbhvS/sKHhutNe8
 xOciJHcOuRGDdl/kUT2tvU7T5S+Ar0VD94+sYIVmKZWemOFmY2b9+iHtIx8ziK9dZ+RiWNkwB8l
 7JhU4Bn15Ba89BjGMnAIa1GJtZ6V6zsnc9pSqpt0zCi1KdRzeJdITeF6uDPj2dELAhY4eYL85vO
 Yt79zknTi2J7ot32qkifNWUwEuaR5hR0VnqsCW1LoBUJL5HTIrnpLInLRTv0a2/dDgBjLvOfmT+
 ty6zZtn2hxblFFEIIZxLKHtU1snVhw==
X-Proofpoint-ORIG-GUID: rs9hmLvE7jeYR0M6EpAUdchKZmW4faFe
X-Proofpoint-GUID: rs9hmLvE7jeYR0M6EpAUdchKZmW4faFe
X-Authority-Analysis: v=2.4 cv=F/lat6hN c=1 sm=1 tr=0 ts=69391a7e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=LOCgFY8hBHcYmJJ69lAA:9
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100059



On 12/10/2025 11:14 AM, Krzysztof Kozlowski wrote:
> On 10/12/2025 06:36, Harshal Dev wrote:
>> Document x1e80100 compatible for the True Random Number Generator.
>>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> 
> 
> How did you test a binding? To remind - kernel tools and make is not
> testing.
> 

Thanks Krzysztof, looks like b4 tool just auto-copied the tag to all patch-sets.
I'll remove it since there is no real 'test' for a DT binding.

Regards,
Harshal

> Best regards,
> Krzysztof

