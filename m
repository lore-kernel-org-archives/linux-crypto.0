Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C7C1C14;
	Fri, 13 Sep 2024 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726249077; cv=none; b=IWtmPMzWKlvk4Gt2ofKoxNa3pCg56R7tOC1pGFb/yI9S6O9l1vSGP+4E/ZssUMxbCzj0cSdoVUWTUtbnZ8jOstPlRQJICrVoxWyekzTohIf8dCx0ez/Pr7NVo+kx26ywZSWr+I+YFs8Q+XaEnxSE0p1/KlOpj9KFC3TCavaWkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726249077; c=relaxed/simple;
	bh=vibNHNRRH+3vWgI3ynOIkAiw/SlNeRRCDGEqnJuShtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXqr+MQdMjqRBL6OZjqv2JaqUy/mCc/c0wI2F+kYVqNhXN7ahdpJ0m487yGSbEWl1W/aHl7S7oTOjbg2OHFfg8YyzfEd7xe7B9EC9DFWH+ze6u3cH1X1brAZFlTvBSlQGM/1tnzLFLmJB9zMQuIsasqn8qWOU45WuS9gK8bd4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qhLa5RT+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qhLa5RT+"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DHLqtG019201;
	Fri, 13 Sep 2024 17:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=d7S/wbjkH88BU2FIx1D3gL3jHpT
	+UBoRhUinazWDT44=; b=qhLa5RT+JiHRkcgwCBVaVj1VsSg5tk89+GinbM2DqIp
	VQPGJGnfS8WX4z+CW7oZvqlTMqJwNrFJ5jNArq1Vel48Vjdl7BwEFpmrENyvWziq
	VEToeweuDl+0nnthebTPjvDSw0vZG9kGLmlMKt0CNnTBh94FImMyqkQ0YXNXIUVn
	48ot8ngcdp+BSYurlaNs9qIKY/CZJubLfop6eCEjF09Hm+TMzEWc364qC2D2yC7r
	TLsnI3NknASobis7Bl7wvuiBMrwdHcqKJVdJhei8yLw+f5N8zGJLSibw7pBYqJWP
	18GiGnsmCzsMhmCULfMNNG3VlGFA2aCSuog4XomfwQA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8m3cwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 17:37:53 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DExNDD010808;
	Fri, 13 Sep 2024 17:37:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb73a16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 17:37:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DHbmi654460692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 17:37:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D4BF20043;
	Fri, 13 Sep 2024 17:37:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBDD920040;
	Fri, 13 Sep 2024 17:37:47 +0000 (GMT)
Received: from osiris (unknown [9.171.6.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Sep 2024 17:37:47 +0000 (GMT)
Date: Fri, 13 Sep 2024 19:37:46 +0200
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
Message-ID: <20240913173746.30385-D-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRD58DrEzzcXKZg@zx2c4.com>
 <20240913141651.30385-A-hca@linux.ibm.com>
 <ZuRS0sz_9_mkHsnl@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuRS0sz_9_mkHsnl@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bFATFXXoS8TIMWBzc_yMd9eoDzmSksXR
X-Proofpoint-ORIG-GUID: bFATFXXoS8TIMWBzc_yMd9eoDzmSksXR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=679 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130125

On Fri, Sep 13, 2024 at 04:57:22PM +0200, Jason A. Donenfeld wrote:
> On Fri, Sep 13, 2024 at 04:16:51PM +0200, Heiko Carstens wrote:
> > On Fri, Sep 13, 2024 at 03:53:43PM +0200, Jason A. Donenfeld wrote:
> > > On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > > > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> > > 
> > > I'd be curious to see the results of ./vdso_test_getrandom bench-single
> > > and such.
> > 
> > It looks like this with two layers of hypervisors in between, but that
> > shouldn't matter too much for this type of workload:
> > 
> > $ ./vdso_test_getrandom bench-single
> >    vdso: 25000000 times in 0.493703559 seconds
> >    libc: 25000000 times in 6.371764073 seconds
> > syscall: 25000000 times in 6.584025337 seconds
> 
> Cool. I'll amend that to the commit message, perhaps, so we have some
> historical snapshot of what it does. What cpu generation/model is this?

That was on a z16 machine.
