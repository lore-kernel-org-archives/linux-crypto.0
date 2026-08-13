Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33420384232;
	Thu, 13 Aug 2026 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786649962; cv=none; b=CIrxfblZDm7yObQmk2RaO3/5p1lWdbofaiJKO0blv4nT0vHZmXiIwEmTL7jA6MCl+1mc9ovueHEpymj6LUhuvQfvH8YzQCCo+xAJ7lAjeCjE7nLgbjppY10JKiOMi2H3q0JjacX2DWnlEJfUyuy3qRsTA+/dYKWnKY7c7yEgdD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786649962; c=relaxed/simple;
	bh=ucZ/tcGgWe30bhGgTt8f3VkUDMA+TNeHF4Qk5dpkc44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGGOpXdXs2j3nj9oDscKAVvE6K+BTUGN+8d+mMXnGs0E//qAcZexZWYZNDAX+Erf2ceedRmCdvItu28Hql3o+wS4hyfgo6fwkGpQ0Z5ZFRb+QUNkLDAOzNcrm3ASW8JmApotSkMJAMpFPGv47EORIkxhAWqLw3LfZidMwTsowlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UMoFkhok; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UMoFkhok"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DJ1a9x3196079;
	Thu, 13 Aug 2026 19:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=aJSuQE92wTcHW0PjojrCA4snGtNQRk
	DE2GT4P3gmVl4=; b=UMoFkhokxucU41AVykvczseDeejjLD58N3zbqHjasVxYJF
	hYGFQPRpx43aKpSMTtXQotS0cDChWKu5vEEl4HkCaNJm4SQtEm4Dj5F1jnh3eRAK
	jLqcBtviK2ah2DysRxI2rHDNPhvb9r5b1uGwHK8YwRpFHmAKXfswn9rhVCHkxgWE
	mRj7KZ8DcSUB+kbCVQcDCiwUURPnmRo/DDsX76ygbcSvWtMzXBhCzOfojwSTUSa0
	cp6uNuBSVRnNbb99gbn4tFGHRk5m+vHpL5UWwx85dzAqDUQnwrtasHnUL7oA2HPS
	JD9/0wp1Dw1Hj+UbKrY+df6zNydzz9c1+d9IKQew==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma1r0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 19:39:20 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67DJBL6U022755;
	Thu, 13 Aug 2026 19:39:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxf5wchn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 19:39:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67DJdF1K38011372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 19:39:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13DE420043;
	Thu, 13 Aug 2026 19:39:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85FB20040;
	Thu, 13 Aug 2026 19:39:14 +0000 (GMT)
Received: from osiris (unknown [9.111.38.179])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 13 Aug 2026 19:39:14 +0000 (GMT)
Date: Thu, 13 Aug 2026 21:39:13 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/3] s390/crypto: Rewrite AES ctr mode to be prepared
 for context analysis
Message-ID: <20260813193913.7399A18-hca@linux.ibm.com>
References: <20260813155406.50051-1-freude@linux.ibm.com>
 <20260813155406.50051-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813155406.50051-4-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDE0MSBTYWx0ZWRfX4g8yKefKKyBg
 FXAb+UAzJQVw/jzYdUTpmT8CEfZRuBQNStvd9V0ElZia8L7kmBHUT22tPVSPc4WLVh6mqS6tetF
 dIuYMBa1Dl7JOyPz/s2irP7Ck2FPxtGVWNbLReIq+DRLdBblLV8YEwyx+Iz0/da9Ni/Mk48aybw
 So/xRMaKaRnQdeysXi1A24ux2mUQipEAs9rLa4vUUyoLNlfpmwZQqRpK69CKmgzFKn0DVW066dS
 0PxpsfSY4206xyz06T9JAdDCZLqBcwji8rWYKjU0PwFTt8fDju04j+m3SspbWQoWxZWj65MgZAl
 qZ/xWaizWKKd3lxyNXduwvCCiDD/9qdoM17zj+o14fMq/3aMNaTQYOO8FUjGE+BSZMnSUFFo1yB
 OO/gi/ycTLFBYeIB6zmQEjXCBr1QTLa3WQJKI3mOOss30EH5X+yjxSeKuROky8NE+O24+xiMfJI
 EBDB+UcLnuHSqWDbP9g==
X-Proofpoint-ORIG-GUID: uY_b_xxZumuagpQDVs1yCMRsyTHjWhPM
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDE0MSBTYWx0ZWRfX5i0sL6jX1RSQ
 HBDHmYedgYBv8uko0fca7wpl79qUEY2x5ik8Cpe7UgOUt0Xnj4t3JP/ox8VEHKxW4ATzwCLULo1
 2eua7Yg5e02ZPpJ1eh123oP5Dxi+wSs=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7e1d68 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=DTY8ulchmwJOzhwp0cIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: uY_b_xxZumuagpQDVs1yCMRsyTHjWhPM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130141

On Thu, Aug 13, 2026 at 05:54:06PM +0200, Harald Freudenberger wrote:
> Also cover a finding from Sashiko about that the mutex_trylock() may
> be invoked from a softirq context. So add a check to make sure only in
> process context try to lock the mutex.

...

> +	if (in_task() && mutex_trylock(&ctrblk_lock)) {
> +		/* process context and mutex acquired */
> +		ret = __ctr_aes_crypt(sctx, &walk, true);
>  		mutex_unlock(&ctrblk_lock);

Something similar came also up when converting the dasd code: better
convert to semaphore and simply use down_trylock() and up() instead.

Please make the conversion from mutex to semaphore a separate patch,
so it can be easily backported if required.
