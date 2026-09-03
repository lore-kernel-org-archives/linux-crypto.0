Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8E550C2B7;
	Thu,  3 Sep 2026 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788464195; cv=none; b=gBwpIP856AROyrp2eh+Hx2MrQOjVfkhw1f3h7W9mtkdClfZBgOucf5jDdEB7pAGl+xtTHizQjgvG+7yq40n7VwAJ1kZvjeuBdxMnSuFdKRwAMTATqcS4dmEG5r4nJywp/FfMNQbEXtBxkyVkL/P4hgN6qi6FM+zYbJr1HFdai6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788464195; c=relaxed/simple;
	bh=M/q4MyB85gJu6+ihTHZ/w6Bz6pgkJ4nnTZ+4KqCG5xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IfO+rScC6AjQba1L1Puo3SA5PYf98KlUrkNqO5w/vzRG2VBahO4sL8JuzV8sKSDceS8vxi/sgtrKItGM3HgkWL0PTN9NB9Opw8bhOmOPWxJ3vZa0Qt0fqAmLhllTOfevy0nl4z9SrFkkWd+hb831gkpH+5ewEDQlErGr+M4LSIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pQPMogUG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pQPMogUG"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G2UPr1550086;
	Thu, 3 Sep 2026 19:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZmxYBLa+OYs7arMUrvCnaL5hYyD5bs
	2HB8BlDjRRxy8=; b=pQPMogUG5blDtEjXVQ9y3E9OiVnuubROJcsc9kZG5N/PH/
	6x8b2kB6ODjqV87DleFsNt+epa/57yQdK0xqD7vrdo+jhU/NMYP7kRXfttb27s/N
	W0/cOGbn5d9+QHtxkTxAoq/dTmxzjq5NbEAPbMSDoZiPjAOxS4U2Ui7+V/Hgcg7G
	6PyeAXx5+cjubkR6P1pXBULX4sX0vDqBsukny1A1l2j/KkvQWwZw8HJg+y9epfrR
	noRNzuX0b0gfUvcqBbDc3nP9EbUcvCJWZYpQn7Vu2qdtOabCOIjbEiiPDa6FsRBo
	N1YCSbwPq9RhLQR9oodrwx8ctWFdfK8trK7F2glA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq3rpqn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 19:36:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683JQJaj016795;
	Thu, 3 Sep 2026 19:36:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcceyh139-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 19:36:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683Ja5KJ35324320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 19:36:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED72220040;
	Thu,  3 Sep 2026 19:36:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB7DB2004B;
	Thu,  3 Sep 2026 19:36:04 +0000 (GMT)
Received: from osiris (unknown [9.87.144.233])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 19:36:04 +0000 (GMT)
Date: Thu, 3 Sep 2026 21:36:03 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v7 0/9] Fixes and rework for paes_s390 and phmac_s390
Message-ID: <20260903193603.12158E8b-hca@linux.ibm.com>
References: <20260831083838.3703-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831083838.3703-1-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EIc2FVZC c=1 sm=1 tr=0 ts=6a99cc29 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=sYW9yiRiYxeI9-PqEhUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE3MCBTYWx0ZWRfX9WlM364jbS/9
 xGo2CGQZ9Ru3k/0VWool9D0PmVEzAU92RrjQzqId5QkQp2v/MKTUebAWJGMGON4aqGKU1CWCtQn
 r4qCrtawFxD2ryqTfAwqZG8i7D1YdNOwdOJKWV0L3ARr1FYl/TphQ8zHBvU4toUFA6N41NpFsFP
 t66Tkzv5XuReyi8remtQIuiW62aHh5BG5ibzTNdB5H5OIwdKFuTyQJoaQxqg7tNyYoDPDR0mdGY
 xKnO1UPFgcJkISM8Ud4heNiZygBLVfeTE543wSoILqvImXHgUqwIB34en8lnFKaUUbAa8nh3tLN
 rWWVneIhwozZVWS7rvjiLJexbmSVyOx/YZNINA+ywsLEndTt3QSgejTiVfIDhomv0rW0BurQdSy
 3XvKZsgPD6QF0Pc3AJ1xcI/Vw0XR3avKQMPZIWU37WOUmPRHxHcqrLyfwzaDlMFg6W0tAN21AH/
 JYSWeYyZEYQT3I4oD9Q==
X-Proofpoint-GUID: STILSG226ENtGQ39sFxiE1IcChY9OfDH
X-Proofpoint-ORIG-GUID: STILSG226ENtGQ39sFxiE1IcChY9OfDH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE3MCBTYWx0ZWRfXzqYWSsx3Xzph
 fj3UIiTwqpw6395HvMc0JcMwFTJqTY4buZgTMLAJmYQJ0fEr9ZrEM9HAMqaqcJ7sbpSohaB1ANg
 oKxs8YBm00E77a5mQFtvaC2+CUQaoKo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030170

On Mon, Aug 31, 2026 at 10:38:29AM +0200, Harald Freudenberger wrote:
> Fix and rework some issues around arch/s390/paes_s390.c and
> arch/s390/phmac_s390.c:
> 
> - Fix skcipher_walk return code handling in paes_s390
> - Add scrub of some temp buffers
> - Shift from using a mutex to using a semaphore in PAES CTR
>   Surprisingly clang code analysis is able to deal with semaphores and
>   thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.
> - And some more fixes related to paes and phmac (see changelog).
...
> Harald Freudenberger (8):
>   s390/crypto: Fix return code handling at skcipher_walk_done in PAES
>     algorithms
>   s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
>   s390/crypto: Fix use of mutex in atomic context in PAES
>   s390/crypto: Fix missing cra_flags in paes_s390
>   s390/crypto: Fix handling of EBUSY in PAES when req is pushed to
>     crypto engine
>   s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to
>     crypto engine
>   s390/crypto: Fix wrong return code to engine in asynch callbacks
>   s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly
> 
> Heiko Carstens (1):
>   s390/crypto: Enable CONTEXT_ANALYSIS
> 
>  arch/s390/crypto/Makefile     |   2 +
>  arch/s390/crypto/paes_s390.c  | 184 +++++++++++++++++++++-------------
>  arch/s390/crypto/phmac_s390.c |  36 +++++--
>  3 files changed, 142 insertions(+), 80 deletions(-)

Applied, thanks.

FWIW, since there was some confusion about CONTEXT_ANALYSIS and if
this should go upstream via s390 or crypto, I applied this now to
s390. Future crypto patches should go via the crypto tree again.
