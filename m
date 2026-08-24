Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2D63932C4;
	Mon, 24 Aug 2026 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787608883; cv=none; b=UL/QK3/3KDVpFF0lxuo0hMMFp+nFf70Zf06n4u48yCFgOVZ97mLRHJ8cpq3C0WVBK/tsSo2JUUFrQx0NoqMqWIZpVjMgD7tLdqizfPsGu/PpyDBjw84H3XiVKqkrPvfMhBv9dQCwVHBHLZYlLNdemcRTd7ZxQNNMXq1+/6GOiOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787608883; c=relaxed/simple;
	bh=D84dXFU2s+be2IrogPBAMQBetlSLTDaJXF+gCrrtwuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgvhPTF44p7GAp3dLn5e9RVE932KRPfmdcRp8SyRypz21yntB0mPw3YMPk9BQ1CZudL3OIhm1Qdqi/WJr8HBQkx29y2hiJJPoBaFQiQjFuiL92oCd05eun6Z0ZBo5ZVcyXyvV6pcrWNjIc1TaWEGFirA1TydIyeloxUsqEPnAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tutY60op; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tutY60op"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67OJVYMs984709;
	Mon, 24 Aug 2026 22:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=YGYKJv9NBNcSJNRycA8Mu9wXCkvu7S
	IvSTOM7d06S5U=; b=tutY60opXTVWSgxZZnIeYuOSVwAXRs/8b9KupVVf/7bAPd
	frFoB6PL1ALhQbr2b+uJVtrccXGf5tZS0Iy2Po3jSblCAzOS4CiwLQVszdow8OCz
	ygrMbcVaLn1IYy3ZoYEtmuXQeTSpWF7C71gJTojmRsc8QzOswKMPcj+mOqq/aZeX
	N8uBjrFxRMRar2vVwwLnnOsfmOQ3ARbSMf/tW3q0J0hpG82IArjkf+0YlERlXQ5E
	lVQZBhHx/0MdN3/J/KXnI/JVO7/zgdZXuBVEiM/quYHNMrm+CjAEx3SyRXCR/3JN
	iwFK5YNXJof8sJk4eE6ON/wvK4QLBFcRqwOXnySg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73eqmdxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 22:01:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67OLuU8q008261;
	Mon, 24 Aug 2026 22:01:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkh0nav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 22:01:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67OM1CWq40436184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 22:01:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2FD520074;
	Mon, 24 Aug 2026 22:01:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4429120065;
	Mon, 24 Aug 2026 22:01:12 +0000 (GMT)
Received: from localhost (unknown [9.111.46.147])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Aug 2026 22:01:12 +0000 (GMT)
Date: Tue, 25 Aug 2026 00:01:10 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 0/9] Fixes and rework for paes_s390 and phmac_s390
Message-ID: <ttkanty@ub.hpns>
References: <20260821084648.23222-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260821084648.23222-1-freude@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1pfcxQw4SotW9UN7qKVyTmKWeMxfH65w
X-Proofpoint-ORIG-GUID: 1pfcxQw4SotW9UN7qKVyTmKWeMxfH65w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDE4MiBTYWx0ZWRfX7+enI6vHbbKz
 CijVamIdZwQd4biaiPZATel48pFPfLNqjysB70Jmr/3Yu8NFDPImKQZmYjfkV139e1yYmDiOgg8
 HFpcRmA7ely4J1/gA2d01Vr10B1amqwyM+QlGIurjlQ6a6qn+CRFiqgSiNYqnOl/KlMYkATtKlJ
 u4EnfsUf3FzAbm4TLIxGA5MNvJ/k/gIKoYBGXW8nnWUyEC3abEeJzN39lJiHrfrKEOShahx8tVF
 NT9FVgk3yxxfTV8F4dFzSbMvW5AIBzMMPvYBLq5T1GvSTOhqshYBhVLaiA4nVFFIBeiOS78eLG6
 OvdEQhdCXXrGglZ2e9VL82kx7E5aEC4tZzm7/4I62ACsXWK/PeM4QWoERQovAgVu7fZAfRiIMSD
 jflErLKvErzs1YR69B7LkTFkS9q51Lm5izCoyDG729Ap5zjDWQYEu9TLOVaGO9z8ZRHKEpEWTUX
 pxRh0cnZRgfNyufOXYw==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a8cbf2d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=g_xAjTxU5e_KTNpfFQUA:9 a=QEXdDO2ut3YA:10
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDE4MiBTYWx0ZWRfXwAdPc/o7xQYr
 CwxlGasl9qcM0Xd2uJY5j4BNjnJSO0lMRxTKoauAQ94a+O9zStRpphCIX+W6hgXhWDH62ouLiNA
 JIpSako0+GxCn6b6ceIHo3fvUT8ukxE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_06,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240182

Hi Herbert and David,

Harald's
"[PATCH v4 0/3] Fixes and rework for aes_s390" [1] and
"[PATCH v6 0/9] Fixes and rework for paes_s390 and phmac_s390" [2]

grew out of Heiko's
"[PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS" [3],
which was part of the broader s390 context analysis enablement work for
v7.3. Routing it through the s390 tree together with the rest of that
work was also briefly discussed [4]. Harald's series then grew with
additional fixes based on Sashiko findings.

The resulting series still only modify arch/s390/crypto, but several
patches now deal with interfaces and semantics maintained by the crypto
subsystem. Holger has reviewed both and valid findings reported by Sashiko
have been addressed. Could you please have a look and ACK taking both
series through the s390 tree if there are no concerns from the crypto
side? Or let me know if you would like to handle it another way.

Thank you.

Harald, could you please address/Cc all relevant maintainers and mailing
lists for such changes in future. The AES series has Cc: linux-crypto,
but the PAES/PHMAC series lost it along the way with v4. If routing
through a specific tree is preferred, please state this in the cover
letter.

[1] https://lore.kernel.org/r/20260814123711.61145-1-freude@linux.ibm.com
[2] https://lore.kernel.org/r/20260821084648.23222-1-freude@linux.ibm.com
[3] https://lore.kernel.org/r/20260804113736.1423667-1-hca@linux.ibm.com
[4] https://lore.kernel.org/r/an-56jLbR6bfPwvk@gondor.apana.org.au

On Fri, Aug 21, 2026 at 10:46:39AM +0200, Harald Freudenberger wrote:
> Fix and rework some issues around arch/s390/paes_s390.c and
> arch/s390/phmac_s390.c:
> 
> - Fix skcipher_walk return code handling in paes_s390
> - Add scrub of some temp buffers
> - Shift from using a mutex to using a semaphore in PAES CTR
>   Surprisingly clang code analysis is able to deal with semaphores and
>   thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.

This is not accurate. The semaphore conversion fixes the atomic context
problem. But semaphores are not a supported context analysis primitive
and down_trylock()/up() have no acquire/release annotations. So a
warning free build does not mean that the analyzer validated it.

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
>  arch/s390/crypto/paes_s390.c  | 100 +++++++++++++++++++++++-----------
>  arch/s390/crypto/phmac_s390.c |  36 ++++++++----
>  3 files changed, 97 insertions(+), 41 deletions(-)
