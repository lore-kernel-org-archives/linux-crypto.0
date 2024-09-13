Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51241BA2E;
	Fri, 13 Sep 2024 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726237774; cv=none; b=aaoi8VvVoTXImb1kYcyKxxn22PmHPSCxSpe5b6bWGpeYF3m/Jo7p4wYirb10axQWotxYnip8Z/58PiBxHQ/C/C0HA91Wqu1/P2rd7YJIrGuk+LWZn4BS4WnzfSf+PesJ/qapDXsbrTuQehBuF+tlGv9FxZWYWammmUW4AMd2mnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726237774; c=relaxed/simple;
	bh=n4CypEvhl+akW3fJZ9oHywQiaIVLr4KPiPhcov62YQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpyq55rb4z+UVh0pFM3Hl7r8JoD+Ot50SMFYCFI1BLk7KWRM2f76ebZjAAU5zB4j8EfCmmkFsqFLJq8CuTLrLr1D92nKzR4XoiDseEbPJJuXOEQYoMu3zfCQdZgNfmui6EYt2b5OFFa96EqoELCDYxAstF8DORewV6hpm1aIxMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GD8gobdz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GD8gobdz"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D8cqx7026511;
	Fri, 13 Sep 2024 14:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=6orxksetWM7LC3aR/f1cAshO7y6
	ll9SRw6ogrQry/sc=; b=GD8gobdzDn7cePakFUrFyAnAvG5el24kxWBpvgLhb5I
	/Dt6rJuqjAC7lFDrOhF2HXq33XnKwwx+wdMnmi42c/I02M8ByZr+5bg1Cv3U4YNx
	5Jx5ZXRWWtEB3Jv2kU9o6V9hpOsDe8gQIwgk1kZFBCEjc9zom8RKDY5t2XHJy8+s
	9Bgj+ju0KR/XastcM9sfp3J5IB8hgSwcshn7FG6QSiMmEKtwiXnDsLnOODc41qEv
	Ycbm8Q0P3bE5XeRCS5hyAyqL65IjO2jLIk+Bh0CotJzZmNTOR1nX6dboWNZN3GXa
	4zUi4ggtiK8deLCwzYCFKIIcqysrnGGK9i4XpK1tAaA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8m2d3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:29:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DCR4vA032091;
	Fri, 13 Sep 2024 14:29:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41h2nn6mgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:29:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DETQN449807714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 14:29:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B8F220043;
	Fri, 13 Sep 2024 14:29:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC32B20040;
	Fri, 13 Sep 2024 14:29:25 +0000 (GMT)
Received: from osiris (unknown [9.171.6.86])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Sep 2024 14:29:25 +0000 (GMT)
Date: Fri, 13 Sep 2024 16:29:24 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/7] s390/vdso: getrandom() vdso implementation
Message-ID: <20240913142924.30385-B-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <ZuRDp4DPOz8BlGAz@zx2c4.com>
 <ZuREmWTzI3Vg7tZE@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuREmWTzI3Vg7tZE@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wh0O_NEiFcsXimFLq5Hhe9mRPQUFn1oD
X-Proofpoint-ORIG-GUID: Wh0O_NEiFcsXimFLq5Hhe9mRPQUFn1oD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=465 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130098

Hi Jason,

> > On first glance, this series looks perfect. I can't comment too much on
> > the s390 parts, but first pass of the crypto/vdso/api parts looks spot
> > on. Nice going.
> > 
> > Were you thinking you'd like me to take these via the random.git tree
> > for 6.12 next week, or were you thinking of delaying it a release and
> > taking it into the arch tree for 6.13?
> 
> If you did want it to be in 6.12, assuming this series continues to look
> good, I think we'd still want it to be in -next for at least a week, so
> maybe that'd take the form of me sending an additional late pull during
> the merge window for this. Either way, I'll defer to your judgement
> here, as most of these changes are fiddly s390 things more than anything
> else.

This series is intended to go into 6.12. I don't see a reason to delay
this for a full release cycle. If something breaks we'll fix it, as usual.

So a late pull request would be perfectly fine. Alternatively we can
take this via s390 also for a second pull request; whatever you prefer
and is less work for you.
