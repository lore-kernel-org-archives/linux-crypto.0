Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015293AFCE9;
	Tue, 11 Aug 2026 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440190; cv=none; b=RLoFpxU2rOvDKflz4em92Y+0/oxwPI4FXSRIepmaGPQ3pjRQjqAz2v4NkQBanz2OihGLJJk01C65PttTPRzdxVcGacFjN6aVwTxAXUrOzT293nXCY64/6odOFu0aSphrtAbsaKfihGBk5vyS30mJaHF8wqBAEYxXsrwVemNT3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440190; c=relaxed/simple;
	bh=Ipcrx0Evye+M5uPrbGgZnbMsr60HsAnLGjFS4e5yFCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E7tURznhPEFKgCF+q5OxUmlF5fyOvjp2NIRJPoXf5pEs+N+zLKcQjGVIrxJWiUcDVpBxFEoHiJIU7ti2OxpgnSz0wUyTDavoMg/d2nf9xKY0Rs6kvz6TGaAdXhBr+AZDkA8MxfFTkCdydPFS8QZ3k+4QOiE/RYfEjKsqieJVPt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RrMLw5wr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RrMLw5wr"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AN1TIx2920103;
	Tue, 11 Aug 2026 09:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=x/Rj7B
	NwDk5gCiDtySXXFjaIFxK1zoS4cyffyiZelvc=; b=RrMLw5wrc7BKjE5AgQvnST
	rJnJHYE47q/EmkiOAGyQlRZrJvUeX725UEe/RXtlyRRISsn+JwjazNJdIp+2DmaY
	BN5lw8RLpClF4+XtrpIyz2yV4Z2kETIOX2KoibEMagNRoxB2EkmjBwXfGRdKzWv5
	kxUWmoEp5yY3EXik6AaAXR/8dPF9mBknz2HO1ok+BZjNvDIYqhkv0Svtl2fN46CC
	4vHOvQ81hEseXyw+teoCkAkcpwLBDjDuD0utfnOOsynIrwAzoYh09ShL6ssW3VkH
	3wEV7ZDGnPkPEmLGqEOW60GEo4wx2dGGMV9lkDUttBMIKvI2MBpPP0sGX9Yji9nw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvq9c6b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 09:23:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67B9BGaD001088;
	Tue, 11 Aug 2026 09:23:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxh0g86q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 09:23:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67B9N3xt47448372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 09:23:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 507CC2004B;
	Tue, 11 Aug 2026 09:23:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24FFB20040;
	Tue, 11 Aug 2026 09:23:03 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 09:23:03 +0000 (GMT)
Message-ID: <67b4eb88-35ca-46ff-9bd8-215bba1f334a@linux.ibm.com>
Date: Tue, 11 Aug 2026 11:23:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] s390/crypto: Fix skcipher_walk return code
 handling in aes_s390
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260806084950.17679-1-freude@linux.ibm.com>
 <20260806084950.17679-2-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260806084950.17679-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o3pipYPylLROmhVMy8cPojykWBYCheHW
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a7ae9fc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=bx6gCwCgHWRvor7s2BUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zgiPjhLxNE0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA3NCBTYWx0ZWRfX9tkT8/GlyJ8k
 vv+Vo/6AFZo82jn3LqEP8eRVR6U0dO3aG94m9zp2JCfN2KpJjUJclGxjwdv/54NM0l/fZx1ZQ2N
 Q71DFUg+nwjjZyolw3DWCoJ/teoEUbJ2hoOXndTr5ybIEAA2Ukr7wqxsQgUhSuDkulJiRG+Atw0
 d8ysB4TsGWap0ImR+VP3N/kGprb/dm44djFyLpglFiAlamsu4wcU5+en0twaC3YidiiccBsvZLh
 4knYMgqxynDZlhxmXXRXf6Mas4iZL/RjdOp+r10i9NszcnXF5bLrqKmNvFRe0IHaaiWJwZs2tJx
 eayU2Awqw0vmPq+yXilRbXqdoojlTqEuJ8EJOG+BLDNAWcZqySNN1cPQJN5PKU3shaKIHvjr5vG
 Wrc9sNceZdQNm4La2brgAd4r/KSp3dPKTiiek80DQp7CtAKFuWbawMXPsuCiLQIV7rIcHrB5q+X
 DZfmqfCYCKMgvZ8hT9g==
X-Proofpoint-ORIG-GUID: o3pipYPylLROmhVMy8cPojykWBYCheHW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA3NCBTYWx0ZWRfX3oD1sBjft0v+
 De/rEtQUR7Tkh7Ta/s1GuNXlayMcizVmqm2yBO4i9ystjyr9vSCYtnAwOBRCSy5J2oyVAe1ChtG
 Ce+uop1VtSy9rjApaLYFTxOv364H/WE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110074

On 8/6/26 10:49, Harald Freudenberger wrote:
> The return codes from skcipher_walk_virt() were not properly checked
> before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().

Maybe you can also mention here the other fixed functions (cbc, xts and
full-xts).

> If skcipher_walk_virt() fails, the walk structure may be in an undefined
> state, and attempting to process data could lead to incorrect behavior
> or accessing uninitialized memory.
> 
> Add proper return code checking to ensure correct handling of the walk
> initialization and walk advance and eventually return to the caller
> with that return code.
> 
> Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 5.5+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

