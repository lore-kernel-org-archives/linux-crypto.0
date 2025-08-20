Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21592E5B16
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 11:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690771; cv=none; b=U7IpwxHjeKBa4ZcWEnamPE6HVi8Y2rdrlp3DQu4/CiKeZI6+AM94BJ9vbqXhMdR63HTispuQEv6FNpFLcLRopwHgydMBOeofac7aphe7Ye5FyZZ8Ewq2Cc6lxvQ0gNvc3mSBlCxTLWlv9wGhWc3s4Aj9mf3MajbFrqmV6Oc511s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690771; c=relaxed/simple;
	bh=+036hMkub/Af/78NBaftIgQF6n0LrLF1Du+6bYcKRAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGsMfo/BWkVFTjW/14VLRgf2MeoHy2tpAbFab6UjXq2bkcO/umdIg5eBqOd/Y4MtkeQHq+5yCw7JRPSt7PWCGWHEFG4GeAQk8poQfNxe6k5l8q81qExU1RygLTHNpOXLVEFh5dCLAs/eJiFygM9QmuXKWhv2uI4iMcznRCIoYq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NbFnfdJY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NbFnfdJY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57K9tg8F010412
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 11:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=1NU5anoXaPxzB4evmItsYtEq
	4iSlXrdsVmJAEsKcsCQ=; b=NbFnfdJYQFNM8SCh4++tmwy0/BvWkAI43WOCQSSh
	O3o7Qz9qkdEC99FA+82EDK98grL5bjNiakj1q0hgVSU/Urecc7h6AsF7YMslu1oC
	z6OqTD4bHTKCcNaLzC2ILLWw3xqDowiDjKQFUstWZWaCvElKl2fd1Qllce0Wco6y
	Iw+0ry2qPplv0VmFicL5XDUqV9HM9CmFG3R2PUPpHvkyvwmqiV48EvbJaLSJgYYr
	XgJqfnyBSBLMTzp7k8DOzFM18HzywyAl7ZAhZwDA263cxgBoqeqWeJEBJbCs3q1I
	qloXnMJOr66vMBVgyAkjxPjx9bnp5tg2oMVfNYwV2qzEzw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48n528sk2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 11:52:47 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70ba7aa11c2so110229466d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 04:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755690767; x=1756295567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NU5anoXaPxzB4evmItsYtEq4iSlXrdsVmJAEsKcsCQ=;
        b=bSi5Ey6pgMP8mKqreM0gkSMWzU9HOOJkaCTATLTvA32IP8cx17iT8XNjCvamIa9BHW
         wBrW+sUugNNAqlVvTEMXUHMor6HJkg8cIw05pUmAgCc/0PVqtTMLf9/3rKvB+DYNHLNP
         cGMXgTPkFZLT065Kr92ESHAX/5PPChcjnUsBNxLOSQkrJAiikCQFgiOijh6EuIanHcfk
         aBtJim2SPDwJhPPmr6df6srVDdYSNWlyRTY6FlzLO2cV+HoKAL3Lmep5Otg0GjrYCo6a
         +S++mDuSjlz1+vaoIqemY4rUy1MgRTwdjafQ1F6Vno72TNRU6IBd03J42U7dv0bAfJBE
         Ws5g==
X-Forwarded-Encrypted: i=1; AJvYcCUDbSRZ4HOD+h5e4m2uAr/sIzXq9YAFALOt27BcBQy8/vjdo7cm99+nsrBFdGpqTYxj5WBjpO+LizpFXXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOF3vflYoUOe7S6VTUzMv91k43xDZQeY9JuYimrWx+QWOrYdj4
	oqH4F0YyEHyAoWIEfSFxRjttk3Wx8kJ5kPV85EbWXEknMaHtV03yu10XBils8dD75a89ftECO2m
	7mbGw/D6j6P9+ojmGi9BbjnBLE1JDfqlh9LUIuhzK+iojSF2YPf1SbXIpVYwK0jl2JBs=
X-Gm-Gg: ASbGncv4Bu6+da+QY6y9E/1+25HH4CQHTjdTs5RMgwAEgybQvv+gADSrCvE0KvmMoIa
	u1HwLsIfJzJ9c3y3nnMpx8IcHz6ydeN68GARH2mIKFE1KdIHDdSplUdTrb5hTH7jQ3gsSKPK+gS
	jG6xxYVSiwUF3o9vTSPDgHAp1UJFTCF/BIrO+lnzZ/IHEWSQPfiiInZLiAwC+FUl4fjU6tKhk+/
	MLe7T5jaS7QT5e5oLOGuNrWzcN9FkxDuYcRNZXy881Na6RqTo8lsnn/vxgzq3KD04d+9rRMd0k2
	J0+1LTUI7VY7CoNBTonWzGTyZAOLi+WKX+VX2ZHuVIUujrFRTPDKSHrFAhstf+cK1kegQ8fwgGf
	w3UlT1dBqnF63py+xP6JdHcXBkAqfZFqlWu//gFRzv9TCvruBUQ72
X-Received: by 2002:ad4:574d:0:b0:707:3ad0:1f15 with SMTP id 6a1803df08f44-70d76fa2d8dmr29441766d6.18.1755690766856;
        Wed, 20 Aug 2025 04:52:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXhlwYJEE7/G3XlVPANthN7ixhS1XYB40WO19b3qrubjjpDOPnmRSenoHFW9qSHFfTgNHFoQ==
X-Received: by 2002:ad4:574d:0:b0:707:3ad0:1f15 with SMTP id 6a1803df08f44-70d76fa2d8dmr29441236d6.18.1755690766314;
        Wed, 20 Aug 2025 04:52:46 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef35f105sm2554042e87.50.2025.08.20.04.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:52:45 -0700 (PDT)
Date: Wed, 20 Aug 2025 14:52:43 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Robert Marko <robimarko@gmail.com>,
        Das Srinagesh <quic_gurus@quicinc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 14/15] arm64: dts: qcom: Add initial Milos dtsi
Message-ID: <2hv4yuc7rgtglihc2um2lr5ix4dfqxd4abb2bqb445zkhpjpsi@rozikfwrdtlk>
References: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
 <20250713-sm7635-fp6-initial-v2-14-e8f9a789505b@fairphone.com>
 <3e0299ad-766a-4876-912e-438fe2cc856d@oss.qualcomm.com>
 <DBE6TK1KDOTP.IIT72I1LUN5M@fairphone.com>
 <DBE8G88CIQ53.2N51CABIBJOOO@fairphone.com>
 <DBOC7QBND54K.1SI5V9C2Z76BY@fairphone.com>
 <55420d89-fcd4-4cb5-a918-d8bbe2a03d19@oss.qualcomm.com>
 <DC74DPI8WS81.17VCYVY34C2F9@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC74DPI8WS81.17VCYVY34C2F9@fairphone.com>
X-Authority-Analysis: v=2.4 cv=I4c8hNgg c=1 sm=1 tr=0 ts=68a5b70f cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=6H0WHjuAAAAA:8 a=XuIBa_usxpjq5QTMMVUA:9 a=CjuIK1q_8ugA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: -LVaLpkfIhF3Xn4CUkZ2wzqDCMIC6-Qg
X-Proofpoint-ORIG-GUID: -LVaLpkfIhF3Xn4CUkZ2wzqDCMIC6-Qg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIwMDAxMyBTYWx0ZWRfXwNkYg/Ao1TU9
 rxY7o2scm9x61bagnR1+gjXa+MmZNP7hbXjGbOF7lfBA3fPt9d9a9ythNOm7NmXo/6WafL783J+
 lVCPmQnoyLERLE+tf5HJU3ZPAT4GSWTrVmYAOWQv3jiuvSDLke63kJfCF7sT5/Ge35hH3bVHAoB
 JGthO65abV/SaCsDCTzpSlg6fs60NjxelDdgp84gl2Lkt9Znl4XSaVZ1rx5BYz63xLwEp/GGSyy
 V9dQ/QSoe1MUBzd6LR3nR7qZagL7H0UYy+ckInBgJn6Kbv7pPONUwsvh4329MsrT7HlCdGx1GNy
 F2MvuOIgyo40CDk/MOgu/b6haZDDquZVDwoefRuaOMYE0irXK+Tld2azNbw8P9NQTdJYm+cAMKx
 ZDR2KZEI7pJtKAotcnXNPkb4AfX6FQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2508110000 definitions=main-2508200013

On Wed, Aug 20, 2025 at 10:42:09AM +0200, Luca Weiss wrote:
> Hi Konrad,
> 
> On Sat Aug 2, 2025 at 2:04 PM CEST, Konrad Dybcio wrote:
> > On 7/29/25 8:49 AM, Luca Weiss wrote:
> >> Hi Konrad,
> >> 
> >> On Thu Jul 17, 2025 at 11:46 AM CEST, Luca Weiss wrote:
> >>> Hi Konrad,
> >>>
> >>> On Thu Jul 17, 2025 at 10:29 AM CEST, Luca Weiss wrote:
> >>>> On Mon Jul 14, 2025 at 1:06 PM CEST, Konrad Dybcio wrote:
> >>>>> On 7/13/25 10:05 AM, Luca Weiss wrote:
> >>>>>> Add a devicetree description for the Milos SoC, which is for example
> >>>>>> Snapdragon 7s Gen 3 (SM7635).
> >>>>>>
> >>>>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> >>>>>> ---
> >>>>>
> >>>>> [...]
> >>>>>> +
> >>>>>> +		spmi_bus: spmi@c400000 {
> >>>>>> +			compatible = "qcom,spmi-pmic-arb";
> >>>>>
> >>>>> There's two bus instances on this platform, check out the x1e binding
> >>>>
> >>>> Will do
> >>>
> >>> One problem: If we make the labels spmi_bus0 and spmi_bus1 then we can't
> >>> reuse the existing PMIC dtsi files since they all reference &spmi_bus.
> >>>
> >>> On FP6 everything's connected to PMIC_SPMI0_*, and PMIC_SPMI1_* is not
> >>> connected to anything so just adding the label spmi_bus on spmi_bus0
> >>> would be fine.
> >>>
> >>> Can I add this to the device dts? Not going to be pretty though...
> >>>
> >>> diff --git a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> >>> index d12eaa585b31..69605c9ed344 100644
> >>> --- a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> >>> +++ b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> >>> @@ -11,6 +11,9 @@
> >>>  #include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
> >>>  #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
> >>>  #include "milos.dtsi"
> >>> +
> >>> +spmi_bus: &spmi_bus0 {};
> >>> +
> >>>  #include "pm7550.dtsi"
> >>>  #include "pm8550vs.dtsi"
> >>>  #include "pmiv0104.dtsi" /* PMIV0108 */
> >>>
> >>> Or I can add a second label for the spmi_bus0 as 'spmi_bus'. Not sure
> >>> other designs than SM7635 recommend using spmi_bus1 for some stuff.
> >>>
> >>> But I guess longer term we'd need to figure out a solution to this, how
> >>> to place a PMIC on a given SPMI bus, if reference designs start to
> >>> recommend putting different PMIC on the separate busses.
> >> 
> >> Any feedback on this regarding the spmi_bus label?
> >
> > I had an offline chat with Bjorn and we only came up with janky
> > solutions :)
> >
> > What you propose works well if the PMICs are all on bus0, which is
> > not the case for the newest platforms. If some instances are on bus0
> > and others are on bus1, things get ugly really quick and we're going
> > to drown in #ifdefs.
> >
> >
> > An alternative that I've seen downstream is to define PMIC nodes in
> > the root of a dtsi file (not in the root of DT, i.e. NOT under / { })
> > and do the following:
> >
> > &spmi_busN {
> > 	#include "pmABCDX.dtsi"
> > };
> >
> > Which is "okay", but has the visible downside of having to define the
> > temp alarm thermal zone in each board's DT separately (and doing
> > mid-file includes which is.. fine I guess, but also something we avoided
> > upstream for the longest time)
> >
> >
> > Both are less than ideal when it comes to altering the SID under
> > "interrupts", fixing that would help immensely. We were hoping to
> > leverage something like Johan's work on drivers/mfd/qcom-pm8008.c,
> > but that seems like a longer term project.
> >
> > Please voice your opinions
> 
> Since nobody else jumped in, how can we continue?
> 
> One janky solution in my mind is somewhat similar to the PMxxxx_SID
> defines, doing something like "#define PM7550_SPMI spmi_bus0" and then
> using "&PM7550_SPMI {}" in the dtsi. I didn't try it so not sure that
> actually works but something like this should I imagine.
> 
> But fortunately my Milos device doesn't have the problem that it
> actually uses both SPMI busses for different PMICs, so similar to other
> SoCs that already have two SPMI busses, I could somewhat ignore the
> problem and let someone else figure out how to actually place PMICs on
> spmi_bus0 and spmi_bus1 if they have such a hardware.

I'd say, ignore it for now.

> 
> Regards
> Luca
> 
> >
> > Konrad
> 

-- 
With best wishes
Dmitry
