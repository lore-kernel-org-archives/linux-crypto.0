Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778521EEE4;
	Fri, 13 Sep 2024 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248737; cv=none; b=nrys01oYlUfyCCGm1Anrss1heM/LVCJ0otOcKf06QjWVwOKUUP/cJ1PRw7IWoeNbQzEI0g3yBewJUEsuP/Y8Ylk+B7BpWNsVQ/jwA6XBZHG8Vw6HCveS9qJcxXJcvDNMUX3eSIwQzNqKHqHJGhJm92sFV77fRR/e1eCUIZ+Au2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248737; c=relaxed/simple;
	bh=pzA7ZMZZoVgNpmaWFc0CC225Ch3A3u6mzfsVUDrccy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FU4z9DP5kG9za5wbVc2lU61oupeB6Pks77rjT5im6gHqZgCeILqPvPv9dyWiZe0G4QfOGGmtOVpT9bSOgan5HraY63zA0fG8UqQ6toZwetnbb1LjmbNa7+6yva9aGSpPNqBTuJxroCh8jbWkMW7sNpzR1IPlrDA2tg3LgCHRyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SeVAv5rb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SeVAv5rb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DHLhtX025025;
	Fri, 13 Sep 2024 17:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=QnKufj0sD+PZoQG/V9Fz2QjNWrI
	8Gvwt12+jULSnV+0=; b=SeVAv5rbtltW6SAgQMF+DzHSgsRDHIGUsCnOuFBenmE
	UBDwWoEzNix9XtZBs8kuNCYbw3Vv5vG7g5WACVneFb6UhMWSV8pjoDNXtBBO/v/Y
	ETGD+OG/L2RO37S4ewyYCwQXMkSOr5GD3Ql4999FGLepgiqiKlfCXI+64U7Wqeyp
	qXUszcKqmmkn9ntsN3kExYN9qzc93SZKwPSqUiHMbdsJALyjriwgEY303mNMA7tD
	o5ImiZ7sB3u05Bo3zL+SJHDXRwuUElUpKQa2AD5xgefL9IIolhw9OjXOWiXuYuIE
	8oeB8VUlTczvJJj9fbkua/iSPAIeEWMFYfR3SBHRvAA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gc8qusv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 17:32:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DFGMtg010729;
	Fri, 13 Sep 2024 17:32:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb7391e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 17:32:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DHW8b253215732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 17:32:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7590A20043;
	Fri, 13 Sep 2024 17:32:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D301320040;
	Fri, 13 Sep 2024 17:32:07 +0000 (GMT)
Received: from osiris (unknown [9.171.6.86])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Sep 2024 17:32:07 +0000 (GMT)
Date: Fri, 13 Sep 2024 19:32:06 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <20240913173206.30385-C-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuRYoVIrg28kBKqb@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eTsnFCQgIgAm6HIewvB69RXkhB0rMtH1
X-Proofpoint-ORIG-GUID: eTsnFCQgIgAm6HIewvB69RXkhB0rMtH1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1015 mlxlogscore=610 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130121

On Fri, Sep 13, 2024 at 05:22:09PM +0200, Jason A. Donenfeld wrote:
> On Fri, Sep 13, 2024 at 05:13:28PM +0200, Jason A. Donenfeld wrote:
> > On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> > 
> > I'm trying to cross compile this but I'm getting:
> > 
> >   CC       vdso_test_chacha
> > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
> > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'
> > 
> > Any idea what's up?
> 
> Looks like I needed `-march=arch9`. I can potentially rebuild my
> toolchains to do this by default, though, if that's a normal thing to
> have and this is just my toolchain being crappy. Or, if it's not a
> normal thing to have, do we need to add it to the selftests Makefile?

That needs to be fixed differently, since the kernel build would also
fail when building for z10. Could you squash the below fix into this
patch, please?

That way the compiler will still generate the correct code even if
compiled with a lower march flag. There is already a guard in place
(test_facility()), which prevents that this code will be executed if
the machine does not know the instruction.

So for the kernel itself including the vdso code, everything is
correct now. But similar checks are missing within vdso_test_chacha.c.
I'll provide something for that, so that the test case will be skipped
if the required instructions are missing, but not today.

diff --git a/arch/s390/kernel/vdso64/vgetrandom-chacha.S b/arch/s390/kernel/vdso64/vgetrandom-chacha.S
index ecd44cf0eaba..d802b0a96f41 100644
--- a/arch/s390/kernel/vdso64/vgetrandom-chacha.S
+++ b/arch/s390/kernel/vdso64/vgetrandom-chacha.S
@@ -144,7 +144,8 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 .Lstoredone:
 
 	/* ++COPY3.COUNTER */
-	alsih	%r3,1
+	/* alsih %r3,1 */
+	.insn	rilu,0xcc0a00000000,%r3,1
 	alcr	%r3,%r1
 	VLVGG	COPY3,%r3,0
 
