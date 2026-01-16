Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9FB2D73B4;
	Fri, 16 Jan 2026 19:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591264; cv=none; b=eLfLpg70qgzU3lx1ZimnkgB5gGvzRnGq8rWkHu8rDKNSqvqbAmZRdzTRd7DiUZ8w1++fZSQEjRDMYFuZDuQrMFo1ZZUrgkbah6zg7goPIvRZfqhPwbbYediSSZBw86xYb5UDLopkJvfshkk6276PY44XwhIZy7QaVLBDo2/OnVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591264; c=relaxed/simple;
	bh=gTNTRvhpWGeAi1XOOd5llpG4BYp5XH33b07z4INnJVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eu9cqQTE/TWJSfZ6JvSWBPGz2ynuDKePihN+sAtBjaarr3oVNo4bFR5/NpVtYT+7SiAvQFpDghIJs3DPqzAMQP+drCt3KJseM55AkcXYXacMl1TU0udz6IdFF9ZlgWWfarev/C8BJIKX74imZsFyyCNW1M9LG50OcEPooR6fYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s6L4P++3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s6L4P++3"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60GD1dlO032563;
	Fri, 16 Jan 2026 19:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PlDNwK
	rXvUeuIFC3792iHsQheqz/lsi+lsSPp61aBRQ=; b=s6L4P++3M6vusldB0t7Pmy
	aJGWCFxV3A+/rTJ1wt8GRLK/4DAIFlboVNFNxhcsuUozrbAAqzjdDvHu7SkfbAik
	d4aF6AQtsUu0rcw3kafE9hWIR++f2csUODek1nHD9Pb7PORvpfkK9WxMCyC/cMLr
	R1euv/2G35T2TyZIslshi5BCqJavp2m+cV47rS5YAhsLVd7+sVIQJE5C48Hx0Xwx
	gIZEVUS+RjLzBeisi+HLLGHdTmNGO+CEXnHXoeo353aAjpPCT3GZnhip4so3k3+X
	FjtWy8uwjkCu9TBwr+928A4O32LBMwO184GTBf5XltcDtgc4h5+qzv3eCGAWNw/g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9bmmkp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 19:20:56 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60GJKtJC003020;
	Fri, 16 Jan 2026 19:20:55 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9bmmkp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 19:20:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60GHigpm025546;
	Fri, 16 Jan 2026 19:20:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm23nr51p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 19:20:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60GJKqkG24248646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 19:20:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BA8220049;
	Fri, 16 Jan 2026 19:20:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15B3D20040;
	Fri, 16 Jan 2026 19:20:52 +0000 (GMT)
Received: from [9.111.195.181] (unknown [9.111.195.181])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 19:20:52 +0000 (GMT)
Message-ID: <2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>
Date: Fri, 16 Jan 2026 20:20:51 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
To: David Laight <david.laight.linux@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com> <20260115204332.GA3138@quark>
 <20260115220558.25390c0e@pumpkin>
 <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
 <20260116183744.04781509@pumpkin>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20260116183744.04781509@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5_rA5nZkNCK8VSG2tM8JsO922Wu11ub5
X-Proofpoint-ORIG-GUID: f5RGvIjJuwq_-pjVUcq2UF29fqc65wjo
X-Authority-Analysis: v=2.4 cv=TrvrRTXh c=1 sm=1 tr=0 ts=696a8f98 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=xzLv6Hm3mJIvqas7ytYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE0MyBTYWx0ZWRfX7RDvXZsCRhJG
 XEPyxFXm5+VzrJojxzaW3jmEtwlHiWUPpdCd/+8ISA0XPyvV5lG0yZDuAC41Qp6UtHC3zyL/dtL
 nim+uSD+le2bQs8ESRdIRacm2zZYfyukPZeRiuA4BRI2+9Ts8U+lKu4BqeM8xbw0ovtfdDlBZlv
 pJnoB3wBBA5OLE6+4rvj1JWDdOlC5wEdSxVeT6Jr/7k9CgL21w+gbzIkWWeHXbndQeHsWDmMegr
 QZnwNZmeZ5bkNdsA4LGWsanzW1Gtpn2h6BO79CG7r5aZWGas9AkpvbvoP5U7BZupYEu80H2l9+o
 Uyfa/gdsJ+cA07+25seO4YOei7OkYfSJLF00s6LMnrSmA8SMsq7kPnUTIaX0+VTVujB8uAjvJXP
 R1kXSV4jvLDtAru38LS1kmYyHf+PtZXDNVbdoyu2TB6byd2rMeC4UZkPpXgKpEg3yE98Raa21Fh
 AAkJFaobkCGsVtjKGJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601160143

On 16/01/2026 19:37, David Laight wrote:
> On Fri, 16 Jan 2026 18:31:58 +0100
> Holger Dengler <dengler@linux.ibm.com> wrote:
> 
>> Hi David,
>>
>> On 15/01/2026 23:05, David Laight wrote:
>>> On Thu, 15 Jan 2026 12:43:32 -0800
>>> Eric Biggers <ebiggers@kernel.org> wrote:  
>>>>> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
>>>>> +{
>>>>> +	const size_t num_iters = 10000000;    
>>>>
>>>> 10000000 iterations is too many.  That's 160 MB of data in each
>>>> direction per AES key length.  Some CPUs without AES instructions can do
>>>> only ~20 MB AES per second.  In that case, this benchmark would take 16
>>>> seconds to run per AES key length, for 48 seconds total.  
>>>
>>> Probably best to first do a test that would take a 'reasonable' time
>>> on a cpu without AES. If that is 'very fast' then do a longer test
>>> to get more accuracy on a faster implementation.
>>>   
>>>>
>>>> hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
>>>> iterations.  That would be 69444 in this case (considering len=16),
>>>> which is less than 1% of the iterations you've used.  Choosing a number
>>>> similar to that would seem more appropriate.
>>>>
>>>> Ultimately these are just made-up numbers.  But I think we should aim
>>>> for the benchmark test in each KUnit test suite to take less than a
>>>> second or so.  The existing tests roughly achieve that, whereas it seems
>>>> this one can go over it by quite a bit due to the 10000000 iterations.  
>>>
>>> Even 1 second is a long time, you end up getting multiple interrupts included.
>>> I think a lot of these benchmarks are far too long.
>>> Timing differences less that 1% can be created by scheduling noise.
>>> Running a test that takes 200 'quanta' of the timer used has an
>>> error margin of under 1% (100 quanta might be enough).
>>> While the kernel timestamps have a resolution of 1ns the accuracy is worse.
>>> If you run a test for even just 10us you ought to get reasonable accuracy
>>> with a reasonable hope of not getting an interrupt.
>>> Run the test 10 times and report the fastest value.
>>>
>>> You'll then find the results are entirely unstable because the cpu clock
>>> frequency keeps changing.
>>> And long enough buffers can get limited by the d-cache loads.
>>>
>>> For something as slow as AES you can count the number of cpu cycles for
>>> a single call and get a reasonably consistent figure.
>>> That will tell you whether the loop is running at the speed you might
>>> expect it to run at.
>>> (You need to use data dependencies between the start/end 'times' and
>>> start/end of the code being timed, x86 lfence/mfence are too slow and
>>> can hide the 'setup' cost of some instructions.)  
>>
>> Thanks a lot for your feedback. I tried a few of your ideas and it turns out,
>> that they work quite well. First of all, with a single-block aes
>> encrypt/decrypt in our hardware (CPACF), we're very close to the resolution of
>> our CPU clock.
>>
>> Disclaimer: The encryption/decryption of one block takes ~32ns (~500MB/s).
>> These numbers should be taken with some care, as on s390 the operating system
>> always runs virtualized. In my test environment, I also only have access to a
>> machine with shared CPUs, so there might be some negative impact from other
>> workload.
> 
> The impact of other workloads is much less likely for a short test,
> and if it does happen you are likely to see a value that is abnormally large.
> 
>> The benchmark loops for 100 iterations now without any warm-up. In each
>> iteration, I measure a single aes_encrypt()/aes_decrypt() call. The lowest
>> value of these measurements is takes as the value for the bandwidth
>> calculations. Although it is not necessary in my environment, I'm doing all
>> iterations with preemption disabled. I think, that this might help on other
>> platforms to reduce the jitter of the measurement values.
>>
>> The removal of the warm-up does not have any impact on the numbers.
> 
> I'm not sure what the 'warm-up' was for.
> The first test will be slow(er) due to I-cache misses.
> (That will be more noticeable for big software loops - like blake2.)
> Change to test parameters can affect branch prediction but that also only
> usually affects the first test with each set of parameters.
> (Unlikely to affect AES, but I could see that effect when testing
> mul_u64_u64_div_u64().)
> The only other reason for a 'warm-up' is to get the cpu frequency fast
> and fixed - and there ought to be a better way of doing that.
> 
>>
>> Just for information: I also tried to measure the cycles with the same
>> results. The minimal measurement value of a few iterations is much more stable
>> that the average over a larger number of iterations.
> 
> My userspace test code runs each test 10 times and prints all 10 values.
> I then look at them to see how consistent they are.
> 
>> I also did some tests with IRQs disabled (instead of only preemption), but the
>> numbers stay the same. So I think, it is save enough to stay with disables
>> preemption.
> 
> I'd actually go for disabling interrupts.
> What you are seeing is the effect of interrupts not happening
> (which is likely for a short test, but not for a long one).

Ok, I'll send the next series with IRQ disabled. I don't see any difference on
my systems.

>> I also tried you idea, first to do a few measurements and if they are fast
>> enough, increase the number of iterations. But it turns out, that this it not
>> really necessary (at least in my env). But I can add this, it it makes sense
>> on other platforms.
> 
> The main reason for doing that is reducing the time the tests take on a
> system that is massively slower (and doing software AES).
> Maybe someone want to run the test cases on an m68k :-)

So I've currently 100 iterations. The first one or two iterations will be for
the warm-up (cache misses, branch prediction, etc). But with the interrupts
disabled, the rest of the iterations should give us enough stable measurements
for the benchmark. Maybe it would be worth to test the next version of teh
test on other platforms as well.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

