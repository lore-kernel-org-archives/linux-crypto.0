Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D13221FC6
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779696731; cv=none; b=tRP5B0Yo6ls73BXXEqexYbYyU0aKTvXGEOuMrmLamvsRGTtqdUXd5TH2kzuY2OKWtUqSgeovHN0DrkUl3eqr9j98deVEi0UEkuquwOercg1BbiX9jt/pskClpUJnKPiK7E5I6iELzpDzOZrgAEg7YHgg3KFsRQWBbTTjqP/O2YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779696731; c=relaxed/simple;
	bh=ky/uvj7TS8x9BLdhtFGYoyUVdaA974Kp59ypdiHaEBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI4FtRQobfiHypBL4AYN4SRfxB1l2O7B8AO894mRJ4TziQ+tw4AMtsVTSXY+rhxPMuSmuSZiR/Oa2SA9QkxmVHCuh9InFTGInn8cOMeAeFY9I1eZ0LWiitQ/O0b2XfHJrifvcpOBKcbar1qTRnk0m0rzUCDiu+3JOetDGiS155I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FEI1zkhj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=btLYL7e7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FEI1zkhj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="btLYL7e7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P6TCeO3666132
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 08:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=1uKsUrjz0I8S2LEpuKUc7mm7
	jWBeKvWru2gsBEv3SYY=; b=FEI1zkhjDA8FW4jKZwKvB+LivL0t60Q+2nRdGhcW
	aXF8pHiSvN2eFJ9FTbEXYZASBrVg9Mp/+oHKYPgIVtdOywiRLXVPN9VORFqnXr7V
	WPYkRutPVpqepKSQf4p/hleSfV4btVb6ANHXgifsvUnPUi1G/WfVpUE9q6nm3pV/
	PJ7WoEfnXmGI5f3ACP5TtixE84xIqnsVXPPk/gl2eLUXlhmQzPnIw3RITXFtM3lK
	AUd6gyHLuYUlrr37dsXbQkhDNHsLAx3ZStAEA15Ah3wKG+ynWXx6vrer6FBINanD
	ioMhZ7kSv+4M0QC/ZXrZiThRGmPNHOMinoGVhUZIekof7g==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb386nx5p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 08:11:52 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-6312aa1d7adso6257515137.0
        for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 01:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779696712; x=1780301512; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uKsUrjz0I8S2LEpuKUc7mm7jWBeKvWru2gsBEv3SYY=;
        b=btLYL7e7MYvDop8b+dcPXttvsmGHDrV5aiA8iC02x6zQG7fhlU7of7ZSajB6qfjdri
         mp5FboCbGLKpX7fmRlwqbNz1rMKT+sRwuPi6Nx/RoBbJcd2sjMr2inAn4HFd/pCvEElP
         pTI3rpYCRzFczZYsAfhgver13zyAANiAtudcBaUpWrHksvAKPpflIx0B4iT/lMGr3QQj
         XRQTfzPy4e+dk4sL9qrQwmc8c72lMidigEtoImm8sO6Lj9mJNoYfj1XiemcKqwbfs9qn
         vxRa4uNUGcMqd1tjnyGNrORFINt3KM2VsGXXWzEkLBH6XIhsD2eIo4fneZibwCpfNRmR
         wLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779696712; x=1780301512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uKsUrjz0I8S2LEpuKUc7mm7jWBeKvWru2gsBEv3SYY=;
        b=DAB7g5KjmMTri7stFAg47xLi52G64C1F69BoiZFBwGCryRqIFw5AM3DTkrA3JRZdfI
         coVxq3VdYLn6pQCi1rs7CCsX7bs4UljAC0wVhfBZP5n4axa8pCeGvGkTDnej5Hy3IhKw
         2CmcTex5OSuZc68CCdF+YpxUe64sO7rlOMAHRYbB96UkTym79pV26OlWWmx0M/HuFPlM
         2ssIwhWTBBzsPjvxdbRVP7uiqX91Y4dHDXBOhWaB4fGhSH1BqNVqlHmN41HvAzzXzLE1
         QDHOwYkKLJacx0Gz+kSYC219LdDYo55MtAijwBWZXhzhLIbhJYsbFlVis6zY7simSbwK
         mJ6A==
X-Forwarded-Encrypted: i=1; AFNElJ+zW1bf6Hh/JX+jGapRXq9CNjk2wJ7+JYc1xYIvKqN+dbgOaCI0DUVlEygHIkf8ToUFHxKyIdgVEOxLhKY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf5Y6lQxA/8Z6eiqIwgIhE5rEUtq0E5lPxq0Cc13+rtTUZL2M6
	sbiQ8IqZS0HnWxDkWwvDZBQDc97KadbzLWkDrYkpgmti+hJ6+0PrUTJ2IZsLKbAPp5Yj/nVrjUZ
	XC8zQcXlLix3n2MtaM+ANYRFzEgJ52VvVgNM3z5z6ATSh+dqxNfOm/BBCpfGd1t2vtus=
X-Gm-Gg: Acq92OHTPF9O4x4WBFMJpymrOP6eyGgidpzo3iFZE8iJmrlr5luM6EtKi6W1HAFB1+w
	tg+YYmiMqet0wLe3JfOh2M1X6tF0LwCVyU6a+g8fGd3qo5FwnEVCakYODkFBIxo1F4r2wKkJJT5
	HJ9xLinxED/IXzWjjPg2O4hZzfC9C4NGTVnLuCj/UyZAK1HsnSIVDxDH4qGEVRGL/Y7VhF1LRI7
	eTNhy/iQJwFjRBC6enlHCusjmuybjZOKOQH8jU53CEtqzuUyVtGL+SRTSuWlI3vYK7E/B59Ow3h
	WcNbyGOUEN4qS6kJeW8uefK3OaC22M/VDzxv0MGcFFTrq78zI4ZbFT/9dFqhQM3wDY/07WCLem2
	oCSGXlHvFNb2/Gre4kuu8OMTryg0oiuNWwEHD5aifxbLW/gDtNH8g0XfZm84yf9ycp7oGDYHRld
	PfS4ogS20qXmVA7zjjXD7axZSD3Aevm8i7Mas=
X-Received: by 2002:a05:6102:3f9f:b0:631:ab8b:c34e with SMTP id ada2fe7eead31-67c7300bc83mr5975211137.11.1779696711897;
        Mon, 25 May 2026 01:11:51 -0700 (PDT)
X-Received: by 2002:a05:6102:3f9f:b0:631:ab8b:c34e with SMTP id ada2fe7eead31-67c7300bc83mr5975193137.11.1779696711479;
        Mon, 25 May 2026 01:11:51 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32cb3689sm2529041e87.5.2026.05.25.01.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:11:50 -0700 (PDT)
Date: Mon, 25 May 2026 11:11:48 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] crypto: Delete Qualcomm crypto engine driver
Message-ID: <rb35vwvusd733s2zbgsitof3cpoyyfope4cpeh47xldw27ufix@7fm6bgr4wtkz>
References: <20260523-delete-qce-v1-0-86105cd7f406@gmail.com>
 <20260523-delete-qce-v1-1-86105cd7f406@gmail.com>
 <7rgfuvv3hai7g4wt4accbkejtzdt5dnb6mkj6x7ox5sz35q4n2@h7j6rr7extuj>
 <66317f6a-645e-432b-ae11-8f40569d4117@gmail.com>
 <d97382a6-6c5d-4a3f-89cc-3ae9b432de3f@kernel.org>
 <20260524204537.GB110177@quark>
 <e36172c6-4424-4b77-9b3c-47dcdbdff05b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36172c6-4424-4b77-9b3c-47dcdbdff05b@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: ThgXNZIaeP_WUakc2SwO6BbTO-3_QgYI
X-Proofpoint-GUID: ThgXNZIaeP_WUakc2SwO6BbTO-3_QgYI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDA4MiBTYWx0ZWRfX4HWEmf0LHXfc
 t1laP0Uc9Sfxmhmg+E17LhxxyETK0H2cQmR7dl0iysonA/A1/rRnHY7wHpzNc13yxjn0E+AIV4l
 z0GJi58mxBnOG3dr8sd36ltJ1M9ZZZwA45nTIZsd/jadPVmYPGZwPNaLBmieu8TvLGLIKGrbBI4
 6Z/sJPgWf0UmVdp0qxWoXbe8bXg03yMes48OPlJkSRFuHVQODfCT2veaB+/tV7XWv3d+tm8Q2bm
 /AFXc4EnwLAHln6GMu8EFlgIP/qjlzK5kABkVcuIZin+wXrBmSteOeTQKaWoxuUCJ/1BHyESoM4
 94XAtjCePg3hjJ89KlswAwEB+Aee5vH4pf6cTRQ80zA/aDVapPaYWZMtV34sNUzC8EPHge1bRSh
 byzsw7pWNDQENTYeUtJXa2b2VXiuErjuTeyg4ZIct8nrdIUrHwruihhEhfOG7E8K2BhQF/NmeIK
 FA64ymiM62sBQAL9LKw==
X-Authority-Analysis: v=2.4 cv=PJY/P/qC c=1 sm=1 tr=0 ts=6a140448 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=hz7RXHJ8Q2vzIh2DF4cA:9 a=CjuIK1q_8ugA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605250082

On Mon, May 25, 2026 at 11:59:33AM +0530, Kuldeep Singh wrote:
> > This driver is more than an order of magnitude slower than the CPU for
> > both encryption and hashing.  See:
> > 
> >     https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
> >     https://lore.kernel.org/r/20250615031807.GA81869@sol/
> > 
> > There are many examples of it having bugs as well, for example see the
> > second link above.
> > 
> > That's why it had to be disabled via the cra_priority system.  This
> > driver was actively making Linux worse.
> > 
> > This isn't particularly unique to drivers/crypto/, of course.  This one
> > we just have data on, so it's a bit clearer.
> > 
> > I've yet to see any real reason to keep this driver.
> 
> https://lore.kernel.org/all/c1697372-54ec-4f57-85d9-ad375ff1a44d@oss.qualcomm.com/
> Kindly check my latest reply to the thread. There are numerous usecases
> like DRM(Digital rights management) coming up and qce driver is required
> for secure content.
> 
> > Crypto drivers need to be held to a higher standard than other device
> > drivers, as well.  The onus is on those who want to keep a particular
> > crypto driver to prove that it's worth keeping. 
> Sure, I'll be working on stabilizing self_tests infra for qce.
> Kindly allow sometime to go over failures in crypto selftest and will
> submit fix if applicable.

Why are not selftests a part of your default config? How are you testing
the driver?

> So far, i am observing 2 ciphers failing(xts-aes-qce and ctr-aes-qce )
> with CONFIG_CRYPTO_SELFTESTS enabled.

Please make sure to run the tests on older platforms too, not just the
latest & greatest.

> 
> https://lore.kernel.org/r/20250615031807.GA81869@sol/
> May I know how to issue reproduce steps because I didn't observe
> crypto/ahash.c failure with CONFIG_CRYPTO_SELFTESTS?

-- 
With best wishes
Dmitry
