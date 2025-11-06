Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660182FB616;
	Thu,  6 Nov 2025 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419313; cv=none; b=YTod3NNXapioJwkAEdcznptPegLMS7Lx01Rl3FNGxPn/uh0DUW3hV/XsgQGC4dIFYZjBHwDD/paqJow1hme82JGKz1ZvDxNfQnpssUG0tu71jtr1kBD9xQNsWAafqGeDgUYIPkGMiTCKTfHcy3fWar+EfQG/IjjF3P8zVe2jE4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419313; c=relaxed/simple;
	bh=d/pD/gP46F3620KXo3+GN7bYbZ3aNu1afsv1SHN+4D4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Xb/sbDmC4QE/frwJUCpyxN8lUnptW3GrXjz2MlY7MWd2lH02WST0a7y2+3Rinb18XyiW5Pfk6E++AMn2zUAE8bQudjcSszLr2GvM0OKqNgdt2Cb6yYSJC6z6W8RIwDqQ3gm3V2sys7BC4O8WuSmROVdRuIa0DKkdCrWrMrZ74bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G+fjVumH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G+fjVumH"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5NhNl1005923;
	Thu, 6 Nov 2025 08:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=MFInG01yR0dY8J3nBsRoLQvbDU/53/kAPDfXEeqIrbE=; b=G+fjVumHKjbv
	qvTPguosvzrwP3RdNzIv+M9NSRpGBJxABYZTUJeXNrDEtMGSDLy++nKqg7JXcasg
	PRqe1iw7unfVgUXJjTU1ERyZ8wMKf5gVlupr2Gi1ec04TVWzBF8a0VvkiKca86ih
	eRi7/ANx7AvLGnYEG/oV0z0d8MpfjqRaas7kDaun/gS7VS2FtRbzs7aYnJrbFmvc
	MtRM9qitacNTPfqz8vYpcoxTq9M7g7LQRpo1vqwZLy/SmbHgTzQ13utUzdfOrsQt
	rXlLXdQSza9/Yx853NcGfz2NyeFbeoyJy+aCJxoKgsUj9cQ9pMsBzq8c6qqGAlYw
	7/SdrZ7vCQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vup3rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 08:55:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67HCrQ027408;
	Thu, 6 Nov 2025 08:55:01 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5vwymqeb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 08:55:01 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A68t0ic20316922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 08:55:00 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52D265805E;
	Thu,  6 Nov 2025 08:55:00 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDB9E5805A;
	Thu,  6 Nov 2025 08:54:59 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 08:54:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 06 Nov 2025 09:54:59 +0100
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
In-Reply-To: <20251106072233.GA117499@sol>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <20251103173404.GE1735@sol> <4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com>
 <20251106043340.GC1650@sol> <20251106072233.GA117499@sol>
Message-ID: <55ec60661fb672bdd0696a3bd92e21bd@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZRUTdGK-vUq_1cEH5zE8UaIgUSklYNkx
X-Proofpoint-GUID: ZRUTdGK-vUq_1cEH5zE8UaIgUSklYNkx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX7UXj526z1YZ9
 wEEIswQjUDQ/Lkc75HQ7XC9ngsunIFZe7mGCqao7x6XsK6jcwevJZmR6Z/H89FF+tByw4C1VT5x
 pWBTL0ai+mst6N6IBbkXHWDRJUxCFjGVUbdsR04O6us/XQst7iP0U7obhafnydTf4FxdeusOAOd
 sbFPE1YDnidSp8WciVk9hUoSvV2gYkcvqehZhyOKM5PDErKNA/ke328aluJRQaP8lWwCiWBRHFt
 h8e3toHAUPGowEjtfr68AYsLsk+qQQAGdJilKqbNnr+SQEd3d1aUST96M9aOxwRK7a3MQKP+EwP
 6cRkJmSh4ZI8X1qhbbiGWpUhglQGxN6eFThE18Nom0qfVgoNnGtuTwyww4tlxxeKUtW0scAkx6K
 oSAve1xyNdFpLw96tP0TpOgK3N57Vw==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=690c6266 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=6A3F4qp3MpHaHr3445MA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021

On 2025-11-06 08:22, Eric Biggers wrote:
> On Wed, Nov 05, 2025 at 08:33:40PM -0800, Eric Biggers wrote:
>> On Wed, Nov 05, 2025 at 04:39:01PM +0100, Harald Freudenberger wrote:
>> > On 2025-11-03 18:34, Eric Biggers wrote:
>> > > On Sat, Oct 25, 2025 at 10:50:17PM -0700, Eric Biggers wrote:
>> > > > This series is targeting libcrypto-next.  It can also be retrieved
>> > > > from:
>> > > >
>> > > >     git fetch
>> > > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>> > > > sha3-lib-v2
>> > > >
>> > > > This series adds SHA-3 support to lib/crypto/.  This includes support
>> > > > for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
>> > > > and also support for the extendable-output functions SHAKE128 and
>> > > > SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
>> > > >
>> > > > The architecture-optimized SHA-3 code for arm64 and s390 is migrated
>> > > > into lib/crypto/.  (The existing s390 code couldn't really be
>> > > > reused, so
>> > > > really I rewrote it from scratch.)  This makes the SHA-3 library
>> > > > functions be accelerated on these architectures.
>> > > >
>> > > > Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
>> > > > algorithms are reimplemented on top of the library API.
>> > >
>> > > I've applied this series to
>> > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next,
>> > > excluding the following 2 patches which are waiting on benchmark results
>> > > from the s390 folks:
>> > >
>> > >     lib/crypto: sha3: Support arch overrides of one-shot digest
>> > > functions
>> > >     lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
>> > >
>> > > I'd be glad to apply those too if they're shown to be worthwhile.
>> > >
>> > > Note: I also reordered the commits in libcrypto-next to put the new
>> > > KUnit test suites (blake2b and sha3) last, and to put the AES-GCM
>> > > improvements on a separate branch that's merged in.  This will allow
>> > > making separate pull requests for the tests and the AES-GCM
>> > > improvements, which I think aligns with what Linus had requested before
>> > > (https://lore.kernel.org/linux-crypto/CAHk-=wi5d4K+sF2L=tuRW6AopVxO1DDXzstMQaECmU2QHN13KA@mail.gmail.com/).
>> > >
>> > > - Eric
>> >
>> > Here are now some measurements on a LPAR with 500 runs once with
>> > sha3-lib-v2 branch full ("with") and once with reverting only the
>> > b2e169dd8ca5 lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
>> > functions
>> > patch ("without"). With the help of gnuplot I generated distribution
>> > charts over the results of the len=16, 64, 256, 1024 and 4096 benchmark.
>> > See attached pictures - Sorry but I see no other way to provide this data
>> > than using an attachment.
>> >
>> > Clearly the patch brings a boost - especially for the 256 byte case.
>> >
>> > Harald Freudenberger
>> 
>> Thanks.  I applied "lib/crypto: sha3: Support arch overrides of 
>> one-shot
>> digest functions" and "lib/crypto: s390/sha3: Add optimized one-shot
>> SHA-3 digest functions" to libcrypto-next.  For the latter, I improved
>> the commit message to mention your benchmark results:
> 
> Also, I'm wondering what your plan to add support for these 
> instructions
> to QEMU is?  The status quo, where only people with an s390 mainframe
> can test this code, isn't sustainable.
> 
> I already have s390 in my testing matrix; I run the crypto and CRC 
> tests
> on all architectures with optimized crypto or CRC code.  But most of 
> the
> s390 optimized crypto code isn't actually being executed.
> 
> - Eric

Well, there are no plans. However, there has been a decision some while 
ago
that "we" may support this in the future. But as there are currently no
human resources available and working there I suspect a qemu CPACF 
support
in general will not come soon. Please note also that this is really an
implementation of crypto algorithms then and as such it needs to apply
to some regulations with regards of the EAR of the US Bureau of Industry
and Security...

Harald Freudenberger


