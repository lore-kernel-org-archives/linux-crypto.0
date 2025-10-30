Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C4D41C69;
	Thu, 30 Oct 2025 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819075; cv=none; b=j995vF9Kb8XTilEJ7SoFpBY4M1D7v23kfsIdmKEAmymdQMl1fWQKmR6LDVczpA1dFc3j6GwmSe6DQIxLpWeuKeXbnd1+D64p6l0vSxp9TIdg3GqUhWln/JBDBJ/DKOZ/tAGYP1R6cIfP9lu6ap6FFEC1XZPshv1pjdMfHGutiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819075; c=relaxed/simple;
	bh=3F5YlBlt+z0kzM8nCLqJkuqh3UPHp1fBawFYrP8ygjI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=DNFVK87e4OQki09y4+k3S0AytsVpdUbnd0NHwnmY2an4faVcjuiX1wBTp5Q3iFSnc8q+NEyEFPsNcR2brtZ3e3Q335iViKbL29R12QHzf4VlYSKKbo6NOvDO01+FXNTvRr+ki7mwqStHURiMgPMHOIar3N30/mwOQrrigrkEI6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HZ5pUGLA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HZ5pUGLA"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKfqth026155;
	Thu, 30 Oct 2025 10:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=b+9c//CqGqXs1EvYyaw9p4mfVGksibj40nFftwj0X2c=; b=HZ5pUGLAVosr
	D4gJY0ZzWO1qUpd3FYVqOCF8utJoR3aEb/BDWGkwS/Afbg2zab+PQkt0RIGZ/hF2
	kFXQAv4Z6IgNC854SpCnTgfaypHNn8COBdn+csFJrOouRbhhjGaDCku8Vo3JwxMy
	wkiwweW9/VJ3IpTLZDYgz9IjafSQ6iJyX3dm9JEsrGIzX78bHIRWp8eXSfulal79
	iTTR8viyJ1RkQ6+fPh9CETL3L26Uh2YM1CRPa5qX4mWMwLd4JdrEkxHF3Ne8I9cm
	q4FXpvT4QRDvzV0Zz5L+f200NqxGKcF/7vAKiVjCMwrBlqouAocMTUneQ4vvHbqp
	cisQz6jnvw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aaqhjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 10:10:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59U9exwE023919;
	Thu, 30 Oct 2025 10:10:24 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33vx849j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 10:10:24 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59UAANik6947366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:10:23 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EE825805F;
	Thu, 30 Oct 2025 10:10:23 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB5705805B;
	Thu, 30 Oct 2025 10:10:22 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Oct 2025 10:10:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 30 Oct 2025 11:10:22 +0100
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
In-Reply-To: <20251029163216.GA1603@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com> <20251029163216.GA1603@sol>
Message-ID: <fa8bc10f36b1aeb9ffe1abf6350adbc1@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=69033991 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=WVmDiQGdFGOvvYNDNwwA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 1NTO-GqcrkTuq3zAPtgiiup9KtYe8xFC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX0VdIDefrEemR
 oyDicGdm8gl6OM91qy96lykDj0F3lXrv1kMFJVJAUdfu0jEUzASdRCCQM7SfwK1NE/rsG8Te3Q5
 JNzilqS6YwqXXpIwlBbVSIeg+tzYGxwC7w9a1tcMjLmQeer7HIF9SBVhYiCxKR2Ya4GqqVcsVEy
 j/2PkkhSMd77aXOTnuuc6d+Q5KJ26B9lX9vyevKa23naSUPGstkGRhIn4ililE+S8JI/+hJRMGy
 JGQsVG03xdEC3liLanplyG5a4d90DWOHxCGJbSOzlat6gFMkzyaRS3PjvhLgJD2MDJ1ro643trg
 NEhilKFA4uRJF33gnTQZv+DbJ0dNc8pnO5s9nut3kgssduKZWp/VI2wKxgCI+WomEC30IGB+15Y
 CMsz8wTp7kAtxx6K/vIvlAkT2fL8Kg==
X-Proofpoint-GUID: 1NTO-GqcrkTuq3zAPtgiiup9KtYe8xFC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On 2025-10-29 17:32, Eric Biggers wrote:
> On Wed, Oct 29, 2025 at 10:30:40AM +0100, Harald Freudenberger wrote:
>> > If the s390 folks could re-test the s390 optimized SHA-3 code (by
>> > enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
>> > would be helpful.  QEMU doesn't support the instructions it uses.  Also,
>> > it would be helpful to provide the benchmark output from just before
>> > "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
>> > and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
>> > functions".  Then we can verify that each change is useful.
> [...]
>> 
>> Picked this series from your ebiggers repo branch sha3-lib-v2.
>> Build on s390 runs without any complains, no warnings.
>> As recommended I enabled the KUNIT option and also 
>> CRYPTO_SELFTESTS_FULL.
>> With an "modprobe tcrypt" I enforced to run the selftests
>> and in parallel I checked that the s390 specific CPACF instructions
>> are really used (can be done with the pai command and check for
>> the KIMD_SHA3_* counters). Also ran some AF-alg tests to verify
>> all the the sha3 hashes and check for thread safety.
>> All this ran without any findings. However there are NO performance
>> related tests involved.
> 
> Thanks!  Just to confirm, did you actually run the sha3 KUnit test and
> verify that all its test cases passed?  That's the most important one.
> It also includes a benchmark, if CONFIG_CRYPTO_LIB_BENCHMARK=y is
> enabled, and I was hoping to see your results from that after each
> change.  The results get printed to the kernel log when the test runs.
> 

Here it is - as this is a zVM system the benchmark values may show poor 
performance.

Oct 30 10:46:44 b3545008.lnxne.boe kernel: KTAP version 1
Oct 30 10:46:44 b3545008.lnxne.boe kernel: 1..1
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     KTAP version 1
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # Subtest: sha3
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # module: sha3_kunit
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     1..21
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 1 
test_hash_test_vectors
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 2 
test_hash_all_lens_up_to_4096
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 3 
test_hash_incremental_updates
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 4 
test_hash_buffer_overruns
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 5 test_hash_overlaps
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 6 
test_hash_alignment_consistency
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 7 
test_hash_ctx_zeroization
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 8 
test_hash_interrupt_context_1
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 9 
test_hash_interrupt_context_2
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 10 test_sha3_224_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 11 test_sha3_256_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 12 test_sha3_384_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 13 test_sha3_512_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 14 test_shake128_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 15 test_shake256_basic
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 16 test_shake128_nist
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 17 test_shake256_nist
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 18 
test_shake_all_lens_up_to_4096
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 19 
test_shake_multiple_squeezes
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 20 
test_shake_with_guarded_bufs
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: len=1: 
14 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: len=16: 
109 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: len=64: 
911 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=127: 1849 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=128: 1872 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=200: 2647 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=256: 3338 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=511: 5484 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=512: 5562 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=1024: 8297 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=3173: 12625 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=4096: 11242 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     # benchmark_hash: 
len=16384: 12853 MB/s
Oct 30 10:46:44 b3545008.lnxne.boe kernel:     ok 21 benchmark_hash
Oct 30 10:46:44 b3545008.lnxne.boe kernel: # sha3: pass:21 fail:0 skip:0 
total:21
Oct 30 10:46:44 b3545008.lnxne.boe kernel: # Totals: pass:21 fail:0 
skip:0 total:21
Oct 30 10:46:44 b3545008.lnxne.boe kernel: ok 1 sha3

>> What's a little bit tricky here is that the sha3 lib is statically
>> build into the kernel. So no chance to unload/load this as a module.
>> For sha1 and the sha2 stuff I can understand the need to have this
>> statically enabled in the kernel. Sha3 is only supposed to be 
>> available
>> as backup in case of sha2 deficiencies. So I can't see why this is
>> really statically needed.
> 
> CONFIG_CRYPTO_LIB_SHA3 is a tristate option.  It can be either built-in
> or a loadable module, depending on what other kconfig options select 
> it.
> Same as all the other crypto library modules.

I know and see this. However, I am unable to switch this to 'm'. It 
seems
like the root cause is that CRYPTO_SHA3='y' and I can't change this to 
'm'.
And honestly I am unable to read these dependencies (forgive my 
ignorance):

CONFIG_CRYPTO_SHA3:
SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
  Symbol: CRYPTO_SHA3 [=y]
   Type  : tristate
   Defined at crypto/Kconfig:1006
     Prompt: SHA-3
     Depends on: CRYPTO [=y]
     Location:
       -> Cryptographic API (CRYPTO [=y])
         -> Hashes, digests, and MACs
           -> SHA-3 (CRYPTO_SHA3 [=y])
   Selects: CRYPTO_HASH [=y] && CRYPTO_LIB_SHA3 [=y]
   Selected by [y]:
     - CRYPTO_JITTERENTROPY [=y] && CRYPTO [=y]
   Selected by [n]:
     - MODULE_SIG_SHA3_256 [=n] && MODULES [=y] && (MODULE_SIG [=y] || 
IMA_APPRAISE_MODSIG [=n])
     - MODULE_SIG_SHA3_384 [=n] && MODULES [=y] && (MODULE_SIG [=y] || 
IMA_APPRAISE_MODSIG [=n])
     - MODULE_SIG_SHA3_512 [=n] && MODULES [=y] && (MODULE_SIG [=y] || 
IMA_APPRAISE_MODSIG [=n])
     - CRYPTO_DEV_ZYNQMP_SHA3 [=n] && CRYPTO [=y] && CRYPTO_HW [=y] && 
(ZYNQMP_FIRMWARE [=n] || COMPILE_TEST [=n])
     - CRYPTO_DEV_STM32_HASH [=n] && CRYPTO [=y] && CRYPTO_HW [=y] && 
(ARCH_STM32 || ARCH_U8500) && HAS_DMA [=y]
     - CRYPTO_DEV_SAFEXCEL [=n] && CRYPTO [=y] && CRYPTO_HW [=y] && (OF 
[=n] || PCI [=y] || COMPILE_TEST [=n]) && HAS_IOMEM [=y]

> 
> - Eric
