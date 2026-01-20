Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135C44B678
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920770; cv=none; b=YkV5jtgPSQZU4Qu/1WuQYyMpKrlWIaNVDUSph57BGm4k/lauHw+PbI+JefmpU3yu+Qs5we5s3KJHQt9sXlKo2IHXS67Nau5bCl9thiGjOP4AThZJCMbOqbBYpKEBk/19Lfql83CpsnLaztF1WYJmyVJwXti81lGHW4ikwPth6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920770; c=relaxed/simple;
	bh=YblBCSIO+Ze+wW74gpCOTjlIUF9aS7ZvTbmSmHD67Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcRpFnbtvHq2e0aIAhggYPyad62a4e34GJDmbcBYv8rfVqNfJ6A9gL94ZT58JDe4AC2idAUeYT3VTZB+PORp6ip/5be74qd6RjsKXe+7KnpPJnGGDM4CzV/w7vifM3pdVE7w3JBcCmnQNPnrQEeYE95h+35ntz9xQS7o23tl0Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UkIRZ1G4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ujhyk9sQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UkIRZ1G4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ujhyk9sQ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KEk9x01408547
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ZgHrGhKoJPUcO1Zkr5HE9E2/
	XP1B6ll6VlqYUNqZux8=; b=UkIRZ1G4RJdh5FiKLLcXcE0ptLhxgnPZFJhJFJQz
	7hrUlHbmMPf2cW5yBpGiUPBDX5Ge6EqjecjwzbqHEKX14OqtaCvwOdXBYFiztJCS
	aF15JpCL9iyIFsaixCtS5WsRkx088RP0onUTvXgS9mvtjp1Kv+AnnVCRe6CLdQg1
	APiwP173WVJ9Q0umBxqK9fi4qmPWbI6e2NUzW0U+p9XKTZ+xki2LROgq13xTMy2S
	ac/Ch6KYd2FC7KstduBhpODXeoAaxNsWr0RvfHMaIokqdEIiB1oPEQ7EcpDNcQ6R
	KAgZezL6FsOcVsWxSyG2XkPU4PMHojo0FmERpZ6OpO+FDw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bt4y2sdfj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:52:48 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c52c67f65cso137101085a.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768920767; x=1769525567; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgHrGhKoJPUcO1Zkr5HE9E2/XP1B6ll6VlqYUNqZux8=;
        b=Ujhyk9sQhR+1vu0e+S74gaRtvWCvQJ/+eeK2Zs2UK3hitZHPLeKeaZSMO7LRyPF+j3
         /7xeD92u5w8/e66fm0CwUgne0faURqNOh8yWLr3rFU4+WNg3u42+gWpAPNgNbmHOsvva
         hl04A/Kfyi+SHS6oQ4eRL9bu0juJJBjHcXwQI6Zrg1DFOGxxQH+t7o9abqQmJheA3mVp
         09hj3wEV3w6/oK58S1GQS1vzqRJihOF8wikOMyWYC0DSXWPAUHxoZ7sm5wXqAEHn1Qxx
         Ec+ZSLj53FpwN3xGgnUQwEM7+wBQVEdG7rPhpgajfaYN9eQWtcz82OMWUaQ82hPYqOKP
         1znw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768920767; x=1769525567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgHrGhKoJPUcO1Zkr5HE9E2/XP1B6ll6VlqYUNqZux8=;
        b=p9XM+6T/byRE0lMqkrkjHMVSyCgtp+Do2KD3fl9Kd9uurXsQabhBl9RVe/FFSUSbmV
         IYso1An+wJTo6NvscUmhUP1e0AftJQw5/Lj/UiAHQWi+6SbQ2aeGPkIiUoR8g6L+wK+n
         CVrRnPbQqx8bwHuusl0JGWjkNONPhTCZPeKd0zIwL5c04Zo0c7ymGsEwO5umPoXy+Wqh
         t/QNyEY/B0Cxs0jis/d8+I9ZzXxbBNoXuvTkJezBPtkZ/Ld0Tv/A1orZN0NB/UK9Jnpo
         6LVgjgxLLjFgXCjERU+1hLS/oqTxicrWJVqkv/kynTkzrEeRgmibSO58E8qYYyhqWIqO
         X5Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXUaUhn52KrMKxli+COD5wArz1SFQnMe0HyF45KZUW5mBAhnwXzbZf+KuZIT3dlrPaBuA/e1BpP6oVOSpk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfj26N5gikO/u/eaphrQ9kn8azY29oRnEUVRhWymdflmAZbW3v
	JS7AMEBXke3xfMgQs+SqDSt4pzqsKVesLFUolKi8Ujth/v0R7i/2yD1IOlO4to/lwb6T9EHHCps
	+P8HairQhYJ6olEycdvUbmUd8nJ+eiaOar9QhMmaI0+Pl83FfTZq0Vk+G2aYP2TTm5TE=
X-Gm-Gg: AY/fxX7hK6zDLbQTBIZIKC1F3SSG0HrgXVxTpQ6tGx9HE8GjRqXzFdQCOWW+DyCYUK+
	qVXIdA1Zl16Pj582/Xyl4PpY7Ivcwlcn+tUMDgqpmXTZtQVLtm7Ucsw+Ufqrmgc61s4aekQ2JUq
	WBrj7HTuIX1JyuchXaXGKrTUOLZJF7FBXFUnY5slzbl8f51k2DnkyXBug+ecgltzXO6VzaWnbJD
	YPWaZjzU8iAadCTPWNtPd6ZzCZ71ZirDbjRUyL4MNfTUq9j3O4PVWX3VX6vywuQ4fl8y+MYxvkx
	3JjUM49wPTa219XqqQkW9gwpPFYQ89jJ3ALskDPt6HWw8QJXrSRTwuQobfSxBu7zLvfTXKlZ7t4
	zcMaDToN9eDIpMP36sImaFiLO
X-Received: by 2002:a05:620a:3944:b0:8c5:2ce6:dca with SMTP id af79cd13be357-8c6a68d3547mr1953251185a.6.1768920766946;
        Tue, 20 Jan 2026 06:52:46 -0800 (PST)
X-Received: by 2002:a05:620a:3944:b0:8c5:2ce6:dca with SMTP id af79cd13be357-8c6a68d3547mr1953245885a.6.1768920766241;
        Tue, 20 Jan 2026 06:52:46 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.163.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43596b62700sm761202f8f.42.2026.01.20.06.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:52:45 -0800 (PST)
Date: Tue, 20 Jan 2026 16:52:43 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH v2 5/6] arm64: dts: qcom: milos: Add UFS nodes
Message-ID: <7zdyb2wnojudnrnomnx4aiwvni3e6i52kfioflb3gslztsizkw@ofvvkvrv5f3s>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-5-d3ce4f61f030@fairphone.com>
 <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDEyMyBTYWx0ZWRfXxoXe6v9kNL4Q
 HWw4lojGDkdts8LdGmrIPvgDBUs/EqZsORccgw+KvaZqlsvvNxvUlWwKTSyHLxncZVDhUyUgpC3
 SCpgcgxHUWWbQ/5obC5G4qOtN7MqgMPFE4Wzq6I7bObQN/Fcvaybar+PEzenu1pU2eU7WI6xbTl
 2KWHtJCvLX7HWfyU0B16VQCKwG462GvmRE/yWGZYTP/qHHDjfON/XdtdJ17V8gw6daTTyr7tJGB
 2PHqH20dFCHo417GaltB5+ztcxADFJZ/TufxML95P0zQpOE5GL/Ifanft51W+SkOmGqzgi1ybey
 hQmuQRmdWZWD8hM5yLNsHObB1OzuwHW95gCwRgghHH2ux8QTgH9XlW+clRO+IZBeHRBza9KZBph
 s27Wr+SPO7abbQ7ytrGjSToeg/z5/ATR4JA6yfz5Ue1YQUbozYrpXz6NN4rMxviHu/aqiAZcqaO
 V1mwi2q2Nee+9eVNiLg==
X-Authority-Analysis: v=2.4 cv=Ds1bOW/+ c=1 sm=1 tr=0 ts=696f96c0 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=RUlelSpolvTNyr7Sls5SJA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=6H0WHjuAAAAA:8
 a=3ktymktcbobz44Ac5DoA:9 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: zqV_KOKHRpLHnybz7RosXlDDHFhkIOzx
X-Proofpoint-ORIG-GUID: zqV_KOKHRpLHnybz7RosXlDDHFhkIOzx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601200123

On 26-01-20 16:49:26, Abel Vesa wrote:
> On 26-01-12 14:53:18, Luca Weiss wrote:
> > Add the nodes for the UFS PHY and UFS host controller, along with the
> > ICE used for UFS.
> > 
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> >  arch/arm64/boot/dts/qcom/milos.dtsi | 129 +++++++++++++++++++++++++++++++++++-
> >  1 file changed, 126 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
> > index e1a51d43943f..7c8a84bfaee1 100644
> > --- a/arch/arm64/boot/dts/qcom/milos.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
> > @@ -1151,6 +1151,129 @@ aggre2_noc: interconnect@1700000 {
> >  			qcom,bcm-voters = <&apps_bcm_voter>;
> >  		};
> >  
> > +		ufs_mem_phy: phy@1d80000 {
> > +			compatible = "qcom,milos-qmp-ufs-phy";
> > +			reg = <0x0 0x01d80000 0x0 0x2000>;
> > +
> > +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> > +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> > +				 <&tcsr TCSR_UFS_CLKREF_EN>;
> > +			clock-names = "ref",
> > +				      "ref_aux",
> > +				      "qref";
> > +
> > +			resets = <&ufs_mem_hc 0>;
> > +			reset-names = "ufsphy";
> > +
> > +			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
> > +
> > +			#clock-cells = <1>;
> > +			#phy-cells = <0>;
> > +
> > +			status = "disabled";
> > +		};
> > +
> > +		ufs_mem_hc: ufshc@1d84000 {
> > +			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> > +			reg = <0x0 0x01d84000 0x0 0x3000>;
> > +
> > +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
> > +
> > +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> > +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> > +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> > +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> > +				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
> 
> Maybe I'm looking at the wrong documentation, but it doesn't seem to exist
> such clock on Milos. It does exist on SM8650 though. So maybe the TCSR CC
> driver is not really that much compatible between these two platforms.
> 
> I take it that the UFS works. Maybe because the actual TCSR UFS clkref
> is left enabled at boot?

Oh, nevemind. I think I was looking at the wrong SoC.
