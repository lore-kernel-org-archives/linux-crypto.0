Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE9283CB3;
	Wed, 18 Jun 2025 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238997; cv=none; b=o/vaJV+/vgr33Lfm+hxrowZljMZZVYQQzCLb86v2v8/e3eAwpDMTSFHXiqVhIu7pjQKCBoncVnw5PyjFiyvJmu6uxR4Y+FztrLFYcuj2WBBJRDCUew1bTrHvNe2va1VtRyQ4ZcTsIJtlMy5bv41WBP80+5rPBVXw97qiEgaHBmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238997; c=relaxed/simple;
	bh=SHb+FYxYFmzYXTrHqY58CjmUGi/fCNcxhXjCEShlv3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZlIGhE2SNcoMf8ECZoVekgSV81rqLP0TyuuFBEhdlc/66OkodrUjQY+9CT+ML4H4FS0EkpVwF2QaZh256Q43cYI0HPDeJx1G8IOIUXmEdxy2aBah8MJi33zDNd+jQBKSqa7bsOpy+mF0NSKq/0guh93DxcnoPC8EiqpMuQ8KFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QjelM2dg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QjelM2dg"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I2IuiC028616;
	Wed, 18 Jun 2025 09:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=mOOOnDaC8EFQbgAba12lgHxi3tNja2
	71Nl1KAhpuL9U=; b=QjelM2dgbsWc3GtC+Ndo6SGSK+6KL4tIihpXFlDOKCg3kA
	HswJHemPbvPiEnpytIcQ+YTdDmZe3WuSkdE2QvsyjYWSD/o8byxvh4Bmi3RL3twa
	fLR820rJAKF0Jjs1eT2T3Q2CTaLsadEQR4VQDgCfdXqfHlZnORLYBpiS1OaDe5fN
	ZQRyVFoEfWm9mhWB+XPtlHtkwsj0QPGpWZTNLI+HyuaTOVNEvLLEkwfI0bm1a7zs
	hTjkIgWhEV+lzzacY63Hk7KEXax9GX5wF4GwGXna8Lg5TNdANIpEwJOmVLWnHlie
	InDDaLXHvk7XxGvsd1PsWbQyydd0meOcwJ7OKAWg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r25bgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:29:52 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55I9GCTj014267;
	Wed, 18 Jun 2025 09:29:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 479p42fv9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:29:51 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55I9Tlab42926580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 09:29:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6F982004B;
	Wed, 18 Jun 2025 09:29:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BDD920043;
	Wed, 18 Jun 2025 09:29:47 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Jun 2025 09:29:47 +0000 (GMT)
Date: Wed, 18 Jun 2025 11:29:45 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, dengler@linux.ibm.com,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: Re: [PATCH v12 3/6] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250618092945.7535D4b-hca@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
 <20250617134440.48000-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617134440.48000-4-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NUFIjbu1fex7WWDKd82zVCTvWAtNk8vZ
X-Proofpoint-ORIG-GUID: NUFIjbu1fex7WWDKd82zVCTvWAtNk8vZ
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=68528710 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=tV9you1X9CY752Hip54A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA4MCBTYWx0ZWRfX3YUy2VxqCtTm 0KVgsi6Mcso66g+SRRHq4fLaVTw0gmUcdBuW2QJAUoJ3v3uKPkXsoplkVlXbz8jdvYUeKXAkHid /4oXzDDfvJnzBxzryd67Nuz38i/GZshTfWv9cKkxel0FEsi4Ut7MyuP22CvmjdGa6jwbrGqfzun
 t2jK8hE88d0MkfqkK8k0ND8tf2cKkGFXh95EU8+dOj+rVCzYs84Zl1Z4EkyfLUfKLJ059JwiUr0 r9gsOX8U8KpSVIh+CjCjMFM4baEEAHup4GvXAbptqUYyNCVnPaYjQulK27Ae7Z+5YeWSX2h8e3+ Wkop3e6Ol7aaRbpykB8P939oYH5sTkQxxVKGpgoVMWZlTJSsrBklMumdz4I9TokdO4Qf5fvJufd
 7fwDsCXJgTq6S5Lx5m18Q78bfIRY2N76GjCihbh46+j6b1hN7Zf2UJ6uTqqE3qr6x0OyoWBe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=414 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506180080

On Tue, Jun 17, 2025 at 03:44:37PM +0200, Harald Freudenberger wrote:
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new ahashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Co-developed-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
> ---

Co-developed-by must come together with a Signed-off-by tag.
See Documentation/process/submitting-patches.rst.

Holger, can you provide your Sign-off, please?
