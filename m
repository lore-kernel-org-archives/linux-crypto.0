Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE7820B7EE;
	Fri, 24 Oct 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761315851; cv=none; b=UetQKSH7gpI+dI4JqnoDv2Xj+vZ+oxHWcclbxuIKwTZibt1P/rmOpbihmBc99f3uVMmds9JnT3HHTAxmKTCwgihv+mmCouSadvjfScNFKh2+VYsPqUJ8F1crhWIzuRF8JufFe6ZMUPrnLpFq5l0GaC8UCkaksBOujlizQnjJrEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761315851; c=relaxed/simple;
	bh=ppRVyfRVIH8bZsZWAE5rWCDKac3K8OKO5jqyS8t/g1M=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=UgBzgRmFwW6AFgzj5lUyu2yEBirbVGR6oiFFsDO/swq/whA2w7Yx+ayG/6p6134YIPDi7IBzrgzOcen7akhpmrsck+BlBxG0AqjCL6d6F8rHIQsn2jvUL8ET7Mj6gUv4CHuVtxtLMwc6BtQlGJibEt3bbdqr/PbNV0iiwnyw//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U+z7lKKK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U+z7lKKK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OA2nCk023244;
	Fri, 24 Oct 2025 14:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=QTv5l8HYsmXSaBkMSL5ZDaSrsBFiVYOpAyIiO0ly0rU=; b=U+z7lKKKbjXr
	HLDG3Zc7L9QsfRKFx06zgpP6WhgYwkk94lFm02+yTgixgWacf0+bMFZNW9cReS8V
	zz0Yff4Wuqzd53o1xMhsKkckW4RcC2lypY1T5oy9VHjTcbUsBXlHAD/KZp0OwCOn
	01z36FmXyqrw6KJb0P1U+Fkrx/W523iKOTciKVA+tSSBz9dKZudRPyU+GxAAQ4wn
	KkGFKqe46z4FBgNxzI7zsw5e9BBYhsonlhlRet0HP9KdSRnLuRuk87bnV+Z+PW9j
	0ItC6cNvJllKH9Vvvyw/A8icsd+CJXvep7/aBi1My9XnnkbqAhEjAQkCRSECv/Y6
	vJ8O7ddaeg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v3277rhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 14:24:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59OAkYeV011015;
	Fri, 24 Oct 2025 14:24:01 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx1k6gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 14:24:01 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59OEO1vH26673758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:24:01 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AD3358056;
	Fri, 24 Oct 2025 14:24:01 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C57CF58052;
	Fri, 24 Oct 2025 14:24:00 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Oct 2025 14:24:00 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 24 Oct 2025 16:24:00 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Holger Dengler <dengler@linux.ibm.com>,
        David Howells
 <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A .
 Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20251021154906.GB83624@google.com>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
 <20251020175736.GC1644@sol>
 <29e766ca-54e4-453d-9dfc-ea47e2a1f860@linux.ibm.com>
 <5895ed68-dd6e-4f3d-9e6f-c27459556ff7@linux.ibm.com>
 <20251021154906.GB83624@google.com>
Message-ID: <b9094694cb5bc3ec0f479f3c6df909c9@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68fb8c02 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_Sl0zld_v68khJEgkSQA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX/7qZ6wKRafKZ
 mK/7ISmrSIyR9IBlUhFX14cubGLJSW4l1mNog/XzaYNg9VJBvgUceJCtyF3hemj0Cc+0OmCCjO6
 v0Mbwi/cm0IauQI4PXp66wOM0la49kM2giHe334oaCU92VgQaU4yqNgyUmvuvIKYhL7yHfQu1q1
 XuI+2wAK5AC1RmK0WR8YnSmsjMztB99IKqbe80TxZXBBSxglbUbqeyz6q8Bd/lPoPMSvBvrietL
 remlo8xYOWdyu9Qd4C9iDYkZc5lK+cD47CotJ2cHKKZqjXcwpiR8xCt0BCep0qBrcm9+glWcQ9j
 rrWEN0SOrehzh5SbmG1gldwlGQaNkhdLkJKJsa0EfFQ3MyG7Dj+jeelslCZefpCOEDh6eZMZjNV
 91fbD2VkqnhjsIZqg2qhNQXdTXleag==
X-Proofpoint-GUID: pafbIPS1SsUnA0ap6FIduDkkgGpA_N8g
X-Proofpoint-ORIG-GUID: pafbIPS1SsUnA0ap6FIduDkkgGpA_N8g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

On 2025-10-21 17:49, Eric Biggers wrote:
> On Tue, Oct 21, 2025 at 10:43:00AM +0200, Holger Dengler wrote:
>> Hi Eric,
>> 
>> On 21/10/2025 09:24, Holger Dengler wrote:
>> > On 20/10/2025 19:57, Eric Biggers wrote:
>> [...]>> - Risk of bugs.  QEMU doesn't support the s390 SHA-3 
>> instructions, so no
>> >>   one except the s390 folks can test the code.  I can try to write code
>> >>   for you, but I can't test it.  And the s390 SHA-3 code has had bugs;
>> >>   see commits 992b7066800f, 68279380266a5, 73c2437109c3.
>> >>
>> >>   The first priority should be correctness.
>> >
>> > Let me figure out, if me and my colleagues can do the testing for you.
>> > Unfortunately, I'll be unavailable for the next two weeks. But I'll come back
>> > with a solution for the testing.
>> 
>> I talked to Harald: we can do the testing for you on our development 
>> machines.
>> Please send new series to us or provide them in your git repo.
> 
> Thanks!  I'll Cc both of you on v2 when I send it later.  For now, this
> series (v1) can be found in lore at
> https://lore.kernel.org/linux-crypto/20251020005038.661542-1-ebiggers@kernel.org/T/#u
> And as mentioned in the cover letter it's also retrievable from git:
> 
>     git fetch
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> sha3-lib-v1
> 
> v1 already has the s390 optimized implementations of
> sha3_absorb_blocks() and sha3_keccakf().  If you could enable the
> following:
> 
>     CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y
>     CONFIG_CRYPTO_LIB_BENCHMARK=y
> 
> ... and then show the results for sha3_kunit before and after the 
> commit
> "lib/crypto: s390/sha3: Migrate optimized code into library", that 
> would
> be helpful.
> 
> In v2, I'll look into providing overrides for the one-shot functions
> sha3_{224,256,384,512}() too.  If it works out, I'll ask you to re-test
> with that additional change as well.
> 
> - Eric

I pulled your repository and checked out the branch sha3-lib-v1 and
while the kernel build runs I get link errors:

ld: crypto/sha3.o: in function `crypto_sha3_512_digest':
/root/ebiggers-linux/crypto/sha3.c:80:(.text+0xaa): undefined reference 
to `sha3_512'
ld: crypto/sha3.o: in function `crypto_sha3_384_digest':
/root/ebiggers-linux/crypto/sha3.c:73:(.text+0xea): undefined reference 
to `sha3_384'
ld: crypto/sha3.o: in function `crypto_sha3_256_digest':
/root/ebiggers-linux/crypto/sha3.c:66:(.text+0x12a): undefined reference 
to `sha3_256'
ld: crypto/sha3.o: in function `crypto_sha3_224_digest':
/root/ebiggers-linux/crypto/sha3.c:59:(.text+0x1aa): undefined reference 
to `sha3_224'
ld: crypto/sha3.o: in function `sha3_final':
/root/ebiggers-linux/./include/crypto/sha3.h:188:(.text+0x1f0): 
undefined reference to `__sha3_squeeze'
ld: crypto/sha3.o: in function `sha3_update':
/root/ebiggers-linux/./include/crypto/sha3.h:172:(.text+0x232): 
undefined reference to `__sha3_update'

with a s390 defconfig kernel configuration an a s390 debug_defconfig 
kernel configuration.
