Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0DD2F4A15
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 06:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770014182; cv=none; b=AkaXe/5ONamSxArxs/LwEgYUeyamoVkRxzsS/lsb32dib3k82VjtQaPmevG48LxEpchTCQ7hoqGrvm0jszhiqo++Ond9c+LGtRikzf8mBsuAZxL++isn+sJUqEgKOPzo/TeMox4k4xPPJKSl0H0OgI7KeFurpBFUTGUhoty3qJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770014182; c=relaxed/simple;
	bh=xg9NDRatmvfZM5E54UM8msbcE7qfGPKuOC+UcnpJ4/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijVif5vXo04vR/J01IRToEINjsQcK7o2yD6/PhS51F7APaBcZoSCE5dfERR5/EBxiye4ISN5ntBNCsG222nFNDY+PrPSgAeQEu5bnjGN24q+m52lPYCv+wjivrfgyL9gPlSkyrRQzIqf/3JlVQsVu9/cThj2rSMDWFvjExiY55M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GihNtjmD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kox73u+n; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GihNtjmD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kox73u+n"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 611JSJ561305623
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2026 06:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=; b=GihNtjmDDTRzpMPf
	6aQjhdbcDWzLLok01G/P6xrmiMCy5YL26eKMr5UhAhLNq+xPCNuY931OH5A8yJFq
	w0VLjs6ExTUiLrWVyJ2GDVsTRb9QVWeDcRaaYGIOih88S2QGyQekv1rx7OkhCaJT
	a1GKuGUgvtMVecwWXw+szM9yIt99hguynrrXi8EGQIfcZLp9ckSYTjwQQL6x7kxx
	Do6zy2/17Y5uJ4dXyN/tGAJICMWl3+rWYguIyfp+mC61+M3ke1/OkciUvPW8hiqk
	NhR2u/TcZf+pQNxPvBI9INuBpdPI/qImp/NH56nSRuGhC+mSBBmnWrq6lQaGtQxY
	ze4A4Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c23h1hxa1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 06:36:20 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c52d37d346dso2370470a12.3
        for <linux-crypto@vger.kernel.org>; Sun, 01 Feb 2026 22:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770014179; x=1770618979; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=;
        b=kox73u+np/bE+HREofuTtz6VaBUmxiS05+y+MzT/Yj1CP4XSAC+QRsGmsQ6M+PDMY2
         p3Xxkr+CoyrQ4576U4Aucf/9iMzSWMMmZFOeP2sieBEnvnhJWYn/sVyOy02YFQPGt+DU
         SmKcC5WpSkI+km9ZIpzX152Xgcw4ZYzsucXJ7jO781ZdNYP5BdF+nHtf1QFse2Sblgi9
         3TjKRnBXi094LRRsldAsKHKfnFcP2lVGjTG3dyf/8fMyE0xtj6/r67vSYu5QPjsnpAu3
         hcLGPSGmYQY2ShjgMihnj4dVTTb90Dj5B3IupBnzXL0fyRG1dyCm+5vbwyFbehCFt80P
         AUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770014180; x=1770618980;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SeWrAZswpltJqdpISuUe09bjU6CqIAWEII1qQkgXJJY=;
        b=ncV4hNCYO+y6TflJkHQ6HFPmLma76IApEeQabn8IM2+FpYtba+WoMzXKsLePX30/Ln
         PypXAy/mSqKQi+nlvl4V4wLD7/XiFV61Xjvft8lnAmBgoZ3ec68fJORch05jDILE3v6z
         kkT6jpPXUcUQNEFawo5gtc/jdrkevb7YFrnkk8So62dyUhByEiCzxd7oQsrk9xXmebwh
         GMU1bG+i8o/72czvMpm1bELSRdNRf4EbHELG8GhamHGsQcKd6B+LUypQ9atMQUsYUKxi
         x4DDhCbiVz9pCerOKmtiTTJ4EtrDEMGh7cdH4poh5sMW5dWSCudRPFKuokVLV++kPDvS
         XZzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIiDoypdVYAyn22/RF9Qt93yKVlEPc5KOu3ovkZe0WQRrENcSpMvXwhyoZAYRnakKnA56eyO2AHyOV06c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXCjtVTaKZWarCxVwrGXYUPj3cPnBU9UOYoas5geuZoTlGNLrV
	m4K6rnXsF5VcKazzcQFI5o26tOikHqYhP4XdFjEhc7BAFKAexGXo9vO4zQx34JuDg1elN3QNzXT
	uiFJPveBIojh2G+8b/UfsFKk3xWK4pjK7XoAkSVxcZqchgPeKtlFYXi1MJn6sfKbz7HU=
X-Gm-Gg: AZuq6aLl+1XkR0ET2TMNngXz8HtG5bjTSd6gXDg4mNQvqf9EyedICdXw5ZDXNWu7107
	qb4dfRVMgBgRqAIhiza0bw2/KOK1dRt31tXT/VMTcb1a+HlZ8C6VM0/tRZwIPdZAxMgvg1Nh2Sr
	N88QcfCLj8Y08pIm9XvF0N5wKIHG4PnXM6K7Qrg9Ey86/dlVlTeE/lUF2quyeASP/SKtZToDIyr
	4KzGX67jlTfKrVJV2wtMkOTMgHvYQE8VzAemE6YKurOjVsRkWBPF6bxSv0nV9pHs7KqSgP5lBUS
	SiUxM90UtgYevAA6HS8lYGZUW9qMUT4z+Nt9WMfAmp/dK92Uke6W9fottjwmFQTLnCCzOj2VeeY
	IeqsVlqamSkbiSQNUC48LccbzHr/MNZUa+75JTVFXSgC/nhQ=
X-Received: by 2002:a05:6a20:cfaf:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-392e01b362amr9962854637.78.1770014179628;
        Sun, 01 Feb 2026 22:36:19 -0800 (PST)
X-Received: by 2002:a05:6a20:cfaf:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-392e01b362amr9962821637.78.1770014179151;
        Sun, 01 Feb 2026 22:36:19 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642846888fsm13626274a12.16.2026.02.01.22.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 22:36:18 -0800 (PST)
Date: Mon, 2 Feb 2026 12:06:12 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
Message-ID: <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
X-Proofpoint-GUID: uOugKh-_c7zwRnau1DwxK0g20whv_yfe
X-Proofpoint-ORIG-GUID: uOugKh-_c7zwRnau1DwxK0g20whv_yfe
X-Authority-Analysis: v=2.4 cv=Fu8IPmrq c=1 sm=1 tr=0 ts=698045e4 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=OguJ8merRGVtADoZ0hMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA1NSBTYWx0ZWRfXwBta9bX4n/jM
 IW3Fkhz3x6IZEVrUX/tRMOdLu6PO/ArHwgvSoC/9ALd8RMsbfGPMDSA6y6OPq8VwSQ4mXf3z0Pf
 gMJOnTxA1N4jmRwGaWT9vyBGK/PgkL41jfvXTO7IBlFKUfFvkECp30aE32G6M/qgftzjDzWLRjZ
 H3zW4YTewjwx4BJraklHKgoV0fWeMm57sYxssejno+oRLzaM4U9qrFLJoPPDCH4utoueY46F3gj
 0r79zpXtc1Ki9SXB5KPPpZEJOqejhmDjx2wUkSACbvFRfaPA4DnGsksKK0ld45XkrdzB9eugXXQ
 pmZ3IVFVOO1AIYMHKBMv646wMwtnQFAjHCNiGDexd77BGfuJHi/r3XScM1YgkOCuA/DuvAVOMnY
 nvRtPz9XJSJWrZ3dT+z98VR70Bf6/5VaGiIDkhsXG81Maqrn0ZZ6/tD+j0EzyUlZQdw7eDCs/la
 5dbWfITgZwZNSCvQm1w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020055

On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> > Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> > using the OPP framework. During ICE device probe, the driver now attempts to
> > parse an optional OPP table from the ICE-specific device tree node to
> > determine minimum and maximum supported frequencies for DVFS-aware operations.
> > API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> > controller driver in response to clock scaling requests, ensuring coordination
> > between ICE and host controller.
> > 
> > For MMC controllers that do not support clock scaling, the ICE clock frequency
> > is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> > consistent operation.
> 
> You skipped that bit, so I had to do a little digging..
> 
> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
> would absolutely wreck the power/thermal profile of a running device,
> however sdhci-msm's autosuspend functions quiesce the ICE by calling
> qcom_ice_suspend()
> 
> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
> and a mirrored restore in _resume

Thanks for pointing this out, its an important piece which is missed.
We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
suspended frequency in the _resume. Something similar which is used by sdhci-msm.
