Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A472F8462;
	Thu, 30 Oct 2025 08:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811898; cv=none; b=jwoShaCbHVJwKwwVvlbALi4/yzd0F2eZ/CKxFWgvpgciQEP1tyQP0LWCDnON92hN2QrQZqtY0g6hD+WNwQoPgY2m/QpuZGX67Tu4Xzf1bSBNhMvqO5SVNQJZGJCf3XQpDobFewgGoDyoZNNLd2HCwmPVRebY/PGVkEj2seNNlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811898; c=relaxed/simple;
	bh=iYhsNsND7qDO+YoBKABPFaj6i6RQQLg9em+341lxC0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZA3aWeejk3S8j78t0YKqP+HUTuqUncFbUzNqIPc1alMqJsRp8qtasDk+CNxvEvgTRxyh3ndzEMc6o0nP2oi/8+YxloldypMzZcr5ifU7rKPOQ3QaSpmFvDwaLlE95uPZC3/T2Jbv7Z9fDWTvtByafsqS0DixDG6MT5ViLATT9FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cuJG1pZs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cuJG1pZs"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TLn0RC025885;
	Thu, 30 Oct 2025 08:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/eQjJmYkYH6SFeE+16nCc7H9e+jNOC
	Rg1nbgStXINRw=; b=cuJG1pZsfaDqquxCGrOzfAhNCTQ2ugViPxgZAEFflsoUC5
	dRVTCZoXoiNUjAM/QbiZIVkkXwJgCun0g33n8FboORMftxUjhON5UKvbkm9fn+g7
	4u3Z4rTgmQ75v+Pa9dLJ9AXhXofu7HyTLkZHoDXOKbKc3ghfOfzVcIfu2I4iBR4i
	hQLTwCE/xVOq5ufKUT84DQFKGICO4vF5uZ+LmljvCX/n6LIX4ukdbMWtIO/bT/+S
	antjD7qTt3JUxAeWP8tHw+l5ANqrvw5XwYsUO9UjLUNIeYTzVA10B9PjurDwNyOe
	bhZzp60OECuRQgEhgtCxz5qP6mt+dVQj8MDjWO7g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34acq8tw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 08:11:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59U5qPIP027495;
	Thu, 30 Oct 2025 08:11:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33w2qgcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 08:11:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59U8BGfP60686592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:11:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9644A2004B;
	Thu, 30 Oct 2025 08:11:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4775F20049;
	Thu, 30 Oct 2025 08:11:16 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Oct 2025 08:11:16 +0000 (GMT)
Date: Thu, 30 Oct 2025 09:11:14 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251030081114.16837A86-hca@linux.ibm.com>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <ba3ff3d5183ab78b3d02d8db30223def@linux.ibm.com>
 <20251029163216.GA1603@sol>
 <20251029203345.GA3750798@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029203345.GA3750798@google.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbuEDY55 c=1 sm=1 tr=0 ts=69031da9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QzQn2ZgXezoNSR50NVEA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: YSIgbfw2sRFgOkhpdpHl13KDpANc36eI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfXx99/Np7suF0D
 LdNjxw8CMpQUQfWr5ceWx67gWngQfx6OwZL8VGJyQUoL7dj2TK82msPvqeMbboIBXSRD/hfHP5y
 CoByoCwcC0w3YSttYeDzqxehe1u3h3gypxQ/bh+vdb8OvyC7f72xwj+kNy0PQhdb6RB5Z61j6WL
 PzQwDYALi+yVz1E6maJcezSCOu+Jkm9Gby5uGlnF3vXFD58/R34oNDXwEW6+pSeCLJkvMAVKDqZ
 KiGrmSmTJel7FpX5dAewlh+98nvWv4EDR0ukEPAWQpo5G4zEKBMajDv+T6t//8lvJS7xWoqrIBb
 9/pg7l5aSGVgAOeLHkApb161ER2khS8yF9xp9nS1tcWdrPlVZ/6peqLtoJV6rpFFLVxvBfUGODB
 2uMVMMvEQ76KhoyBqJbaS82w/BUk5g==
X-Proofpoint-GUID: YSIgbfw2sRFgOkhpdpHl13KDpANc36eI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

On Wed, Oct 29, 2025 at 08:33:45PM +0000, Eric Biggers wrote:
> (By the way, I recommend defining named constants somewhere in
> arch/s390/ for the different facilities.  I borrowed the
> "test_facility(86)" from the existing code, which does not say what 86
> means.  After doing some research, it looks like it means MSA12.)

Not so surpringly this has been discussed several times in the
past. It would have been easy if each of those bits would represent
exactly one facility, but then there is e.g. bit 46 which means:

the distinct-operands, fast-BCR-serialization, high-word, and
population-count facilities, the interlocked-access facility 1, and
the load/store-on- condition facility 1 are installed in the
z/Architecture architectural mode

Some proposed to add defines like "FACILITY_MULTI_46", which is of
course pointless, since there is added benefit for just using plain
46. Alternatively it would be possible to have a define for each of
them. But if you need two or three of them for your code, then there
would be several tests needed - all for the same bit, and each one
generating a static branch - which also doesn't make too much sense.

So in the end we ended up with the conclusion to stick with the plain
numbers.

That said, users are still free to add aliases like e.g. cpu_has_vx(),
see arch/s390/include/asm/cpufeature.h. It is just not an all or
nothing approach.
