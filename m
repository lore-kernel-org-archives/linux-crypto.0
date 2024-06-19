Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A187710F;
	Wed, 19 Jun 2024 22:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718837058; cv=none; b=YL5AksdnJaU4k+ijRxs1kFZPMPc9EgTf6blemW/TWKBi2wYpelPtMcD0KEi+KxDNK83MTAksnmHRCr52IRxl9gA0ZrS/Yu3vmJjhwlcZQ3P7SnaJMFNtdZ+wLcFdxOFU6Bn18LGe3JL+bUa+Kj61SNLR/+o2S1taNXdP59uZb00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718837058; c=relaxed/simple;
	bh=oXNp7YRH64cXmuw4jAlI8JwhwlwS8BtkRBU7nn3JFxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcbGpK5XlsWnUnge0k7rDe5XZ7ro23LtI/fy2voJs00SGmdgyTkdu5TP9Na260vtpTxXlKfCRAdcxS4iwfYo9lb9AxfaVfeX5Fz79ErnomOLtSXjnZ9fvN9XBkzpyMnl57c3PPc4RF28iRj6zEARc5DjRlr0J5l2vwozeldTWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=klxcBaF3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="klxcBaF3"
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JLuTrS010651;
	Wed, 19 Jun 2024 22:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=D6o2Lr4PvzOwJVcJ8tboANHymGZ
	LCNhEYoq9kHcrZyI=; b=klxcBaF3ndVrGfHb9lWri/hgjNwSGH51YiP2uCuOBdA
	hwzf/de4H+jL3p9+T4+Y/fjWyLX9JJVhNiJT3CECbSIM638fApKVSd9PyUYLvrau
	cahjndAtlcOlOdjCKX6uUyFlxCqrSGt1LgGobcWc+BSv4FEcnV0ULoNLX52nUCL1
	qvZbWQmCFHrvI2LFTxKG67uWmgfK3j05HhtbcwKVshl6YURd+vHTPpnjSigOeSyu
	u3i2gPjStGiY/C3tab8ytZpGIhpMxtBUVt1BygKEnuPMUnpCNerFEBfj9gdKYO/K
	LAtSI53N3cbxUgsD0ajn6uFmoDzDlxVT6Ajb7GqG9bQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yv5h10dxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 22:44:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JKacKW009425;
	Wed, 19 Jun 2024 22:44:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgn0c6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 22:44:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JMi5HY55837074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 22:44:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6C4320049;
	Wed, 19 Jun 2024 22:44:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AB1120040;
	Wed, 19 Jun 2024 22:44:05 +0000 (GMT)
Received: from localhost (unknown [9.171.70.82])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 19 Jun 2024 22:44:05 +0000 (GMT)
Date: Thu, 20 Jun 2024 00:44:03 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] s390/crc32: add missing MODULE_DESCRIPTION() macro
Message-ID: <your-ad-here.call-01718837043-ext-7717@work.hours>
References: <20240615-md-s390-arch-s390-crypto-v1-1-7120d406e7c7@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240615-md-s390-arch-s390-crypto-v1-1-7120d406e7c7@quicinc.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EwXSEozTdFnzNFxEQ85b3Ege4cvhqljQ
X-Proofpoint-GUID: EwXSEozTdFnzNFxEQ85b3Ege4cvhqljQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=684
 impostorscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 clxscore=1011 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406190169

On Sat, Jun 15, 2024 at 04:46:50PM -0700, Jeff Johnson wrote:
> With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/s390/crypto/crc32-vx_s390.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/s390/crypto/crc32-vx.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks!
