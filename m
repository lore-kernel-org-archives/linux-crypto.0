Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D562258A;
	Mon, 30 Jun 2025 07:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269065; cv=none; b=fLlyZhzcfqqgblC6KsTu8rQQjLLElfvsAGgmufB4oJQXGABTzMvlw3gEPYKmFFyfoYoKMiE86i6bcW4/Ic96CT2P9f6bR2i5S/nlmx9g4Ry0bgHd7xuW1vxZySzMDP1OuGX/Cc330Y5phRcea+xab5a6fW++izSIi0qRaOnkjT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269065; c=relaxed/simple;
	bh=sG18V9YH6xwaMCKoP5b6EmXZZdF6kA34hDti89/UFzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CljHt8S2S18CiSD8ZayDEqVl12z3nDtAVBZL9ezhVBi+JGwpg8A2k82vnJNmLSYYgsaM7CaqPQaFDWGBbxkS4jJ8Oi/RsZglxEqdEU0bb1UN+S6Ruf4gjdARHL4caJ+sW2zwk5GvtRpmNx1yMhKP55pLM//Ef1yiMWSbYewCIiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e1i4YqiD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e1i4YqiD"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55TKuAvD027682;
	Mon, 30 Jun 2025 07:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=LRuxJGeazOAFE04HqsIYG5vhTHeYxo
	okmIsQ4rJ0tr8=; b=e1i4YqiDY8naXnepnWvjDRT1icKqYeUPy0sKroEwdegooK
	XhfgAqCcIHNY99Fo1ms6mc8/sunnG8B0qa4T2RyDa7atatmN9GaAEi0trTxO8t59
	5BmkOURCLWZwzeqRt2LbBek/J5GYoEjShxtT4Hiu/BXe7lXlVFk6SWg583iLQS/+
	VadCkhXg93j+UrNuKOmxrmNcWeVHKWcy8HRfraiNw1XkdkASwbhZjSkSW0bIhPBc
	axodA+w9wi8dyp+cvXjrHNRgMuX+tcJVkcIELmUf/W6S5oKzKx4pxIO7Sjz2y43d
	8apG/Ixb+L7BRxxnBDKsdy8lz7aU/gEtGWkWHT/w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47j84cyw1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 07:36:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55U4P3Yt032250;
	Mon, 30 Jun 2025 07:36:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47ju40d014-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 07:36:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55U7aVQC19136952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Jun 2025 07:36:31 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CCCE200F7;
	Mon, 30 Jun 2025 07:36:31 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9864200FD;
	Mon, 30 Jun 2025 07:36:23 +0000 (GMT)
Received: from osiris (unknown [9.111.82.77])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 30 Jun 2025 07:36:23 +0000 (GMT)
Date: Mon, 30 Jun 2025 09:36:11 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Joerg Schmidbauer <jschmidb@de.ibm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
Message-ID: <20250630073611.15284Ab6-hca@linux.ibm.com>
References: <20250627185649.35321-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627185649.35321-1-ebiggers@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lUTN_MH2-aHDhXdBvhoSJxnHTj2BMH8s
X-Proofpoint-GUID: lUTN_MH2-aHDhXdBvhoSJxnHTj2BMH8s
X-Authority-Analysis: v=2.4 cv=Ib6HWXqa c=1 sm=1 tr=0 ts=68623e87 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=adFIAS80RBVZD6iCsq0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjMwMDA1OSBTYWx0ZWRfX4fBph0upJLoJ qAnseUygVc31k1QlUokbrLSgo1tcxWae2LXhVcad06UInBCAzoYSneVvU8zkzrsd+ooHLNqKLBs JGHGyAP6assaCXlMdDjozBidzIik70S5p5lVsG4sNoCW6rI4MWSikRASdJg80OsbMoqwoId1VhM
 OvN3aI2Z0vqXTxr2B3WqBB/1Gc3zEBdDkUnBHBeUtJf95/JYI4nN4eo9Le/p+Ycer41iFDxI6qu /o0aGbFJZiFftAWvI4Mqm2PmwiyyPN4vM9JIba+Wn4txqeiuxoFBCo6tuDKkpYOat3XpWYhovo3 td/MKH5hU42E9OAdoO4AYx4/LE6L5yqc1cs2HI1hJlxwKqJNtgwjXID2GeA6CK8plmzQNkiNePt
 87rmZVMpdZvYUtjrjHYUeaB5w9a+4vFM2PUlxTPAUK7AYdg7f9VcT9P1UrTHI3kzp1hzpLNX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-30_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=442 lowpriorityscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506300059

On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
> Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> added the field s390_sha_ctx::first_message_part and made it be used by
> s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> the initialization functions for SHA-3 were updated, leaving SHA-1 and
> SHA-2 using first_message_part uninitialized.
> 
> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> problem earlier; this bug was found only when UBSAN detected the
> uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> and SHA-2.  Regardless, let's fix this.  For now just initialize to
> false, i.e. don't try to "optimize" the SHA state initialization.
> 
> Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> hadn't yet been librarified (which incidentally fixed this bug).
> 
> Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> Cc: stable@vger.kernel.org
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is targeting 6.16.  I'd prefer to take this through
> libcrypto-fixes, since the librarification work is also touching this
> area.  But let me know if there's a preference for the crypto tree or
> the s390 tree instead.
> 
>  arch/s390/crypto/sha1_s390.c   | 1 +
>  arch/s390/crypto/sha512_s390.c | 2 ++
>  2 files changed, 3 insertions(+)

Routing this via libcrypto-fixes is fine.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
