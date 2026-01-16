Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F923ABA7;
	Fri, 16 Jan 2026 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584732; cv=none; b=dNGyZRhR9lfv5xTsB89hLXo00fBeanjDfwXKIJnNT2+6f/5MI7yZrxqIKGdVn+do/yeoA0qHZKSygLS+qcHq354P1ZjpzVnezTKTkcUciTKTB/rQ8CvCLLyIAhEHXGg/5TTk3rid1Wvvx3StpwSspo/XHhHE3KfEVDczQrsZjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584732; c=relaxed/simple;
	bh=R8AXw83zI3IjmVrvcEhhs+oMe3X5CndLW6MiC35xtQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7RPgg4EugYjD1vvJsFERgHk4s/WfInOj0fl1grnetcQBYmP3wv8dslzg/aVB0Zbaoh0pXU4oRB+voXSqLClmvogrYFqXSS28/s2TOgot+CMHIMTP2RlAgCBR8eEdYhYmH55OFPCg19Gl4IUy4LakjF8nLSGhe8lkjl38kD9DRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o7aTJJAy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o7aTJJAy"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60GCPYCU013353;
	Fri, 16 Jan 2026 17:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TViLPu
	jWTXJbConvKQo1MImvVj+v8u6e4htEwClAmwM=; b=o7aTJJAylrUY8PL0K6AX/q
	OIxsM5i14FlfF8mDNEjnEEcjbZFGcJuDVHyjh3NrYoZK9bZflM6dKabEA+jXtHbp
	AFtt/jXdNsf13/TLm4fTxnYetdCH6F1fseCxXabgGKEc4VpCLp3nAbNznRI8qRmf
	UpINkEJqp+CKu4iQuiq2Sc3Iv4ERdsW+L/MjDHLmBkbu5U0qey3QYlrwNSnNJk5A
	U3xo6rUEPfOwiGiwc+LYwyukTUxYv1mE57eFgscYy5HXPSJDkGa0hr2GQ7YzhxMI
	HT7mAZiHtq7FrVWP2P6U0eW6dR1JR+0cMxmRgP9lA0W/QBr1ochsOhV8DfG6cq3Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9emv18w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 17:32:02 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60GHPdqo019315;
	Fri, 16 Jan 2026 17:32:02 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9emv18v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 17:32:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60GEfSCu014261;
	Fri, 16 Jan 2026 17:32:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fyqr5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 17:32:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60GHVxLD27919054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 17:31:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9821120040;
	Fri, 16 Jan 2026 17:31:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3001E20049;
	Fri, 16 Jan 2026 17:31:59 +0000 (GMT)
Received: from [9.111.195.181] (unknown [9.111.195.181])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 17:31:59 +0000 (GMT)
Message-ID: <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
Date: Fri, 16 Jan 2026 18:31:58 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
To: David Laight <david.laight.linux@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com> <20260115204332.GA3138@quark>
 <20260115220558.25390c0e@pumpkin>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260115220558.25390c0e@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KvJAGGWN c=1 sm=1 tr=0 ts=696a7612 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=fXmDmO1hTawVRzeH8PEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEyNiBTYWx0ZWRfX5rG9tgurn8PH
 fov0OTdy3kpoAlEHSGCvBGbeTo6/5ENtecnCK02tXBarUgj0fIWKLiZg8Zn1fB6PhPx9M6Kc7Ix
 gwU6YORPCuSBw9fdXHtmhT98LGKR+UvucqymSgM6JxNoCcwVCCqWxraAZy5G1duT9aNiuDDUH0p
 oEwS+pbH/BgbjA/M37ghUxYYC3NqLVV4FohEVZ8RTJi9VVVfxD9MgD2EVA5jMzYL/jmJdVo63Ab
 LBiOSV91ulx6QNOx5K7p79owDmfP8kt0WVvv9v65njjPY7B0Bd0LHWHd8aNwwbFg+dMANfBk9W/
 u1URvCN0Jr31JPAbTK6IFhEHOcSMg0hAPtJaqcYMdP/74/+OWBwfKQTtN895se2TB0iszgY9jha
 xhE49Be6tlUit7MY8truOkeCJpTTMj/X2J2s1ctbFIseMTvLp6wnJFlh6hceugMXs5im9qtT3Vr
 x/Z28LuoYY6pYMihC6w==
X-Proofpoint-GUID: E60otIO-GBokkgWExs9GYaFozBH7ajo8
X-Proofpoint-ORIG-GUID: 7OGnvKXsApdSLYaG-EpAYQw8f0Rmo8G-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601160126

Hi David,

On 15/01/2026 23:05, David Laight wrote:
> On Thu, 15 Jan 2026 12:43:32 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
>>> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
>>> +{
>>> +	const size_t num_iters = 10000000;  
>>
>> 10000000 iterations is too many.  That's 160 MB of data in each
>> direction per AES key length.  Some CPUs without AES instructions can do
>> only ~20 MB AES per second.  In that case, this benchmark would take 16
>> seconds to run per AES key length, for 48 seconds total.
> 
> Probably best to first do a test that would take a 'reasonable' time
> on a cpu without AES. If that is 'very fast' then do a longer test
> to get more accuracy on a faster implementation.
> 
>>
>> hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
>> iterations.  That would be 69444 in this case (considering len=16),
>> which is less than 1% of the iterations you've used.  Choosing a number
>> similar to that would seem more appropriate.
>>
>> Ultimately these are just made-up numbers.  But I think we should aim
>> for the benchmark test in each KUnit test suite to take less than a
>> second or so.  The existing tests roughly achieve that, whereas it seems
>> this one can go over it by quite a bit due to the 10000000 iterations.
> 
> Even 1 second is a long time, you end up getting multiple interrupts included.
> I think a lot of these benchmarks are far too long.
> Timing differences less that 1% can be created by scheduling noise.
> Running a test that takes 200 'quanta' of the timer used has an
> error margin of under 1% (100 quanta might be enough).
> While the kernel timestamps have a resolution of 1ns the accuracy is worse.
> If you run a test for even just 10us you ought to get reasonable accuracy
> with a reasonable hope of not getting an interrupt.
> Run the test 10 times and report the fastest value.
> 
> You'll then find the results are entirely unstable because the cpu clock
> frequency keeps changing.
> And long enough buffers can get limited by the d-cache loads.
> 
> For something as slow as AES you can count the number of cpu cycles for
> a single call and get a reasonably consistent figure.
> That will tell you whether the loop is running at the speed you might
> expect it to run at.
> (You need to use data dependencies between the start/end 'times' and
> start/end of the code being timed, x86 lfence/mfence are too slow and
> can hide the 'setup' cost of some instructions.)

Thanks a lot for your feedback. I tried a few of your ideas and it turns out,
that they work quite well. First of all, with a single-block aes
encrypt/decrypt in our hardware (CPACF), we're very close to the resolution of
our CPU clock.

Disclaimer: The encryption/decryption of one block takes ~32ns (~500MB/s).
These numbers should be taken with some care, as on s390 the operating system
always runs virtualized. In my test environment, I also only have access to a
machine with shared CPUs, so there might be some negative impact from other
workload.

The benchmark loops for 100 iterations now without any warm-up. In each
iteration, I measure a single aes_encrypt()/aes_decrypt() call. The lowest
value of these measurements is takes as the value for the bandwidth
calculations. Although it is not necessary in my environment, I'm doing all
iterations with preemption disabled. I think, that this might help on other
platforms to reduce the jitter of the measurement values.

The removal of the warm-up does not have any impact on the numbers.

Just for information: I also tried to measure the cycles with the same
results. The minimal measurement value of a few iterations is much more stable
that the average over a larger number of iterations.

I also did some tests with IRQs disabled (instead of only preemption), but the
numbers stay the same. So I think, it is save enough to stay with disables
preemption.

I also tried you idea, first to do a few measurements and if they are fast
enough, increase the number of iterations. But it turns out, that this it not
really necessary (at least in my env). But I can add this, it it makes sense
on other platforms.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

