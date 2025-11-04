Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E49E2E3373;
	Tue,  4 Nov 2025 11:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257322; cv=none; b=KszzPuJNWBPhQwTrk8Cp38pdFyzVjpIPE7tX5b/MwVvWK1Fll4na+2/mQcjbedWL3EerQeLvx7qIuP4nJ8EMWhfS3otdu2fLkGwzkbeBEm9Y5g5K6Gm/RTGXbSpJs5jwY09fLG0WnLrdVW93lRVk4q38aRzHEVlVsDnOR7cVB9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257322; c=relaxed/simple;
	bh=NNH16t7shX+ZSoRuzyn/7CJjaSOfm/CaaMY4E8c9iRY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=WEeRwnLMEfSd7VY6rjPJVRA2MS+9Cnb2nIiP0ooWsGCv4AV8vUSJKUQPEQJOfVl9J2fUWn0ENzPoWO9b1vxcmd6Vx1tW5SthgG6Hzj6MmXIIOZ6pAcYlVw98vDq2lkzE8jNVNf67xhyOxvLWR49yQZB0QIXx/R3BjBnXVaFqKb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ja8gAwPI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ja8gAwPI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A40m8V5011006;
	Tue, 4 Nov 2025 11:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=p6yZqEmK0XYRFGs9RCkhx6N2+uDZP7n+q+ENaJ1ULPo=; b=Ja8gAwPIEqoN
	s6VzLvS6W/lwK/7mxWDXWjPY2smvjd//F/XJp9UVCcERIv7hNE+DLNYydDtK29UG
	3eQDk9SnkVO5Gvd2Pj9q7dZIOU02exxIeGVzHesIIvPs3oUixKpnbwUAKoJRwl0D
	0K9ZTsY8cdwspzF2mR5t4FKFPncOWGBdXpBIga9+VK90znWj9NoIVvY6Go1CodiS
	eIda+IMicevtlzGb/tNcod9l991x6FQ8ENppZ4vv7UPjIEnWqPrkiXSzP3vzfprV
	F/hh0Rr7wvQMJL+GwOcJlTtxjN+Fa6b5z2OM9+Gv84JxKOH1QjUN0hWs6TOMHzlx
	IojRIxHmug==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v1uhgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Nov 2025 11:55:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4BfOjL021471;
	Tue, 4 Nov 2025 11:55:08 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrjjpa4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Nov 2025 11:55:08 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A4Bt7UQ21496566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Nov 2025 11:55:07 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CEA958061;
	Tue,  4 Nov 2025 11:55:07 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C40D5803F;
	Tue,  4 Nov 2025 11:55:06 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Nov 2025 11:55:06 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 04 Nov 2025 12:55:06 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ard
 Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20251030171453.GA1624@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com> <20251029163216.GA1603@sol>
 <fa8bc10f36b1aeb9ffe1abf6350adbc1@linux.ibm.com> <20251030171453.GA1624@sol>
Message-ID: <ed5c835c48bcfcdaadeb4726678fa551@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dwTlHSZThP0CQ9fXbrDjXCK3lj7Q77nu
X-Proofpoint-ORIG-GUID: dwTlHSZThP0CQ9fXbrDjXCK3lj7Q77nu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXxqF91XqzJdHk
 1N52+Q1Jp8rC5gR5TFpmfIRCXz5HKBa65LMQUWW/A12gdoKlscoC7E6Xx/6BCUoyil9SnaC/SMA
 Nkuic/aCV0nEFvZJVC7H70gXsXeNxhgI/A4JNlvLmAKyqm7bVrbW3x0P6aZPlhuEYwSbFVPSJSy
 JkxaNoj56wdYfa9bTGC2kzWF6HaxGcqegTnwBACJnczf4t4Npei7QrdlA3fIZAPlN2og6vfgsGo
 ttsWu8ZqVkt7r37/TVMfTdpppO1xeft16aqfb1TOul+iT9EenDj9pCo5kW3TcTfShVXFkwUJYTy
 svFLXNka+431S3bMsRjrfgJdMAgRc5x4kGgi4pNrNcEeem4ZRG92HLd8AxHMmIgLc7jB5TbGBq6
 4k/zMrt5z7SagknmE2mCEkPYUFEK/g==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=6909e99d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=xaui7q1DaLXQgw2eFWYA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

On 2025-10-30 18:14, Eric Biggers wrote:
> On Thu, Oct 30, 2025 at 11:10:22AM +0100, Harald Freudenberger wrote:
>> On 2025-10-29 17:32, Eric Biggers wrote:
>> > On Wed, Oct 29, 2025 at 10:30:40AM +0100, Harald Freudenberger wrote:
>> > > > If the s390 folks could re-test the s390 optimized SHA-3 code (by
>> > > > enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
>> > > > would be helpful.  QEMU doesn't support the instructions it uses.  Also,
>> > > > it would be helpful to provide the benchmark output from just before
>> > > > "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
>> > > > and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
>> > > > functions".  Then we can verify that each change is useful.
>> > [...]
>> > >
>> > > Picked this series from your ebiggers repo branch sha3-lib-v2.
>> > > Build on s390 runs without any complains, no warnings.
>> > > As recommended I enabled the KUNIT option and also
>> > > CRYPTO_SELFTESTS_FULL.
>> > > With an "modprobe tcrypt" I enforced to run the selftests
>> > > and in parallel I checked that the s390 specific CPACF instructions
>> > > are really used (can be done with the pai command and check for
>> > > the KIMD_SHA3_* counters). Also ran some AF-alg tests to verify
>> > > all the the sha3 hashes and check for thread safety.
>> > > All this ran without any findings. However there are NO performance
>> > > related tests involved.
>> >
>> > Thanks!  Just to confirm, did you actually run the sha3 KUnit test and
>> > verify that all its test cases passed?  That's the most important one.
>> > It also includes a benchmark, if CONFIG_CRYPTO_LIB_BENCHMARK=y is
>> > enabled, and I was hoping to see your results from that after each
>> > change.  The results get printed to the kernel log when the test runs.
>> >
>> 
>> Here it is - as this is a zVM system the benchmark values may show 
>> poor
>> performance.
>> 
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel: KTAP version 1
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel: 1..1
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     KTAP version 1
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # Subtest: sha3
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # module: sha3_kunit
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     1..21
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 1 
>> test_hash_test_vectors
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 2
>> test_hash_all_lens_up_to_4096
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 3
>> test_hash_incremental_updates
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 4
>> test_hash_buffer_overruns
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 6
>> test_hash_alignment_consistency
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 7
>> test_hash_ctx_zeroization
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 8
>> test_hash_interrupt_context_1
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 9
>> test_hash_interrupt_context_2
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 10 
>> test_sha3_224_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 11 
>> test_sha3_256_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 12 
>> test_sha3_384_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 13 
>> test_sha3_512_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 14 
>> test_shake128_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 15 
>> test_shake256_basic
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 16 
>> test_shake128_nist
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 17 
>> test_shake256_nist
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 18
>> test_shake_all_lens_up_to_4096
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 19
>> test_shake_multiple_squeezes
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 20
>> test_shake_with_guarded_bufs
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1: 14
>> MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16: 109
>> MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=64: 911
>> MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=127:
>> 1849 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=128:
>> 1872 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=200:
>> 2647 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=256:
>> 3338 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=511:
>> 5484 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=512:
>> 5562 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=1024:
>> 8297 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=3173:
>> 12625 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=4096:
>> 11242 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
>> len=16384:
>> 12853 MB/s
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 
>> skip:0
>> total:21
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel: # Totals: pass:21 fail:0 
>> skip:0
>> total:21
>> Oct 30 10:46:44 b3545008.lnxne.boe kernel: ok 1 sha3
> 
> Thanks!  Is this with the whole series applied?  Those numbers are
> pretty fast, so probably at least the Keccak acceleration part is
> worthwhile.  But just to reiterate what I asked for:
> 
>     Also, it would be helpful to provide the benchmark output from just
>     before "lib/crypto: s390/sha3: Add optimized Keccak function", just
>     after it, and after "lib/crypto: s390/sha3: Add optimized one-shot
>     SHA-3 digest functions".
> 
> So I'd like to see how much each change helped, which isn't clear if 
> you
> show only the result at the end.
> 
> If there's still no evidence that "lib/crypto: s390/sha3: Add optimized
> one-shot SHA-3 digest functions" actually helps significantly vs. 
> simply
> doing the Keccak acceleration, then we should drop it for simplicity.
> 
>> > > What's a little bit tricky here is that the sha3 lib is statically
>> > > build into the kernel. So no chance to unload/load this as a module.
>> > > For sha1 and the sha2 stuff I can understand the need to have this
>> > > statically enabled in the kernel. Sha3 is only supposed to be
>> > > available
>> > > as backup in case of sha2 deficiencies. So I can't see why this is
>> > > really statically needed.
>> >
>> > CONFIG_CRYPTO_LIB_SHA3 is a tristate option.  It can be either built-in
>> > or a loadable module, depending on what other kconfig options select it.
>> > Same as all the other crypto library modules.
>> 
>> I know and see this. However, I am unable to switch this to 'm'. It 
>> seems
>> like the root cause is that CRYPTO_SHA3='y' and I can't change this to 
>> 'm'.
>> And honestly I am unable to read these dependencies (forgive my 
>> ignorance):
>> 
>> CONFIG_CRYPTO_SHA3:
>> SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
>>  Symbol: CRYPTO_SHA3 [=y]
>>   Type  : tristate
>>   Defined at crypto/Kconfig:1006
>>     Prompt: SHA-3
>>     Depends on: CRYPTO [=y]
>>     Location:
>>       -> Cryptographic API (CRYPTO [=y])
>>         -> Hashes, digests, and MACs
>>           -> SHA-3 (CRYPTO_SHA3 [=y])
>>   Selects: CRYPTO_HASH [=y] && CRYPTO_LIB_SHA3 [=y]
>>   Selected by [y]:
>>     - CRYPTO_JITTERENTROPY [=y] && CRYPTO [=y]
> 
> Well, all that is saying is that there is a built-in option that 
> selects
> SHA-3, which causes it to be built-in.  So SHA-3 being built-in is
> working as intended in that case.  (And it's also intended that we no
> longer allow the architecture-optimized code to be built as a module
> when the generic code is built-in.  That was always a huge footgun.)  
> If
> you want to know why something that needs SHA-3 is being built-in, 
> you'd
> need to follow the chain of dependencies up to see how it gets 
> selected.
> 
> - Eric

And here is a benchmark where I used I used commit
151fbe15a6cb lib/crypto: s390/sha3: Migrate optimized code into library
from your branch sha3-lib-v1. As far as I have in mind this lacks the
code optimizations:

Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1: 
12 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16: 
196 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: len=64: 
648 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=127: 1011 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=128: 1014 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=200: 1281 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=256: 1396 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=511: 2593 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=512: 2624 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=1024: 4637 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=3173: 8931 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=4096: 10636 MB/s
Nov 04 12:47:32 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=16384: 12339 MB/s
