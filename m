Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011212CDBE;
	Thu, 30 Oct 2025 10:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819391; cv=none; b=YGnpQX7eab7y8O1eXBX5tzPNwQbtJ0fdQ4qqQppEEnet1JdCKaTcXyrFR3s8UGrWGQz3/emX+TH+5CKMryfAFhRXAJfb3u11gHkrDSU86rFCVC4d8FGxjE+eumBNbx0SYLB8+U2tgGODq9s4WuVNBDZL8ldH+Crnas+BsHCm7DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819391; c=relaxed/simple;
	bh=3/mAX/qXwwAkF9NMN8E4c5aGLiLB3NvsU4dDKxeuMUg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=nwgp4EW3RLsNNUy5lX0jZ6GiXerIUFxzvdHuB8i2EAjX7OSFg4Yua9NCU8Xp+2SLlQ3F8fCm9gTmkSSJ6hsEVyt3zIO6M10meB8D9Cd0XTTW6ZTW9mo8psg82GHEHqktKj5rDwP6R6OeNlBuk6hAtW8yWhPAKd7K3AXs9LK58rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lS/J3iOZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lS/J3iOZ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TNrekC025857;
	Thu, 30 Oct 2025 10:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=YoSq++nMszGY9bt29LBL0PZ1p8tLUB3QcUk9v8Tevok=; b=lS/J3iOZUqdw
	xjtisU2ThKSfJuqjhqAJq+T6WakwcMIwHRZaRiKrX/BEJCbEYrwhnVLIbynjYFup
	kccbZ5PqbTAcOfbGoF3pB048WWZqzMbNbB+ixyLPP/aeQv5oMjcF9GOacdhomTHB
	7R9xqbkAWawhoCWaVVdJymcvmflEryL3mnk+KxCK49KpfPs6Zoq5WxUmJfjkhWH3
	YhBDvCWIz2xwUzucIG5JtT6fqLgM9a+ONdeG2snUOKiz8eN5/cwz0JBychXUwljk
	T9qAEEc6S8tS9hYFa5Jq5ofsteq/J1yYm6FPSgyznEkls81JvZCHZ23AiE+5F/Jk
	HgHORyw02Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aaqj4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 10:16:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59U9ZAL2031682;
	Thu, 30 Oct 2025 10:16:17 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33w0851w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 10:16:17 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59UAGGRD49938778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:16:16 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E7E25803F;
	Thu, 30 Oct 2025 10:16:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDD3E5805A;
	Thu, 30 Oct 2025 10:16:15 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Oct 2025 10:16:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 30 Oct 2025 11:16:15 +0100
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
In-Reply-To: <20251029203345.GA3750798@google.com>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com> <20251029163216.GA1603@sol>
 <20251029203345.GA3750798@google.com>
Message-ID: <ae42f7c7aadce04444d40190db13d554@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=69033af1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=0r5XAF8DqmaS_OcKmuIA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: oP_21WzJILOfDfjLU50L0OlXP7MaxWvL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX4dUULRhVnU1x
 1FOVGJlnMw0vaiqnv7D4t705UMKnCzlabHzk/wl1Z7nc9Wr/G4ezmLHLY3fC4g3AzMfxrpBF0ro
 WDNS2z3dDytelCZ976WddeLufMjSDBikGYHlikPvMF91xhmTBWd3zV5dXhw+usM68iWUY7CWoCU
 MzV7gMdAM0Mg7BBBcgprbbqDIf5ernyCWzaqVKI9m7IHgeQBhEgVKMdfcqXNGKixEgxn4UBwdCt
 VU+Yeip1mLnIzjHAK05b5nZBqFSGy/pO0FDJXWvaTCmydZdWRzcghaD4qE3glgHZRWjYWx7EKsq
 hohMmmnx2bPtTQviCES0VxCy1yDNciMWZGpqSoiOB2Yo4WhRU84UgxiX3k4Kq2gS+iKktWfbF90
 0nZt6Th4CtUHz0oKVGkzQpIFjyYboQ==
X-Proofpoint-GUID: oP_21WzJILOfDfjLU50L0OlXP7MaxWvL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On 2025-10-29 21:33, Eric Biggers wrote:
> On Wed, Oct 29, 2025 at 09:32:16AM -0700, Eric Biggers wrote:
>> On Wed, Oct 29, 2025 at 10:30:40AM +0100, Harald Freudenberger wrote:
>> > > If the s390 folks could re-test the s390 optimized SHA-3 code (by
>> > > enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
>> > > would be helpful.  QEMU doesn't support the instructions it uses.  Also,
>> > > it would be helpful to provide the benchmark output from just before
>> > > "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
>> > > and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
>> > > functions".  Then we can verify that each change is useful.
>> [...]
>> >
>> > Picked this series from your ebiggers repo branch sha3-lib-v2.
>> > Build on s390 runs without any complains, no warnings.
>> > As recommended I enabled the KUNIT option and also CRYPTO_SELFTESTS_FULL.
>> > With an "modprobe tcrypt" I enforced to run the selftests
>> > and in parallel I checked that the s390 specific CPACF instructions
>> > are really used (can be done with the pai command and check for
>> > the KIMD_SHA3_* counters). Also ran some AF-alg tests to verify
>> > all the the sha3 hashes and check for thread safety.
>> > All this ran without any findings. However there are NO performance
>> > related tests involved.
>> 
>> Thanks!  Just to confirm, did you actually run the sha3 KUnit test and
>> verify that all its test cases passed?  That's the most important one.
>> It also includes a benchmark, if CONFIG_CRYPTO_LIB_BENCHMARK=y is
>> enabled, and I was hoping to see your results from that after each
>> change.  The results get printed to the kernel log when the test runs.
>> 
> 
> Also, can you confirm that you ran the test on a CPU that has
> "facility 86", so that the one-shot digest functions get exercised?
> 
> (By the way, I recommend defining named constants somewhere in
> arch/s390/ for the different facilities.  I borrowed the
> "test_facility(86)" from the existing code, which does not say what 86
> means.  After doing some research, it looks like it means MSA12.)
> 

Of course, the machine I used has MSA level 12 (stfle bit 86).

> - Eric
