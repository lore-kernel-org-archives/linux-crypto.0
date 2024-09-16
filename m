Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D149413A89B;
	Mon, 16 Sep 2024 11:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726484478; cv=none; b=c52aynxXkv7OQRm8ujnGtilN/6UiR96TK+tKvlHvin5Uy+x/mvAw1TMPfbWKu2xfBFQzGJ0NPV33ZT8yGXTIGCl8MdIXRJR5NlkJk0IlGnAXE6wE5Pw7ksskcfltic+ueGlCGGaDZW9hv9s/vo2l6EqZcVQWamSeNWUMvimCxyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726484478; c=relaxed/simple;
	bh=zhqDBgIh0ud+/e1cE7GtPgGaRvHZbCMbBxDCOt0ijVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cQbCXOHZJNMMcC7ViB3mssFWjFrVhqukwPKNMrJdnuGNBBDK4Ajh1wlbv+HbRQvCbXAz3Xq+pWd3vDbPKtIXeZ9m0PXxVbOxIjl/iMDAoXEOLNUPZfP0I0uS6YEloxGoGg9SX9vebReLkA/2nnaOO5mZdYuYAVMYZja3NyUxTpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PCQnwJLM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PCQnwJLM"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48FMuZMe029000;
	Mon, 16 Sep 2024 11:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=k3O1AIuHdgHWO7B5Gxu/ogb5Oh7
	pev0tj1MQhpk4sps=; b=PCQnwJLMisNvhsmjuPyfM6C0iLinjxSv2fc+W+z6yIa
	hwSXVGGwBGRQB1Dj60zB9OF7XNyo9XHVzuZKMsSzv+qXNHM54Dg8Balzkj1lrnjm
	Ddms5OV9j3R2Xiy4fE3yxWWmgq9vYuaZY1cU8brlXuOlBKQMZQcyNa6SMDWEMBPr
	I5+DuAL90i3T8OBjiPpF0GmqgywGDyCKwOaKOM0DRnMr7wA2qoFsLFONrrNK84WO
	81VRi1BwirhnQi6ZKbCi3GMsEfMJdNm7RuUR1l69/pfkweFDsqVSESx1fvi+e+lk
	ml6nsmMFnb9rW1Q8q6bgZsZcYU+r5LKz2fF+TCeVnUA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n41a9495-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 11:01:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48G8rm5H000742;
	Mon, 16 Sep 2024 11:01:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41nntpxumr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 11:01:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48GB1AAc54002098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 11:01:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B2BC20040;
	Mon, 16 Sep 2024 11:01:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA7702004B;
	Mon, 16 Sep 2024 11:01:09 +0000 (GMT)
Received: from osiris (unknown [9.171.58.79])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Sep 2024 11:01:09 +0000 (GMT)
Date: Mon, 16 Sep 2024 13:01:08 +0200
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
Message-ID: <20240916110108.20933-A-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
 <20240913173206.30385-C-hca@linux.ibm.com>
 <ZuSRKLFdYI1gCHh9@zx2c4.com>
 <20240914174246.8394-A-hca@linux.ibm.com>
 <Zuf1oYveC0rryg_6@zx2c4.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuf1oYveC0rryg_6@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _uoBmGCYpJQxuG2k2-xciyUyDK5dopIW
X-Proofpoint-ORIG-GUID: _uoBmGCYpJQxuG2k2-xciyUyDK5dopIW
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_07,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=610 bulkscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409160068

Hi Jason,

> On Sat, Sep 14, 2024 at 07:42:46PM +0200, Heiko Carstens wrote:
> > Please feel free to change the code in whatever way you like.
> > If you prefer separate patches, I will provide them.
> 
> Just wanted to make sure you saw https://lore.kernel.org/all/20240914231241.3647749-1-Jason@zx2c4.com/

Yes, looks good to me. I just gave it also a quick test.

FWIW, I think the tags for the commit message should be

Co-developed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

However, if you keep it as it is, that's also fine.

Thanks a lot!

Heiko
