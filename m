Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EC03A9D9F
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779640987; cv=none; b=r3SaCISx0isEzs4ljXab94jrWDoEi1kNI3B1QdAoWrrvJTBbUhKeAfDSBwqRnkp27OPU1/PT1niDzDaIUIe3njb8Gp6w6IGZiQcuzLHK6rXaUj0bgftqM3oa0wZLqUdEkIbWJ/5kOKhRsx3dLx7HVFhKRO+IOTi3r80SEJBrTCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779640987; c=relaxed/simple;
	bh=MpD9PwLQ9CgXa4zGAjImHS5FY9Lr+2Ybi7C/mMlVGXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OV30K4WRDFkeGrEuLLPPFJCU/5rqUTOgGMEoz0O2PYTKHWgprmKWtA/Jhk51+AHNJqRidUqRZTlIHo3S0i4s/CbErcyKDZ6pLWV5Wh9io6GyJTtfW/kTXK0gk+NL21A43/BHo/Hrfmihde/myMa9NTXbzhzSLNDRZFhlCGuv+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aC8AiQg/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IWYcF/ng; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aC8AiQg/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IWYcF/ng"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64O57mw3898007
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 16:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=vfCAtu9YjFvfjUfjXckwcd/p
	zB82MK5Peh4a9ngumRo=; b=aC8AiQg/3zgWPCN4RPm2nA0QmIFWwQZENaHmsc5t
	Tsbu/QjF4LYwD0LQq81RVb2K+V5cERB1XqdtV73ZIwpOz5rnVqn1NBOPUBc2Eavz
	kc5mQ+yqyB1Yqk8Qhz2tFp/edMNe6LwxoSG+Dx6/7j7t3PDNinYxcmuQlaf0PcV7
	PGUU+IdL4KLjXfRQ20iFmkTnyQ/Bnq4KSdwbrQeIW2QfpTTB7HFyyi7kalI9wBeE
	fyjlmR/Un2Ch9ZWHclIzUg8hIgAMaSxRJgYFSlL0XpeQPcFsldZYGpgEaxLZP+VT
	m2ArzsBCd0UOBf/KA8HBbas3M86bSRLob9sxH3rrg0U+Vw==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb36t3rb7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 16:43:05 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-6443138516bso12843762137.0
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 09:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779640984; x=1780245784; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfCAtu9YjFvfjUfjXckwcd/pzB82MK5Peh4a9ngumRo=;
        b=IWYcF/ng61hCWMhzyTg1ARiYeN+2jyaKaGhwKbvcwVckHXEGCubIXX85sMjb9fRQ21
         tJyoUQ1P/dcet/vACCZxjUArxmPpPWbxV1dXH7ycSuIpGnLkspCRY3EZWNlvYpiA9r/d
         /GvnC33qaQJ/Wp+2+pJIWzCTidJYlOEEYoF2JptbilzDNFLk7G4SKoxZOPpSP7lj5Nc9
         K+AYl9ERwDmniN61RrzORve53r8DgnOjGZcUiPwBWeQ62qJUcIicXqeCGyDDfAvxt6oZ
         oyWGzLYYjdaoUYx+ETQ8gwgmQHl5w5iP7xNaYcFW5bolRBjFZ7axIE4O+JkT0QdcBryl
         KZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779640984; x=1780245784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfCAtu9YjFvfjUfjXckwcd/pzB82MK5Peh4a9ngumRo=;
        b=mh4LayPzi2fJAJS5by1IwJ5ySS9gDFqpiilmdYlINSivKze3xO08ycUQLa+MdzS9UU
         gnNuoTv5RGas4wO7cBeV+nAwbusq+/di2xY3wKpqdz4ffd+wVerqY+u4Vcj7SMg8QqIQ
         HiMblxVxMSCgFQr+iyM3IL0xmhZ6F2CG7ihqJb30Pa3X5lNhn73XqO2qnHPKJuGE0JLH
         0FQBAKfw7yHEwOKMBYGcDKG4AxsSatZpoj/+SamtYpYf7jLPfS7ScIoqcs1u6KGaPg5i
         OOSJ4G079kx6lHlDhxZHaguXPdxqZD2W4Vb1WUDPhdFkWQ279qq9A/f/gAA/CmHwEpGO
         1FuQ==
X-Forwarded-Encrypted: i=1; AFNElJ9TCR06RGbq+6KeQvK0fnfuxkxC9ZlthL5GEnB/9lHsyNawwmkoEj7b6YeslSFRh5umMw47hY/P5DJuRgw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7+Bug5IndpLq7yjeOFgP5k4IybaMh7hQ2SOCFzJN/0D//KbIJ
	9AwurogwFUkoVwXU8yeogo35pZTFQ2+2Zya5sBDOPL0lWN/XzWs8/6amS+hy50WEC+ukXVEPieX
	huz1v59I5cWgzf/OB5/mVNVqh9w034H4OqtLAzL7tbIshQNjQsOjPP0Ut/8e90FEGmCA=
X-Gm-Gg: Acq92OFoyBnCDALZZkmLVlMS8LY7f1CjkMjxCSqglZ44PJsaV1HB0+wIJFgOEumxCUG
	L785L4b6qT0dEvk6fggvjRB3L5YrmYmqlOnfhVL3RcQ6KKt0ymEtlxf2Bf23Slfa8Hw7miW/p9q
	zux8nJLKnw8RsSU3sdYRQ2XNJmEKHtP7rzOPOfOR7AJ96G4GdHX+RySmhJCNa+DNn1ks/o2hPh1
	E9YGqy9QbUvqBUbDtJeSk3QdrXh5uw5Z9j9jCbQM8eAJcIf1WFBoyErMfmcFHeABkxAnKWsp1VO
	NPUDsiAlWyDb2cB8lt6RIxMG3ALFp1DsJ5ZQbAMzyLs0wuaPE+263em09BM7CdIjb+0fBcCRh+2
	brgv3LJjw+c5HljRNUodGCb7L70c/Kv4WtWdbDiFNIES5c9EZKW/ScoVF9RLW+YanJvbjZKyILC
	rJtGLr0USIWMjoyO2rBs1kKZ930Rro4glux6Q=
X-Received: by 2002:a05:6102:2b90:b0:610:db51:6f3d with SMTP id ada2fe7eead31-67c73e722cemr6301306137.12.1779640984344;
        Sun, 24 May 2026 09:43:04 -0700 (PDT)
X-Received: by 2002:a05:6102:2b90:b0:610:db51:6f3d with SMTP id ada2fe7eead31-67c73e722cemr6301289137.12.1779640983847;
        Sun, 24 May 2026 09:43:03 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32ceb596sm2021962e87.46.2026.05.24.09.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 09:43:02 -0700 (PDT)
Date: Sun, 24 May 2026 19:42:59 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: demiobenour@gmail.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] crypto: Delete Qualcomm crypto engine driver
Message-ID: <7rgfuvv3hai7g4wt4accbkejtzdt5dnb6mkj6x7ox5sz35q4n2@h7j6rr7extuj>
References: <20260523-delete-qce-v1-0-86105cd7f406@gmail.com>
 <20260523-delete-qce-v1-1-86105cd7f406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-delete-qce-v1-1-86105cd7f406@gmail.com>
X-Proofpoint-GUID: 4luyzAZdJxJl56dTCfbnCqgMN6m1hu6f
X-Authority-Analysis: v=2.4 cv=Fto1OWrq c=1 sm=1 tr=0 ts=6a132a99 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=pGLkceISAAAA:8
 a=f6XAlUmOwKfAZ5K3pb4A:9 a=CjuIK1q_8ugA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-ORIG-GUID: 4luyzAZdJxJl56dTCfbnCqgMN6m1hu6f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI0MDE2OCBTYWx0ZWRfX0XGwLPGxfrLH
 hYySasNEIqa21P9r+Ry19SgG9URpo6o1CTmsrSAWPV5mQ/TJ4bBXq5rPZEXYRwMcHG+Z8CUhsHH
 XubvQ8VQtQFj/98noZQSBkcoVUwaZFcSQhd/mkD/6pvnBfO1Q09NSSOuGeuo5dQHcRo9b+lFFLX
 4wcDqOUft0+MRs09cOieOIj1C31xsm+YHS9CqisDXccD42Jv+5RbMf0GhnY36Zl9+7SVvrW0hnc
 DxRF1F+/CQA4dPdMNk0fab6O1TGts4FG5R3dmXl/z9qub2Z1NomcF+a0Ew02pR7QRfU9gClaySi
 NX85oSSijiJgczlxOFg+tQ08X5bEf+2xOLHOLnJ/pGIKAr4HBt7rwTlVF5vCsotNh2zWPnRPN5I
 ej7/JuYv7v6LPlV3GDiJ0yOwx+ntWmhJc1ycKCizIxgEusaASTOqS635GbGvLGb7tH4HzKoFJCM
 zEZGowz+l8tEKPAHtJA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-24_05,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605240168

On Sat, May 23, 2026 at 03:03:56PM -0400, Demi Marie Obenour via B4 Relay wrote:
> From: Demi Marie Obenour <demiobenour@gmail.com>
> 
> It's slower than the generic C code and causes problems.

Which problems?

Also in the security world faster and safer are two orthogonal axis with
very limited correlation.


> 
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> ---
>  MAINTAINERS                         |   8 -
>  arch/arm/configs/multi_v7_defconfig |   1 -
>  arch/arm64/configs/defconfig        |   1 -
>  drivers/crypto/Kconfig              | 111 -----
>  drivers/crypto/Makefile             |   1 -
>  drivers/crypto/qce/Makefile         |   9 -
>  drivers/crypto/qce/aead.c           | 841 ------------------------------------
>  drivers/crypto/qce/aead.h           |  56 ---
>  drivers/crypto/qce/cipher.h         |  56 ---
>  drivers/crypto/qce/common.c         | 595 -------------------------
>  drivers/crypto/qce/common.h         | 104 -----
>  drivers/crypto/qce/core.c           | 271 ------------
>  drivers/crypto/qce/core.h           |  64 ---
>  drivers/crypto/qce/dma.c            | 135 ------
>  drivers/crypto/qce/dma.h            |  47 --
>  drivers/crypto/qce/regs-v5.h        | 326 --------------
>  drivers/crypto/qce/sha.c            | 545 -----------------------
>  drivers/crypto/qce/sha.h            |  72 ---
>  drivers/crypto/qce/skcipher.c       | 529 -----------------------
>  19 files changed, 3772 deletions(-)
> 

-- 
With best wishes
Dmitry
