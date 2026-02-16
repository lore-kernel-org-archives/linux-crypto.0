Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27A2D0618
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 10:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771236319; cv=none; b=iR+rFqn1Z2FXi4XG7MLtNZ6vstXN8gSRVVG+H1qD/nKPIdUOAPVx8v/Q0Qn5Vcuxr61prBWgHYx2ruvjrSIjztYbwrp0FJgB7ZLZFsGBKeF2JFbcH3ZjWlCr6EhSLwHr5xP4f26yYiECSo1NFupIZJLm/oR6L1ToAC+3bV68DVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771236319; c=relaxed/simple;
	bh=h9Br9YS3XInvcC5sO9r9RZvv1U/+jyqG6ZbzxKQnX+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtPmNB80cSFWomkt+e8MH2YlmtJ+chXRJLbhEcPPaVNBSYoBiSsc9ehQpjyXFdfDY7HHUS33NE62CtoOh3m/HXRkcm5qdSEhY7usQgVO1G3d8nd6+I0ssGIQChJ61Ke4qFWeXsEtQGx/0tEmASuF1uPZCeqk/pNC7L41oh0YqbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TOi8KFGe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BmJIAvPf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TOi8KFGe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BmJIAvPf"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61FLoIOs2262627
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 10:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=FjF6r3afnuhXg0DwSK6GZ1us
	vzZbMW2fPMTY0Q9u+sM=; b=TOi8KFGei0IP9/N0La/GHhO4Yg2QMhsaHHJt+h3k
	BrKgTlt0oD9VrK3uj04vEFWtJHsDSZMX2zssLG5B5H8CmMcvHGb8wqenfo0av2Z4
	0WC+ddoFb0pTSecqvXlUOSIipNTQy7U1exZ3GOqLFEfDUzUvk9Ule8qRqy1DZrmG
	6Tsh+BSPjz1mJvP2bG1ELjCw9wGTP29L+HCDNpCReJi+y/HftRmmZJpXc5NuK6+V
	BbsecfIZmAxk8od4LqeLLUH2yfKG10aVjj0Fgbw0M/rbHxzAaSEEnZ2Ho0tTohHy
	Z/cMxBeYHgH7NGQH4OjaJ7wu4JqS37N6DRueH8WYYtPvqA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cahe64405-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 10:05:16 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb403842b6so1958450685a.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 02:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771236316; x=1771841116; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjF6r3afnuhXg0DwSK6GZ1usvzZbMW2fPMTY0Q9u+sM=;
        b=BmJIAvPf7F08eHcI8jArHiS1q7l/pzuVRctEdK0ysAhrp2tUK8y0RUdsQWG9U3OqsI
         IszTlSJB46hpenYP5vLrH1SCrRbKFQwzArsdFn5ZSvt9D9d3nNmgF0xut0IEJ91E/lVm
         nMXjupIUwgjpaWM1Cxm2+WfkaA4B9nO5B+S+IcpvPvwQZ6ENdqfwaw4Okqvyoq/PQUsb
         NA0y31Az7JzcfznhbCDLLSBSAc3wUZE6gPOUaq2WZt8Q26IfqTKl8AMdaNbit0AOq97v
         fb6R7avD+Nw5ieO/snUPOtTwz5E+93frVn8b+2TqJxoydo94GZxd/72Qk0ABGHA8fxgC
         jGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771236316; x=1771841116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjF6r3afnuhXg0DwSK6GZ1usvzZbMW2fPMTY0Q9u+sM=;
        b=qEHMHJMKy3g2FqQU6cTmAt7kvCOa8oGjZPB78ZhjTjQ46bVsOh1O5wWpj7pjdi3xiH
         H83UNkIoO+3xNbCgunh7vjL8TZwG7GK+ljm00c4jaJ0WfMXrgXG3TP9gUOK4mqIiaVhU
         pwcylmIzTQQhxZPjKtU4OQwGIYHnYAi5I23xWhuii73YcoEM2EfOPxLTgtO2n97xDv6Y
         waNyj7JtazCjlpO6qgsrRclVlxYtQuiWg1CQyxTV3+yRjBM43OugaY4pAnQOMhZ2fzRI
         Ol+pttmlVT5VGTl6r0Nm6S1MLlfHqp7ArPRwwlbIgGG1waZ6hUDqjkKw2D6TcunCgXIC
         fFNA==
X-Forwarded-Encrypted: i=1; AJvYcCVd60mtV3U4FN44j7Eojipqgs631Paee21xcMpikVlpGHlNa7+gY7wHyUp50PZl6ftIpHCRrOcJKrQXn4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/RwCMsWBLN8AV3A2gKGDW0p61upsw1pj3gnECBf/6szgIam92
	ghfaa/Wxav9BTEFvd55fItD0S/y/yfuUo8CUNCjdq8BWbhbocZi2oDcmCOBinz2A936UJBVFtRm
	/OiFQVjUIWaRUTY2a0FZZ9Pfznab6qxE0b6nHdmJc2ECQ1Uws9xobwOHjhUd51vT+TH4=
X-Gm-Gg: AZuq6aLogfQgB+5kJUfUc4ngO83az0p+1JARYKzi1fGX04muhXDL4srKO/V4S72KJkL
	DpHtG+85KB+yVPIlL21vjbWJkACFYe2qyHFEhzPbfDOidXgdwUZKkZLd4m9JuMiW+EN7Rig9m0H
	3i+K0L1LMyUaZYc/Rc7FolovuVG9pLZT2qm6BWJ3dO8VA1iO3ebqkaMWpyYttN4fBxocKKh/uz9
	AsfRLPm7N4dfr3ZlzASJEck/Rggbdif726E/wi9tUEyQR+cEGXPKn1qFUPnLj7L4Pqkh6c9BBno
	7FGfP51e88j/0cwDBTZ7zW7dfgGpK2Ej29Qut4EEXjE7zzaDsyuTKlghLTf4FJ9kRnURMs/w2q/
	NtmZnj2RvNlz/WA/1G+DxW1BXsRCsQH1Q2oJR
X-Received: by 2002:a05:620a:370f:b0:8c7:140a:7dbf with SMTP id af79cd13be357-8cb424ae497mr1084295485a.77.1771236316114;
        Mon, 16 Feb 2026 02:05:16 -0800 (PST)
X-Received: by 2002:a05:620a:370f:b0:8c7:140a:7dbf with SMTP id af79cd13be357-8cb424ae497mr1084291685a.77.1771236315339;
        Mon, 16 Feb 2026 02:05:15 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ad0166sm25953547f8f.35.2026.02.16.02.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 02:05:14 -0800 (PST)
Date: Mon, 16 Feb 2026 12:05:12 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Luca Weiss <luca.weiss@fairphone.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2 5/6] arm64: dts: qcom: milos: Add UFS nodes
Message-ID: <wtlu65ohpv2e23uozjq7b5jl7kzhyggpmji35enpahay3nlr2v@nuc7f4mt27oa>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-5-d3ce4f61f030@fairphone.com>
 <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
 <7zdyb2wnojudnrnomnx4aiwvni3e6i52kfioflb3gslztsizkw@ofvvkvrv5f3s>
 <lvaxthcmqvjit4hnofqikxog3vi557elctiqc3nj3ere7rs47v@xcnwzrzc6koy>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lvaxthcmqvjit4hnofqikxog3vi557elctiqc3nj3ere7rs47v@xcnwzrzc6koy>
X-Authority-Analysis: v=2.4 cv=c5WmgB9l c=1 sm=1 tr=0 ts=6992ebdc cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=6H0WHjuAAAAA:8 a=g50hcL_z2kQj7WSxxyAA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: ZsSaWxPwfBHTgIaULhUU2ZvKrb0KuB2T
X-Proofpoint-ORIG-GUID: ZsSaWxPwfBHTgIaULhUU2ZvKrb0KuB2T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDA4MyBTYWx0ZWRfX553ScgC1ibKB
 1is/0xrQvnZnp1jW/48wigtl2TKg2DI2E5x0nlzQETM0BGBO7kIjN0LDvGGT4bNUCZw+Tu6CY6R
 P2fkKAnZCkhUJW+B94D8xznV6Ij99O7mjUlCjA3khOvdQEAEOZtvnX00zFQn79rh+FSZ/h/LgVv
 22NFdvEyaqwfKuCdaoRVSaUkxSIMenTwwQ0scQlgtmjFFE1QJVfWxYkYOz+yPaCyjMiExLe8hhI
 /V7Hb5DWMUStXgSk80QMpJpw9d1anZGv0naQp28szQGpTC75Bbq41h/HiU13APQAA2/ksWo4FaU
 HE7nmJANpBzESgTqN6Oq7oOclhVI1Ewfp5OpEeNdNcBxxhVylE+vNo7tZbEXxdoa8VGzEC6uhUD
 TjYWG3VUtILibEmueLxvdXIihf/FxBEQSzC2oqbkDUHG4pPFrPu38ZcDrxz6X3RqgqJ27NqCnB0
 DZh77+Uu28f995exj/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_03,2026-02-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602160083

On 26-02-13 23:06:51, Dmitry Baryshkov wrote:
> On Tue, Jan 20, 2026 at 04:52:43PM +0200, Abel Vesa wrote:
> > On 26-01-20 16:49:26, Abel Vesa wrote:
> > > On 26-01-12 14:53:18, Luca Weiss wrote:
> > > > Add the nodes for the UFS PHY and UFS host controller, along with the
> > > > ICE used for UFS.
> > > > 
> > > > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > > > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > > > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > > > ---
> > > >  arch/arm64/boot/dts/qcom/milos.dtsi | 129 +++++++++++++++++++++++++++++++++++-
> > > >  1 file changed, 126 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
> > > > index e1a51d43943f..7c8a84bfaee1 100644
> > > > --- a/arch/arm64/boot/dts/qcom/milos.dtsi
> > > > +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
> > > > @@ -1151,6 +1151,129 @@ aggre2_noc: interconnect@1700000 {
> > > >  			qcom,bcm-voters = <&apps_bcm_voter>;
> > > >  		};
> > > >  
> > > > +		ufs_mem_phy: phy@1d80000 {
> > > > +			compatible = "qcom,milos-qmp-ufs-phy";
> > > > +			reg = <0x0 0x01d80000 0x0 0x2000>;
> > > > +
> > > > +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> > > > +				 <&tcsr TCSR_UFS_CLKREF_EN>;
> > > > +			clock-names = "ref",
> > > > +				      "ref_aux",
> > > > +				      "qref";
> > > > +
> > > > +			resets = <&ufs_mem_hc 0>;
> > > > +			reset-names = "ufsphy";
> > > > +
> > > > +			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
> > > > +
> > > > +			#clock-cells = <1>;
> > > > +			#phy-cells = <0>;
> > > > +
> > > > +			status = "disabled";
> > > > +		};
> > > > +
> > > > +		ufs_mem_hc: ufshc@1d84000 {
> > > > +			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> > > > +			reg = <0x0 0x01d84000 0x0 0x3000>;
> > > > +
> > > > +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
> > > > +
> > > > +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> > > > +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> > > > +				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
> > > 
> > > Maybe I'm looking at the wrong documentation, but it doesn't seem to exist
> > > such clock on Milos. It does exist on SM8650 though. So maybe the TCSR CC
> > > driver is not really that much compatible between these two platforms.
> > > 
> > > I take it that the UFS works. Maybe because the actual TCSR UFS clkref
> > > is left enabled at boot?
> > 
> > Oh, nevemind. I think I was looking at the wrong SoC.
> 

Sorry, my bad. Yes. There you go:

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
