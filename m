Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD052EB860;
	Fri, 16 Jan 2026 20:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768596916; cv=none; b=qfMHXoXbawzMURJLESP4h95KhTvqywWHfSUHZoSQMKFisMJJVw0bPGoizFAJ3pk0JUSxuBVlj03Wt9Q1i9rGzsSvWH/4jyco/ENJ3eiV0hYuQu4s4k9dCaMR3yZKsJtRdrN7mRbdnM4oKS0I+YOL7xsmbyFNWIOHXZ32zFQaYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768596916; c=relaxed/simple;
	bh=1A0KxA/cuEHinZV4fM7vJbjpE+QExAjvwTudkR3gai4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epApwNWebqntSRZqcLd7mom3SzEbQei2xvLLPNueuDfcSwpEbPTbHg8TVq2hdMd2uNHxKddbNlhLHFIwx+LrWYv6KeXZa6WYz76ge2Jzcgu73O/MjFtpwM1h4tpwM2cgZGd++/f3vtIR+LVnzPmqSqbt3wP9GOAmSGBoCVUFXKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kYFW7CpR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kYFW7CpR"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60GKHC4M028031;
	Fri, 16 Jan 2026 20:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TA3fsc
	oL5fS5gm8fAsHmkTcfdN5EiwF2pZ1lVYDnq3g=; b=kYFW7CpRCwmOqDDChL0Fjq
	5yu/wHZZQNlTLlOkmeXwobIqNP0PiDqbyhIdFY+2OHdfzONR5Ku54HEt1gIvQGO9
	SCCRbTwfhVsKgAAdQA/+ItCeuTZ2bgLVPbxhhTp5VHMjtKdx13Pgw2U4xdhAyKSl
	HjkHe3MvheY83aw/V0/3Lhd7PxuTNiN/y6tb9KWRGXomJ7r/H58pCKJDJpyoY05Z
	IY35JY8pjAC40nsLm1LlawbZH08NPIjS8HZ8RhtvtlyKuZlx0yssHCy23zsvir6y
	LTM6Br8RxNfPprvVDWcWyJf3zaQQvOFGq0G2Ipwud9uH/x3QwgjA3FnMOpW1+pnw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bqv7yr44w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 20:55:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60GKhQTx011790;
	Fri, 16 Jan 2026 20:55:08 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bqv7yr44u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 20:55:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60GKJA1O026536;
	Fri, 16 Jan 2026 20:55:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bqv8xg4w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 20:55:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60GKt5P436700438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:55:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 756FE20040;
	Fri, 16 Jan 2026 20:55:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C5CC2004B;
	Fri, 16 Jan 2026 20:55:05 +0000 (GMT)
Received: from [9.111.195.181] (unknown [9.111.195.181])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 20:55:05 +0000 (GMT)
Message-ID: <aedfebcb-4bca-4474-a590-b1acc37307ac@linux.ibm.com>
Date: Fri, 16 Jan 2026 21:55:04 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com> <20260115204332.GA3138@quark>
 <20260115220558.25390c0e@pumpkin>
 <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
 <20260116183744.04781509@pumpkin>
 <2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>
 <20260116194410.GA1398962@google.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20260116194410.GA1398962@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: afnnR1bO4G62Cb61kypiGnpTKT2ieyN-
X-Proofpoint-GUID: M1NmLGDIcwnVqfDlfy1PpVGALgfKiDlW
X-Authority-Analysis: v=2.4 cv=M9NA6iws c=1 sm=1 tr=0 ts=696aa5ad cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=CR-ERseoVsZSmHwjCYsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE1NiBTYWx0ZWRfX7XGCQmU9byBH
 6fbvK8WKKVxiGsCjD/iVie95cWL/UwoLtowBQ+jv/4SjPGM508ju93KH3+1il8GYTZgDN48DQaL
 FrIVLxrZX9Ddw5cPd0nwjGMIYB24IQ1W0w9YJubtBHNK71f6c++fnXJZdRTYaUYWn/Qzvs/unvF
 aGICZkUBYvWioiWD+XT1kzzuQfCuBCxRbEgfKpTV0o30OiKmdmWf0942n16KyPWunrgsFd4d8Z7
 UaZr12DyJ8B/C3Es4sHDT6Y7BXC7zeOQVDxN10po58gBeTvRrKSe0niZAMR8Hwu2/LbDqvTzHnO
 HH/NwoGPWR9W1Y5umJw2Zef63eSwAY8Pr2NDYWoVMFfE16xfkzDASuepRfa8diR3eEbh4zCM9CZ
 PBMjFDyVQZvoc2o1/Ei01LntwX5OrLm3JZOBCdUjqo+OWWAiY9NG18bHKJc4dDoB76ruMBT12/u
 lIWwMUnBRnn4wSCDA5w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601160156

On 16/01/2026 20:44, Eric Biggers wrote:
> On Fri, Jan 16, 2026 at 08:20:51PM +0100, Holger Dengler wrote:
>>>> The benchmark loops for 100 iterations now without any warm-up. In each
>>>> iteration, I measure a single aes_encrypt()/aes_decrypt() call. The lowest
>>>> value of these measurements is takes as the value for the bandwidth
>>>> calculations. Although it is not necessary in my environment, I'm doing all
>>>> iterations with preemption disabled. I think, that this might help on other
>>>> platforms to reduce the jitter of the measurement values.
>>>>
>>>> The removal of the warm-up does not have any impact on the numbers.
>>>
>>> I'm not sure what the 'warm-up' was for.
>>> The first test will be slow(er) due to I-cache misses.
>>> (That will be more noticeable for big software loops - like blake2.)
>>> Change to test parameters can affect branch prediction but that also only
>>> usually affects the first test with each set of parameters.
>>> (Unlikely to affect AES, but I could see that effect when testing
>>> mul_u64_u64_div_u64().)
>>> The only other reason for a 'warm-up' is to get the cpu frequency fast
>>> and fixed - and there ought to be a better way of doing that.
> 
> The warm-up loops in the existing benchmarks are both for cache warming
> and to get the CPU frequency fast and fixed.  It's not anything
> sophisticated, but rather just something that's simple and seems to
> works well enough across CPUs without depending on any special APIs.  If
> your CPU doesn't do much frequency scaling, you may not notice a
> difference, but other CPUs may need it.

Do you have a gut feeling how many iterations it takes to get the CPU speed
up? If it takes less than 50 iterations, it would be sufficient with the new
method.

>>>> I also did some tests with IRQs disabled (instead of only preemption), but the
>>>> numbers stay the same. So I think, it is save enough to stay with disables
>>>> preemption.
>>>
>>> I'd actually go for disabling interrupts.
>>> What you are seeing is the effect of interrupts not happening
>>> (which is likely for a short test, but not for a long one).
>>
>> Ok, I'll send the next series with IRQ disabled. I don't see any difference on
>> my systems.
> 
> Some architectures don't allow vector registers to be used when IRQs are
> disabled.  On those architectures, disabling IRQs would always trigger
> the fallback to the generic code, which would make the benchmark not
> very useful.  That's why I've only been disabling preemption, not IRQs.

Ok, this is a very strong argument against disabling IRQs.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

