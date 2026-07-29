Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA73AEF21
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312337; cv=none; b=mxfQ1MjPN9QPaFHy6PBIiF+0zD+rzcvhSSBnW5/jYEwaAj0v6niC/myGtw0IF/K+TBZOUEhha5I/x5FfxIknYsD/RQ0g2zHfLNP9s8PRkJRJrsEgxGQJHnsjALkpG8lWgVBbvHJEdWUcAYH9tlPBbhPvmVBJrhhRORtfXDu/bdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312337; c=relaxed/simple;
	bh=0jyz1f7rgyUzW7bH6JuBaP6YCQbQexCcMD6CirWWmDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqBU0wLlAmisL+IsnZr7/DUXOz8W2y9v1XNzl6MA5UeTom9tlxsNXY/tht5tZh5K3ogRxPZ9nPELZpw9DFH5EEQhxehW3ErnRSxToOlsCd+3aA4TzxSBaWjpWZ2BcONygm0tbOLalY3VvJiqiGumZRjKeexnLFgG8Is3UBj1lTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p4PEeKLv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FpQyxFp+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p4PEeKLv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FpQyxFp+"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7f8DW1390121
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1FshjYDQvZeVkPIW4yRuQM6ncE/3TUyGCcbaWbILb+E=; b=p4PEeKLvVzUeacT/
	+xXiOYtsES0+Hop2HiKAmTIEMtnRYS8jOm6y8eA4OhnreLuLEN6ICEIipKtlr2eZ
	gUljC7vP+9qHDHmq6YYR1MN0OCYYWTqWOZzRthPA1NNr4n2eG0lTlvavo9LzAmc5
	JSyaP3V0JqrT4QNQAp75Y9kuFrwlwkgKkIxnJsrE1vHHNy3bj8gK0VIB7zC7KgSH
	U3PgnIiImHkJN+pjGxbmphgD1UIcErj1qWeKjKieBRrxrxgLr/Gt6Zh6kJ17IDjU
	5w6AxFfj8nd6kAPD+dTX0Z19fJPjLAoqeFrXZcW/NDiHvtGISf1Xb5s14S5Cz80R
	1icFfg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbmxrh4g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 08:05:35 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c07313be5so1295631cf.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 01:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785312335; x=1785917135; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1FshjYDQvZeVkPIW4yRuQM6ncE/3TUyGCcbaWbILb+E=;
        b=FpQyxFp+PdOQg60v9dWtKO6nwtdjtCxg8xHFf8Mg3LyVm6Dc0UeAY5WAD2kN9uUvDi
         rgtbk8vMtq+E3BvARK/i5Wnj13dqDQCT1eyUWHuzwHmyUmMoQSUs0wY8A2yebNYTv9BD
         iVSc0hweHLDZZbiGpLYCqGIwM8hpQr2ANYZbawHk/30vll6rBj8SRTzWHGTEbSwJ1G+f
         f8VoTGcn7sHrllSYOj8qv1QoeSwfnAfMWQYjX6Q5CvmO5wQKVTnIa6eCWQrRZfb6zUvM
         hldyPrDiLB9EVO7xK6NF+SKjKHEqByE7tLREyrJMQ/6SJc8rEzE8E+UQJV9kCR4X8Rud
         grnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785312335; x=1785917135;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1FshjYDQvZeVkPIW4yRuQM6ncE/3TUyGCcbaWbILb+E=;
        b=mwCpzio/uXgz1B1Xby1iTKo+Hhkx/P/my8C6FGoh+yRyPkx3LnkUvQLKwwH6AP3FkT
         dA3YYPnwFUxvcReiiFTb8dcf1GApQ/eOqZglwrvO5EGDJZIIQGvDzVKHJcxmCdp8XS/Q
         h5EuSZY+NzxlOvXT6k2d2/ntZ8+i8taPLt074brMVJJx/UvbEibQd63157ODEYzKunoP
         RfmMVFPRQNdo3qYdUf9yIx9xb8qzp8Fbt6Ph/K3FL50gQyGkLA8PR74GZ0whN6C68RmR
         iEnkrw8BJfNO4nJPsawNiuPMNgvUoif+YA80LqP+utQ/WEsHaGTbXzH1XX2Om6AMKxB3
         531A==
X-Gm-Message-State: AOJu0YzZE2NszUkGzpUiv7YvvUFjjNql0eAKNdSEQHGap2RzI+JLZsbD
	Cqo78iGT+wZeLX+7WtP6FSQWAw6Pyc5CTbI6viWtfkY4hIcAOEDaPc73Cz/5STE1YpEb0lg4++5
	LhUVF2Q/zboMrgLNGr+ZKTc0kfAZo8ufCKWL/d8+VYYgPlHAKwNTJya7EkHZLyzmMosSSfeeZzt
	g=
X-Gm-Gg: AR+sD120BANd8XdhG9bpOWyQ+VJvrdAhENDA6LgmIfSSRNjBdyEXjA1iNpt5Q6Hu2vY
	C/qxKKUuQ20giJhwHiteeXTuEeRXjs8iYwQddQaTf/GgSadxYAgOU5sCRMEDXyIMrgy6+a6M3Uz
	DmwuvLAy4cEO7Zsau1NAHv/0asVl/tTYlEEjZhzjd33yo72b68BwMC0t7EAS1bPWnpoPCE34h5S
	upsLu88qNOImhi+1u9VnfMDO25PvsA7z1YqmyMH1h4O7AbhxVzisTyg03W8UCovUD/GXVZJnVm+
	oKaufzBAljs/U5UQ3kGL6CtMs3ZPH177epEcBNHgzVjvLTyLvFNkP1ZTwsqor7BC9lLGpt/FzoR
	x8yn24xPeotBeiE2xqcotvaZF
X-Received: by 2002:a05:622a:1aa5:b0:51c:2101:f0 with SMTP id d75a77b69052e-529d6f89194mr47546991cf.2.1785312334713;
        Wed, 29 Jul 2026 01:05:34 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa5:b0:51c:2101:f0 with SMTP id d75a77b69052e-529d6f89194mr47546591cf.2.1785312334297;
        Wed, 29 Jul 2026 01:05:34 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a050c49f7dsm496439a12.18.2026.07.29.01.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 01:05:33 -0700 (PDT)
Message-ID: <f19fa79b-82c6-4cb7-87fe-43c9b92907de@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 10:05:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Udit Tiwari <udit.tiwari@oss.qualcomm.com>,
        herbert@gondor.apana.org.au, thara.gopinath@gmail.com,
        davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
 <d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA2NCBTYWx0ZWRfX9utrfW44tcKe
 GvRotav4GIgqqxPM/gpUh7xInrBMq1lJfnzTia+yUSIFXCeSHiAcVPKkUXl6liSHn/PHNsTv5+P
 OP5T/PmuQy5efXf/kYJm/jrbOJgB173tNk8uAF2AIuCYrpxYCYq5flgaKr6AMEFQs0MjDSaF9gI
 MSKp0zldEJ7ArKvYGHfBu6lQ65qUPZk7mb3zXFW3Rdz83vcbxtM8H0ZtjikMEitVLiREVyYl3CW
 MHqErEZ/58CAQfZ64pJXBYvFowFJIw8ZZ4lpShm4Mm2Qj/QakzUXFvYTx75U6BvuMP5M9xtLfu/
 qjdr+rylOGVh29eVZyKtinJwoq5ssTBp5OHDwDAQH/6mAouUQZO8t3m9cI5+BcVIqW7NThLE00W
 f9Nm/ndn/WnBRM88sXVKhnDQ0b7BXVxZlAfHNyhGzfiY8SEDOU2FFwoIYcJaafxJlqmuAjsDwqp
 x5kTo5LCajotGTFvAdw==
X-Proofpoint-ORIG-GUID: kwYVKTjKef3dAZAKtSrRg8nkISmzZCcV
X-Proofpoint-GUID: kwYVKTjKef3dAZAKtSrRg8nkISmzZCcV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA2NCBTYWx0ZWRfXx5jOJ67NW2mK
 lxsR0+yw2VBvTC0OU7iegesflwlfw7KBjn1dKJXW8MscbJNT3XVnh4nErzvLRTuny9hP1PlZWkh
 luIx9DMGzQgc0IdrCuiG94+UAiluUNI=
X-Authority-Analysis: v=2.4 cv=fLIJG5ae c=1 sm=1 tr=0 ts=6a69b44f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=e6B5lkgUXIycqPoEI80A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290064

On 7/28/26 8:11 AM, Kuldeep Singh wrote:
>> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
>> runtime power management (PM) and interconnect bandwidth control.
>> As a result, the hardware remains fully powered and clocks stay
>> enabled even when the device is idle. Additionally, static
>> interconnect bandwidth votes are held indefinitely, preventing the
>> system from reclaiming unused bandwidth.
>>
>> Address this by enabling runtime PM and dynamic interconnect
>> bandwidth scaling to allow the system to suspend the device when idle
>> and scale interconnect usage based on actual demand. Improve overall
>> system efficiency by reducing power usage and optimizing interconnect
>> resource allocation.
>>
>> Signed-off-by: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
> 
> Herbert, can you please review and pick the patch if no further comments.
> This is required to fix interconnect votes summary for qce driver.

This needs to be rebased on linux-next/master

Konrad
