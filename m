Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF5329C7E;
	Thu, 15 Jan 2026 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768513897; cv=none; b=BIJxTg3ZPNpzRMQT57BvSNXmWY3W+qsWNcuin7L5H6CGAevunNl3V2YrYl6IlP8K+ILier/tN2Mif2AwSHneImmxaW5g3NGZPvmIP+jfVstM9Vpq5KktKtdbAHNh41tEhVr8IW0c+cBxksolWbnkBHigHevo2npWk3J59kjoYcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768513897; c=relaxed/simple;
	bh=eDbG7oIDNSBtxQtDeXKavorlmOv3MxYeICQgBGWqZxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boAF/PwGJp3hxYFcvxe8/0p3MqljbR0pCQpNMfVdpUmJQRtEbVfSU/5z+5ooFUYcTzwrXjFZ9w6G8teSuD2a9KPCH+wyGBE7+OvntcAAZPNx3UUe14SD07W1RjM7XB9T6HDRnQ0vYqZTS0pJOv14UMT9gLqNOAD+rKk47pHb8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UXvwWXRu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UXvwWXRu"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIU2mL023089;
	Thu, 15 Jan 2026 21:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wdu6jg
	KLuaiifUu91W4tE9nmGxoPUXK86sfttdjrE/Y=; b=UXvwWXRuhdSQatVZERK7AS
	h0NBHa0CON4EdR9mqBUor9Thm074bN7Gqp3H6fULoOaWNI4imYu2qjsPABDzQIDI
	TQBqqPICchJjTYvsavM6ONaBDewlNj6XnpFl8xUEpDbLswYS7m/omtixqO0z0/Jg
	Q/58NBaZepnlja1pFNh7X350NyMmWBorbuxw/BmWQPYmmqT3KEi9io/yloLDH9DS
	IjYk5rFhIi4wLsSPnCMKAEyGXR2V44RTL7kN0ZpMQMgZyw3zOhIyl/JvP1Z0xf4I
	tT9w44ZFHSNDbM4JMPzom8YYM9wCirxwaz7+LmTmwPjJStTD83QxpHB7gUrQBRkA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6ege7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:51:28 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FKNX18002536;
	Thu, 15 Jan 2026 21:51:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm13t2uvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 21:51:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FLpPXw51053038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 21:51:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D97C220043;
	Thu, 15 Jan 2026 21:51:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA74D20040;
	Thu, 15 Jan 2026 21:51:25 +0000 (GMT)
Received: from [9.111.195.181] (unknown [9.111.195.181])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 21:51:25 +0000 (GMT)
Message-ID: <76089e1f-dfc9-44e8-8e16-b965cd43d848@linux.ibm.com>
Date: Thu, 15 Jan 2026 22:51:25 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com> <20260115204332.GA3138@quark>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE, en-US
In-Reply-To: <20260115204332.GA3138@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6vg3yQIfphF_h_P6a8XVvGzLLEj6L-7V
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=69696160 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Kmv_wObzDGlLTcwL_M8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE3MSBTYWx0ZWRfXzs47HKSNRyr6
 g4m+6sydJmowNKUPjdVdpeOIbZ/aJd3NRBWijvvl/IFPZokcqGd72pxKxfgqf25Mr2SwPlEBgM5
 ErSMsItitWR2mqwr2XLIcl7wySQu9MSwVaxor/tWE7x93UyFcDsRklRDSix6/pnJZFXcN+FWK6x
 azy5G2/r/VO31dq0Xgnpem3lZ1rhHLM0ocikxci9fDparaOzJIvTwf+oxZ6rKf8TKIkSxFsx5f7
 TmB3SU/+l4wcXYpoZFkAgnayJtN3XGSEU2Hqp9imrxHUkpGDCOsTO4ES+AjD5NvgRxAyVbDpSkm
 C4T833JBMbLkkkv5tjvTufPTHyVG/4lr497mVeB7ojesLYYX8joYPsN9wgFacE1QizGnX/ZfuV0
 bxX9HeEBZ5Ha6ffKuXiyDWyWWJjXNcowtapsujuvBPDQJ3WedRSkLgc97G5LcUeXeGgrKs3NJpD
 p7QsN7jLEdwweGNqvSA==
X-Proofpoint-ORIG-GUID: 6vg3yQIfphF_h_P6a8XVvGzLLEj6L-7V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150171

On 15/01/2026 21:43, Eric Biggers wrote:
> On Thu, Jan 15, 2026 at 07:38:31PM +0100, Holger Dengler wrote:
>> Add a KUnit test suite for AES library functions, including KAT and
>> benchmarks.
>>
>> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> 
> The cover letter had some more information.  Could you put it in the
> commit message directly?  Normally cover letters aren't used for a
> single patch: the explanation should just be in the patch itself.

Ok, I'll move the explanation to the commit message. I assume that the example
output of the test can be dropped?

>> diff --git a/lib/crypto/tests/aes-testvecs.h b/lib/crypto/tests/aes-testvecs.h
>> new file mode 100644
>> index 000000000000..dfa528db7f02
>> --- /dev/null
>> +++ b/lib/crypto/tests/aes-testvecs.h
>> @@ -0,0 +1,78 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _AES_TESTVECS_H
>> +#define _AES_TESTVECS_H
>> +
>> +#include <crypto/aes.h>
>> +
>> +struct buf {
>> +	size_t blen;
>> +	u8 b[];
>> +};
> 
> 'struct buf' is never used.

This is a left-over, will be removed in the next series.

> 
>> +static const struct aes_testvector aes128_kat = {
> 
> Where do these test vectors come from?  All test vectors should have a
> documented source.

ok, I will add this information as well.

>> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
>> +{
>> +	const size_t num_iters = 10000000;
> 
> 10000000 iterations is too many.  That's 160 MB of data in each
> direction per AES key length.  Some CPUs without AES instructions can do
> only ~20 MB AES per second.  In that case, this benchmark would take 16
> seconds to run per AES key length, for 48 seconds total.
> 
> hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
> iterations.  That would be 69444 in this case (considering len=16),
> which is less than 1% of the iterations you've used.  Choosing a number
> similar to that would seem more appropriate.
> 
> Ultimately these are just made-up numbers.  But I think we should aim
> for the benchmark test in each KUnit test suite to take less than a
> second or so.  The existing tests roughly achieve that, whereas it seems
> this one can go over it by quite a bit due to the 10000000 iterations.

As we have a fixed length, I would go stay with a fix value for the iterations
(instead of calculating it based on len).

The benchmark has a separate loop for encrypt and decrypt, so I will do the
half iterations on encrypt and the other half on decrypt. I will also reduce
the iterations for the warm-ups.

What about 100 iterations for each warm-up and 500.000 iterations for each
real measurement? Means processing 2x 8MiB with preemption disabled.

>> +	kunit_info(test, "enc (iter. %zu, duration %lluns)",
>> +		   num_iters, t_enc);
>> +	kunit_info(test, "enc (len=%zu): %llu MB/s",
>> +		   (size_t)AES_BLOCK_SIZE,
>> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
>> +			     (t_enc ?: 1) * SZ_1M));
>> +
>> +	kunit_info(test, "dec (iter. %zu, duration %lluns)",
>> +		   num_iters, t_dec);
>> +	kunit_info(test, "dec (len=%zu): %llu MB/s",
>> +		   (size_t)AES_BLOCK_SIZE,
>> +		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
>> +			     (t_dec ?: 1) * SZ_1M));
> 
> Maybe delete the first line of each pair, and switch from power-of-2
> megabytes to power-of-10?  That would be consistent with how the other
> crypto and CRC benchmarks print their output.
> 
>> +MODULE_DESCRIPTION("KUnit tests and benchmark aes library");
> 
> "aes library" => "for the AES library"

ok

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

