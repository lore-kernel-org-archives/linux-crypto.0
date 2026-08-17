Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FED543711C;
	Mon, 17 Aug 2026 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988062; cv=none; b=YhJc+4Em1V96lHU3/0hPR/n/RuXXlkcQv1JVTYswh+ob4FkopK5exFaH+9+JCHOr8jf7MtArvBCzXq4gWlrqhlAVEt+baZZTS4T4KeetztvOq2ooTXVBMq5GNhRsS493R7GICQLS6oTsPl6SvtGxCuNEDU5viNc3aETEZGLiwWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988062; c=relaxed/simple;
	bh=gXMaFw8QCFCQbh6WGMD0FbsLBzH6F1Bvr5ruS6vLOQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tM0hVFHpTDEb9sEe4QK2f3DTZ2oDfEnRqCmfOnI2Bx1ruqOEFHl3w0mCK45eOAg/KYXHWYrQH5QSwGia4xsA9Brb4QdJPK1C5D7r3F88b+IOCBIVrR64SLq/j4PqvtwVqeYXtHAE1nfzeQY+CYOxRXoszfZWMAmldKsjqfIvCtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k7Yyxo1J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k7Yyxo1J"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HFffa61851476;
	Mon, 17 Aug 2026 17:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MBaaej68c9fH0nMkBFLbUg5CaH2K6E
	orYltBdIK0Bc0=; b=k7Yyxo1J00iv5o306p1gDdgwNNuCxbWof23Ah3ICaDAfdq
	L8gOM2rLSl3yX63eCrAfzSezRD31CqLJ4nyaP1BRkSrv+Vsq+AEXvTf5C1NlI1X2
	UCxf8/LuHN2jrbknUaFei5wqxbPf4/77VHmWgFMwTu/dT6cCnHMnwaDnUfEiGrs9
	2EV1L20cqOBkeaoUtE2oMsfKp0HqNJ/RGYQIAI422rGGXOKXze/X7Jw3OzxMx3E4
	RffhkjTaKYlhJJQIX87ENWp+B+RQBEJRE+sZxF2gH66HmwHoQOeWxSHjhBGD04m8
	N5Kfz7UCgvB0iXHheOE27f8OpVJYGYkmvZsfNQYw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt34kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 17:34:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HHQQTv013804;
	Mon, 17 Aug 2026 17:34:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32epy761-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 17:34:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HHYD2M51118458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 17:34:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AB6F2004B;
	Mon, 17 Aug 2026 17:34:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B54FE20043;
	Mon, 17 Aug 2026 17:34:12 +0000 (GMT)
Received: from localhost (unknown [9.111.2.7])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 17 Aug 2026 17:34:12 +0000 (GMT)
Date: Mon, 17 Aug 2026 19:34:11 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS
Message-ID: <ttjxcsz@ub.hpns>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
 <ttjx5j8@ub.hpns>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ttjx5j8@ub.hpns>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a834619 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=RMK1aKcjqRy0yH2gV-oA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEzNCBTYWx0ZWRfXw5qSJ0Ls5DXO
 WZgqdcDp9Qls5j+B0GVutgzFP9nUKNhPuTgrppNlxLuXwSwe+M7uZwxvKmWkBb3G74GOX8HLsfA
 sC5DP0Few16keVDxzc7x8nJUwBmHh2c=
X-Proofpoint-GUID: IVSQwXQR0K_hH0Z7UHpVx6WPhMAz5FQO
X-Proofpoint-ORIG-GUID: IVSQwXQR0K_hH0Z7UHpVx6WPhMAz5FQO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEzNCBTYWx0ZWRfXxzUhffF3eguN
 aT09mZeAjeliMsuHIw+0YvYXyo7wCFsFREAK8EHauPy30RzUE2GSBbTFG+2iwg98vSDQxAsDWc5
 /2x7On2l3V5WeeHu9ip/vojd/3NoCO5PYsGthLT7PnolxvriOyRfVhUaGfLbggJRFHVMGsKcRiT
 Oe3MwYLKtgCU7ynjBrtPXI2R60WLkdCcJPmOOGSF/P09yxl2XDsuAvKyui5pDVBXZLzuhHpw1S3
 nmlYIk4MTWmseZzVSUD0QuWsXAlwChn3bdr6bcxcqtbBr0CGwkZlNWSeWUG8Gq1OOA/1xX7W7MA
 G42aeP5kQ56EyDyndmBbk9a5nCa744NsKgXxFlbpE6n/fLw4MslFZpPKBpcVOk/Z2aGTj6eMdAV
 Q37fOd7VKBfQ3fMfog8Jhl72urS+mwa2X5Js/I8B+/ANtdw88GX2EzEMi56IxbEgcQXVmGz14VL
 4hBi+krltRq68jN5R9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170134

On Mon, Aug 17, 2026 at 04:57:08PM +0200, Vasily Gorbik wrote:
> On Tue, Aug 04, 2026 at 01:37:33PM +0200, Heiko Carstens wrote:
> > Enable CONTEXT_ANALYSYS for s390's crypto code.
...
> > Heiko Carstens (3):
> >   s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
> >   s390/crypto: Rework ctr_paes_do_crypt() to remove conditional locking
> >   s390/crypto: Enable CONTEXT_ANALYSIS
> > 
> >  arch/s390/crypto/Makefile    |   2 +
> >  arch/s390/crypto/aes_s390.c  |  54 +++++++++++-------
> >  arch/s390/crypto/paes_s390.c | 104 ++++++++++++++++++++---------------
> >  3 files changed, 97 insertions(+), 63 deletions(-)
> 
> Applied, thank you!

This series was applied too early. Harald's rework should go in first, so I'm dropping this for now.
