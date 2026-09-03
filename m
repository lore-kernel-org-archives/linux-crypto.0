Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F37509EF0;
	Thu,  3 Sep 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788464050; cv=none; b=oh6zRn2HlkcOFD5jg9kjtvsXgdr7XbKRwsko3nuTx7OmEXAQGgm78fAi+re23Wa/3BLB4NzAX7oQHyHhe3tUZ+IbS1bgvUiNzKItzDb9VV+AOvcILsXsnKD14puaEMV8DNs/PXBVvvvFwyFiVrwri/47dkY6noHswiXZcQdIMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788464050; c=relaxed/simple;
	bh=f+9n+Mu4R+4nyJEX1yIzJPZcAqzyv55WSi9wVEeQRHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLfGuxiDnqRFGiOZZ/eRpGVfb8KbUogJWTXjFVM97GTOGO1W+F24B44biVD58YNTXekx6C9l2wNjr/N/lK6LIab0KWG7s2WvTQXo678RWUsBPmZVEhwwfZf1ss985pJxwlaat1ppduzOiOCx5nYbK7AKL7nv8vR+Rp9MPFgQLbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PXTW1aQa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PXTW1aQa"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G2gbY3425464;
	Thu, 3 Sep 2026 19:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uZR7oZ+e3R7uS/KLUEWnd/l0TnhNy9
	Yv7qaskPy+8hc=; b=PXTW1aQas35/CWkmCbdhA+sc8+mTiKsUGWXgYnvLvYLE7Z
	hgH2QPzyON0bvJSpYfDnbuJ79sCFcxHt57ImEnatvvxMggE9vT8sCG2Mtq3CvhYJ
	utr/EQff+af2cYlrT7owXV//0gUb06jjPTvPQCXsFV9j2knRo8rYw5G8jNdCjzyn
	z6+yYmJvuJZELkY0GS0hoEh+3Ao7Y/J7f+WWJSM1P1lIbSj6vUoNEmE/SBYKDAST
	75MMbvJkUjyhQkI/7BEx+9QffzpdV213pfYVQbhDjO+pq0IwH+/CYcv+zeqUPuCZ
	0l41pRWXHHhFW2jyMbZvY8oTQsoreaHRkRQDnejQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx5xqm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 19:33:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683JQHQC023661;
	Thu, 3 Sep 2026 19:33:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gecjaskgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 19:33:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683JXqre42205584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 19:33:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D981920043;
	Thu,  3 Sep 2026 19:33:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9850820040;
	Thu,  3 Sep 2026 19:33:52 +0000 (GMT)
Received: from osiris (unknown [9.87.144.233])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 19:33:52 +0000 (GMT)
Date: Thu, 3 Sep 2026 21:33:51 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Fixes and rework for aes_s390
Message-ID: <20260903193351.12158D16-hca@linux.ibm.com>
References: <20260831083735.3625-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831083735.3625-1-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a99cba6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=e_yiWjRrVcQd9PINgtQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: gfcZ0-P8W0sbKQtcRUeavqzg7pWfvZ0u
X-Proofpoint-ORIG-GUID: gfcZ0-P8W0sbKQtcRUeavqzg7pWfvZ0u
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE3MCBTYWx0ZWRfXzy8AtAM98lDP
 5WD32xB1DXceRPnmE6lpswRE0uSXPAhVdZPlZK9knB5JF6zfCR8sxAgdziM266fSapIzEKOdsBm
 9IwZbgQ4pxjWMaFg3YNICaLxubvLAUQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE3MCBTYWx0ZWRfX3ry77bdqlXEn
 p4XfTittrAK2kMmIG9G6qp2R4v/AoNTeOtCC/8+GiEP12YwQdMG+vehPnQqaD2i5KQpzgpV7cre
 IbjSVyUmhoyCosYZp36NiJ5W2PjVQC9z2J9+WDS9lzQ+F79fb4dBEHXO7i3MRXNiryDYipiAiqI
 FAerjb/sG9W5z8haWPVPbzt9JVfqHUo+odnIrSTSLsF3KT5vzLupntdmZyJqOKCSUMcbGcCpL8x
 n2Wc1aPpzg7BjmaoBENkY1MEmwh/uYYL3FK/OCJ4GeJiGFKIWN8kgGb7qwfsR6xWJO8HHuCJoFT
 Ga2775YUIwsaVzXyPee7kD6axDRNLYR4RH/uBV1rlDbfgMgcUrZLgprAQD6tas5mzVCqZMXMucC
 LeXI4gN7k+CiG3C78QHQKG0bMTDei59JCjQ6fV9t0hgBp4gyyQ+y29VE3q+I7LuH4huj3qJTl8j
 /YgCKGC7fvm9L9kUXxg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030170

On Mon, Aug 31, 2026 at 10:37:31AM +0200, Harald Freudenberger wrote:
> Fix and rework some issues around arch/s390/aes_s390.c:
> 
> - Fix skcipher_walk return code handling in aes_s390
> - Add scrub of some temp buffers
> - Shift from using a mutex to using a semaphore in AES CTR
...
> Harald Freudenberger (3):
>   s390/crypto: Fix skcipher_walk return code handling in aes_s390
>   s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
>     algorithm
>   s390/crypto: Fix use of mutex in atomic context
> 
>  arch/s390/crypto/aes_s390.c | 87 +++++++++++++++++++++++--------------
>  1 file changed, 55 insertions(+), 32 deletions(-)

Applied, thanks!
