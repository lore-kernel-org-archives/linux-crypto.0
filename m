Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB522386C29
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 23:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775605543; cv=none; b=jJ6CRbHiq4uWIwV2eNbdhCLjfUF1Z7tL+Y9hQDZFI4qSL/hkE7rrLGEWzypqbJ0e1fUuFSf2FOC+JWCMwnoXQxktx94DvLE8eMtavtXpblx+NrjFqoilhIcioVUF1VAMIuAB2mDThDoBORC9pTX5iyvoBeUhqlSgfkV/BSP/gkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775605543; c=relaxed/simple;
	bh=5RiwWyfTRmY+ICHwSz2ehVlihQE4jCeKt9H823nu7G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPOMqo5lW4oOXmj11rF0J9ZDcnxQAqQNPWV9PCXQce/DHMxJIvzJuOoMVWDEhNKxiU14pvrHU2qoKCP20/PeBgUSBrm/8xwkGwJVQrKBK2BN8r1ueXwM6Cdx3ixhcVRKsbK6657UsaEc3RLltLT/MYolTGZAx+n+T1mZVbC35Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FgJGOP/F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I2Q0L+Ec; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FgJGOP/F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I2Q0L+Ec"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637H7Etx2412018
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 23:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=dqnafUrvON7HZA8zHAS3PedH
	DWzr2LNEiDtUvABj9vA=; b=FgJGOP/FAFMePg582rzGfkWLseQ3HPEe2HxcpqK0
	CZAp+I6li1p/cEviB05ZplP1eggT5wEd72FQ+V2HU/20KPuzOmr37kDdiuEKNybu
	ERepe6f0imAUDZMGgNH5LCXxfXffA+fj94vYPby7H4K+fv46wHHoItMtCu3zotTA
	RZMxYP77GGgnM8D3e+K4BOCdNfpW1uaYKLMKh6X0z96Q9DjTlfxNoy6awkHo0mr/
	/5+uQVLVYjJ2FSrwk4TZXmbVNUVfn9LNzm2Ca3yQ02RbPjDbQrK8kov642ZUKSQi
	8FGwLxiIZ9ozPzI8xypEmP+yDbDs0KDiF3PYKXokeKNVQw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dd61v97f9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 23:45:40 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82a88a2704fso153716b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 16:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775605539; x=1776210339; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dqnafUrvON7HZA8zHAS3PedHDWzr2LNEiDtUvABj9vA=;
        b=I2Q0L+EcLQDoSwFC5QSQe0FtmQT0i6EE06Wzo2DaXPP0XxEgUS8SegNjeeTm26ai//
         DSjg60eQb0C4O3qzjXpTdePxz31kWKs6RmQS76PvnN+aHBn7H+uPJHbaCZd5jrAsVAUz
         dNyTdmMIZ5jFTxaQnbXRg+GpNQBQeW2RU36pMPbcUYUCNF2ja+tfewDTqL05GoILVQ16
         Jc5jFHSkYgp0XbKqWtJs/GOPb6j5LccsBUndLNkJdP3H1KpHdYUhOI2R2Ox1QbxqLqba
         2vNxOr9Az/7wRgf0EL1fY4UZAuj05CfWFLD3/AnCLYfMa9O8H/Ioo2S3aGHJS5ZFP+yL
         tycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775605539; x=1776210339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqnafUrvON7HZA8zHAS3PedHDWzr2LNEiDtUvABj9vA=;
        b=srBxYDsNe70kn61VYTAyQD43Sz+ymXQPjrJ+QOELYLcedA7XDwkZMpbAKY27ZU/oMS
         YwdfjkhiKGz1vHp35v8pw2ptyyyaTCSvQmyuX+VQA+I6KNXOwhY1ezDHIfevJVtbE2Tm
         aauGFtA0fi1deeNS0Nse4hHM94HqcJ22t4JjLhO8O5hFzy+AArJx64i2NrvCJeCj1zDB
         HeLf+erHAakLWOCbJ2wJYujRSd3Mgt+VVbbSDkReewv5wZsfqos6kTpBffEf5rx/qn2M
         vX/J6ejpQgdAXBWHXnEyku4/asJkxlYm5CT2dFRKKOnFxJw8M8ZlryWsjAiwkEpX58ly
         wATg==
X-Forwarded-Encrypted: i=1; AJvYcCWF2SlDIDZOn0c8Vr7ktGbuSytKLquC7syTrACd5DFjZteBnpfV9wEZvE3xMxvs6OC/6+dgcdUsixeTfMs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9BX5ibB/YQRB41GOjh+bQzlVvTIexWWKr8bPQ9jcDrgvOQihf
	9ON39Fqr77PN5YeOgelx5JPJri55jyntYCQRntXoFgk8nfIbJtj+FaVYmHoUzi6pxUBPbjMN5/2
	Pk3hAwP0f/SIvP4nBuXOj1L6hyaCPulBWKPBbKd9wESCEMCgnGGBqY+Vw1aEKciAz3K0=
X-Gm-Gg: AeBDietC7OBeT7Wx6e+LUEk6HFWuvQsKI407+wbIFPUDBTyRdm1SX7PMrUt1UtEDaYD
	vTwpDkquboD1RyoZBuiVQrL8GssYvYR/wph76bQtvy53jYbhJTGpMbqXIeZOIYMo/F3V09M4Q90
	6etwK3wjzgbnpvHzbb7pzDSxRczX8jm6qvVwnssa19wiHO7Vx5/y5sPseg1XgO0Dh70h9d3Qsl4
	xJQM9r3zWpuW/nfhot8K3s4rjdFPTez0X/lF4ScreJqrw4X8nWFPkd2fCqQ8PYcoyen443f8ZqI
	Nx2GAz8m2h/bl50Ic9FY9FcogMXHAEOX0If4Zp67t8Z+aZGRc8nZKIe02I/9GxB/5wMQsZTgIBM
	PyfWBss2paUqLiCn3YFMlXMkTkCalAp+nux86p3LRTCP+v9/2agQ2ddYqufA=
X-Received: by 2002:a05:6a00:896:b0:827:26b6:c11f with SMTP id d2e1a72fcca58-82d003b275fmr19984189b3a.31.1775605537794;
        Tue, 07 Apr 2026 16:45:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:896:b0:827:26b6:c11f with SMTP id d2e1a72fcca58-82d003b275fmr19984129b3a.31.1775605536479;
        Tue, 07 Apr 2026 16:45:36 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3baffsm18939943b3a.14.2026.04.07.16.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 16:45:36 -0700 (PDT)
Date: Wed, 8 Apr 2026 05:15:28 +0530
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
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <adWXGB8QshGguuXC@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-1-669b96ecadd8@oss.qualcomm.com>
 <a616c056-f9aa-420c-a543-7f1539e9e886@oss.qualcomm.com>
 <ac/L6y5B+6SyTNuE@hu-arakshit-hyd.qualcomm.com>
 <0375e235-0b8a-458c-a797-d5b341dc60b9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0375e235-0b8a-458c-a797-d5b341dc60b9@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDIxOCBTYWx0ZWRfX5NWWCIytjFWx
 +9hfm1x/wjudLbfYiKzvFuA76KqvyCDwRTV+0M2vZpRIgosqJMrpe2xtoBZeAlx/w+HLQyTEHlx
 ru+8fCM1Ybj5pEeblOhU8f+pTW5vE2TDPdul7fPogif+x9OuyxmtzfFTDwm/1t2GIIHboxS4lUN
 E+X1PD7tHMhnu7hQiAqnoKO4Mjx99lNm3YH6M9L1KQnq7t35Ef+kig6MlQuI4fXS6Q6dmMTYSBW
 qRCKPjM5w/5RqQDaow65DOJC/MgrtZ0zoiVMsXzbilYl+nas4YEUlgaeHs4yHHUbEEAUb0Nd3Se
 fgJ681zUmQ6hYbq4h3MxOfqjnzFyL/IZWBmeuWjdOGhUxs4Qw/zigg+ozJ1AvnG/iDpwOYB0tzt
 aUjGd2KZCJj2Ou51FNJ2kbgD09jCLbUSEr/gQlSCiPwuhH1JZm3yFvF5VEGj6Bk1QJ3qBU05H7i
 XUrGWz+dZi2dhKHFshA==
X-Authority-Analysis: v=2.4 cv=FecHAp+6 c=1 sm=1 tr=0 ts=69d59724 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=CkLZM6L_lappvOHulz4A:9 a=CjuIK1q_8ugA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: Hf24E_bX0-spn22-h0Npu72WhQcLiJ3c
X-Proofpoint-GUID: Hf24E_bX0-spn22-h0Npu72WhQcLiJ3c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_05,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604070218

On Fri, Apr 03, 2026 at 10:50:29PM +0530, Harshal Dev wrote:
> >>> +{
> >>> +	unsigned long ice_freq = target_freq;
> >>> +	struct dev_pm_opp *opp;
> >>> +	int ret;
> >>> +
> >>> +	if (!ice->has_opp)
> >>> +		return -EOPNOTSUPP;
> >>> +
> 
> [...]
> 
> >>> +
> >>>  static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>> -					void __iomem *base)
> >>> +					void __iomem *base,
> >>> +					bool is_legacy_binding)
> >>
> >> You don't need to introduce is_legacy_binding.
> >>
> >> Since you only need to add the OPP table when this function gets called from ICE probe,
> >> you should not touch this function. Instead, you should call devm_pm_opp_of_add_table()
> >> in ICE probe before calling qcom_ice_create() then once qcom_ice_create() is success, you
> >> can store the clk rate in the returned qcom_ice *engine ptr by calling clk_get_rate().
> > 
> > This was added as part of the review comment from Krzysztof:
> > https://lore.kernel.org/all/20260128-daft-seriema-of-promotion-c50eb5@quoll/
> >  
> > While I agree moving this to qcom_ice_probe would be more cleaner without needing
> > to change the API, most of our initializing code for driver by parsing the DT node
> > happens through qcom_ice_create, which keeps qcom_ice_probe much simpler.
> > Please let me know, if you think otherwise. 
> >
> 
> Seems like a suggestion from Krzysztof and not something based on strong opinion. Again,
> you can choose to do this if you spin a v8, I feel it's cleaner.

This comment raises an important design point around whether the OPP table
should be registered in qcom_ice_create versus qcom_ice_probe.
I agree that moving OPP-table registration to qcom_ice_probe would be a cleaner and
more maintainable approach. Doing so avoids the need to distinguish between legacy and
non-legacy bindings at the API level, and keeps qcom_ice_create reusable for both cases.
This also aligns well with the intent of qcom_ice_create, which should focus purely
on common/basic hardware initialization.

Additionally, qcom_ice_create currently has no dependency on the OPP table being
registered beforehand. Clock scaling is a performance optimization and does not
impose a hard requirement for ICE operation or enablement.
From that perspective, there is no technical necessity for OPP registration to
occur within qcom_ice_create.
Ack, will update it in v8 patchset.
   
> > Also, I don't see any reason for moving the clk_get_rate() logic to qcom_ice_probe
> > though as it will not be set on legacy targets in that case.
> 
> I thought only new DT nodes will be specifying the OPP table requiring us to store the
> clk rate and restore later. If legacy DT nodes also possess the OPP table, then ignore
> this comment.

No, clk_rate is not needed for legacy bindings. It is only needed for DVFS operation
across suspend resume cycles.
Hence, its value makes sense only for non-legacy bindings.
It shoud not be faked for legacy bindings as clk rates can also be scaled from
storage driver in-case of legacy bindings.
Ack, will update in patchset v8.

> > 
> >>>  {
> >>>  	struct qcom_ice *engine;
> >>> +	int err;
> >>>  
> >>>  	if (!qcom_scm_is_available())
> >>>  		return ERR_PTR(-EPROBE_DEFER);
> >>> @@ -584,6 +640,26 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>>  	if (IS_ERR(engine->core_clk))
> >>>  		return ERR_CAST(engine->core_clk);
> >>>  
> >>> +	/*
> >>> +	 * Register the OPP table only when ICE is described as a standalone
> >>> +	 * device node. Older platforms place ICE inside the storage controller
> >>> +	 * node, so they don't need an OPP table here, as they are handled in
> >>> +	 * storage controller.
> >>> +	 */
> >>> +	if (!is_legacy_binding) {
> >>> +		/* OPP table is optional */
> >>> +		err = devm_pm_opp_of_add_table(dev);
> >>> +		if (err && err != -ENODEV) {
> >>> +			dev_err(dev, "Invalid OPP table in Device tree\n");
> >>> +			return ERR_PTR(err);
> >>> +		}
> >>> +		engine->has_opp = (err == 0);
> >>
> >> Let's keep it readable and simple. engine->has_opps = true; here and false in error handle above.
> > 
> > Well there are 3 cases to it:
> > 
> > 1. err == 0 which implies devm_pm_opp_of_add_table is successful and we can set engine->has_opp =true.
> > 2. err == -ENODEV which implies there is no opp table in the DT node.
> >    In that case, we don't fail the driver simply go ahead and log in the check below.
> >    This is done since OPP-table is optional.
> > 3. err == any other error code. Something very wrong happened with devm_pm_opp_of_add_table
> >    and driver should fail.
> > 
> > Hence, we have the condition (err == 0) for setting has_opp flag.
> 
> My suggestion is you either explain this in concise comments or simplify the assignment of has_opp
> to make it obvious.

Sure, will add appropriate comment here.

Abhinaba Rakshit
