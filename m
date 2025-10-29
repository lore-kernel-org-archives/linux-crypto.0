Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688CC2EDD4F;
	Wed, 29 Oct 2025 09:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761730277; cv=none; b=iPRkvxLrfawnO9/Zjhr/wN/ohyhrO4aLtjpu/2YYdd9mki2UiZrF4EDqu2nQEI2JZmD/PA2LJe2hvLgL4+TNY/rxLyo/HS+MSVdHzLzo+nyNDze5iYyTeCzzi0rYgV466S4/RfbtNe/4+dBiXQavgdqtk9/eVplVopQrFNmtOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761730277; c=relaxed/simple;
	bh=67Yp8PRiSnVp+FNZtbZ8Czeko/T31Fa0nNmkzjc6WDc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Luv45MdznSPbIKNJiVlwtLkzzppcJa4LdBwr2hSH3ES1mz0+DimYK8bKCijLgvFKKY2yrTFMEyaTli8OGIrSQ7g7v1nQPpq+POgot1XG0HD3gyHn8q3P/fZEJFRyNArQj7d3yiupUDPJVeenAycX6IT2JM20QF++11hJ0o9dQ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hPVbiq53; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hPVbiq53"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SJmE6u025849;
	Wed, 29 Oct 2025 09:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=bRT40ueltCWeAHZZ/VVXOa8G9IRcy9elrB6Oz4afA/0=; b=hPVbiq536Dqj
	3bArN6jkNL+/JVj5gXhK4+FFMuDeMDy7UGv4fJzFOogpXTQovrhk4ZAbwC1DnXS1
	ujZHyQ6jIPKW5xc5ZSo2MnHpsN4eBV5Pg59Lmuav73Cwo7mD/qkLbluU7qW6mPta
	/54XtEDdeKM/dnJuxOPsHc40YAlebjj7PeQUKGOr0jNgRVJAAHaKGpzby6P8dEbC
	2mrsDIvdigsS2WZkDZn9Fa14X8NNEQaISdu8y0F1zVuiAqogkBJNe7w70LXiR99+
	04/asJF0fRWdcHf/pH11UWx5g3cu2kD4egBKkEecTAadeemi28L27UXFmms7kyrN
	zLagLpMbuw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34acjh3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 09:30:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59T5L8EF027428;
	Wed, 29 Oct 2025 09:30:41 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33w2jjng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 09:30:41 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59T9UfLE26804918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 09:30:41 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EE2258056;
	Wed, 29 Oct 2025 09:30:41 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE30E5805A;
	Wed, 29 Oct 2025 09:30:40 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Oct 2025 09:30:40 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 29 Oct 2025 10:30:40 +0100
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
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Message-ID: <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbuEDY55 c=1 sm=1 tr=0 ts=6901dec2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=0OBHIRt0DnuW_K4Yg-cA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: lPW4ZZ8WPxSI5DjsUIJxSoxD1Sb2aixA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX3g8vFV4TCTar
 BBnezYFrJ5i3rlVVYjzx73BF8sVp0LCWePV8QOg+97Gorw0IcieSreJg8loOWfKwGyWmpLFQeYK
 G95sOYMLk/xtNE4V4e7kBvaCm3HUu97hv1nvbivKHhDTcz+I5PT3Pkxbue9FycumrEals1ke8dY
 gajALPML41PC+5HkxsgX2xlDpp1sCrzA7x4N8mdIX8vLT7Ysy6QloapLrNTXYnUubJFo/yIkQWz
 sFWzFMR4DUDKgVQ7fGQ29xyFSMQu84mAa0aRIg1QXHTzn15sJwn9iZMxhhHhU8gEd2S09H8aujD
 jJMUJuWXUDIbU/QI1JW3i6rntsrEK4yw+OlgN/qGpdCOm5Dd4SH3PdQFSeZjzdujfu2gtyxGppG
 ZKfE81y/GLBXs7tm+I1MUJ1Y6f/rmA==
X-Proofpoint-GUID: lPW4ZZ8WPxSI5DjsUIJxSoxD1Sb2aixA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On 2025-10-26 06:50, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved 
> from:
> 
>     git fetch
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> sha3-lib-v2
> 
> This series adds SHA-3 support to lib/crypto/.  This includes support
> for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
> and also support for the extendable-output functions SHAKE128 and
> SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
> 
> The architecture-optimized SHA-3 code for arm64 and s390 is migrated
> into lib/crypto/.  (The existing s390 code couldn't really be reused, 
> so
> really I rewrote it from scratch.)  This makes the SHA-3 library
> functions be accelerated on these architectures.
> 
> Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
> algorithms are reimplemented on top of the library API.
> 
> If the s390 folks could re-test the s390 optimized SHA-3 code (by
> enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
> would be helpful.  QEMU doesn't support the instructions it uses.  
> Also,
> it would be helpful to provide the benchmark output from just before
> "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
> and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
> functions".  Then we can verify that each change is useful.
> 
> Changed in v2:
>   - Added missing selection of CRYPTO_LIB_SHA3 from CRYPTO_SHA3.
>   - Fixed a bug where incorrect SHAKE output was produced if a
>     zero-length squeeze was followed by a nonzero-length squeeze.
>   - Improved the SHAKE tests.
>   - Utilized the one-shot SHA-3 digest instructions on s390.
>   - Split the s390 changes into several patches.
>   - Folded some of my patches into David's.
>   - Dropped some unnecessary changes from the first 2 patches.
>   - Lots more cleanups, mainly to "lib/crypto: sha3: Add SHA-3 
> support".
> 
> Changed in v1 (vs. first 5 patches of David's v6 patchset):
>   - Migrated the arm64 and s390 code into lib/crypto/
>   - Simplified the library API
>   - Added FIPS test
>   - Many other fixes and improvements
> 
> The first 5 patches are derived from David's v6 patchset
> (https://lore.kernel.org/linux-crypto/20251017144311.817771-1-dhowells@redhat.com/).
> Earlier changelogs can be found there.
> 
> David Howells (5):
>   crypto: s390/sha3 - Rename conflicting functions
>   crypto: arm64/sha3 - Rename conflicting function
>   lib/crypto: sha3: Add SHA-3 support
>   lib/crypto: sha3: Move SHA3 Iota step mapping into round function
>   lib/crypto: tests: Add SHA3 kunit tests
> 
> Eric Biggers (10):
>   lib/crypto: tests: Add additional SHAKE tests
>   lib/crypto: sha3: Add FIPS cryptographic algorithm self-test
>   crypto: arm64/sha3 - Update sha3_ce_transform() to prepare for 
> library
>   lib/crypto: arm64/sha3: Migrate optimized code into library
>   lib/crypto: s390/sha3: Add optimized Keccak functions
>   lib/crypto: sha3: Support arch overrides of one-shot digest functions
>   lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
>   crypto: jitterentropy - Use default sha3 implementation
>   crypto: sha3 - Reimplement using library API
>   crypto: s390/sha3 - Remove superseded SHA-3 code
> 
>  Documentation/crypto/index.rst                |   1 +
>  Documentation/crypto/sha3.rst                 | 130 ++++++
>  arch/arm64/configs/defconfig                  |   2 +-
>  arch/arm64/crypto/Kconfig                     |  11 -
>  arch/arm64/crypto/Makefile                    |   3 -
>  arch/arm64/crypto/sha3-ce-glue.c              | 151 -------
>  arch/s390/configs/debug_defconfig             |   3 +-
>  arch/s390/configs/defconfig                   |   3 +-
>  arch/s390/crypto/Kconfig                      |  20 -
>  arch/s390/crypto/Makefile                     |   2 -
>  arch/s390/crypto/sha.h                        |  51 ---
>  arch/s390/crypto/sha3_256_s390.c              | 157 -------
>  arch/s390/crypto/sha3_512_s390.c              | 157 -------
>  arch/s390/crypto/sha_common.c                 | 117 -----
>  crypto/Kconfig                                |   1 +
>  crypto/Makefile                               |   2 +-
>  crypto/jitterentropy-kcapi.c                  |  12 +-
>  crypto/sha3.c                                 | 166 +++++++
>  crypto/sha3_generic.c                         | 290 ------------
>  crypto/testmgr.c                              |   8 +
>  include/crypto/sha3.h                         | 306 ++++++++++++-
>  lib/crypto/Kconfig                            |  13 +
>  lib/crypto/Makefile                           |  10 +
>  .../crypto/arm64}/sha3-ce-core.S              |  67 +--
>  lib/crypto/arm64/sha3.h                       |  62 +++
>  lib/crypto/fips.h                             |   7 +
>  lib/crypto/s390/sha3.h                        | 151 +++++++
>  lib/crypto/sha3.c                             | 411 +++++++++++++++++
>  lib/crypto/tests/Kconfig                      |  11 +
>  lib/crypto/tests/Makefile                     |   1 +
>  lib/crypto/tests/sha3-testvecs.h              | 249 +++++++++++
>  lib/crypto/tests/sha3_kunit.c                 | 422 ++++++++++++++++++
>  scripts/crypto/gen-fips-testvecs.py           |   4 +
>  scripts/crypto/gen-hash-testvecs.py           |  27 +-
>  34 files changed, 2012 insertions(+), 1016 deletions(-)
>  create mode 100644 Documentation/crypto/sha3.rst
>  delete mode 100644 arch/arm64/crypto/sha3-ce-glue.c
>  delete mode 100644 arch/s390/crypto/sha.h
>  delete mode 100644 arch/s390/crypto/sha3_256_s390.c
>  delete mode 100644 arch/s390/crypto/sha3_512_s390.c
>  delete mode 100644 arch/s390/crypto/sha_common.c
>  create mode 100644 crypto/sha3.c
>  delete mode 100644 crypto/sha3_generic.c
>  rename {arch/arm64/crypto => lib/crypto/arm64}/sha3-ce-core.S (84%)
>  create mode 100644 lib/crypto/arm64/sha3.h
>  create mode 100644 lib/crypto/s390/sha3.h
>  create mode 100644 lib/crypto/sha3.c
>  create mode 100644 lib/crypto/tests/sha3-testvecs.h
>  create mode 100644 lib/crypto/tests/sha3_kunit.c
> 
> base-commit: e3068492d0016d0ea9a1ff07dbfa624d2ec773ca

Picked this series from your ebiggers repo branch sha3-lib-v2.
Build on s390 runs without any complains, no warnings.
As recommended I enabled the KUNIT option and also 
CRYPTO_SELFTESTS_FULL.
With an "modprobe tcrypt" I enforced to run the selftests
and in parallel I checked that the s390 specific CPACF instructions
are really used (can be done with the pai command and check for
the KIMD_SHA3_* counters). Also ran some AF-alg tests to verify
all the the sha3 hashes and check for thread safety.
All this ran without any findings. However there are NO performance
related tests involved.

What's a little bit tricky here is that the sha3 lib is statically
build into the kernel. So no chance to unload/load this as a module.
For sha1 and the sha2 stuff I can understand the need to have this
statically enabled in the kernel. Sha3 is only supposed to be available
as backup in case of sha2 deficiencies. So I can't see why this is
really statically needed.

Tested-by: Harald Freudenberger <freude@linux.ibm.com>


