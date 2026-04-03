Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1123A9D85
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775240100; cv=none; b=j9+gKMSLmhsy4ZbwcXc7XMNZIPFwnzKoeGmsBsIF+uOLUa/FsCkPJ9AONDKjaoJ2dxDt9u4Kojvq2zP7dG0VRPyCYrz+R5Q5RmkgOI4CMmj9jgjvwZqiTPiiOB0Tp8HyJ0uEPac8QzYtSJ855B4Tnsh9iVEN63fi1ADZxGFpa5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775240100; c=relaxed/simple;
	bh=NSDlO7P8GT2uL0RUBWckhyg8j1c54WcUGo+OSmr/9X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9ELjx2OKJbdDm1N2Cyq0gBPTAk6Yonqy9jeTHTt4FAzdOx2q0muhp63paI7w+hQSe9UgbFzuDC+7skV2lQ7M7JQNu8idEMxfGITuATfxWBvm6Qcp3kAGcDDEDrtvY0Vo1J5dLsWLdnch1DU4cIVgbw11LxpbpxGF+jPHSsd96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NUeCRTJB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XfCsXv7M; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NUeCRTJB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XfCsXv7M"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 633FvPrI3449905
	for <linux-crypto@vger.kernel.org>; Fri, 3 Apr 2026 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=; b=NUeCRTJBwDqgy/ww
	RMPKFTAjW382xf2KqarMzVJkfOhcSTO/ZTAeLb5+UFvLyBvHzpZ5UnYaG7SM+kHm
	uCmbT1FBLPY+dt5/8MXEzS2E/GJl7fSHmuvMsURT9wscL1AUeR2qpinDhu7uJ7jC
	4e1Ka4gIAJrZVfW9X2G5KKZiun+qLJXa8lz6/C1hT6mv4+o0Bq2+QipIHozHM5iL
	/LOsJ+uKKNErgA9kYqoeF7j0wMVFxFxzkheiyTTbE3Kozek3sIDdPknWEdDJPWqF
	uyNMI3i+2SoOWEj9Hcpq5+UvQMCgHe0DSL6ZBXBpQvHpcN9Swd6OAq9RlzJX8T6T
	qhHAuA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4da8u59v2w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2026 18:14:57 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b0c96f5d9aso28739225ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2026 11:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775240096; x=1775844896; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=;
        b=XfCsXv7MG8jc7IV84/ejK39WQZbNH16D9HNT4RxqF/DeJviqurB6jaKQVI+Q2yakIt
         x9yOObPLJdm8KI+69BtywbSQ33o1MHGMKqn9ZFDG1Ew5ffq3mWFNW1g71/aRnadqTEpp
         jFbWJnik0n7Ff3+HkIvH8U3gd3dGtqrrQbS/pJsf8LY7yZ6gc6Ykorqc4OBERyRWdAug
         Xdx01ycQw2A9LEPwTfIk5iICiXvxa7P+dbz3w6cSl+1babfC8vpA6xCDuhIKiKrW7s2g
         cCOnAAocXtKO4Fy1ktnrlhhIsTXJrywwCEu+QD8iPS+Io7UzXQCZu2Eh8I6C+UNzkPDy
         ZMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775240096; x=1775844896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eq4fAPdzfCHluO00XoTQB0jQyUIHHbRnBpp5SfKGF8=;
        b=lzywNcIW1PlNG3LhjE572OoHWMNSyjeiDZqIdTymmUxCK0qqNGMhYlDMat24E9+jCp
         wdFYPzUjhBejHsIYMY1/zsP/lgnGLgRsv5vInrLOeomohSDbBa/eNUe0JZquWw5Qd5P3
         n6a+ydNk0qf2j+lin8I8odN12+S4KG5r4jzCky21sg89wWshK3xqzmeZIsyOS46OuHg7
         ZlJZoK/96zugz5tyaJL5ZMS4INISIXJmOEgooBsjDwYkLuOVjs0/cZynHYiwGiBrWZpo
         6QeiOR5kx7epIqr+8s6gJ74YoB+4A/VdIBKE+/gL2UjszQGdL7jmoIDWM4zItpKXJVdB
         mE8g==
X-Forwarded-Encrypted: i=1; AJvYcCXRQyz7pFeiOqvyadX80DAMQ5lLtrgpJVjab8ntaQudcDWKXp44nL76WuALQ6uatgevfJ3vllBmGhcK1r0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAj5pEh/aLWZwFhrjymTjX2y/+1/T73zyr6kx/RZimEmZsSC//
	FpoIzQhaq0ff7SlA2MRiY/OdbDn44A3Gog4l41TFVBnkKr7H28vKatVj/KZhlNnNTxUWFK3B45e
	G9/L3J4/CZcvlw0vmMq+8CgjWJDuZ2RL9xWlGtzIMsSmfAJLqNX0xEVRiPA1J7vUrCOzXQ8oXjt
	g=
X-Gm-Gg: AeBDieuldSTsQlmYOR4ZPgkUISm4wYLEnDR0LR9yZGx0sgvuuh6C/kCzuZGmVfm8xUI
	yA5JxN8VkgA6Vd7IXoG8hPDCL+DbVSmNct1ttS2mgiPcIOKYYdqjsc/ryU9HKiDvN+gLFawK1Cq
	Os9mz02URpM8ZQOGm53gqsjutFadC8FcYJBPSOSG/ctaxJBGbD4k9G74f2Zl1S0p+ZbQnzTN9Mu
	FBQMA/GaZZtCZG+PQjJhLek1MVbJ/OSLB+H9HLjssPPajeQszLBjXlE7nUf2SCHALH3/gxbmNpC
	74tXfepXNzVGFCzUDXAnf3StaPjFzbUZw96xkIn46iBgUbbHKgPnWLtCfuH8CmvqqpC4DReZVNM
	DcTU56GrMgX0CZI6+F2on9Da4mNtk+p38g6P+kXpxN/2i/ClNTlgTpZl5ZNU=
X-Received: by 2002:a17:903:360c:b0:2b0:6df2:8cd8 with SMTP id d9443c01a7336-2b2817d3f7bmr40518045ad.40.1775240096387;
        Fri, 03 Apr 2026 11:14:56 -0700 (PDT)
X-Received: by 2002:a17:903:360c:b0:2b0:6df2:8cd8 with SMTP id d9443c01a7336-2b2817d3f7bmr40517825ad.40.1775240095763;
        Fri, 03 Apr 2026 11:14:55 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d1a2sm67923515ad.7.2026.04.03.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:14:55 -0700 (PDT)
Date: Fri, 3 Apr 2026 23:44:48 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Message-ID: <adADmJBEzIBamX91@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
 <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
 <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE2MiBTYWx0ZWRfX/FetFntpP2jv
 Rpb1jCpYFs6QI+GBHxqL471hz8eIfh+jx6ORQjTyIeDYSi80kMTjHXL7aLK6C3H22iTRJdBuv9D
 v7dQ2ZJj04Iq5Te2o1GqZpgfcUJJhvROqIH3JzTuhCydde/LaOwJ4LoQuS7gyIBY0jaivHwfyS5
 AOtJ6wYCpYf8ClzzXjT3nWU1Jkr0U8uEhzRbHo56qoixQp6TtPOJfQq4BuIaCP/s5UVHkXyiLF9
 5NeaHaBAFJTsPY1BFz012T7VUJyDfgadxYqL3u4XH9ySH1mdIYTWKV1yZv04eyZjc34RbgbuG+q
 0mHK0JystfTV7+IGrbxkELK2iNB67o4lwurlb0vBYB0saAajgTxdlWebJmRIY975DD+iWOepHXy
 8A8N0RLYfXUfpNIrp6hl+Mj+/Pdt7kiRVgSwAUFDdpi0+DVktjOImTdV5jMGqZYFHuhLvuv9JMh
 pWH4938DKdBWmoFV+5w==
X-Authority-Analysis: v=2.4 cv=W5g1lBWk c=1 sm=1 tr=0 ts=69d003a1 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=y-8eonv6uMWv_09NrVoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: BXvtoaVWNJx1w_y1oJr6RdiJ4jT3tr7P
X-Proofpoint-GUID: BXvtoaVWNJx1w_y1oJr6RdiJ4jT3tr7P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_05,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030162

On Mon, Mar 30, 2026 at 08:14:13PM +0530, Harshal Dev wrote:
> >> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> >> index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
> >> --- a/drivers/soc/qcom/ice.c
> >> +++ b/drivers/soc/qcom/ice.c
> >> @@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>  			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
> >>  	}
> >>  
> >> +	if (engine->has_opp) {
> >> +		/* Vote for maximum clock rate for maximum performance */
> >> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
> >> +		if (err)
> >> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
> >> +	}
> >> +
> >>  	engine->core_clk_freq = clk_get_rate(engine->core_clk);
> >>  	if (!qcom_ice_check_supported(engine))
> >>  		return ERR_PTR(-EOPNOTSUPP);
> > 
> > Hi Konrad
> > 
> > Since you previously reviewed this change, I wanted to share an improved approach
> > that I recently realized for handling ICE clock scaling in the MMC use‑case.
> > 
> > So far, we have been voting for the maximum frequency during the ICE device probe
> > to align with MMC requirements.
> > But because the ICE probe is common across different storage clients, applying
> > the MAX vote at probe time may unintentionally impact other storage paths.
> > 
> > Now that we have a generic scaling API exposed, we can make this logic
> > MMC‑specific instead. In particular, within sdhci_msm_ice_init().
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n1966,
> > we can invoke: qcom_ice_scale_clk(ice, INT_MAX, false);
> >
> 
> I agree, this is better instead of blindly turning the clk freq to maximum.
> 
> I was about to ask you to move this to qcom_ice_probe() as per comments in previous
> commit. However, since you have mentioned this now, I suggest adding a call in
> sdhci_msm_ice_init() to qcom_ice_clk_scale() immediately after it calls qcom_ice_create().

Sure, thanks.
Will update it in patchset v8.

Abinaba Rakshit
