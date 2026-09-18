Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51543339366;
	Fri, 18 Sep 2026 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745213; cv=none; b=IMiqEQCpUGaPeKZ8GnIxaWMkz4NglwTc/qEntRXEZXME8UXO13iW+9mI+40bdXJMuRkS5FsMeqTTnPPUKmVOhzltT6GGGZC+iphNsz/nTNzNsP+T1+wIhAW53MoPaIzbwvYKhwjCGt12vbge3EvZcUtH9DBgRdsXwCGP1Cd3pyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745213; c=relaxed/simple;
	bh=rrAEH92Hwr9cGjOraGri21HvAE0gPXzeYOBBwUyQ/3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEODhWsrOeiG+Zg7/eA+nLMUNW8haClMB8b2vFCqpeUzk0W1lEAerpLIkwtXweA5TzWiIUOy1fCmlLa6ZdwwniAogx3ePXEe5IYpJ68gV4I0TIaLDuP+6idFtwuQUYgIH3NXPAZVrm5mu0Xe7D2vpgkJd3TrOjoKUrTA7AocoYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A/Mg5Rd8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A/Mg5Rd8"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDVZN71378659;
	Fri, 18 Sep 2026 15:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rrAEH92Hwr9cGjOraGri21HvAE0gPX
	zeYOBBwUyQ/3Q=; b=A/Mg5Rd8D+jY/P7ejbf76RTGker2TUmXL/XU6UQx9KYCM7
	ZOmLeB+9owQ7/SGLCVwMIEkfDRRrPD8atnC9B2kxY6vmIfvqq+zrovUuOWDaIbDF
	qkx8dhs25Et6kkIHlxfEGNYB/gIGSGBopCP4h3zdyxCA/CF8g5XfVtI4wOy/qUYj
	RtcMPXsU6FYPKPbh/9b9dfmImuqe6sRkoIW1r8jIMPHZbWXjMB8zHuXQutcwrOhY
	8yflP2i9awHkrxCp8clnIq0Y0nW+j+THmAdB62wzFk2HbUAvFy9L+RxP9VqOxGW/
	hZgg8MSyZo3g/bWUN7/aH+dM6N4UB1ahEfpE4VJA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx848vqs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 15:26:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDNqOb771773;
	Fri, 18 Sep 2026 15:26:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr5fffy0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 15:26:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68IFQhC144433848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 15:26:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A6AA20043;
	Fri, 18 Sep 2026 15:26:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8EBA20040;
	Fri, 18 Sep 2026 15:26:42 +0000 (GMT)
Received: from osiris (unknown [9.111.38.246])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 15:26:42 +0000 (GMT)
Date: Fri, 18 Sep 2026 17:26:41 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, ifranzki@linux.ibm.com
Subject: Re: [PATCH v1 0/1] s390/crypto: Generate iintermediate chaining
 value on export
Message-ID: <20260918152641.20386I1b-hca@linux.ibm.com>
References: <20260814142010.259918-1-dengler@linux.ibm.com>
 <5e9a75a1-54f4-4425-806d-55d27569602e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9a75a1-54f4-4425-806d-55d27569602e@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDIxNCBTYWx0ZWRfXzdh9OjRfBxQH
 7/eTzS3S5Aa+HQk44mCpqB69d4Ur5ZD/cz2yxDngwd67U56usktNsigYl8V+TzN1VCdV4/u85TO
 TbnZOtQVKIRsR6NGMQk6CRIoCrnuFTFxtmjP8ecIly0oIt376xbv+7wOM3jWPmYi4A3yGVqJzj1
 pOxtGaHe2MKUqnKA7PQyhMih1YoCz4FsZQn1yPmKX0K20FfGPQreXYPx3tIPKh3AvkgVNmP3aSK
 KjVMkA40stqNiveB0iVaI+svKCVUV3Ax2OkceoehvpsAm28vXwq2XaQYI4yc2vvMJVHy8my0Lnt
 8WbiNIunFLkAPrUDinscPNYS/lHQaORN0/MOyXjOA3PQ6B6L/oZ2IEgRM+ozbyHQcMDU03qsEt/
 s89MfcxL4frJm4Z97ZUVDNGZYy4EewWjy2/vRGje9uGt4W69aTIxcxSfBFalpV3AELpKhN47uPY
 Ir0zoJUyIc7SET6SILg==
X-Proofpoint-ORIG-GUID: rJ1LUaIebsXJESOB-XHcZILp4baJb0Wx
X-Proofpoint-GUID: rJ1LUaIebsXJESOB-XHcZILp4baJb0Wx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDIxNCBTYWx0ZWRfX+ePvBqcSqCZi
 YODt4QCTCyKrxzNC8F+fF66X7JF4+ZEQ0g+shqJcsGiDO2L9aKH/RfT8x4sr5BEbr4GOAu9x8zR
 FpdF82ieNIFeiDnRZo5On8cDuepyfxI=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aad5837 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=N8ADyppnPJuYswJnz-cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180214

On Thu, Sep 17, 2026 at 11:13:05AM +0200, Holger Dengler wrote:
> Can someone please pick this series? Either via crypto or s390
> maintainers. Thx.

This should go via the crypto tree. Herbert?
