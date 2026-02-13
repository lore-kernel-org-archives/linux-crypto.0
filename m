Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E298214813
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771016820; cv=none; b=XqlBLNFV1WjpuKwGw7EF73N2Kh1lU76SKU2gpNnZ5k9ojQ4RG6irFpKhEBGt7w6DFc7D2cZCiIbTNtTO4I95eZncVgoFnF8s9xFk3FAXRqxG5E05WqCDWVxMDZJizydt9pu8XlHK8wId1DkUU+Cjc1GG+8Bf+K2v9XVdvR75iFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771016820; c=relaxed/simple;
	bh=pvX0qD+BxhDp4RHo7v7HNqfm4Toxz64yP3LF77EctMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdC8zCtLAQ6Osmz+RERXaAAgxJQT2gaAAfsg/O5WnhClgqvF3fxKKJs8w+Bp47BJ3AqyVl8Gc3J0+22hCb5gi4zebpT0C4YsROuV0uNR0UY1mnimWnRzP8l+8d/BqSPEOrqBZTr/VqdJfwU2wy2wFQHjTy+3gN6Yfn34SlT0+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MR1/BEEE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QZgsFNg+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MR1/BEEE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QZgsFNg+"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61DK07s81282061
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 21:06:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=fxTjLbHnLmXQoT5fNrXa0GhY
	+U/uWzDJb1svuEha72Y=; b=MR1/BEEEP6HKSDcuLwr5vcavcwV1FEBEXY0E/xZ1
	oN5i5j5TWjpegJIiNkQZk1z1nYxUSHylnrr1in3vGw46B4/EHAEumuVP0iTpbM+F
	5Kankz5xHFY3nK0PFBNs1SttOXxmjgF9j7ogAVCjl2R4NbwaavEoW1WalREoJms6
	FM3y4ttkdRsejtWJYLYmQ7Wv2CEigQDn0B0XvkcHlOD7WdYTvMCfk+wyw3c1Mc4K
	GvC7+cP8QMRG4BgZgbRsy10cSM+huuD1QntvYk0f2EmORnAz0FfmOjU0MQVLfFJN
	t8cn5AqBoc7Z6JQDlmFSMMpapU6NWZllBHVRyiQEdGQfAg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4caakjg5ae-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 21:06:58 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c882774f0dso513711885a.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 13:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771016817; x=1771621617; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxTjLbHnLmXQoT5fNrXa0GhY+U/uWzDJb1svuEha72Y=;
        b=QZgsFNg+sjrbZYUf6wSl+ZiuxQIx6s+1ppq+gu1sy0hueER9EWn+c059676ff/sYyc
         YcrYuRdaRxBKgD8uKSjuMxgyZ7R/XSlAN1ZTXPUMkV8CpAr4CPJ15cAzgNJYEz/uByhG
         LVEq6duCqpeVcov+RGUwmPtQozOE5cabCbhH5jBO+YUCvc2jBVM+/995dNoA1474lLEh
         bD4EcXIWY+7Alc+Z2jBLZx04rXap3zGMs3IQUlcwe769jIjQDldWiCkf+tvrd77m1Qwl
         s9MNRMDb9lh36pE0RA9ES+gFJr7QCobfzqpCK1OskHEbJRKbue9wiPszyJ4unNHTUJJG
         qGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771016817; x=1771621617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxTjLbHnLmXQoT5fNrXa0GhY+U/uWzDJb1svuEha72Y=;
        b=o0f0wvEh5h0HvK9PrFocpVl47rVMxo3nyz0dRcqu/bVms1tWHlHly3noBH3/C3UuRx
         9IknBQ+q3wMgw9xOaQMMBll036hmmR+QHVmuq0P4iuDvHe9dCRsDg6PIxFhTmOx/+TQc
         VTFs6IY4SNtTbEWOxLBiFVdtzWh9TcOUVySPgXkDtSSdcT05rycueFXnwQshX8nXqDDZ
         Rw/+ZPhVJSeH87Bm1hIhXyjEt6ZiymXu2P1aGIeuJUxfiWhI9EHEfpUcICxNDJyG8ORK
         LL+xEmlEmj7akF9cBQ0mTbzF2XjNYrp+rd7Vo3NyXRvxa6GsZDvWWWC/frBKpG8sK8YB
         XmgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYzPmcXw5wv+bfg9i8cxmXdlipiUu6PLgbRWALz3qCCHPvpmq7IDN818IQZ9XEFhATYfPIw9CHxxDzd/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK4jl4aHJhX73QX5LLzPhxYDK46BUNyp59qNXTgZA7p1SJTgD5
	63EsXCcVOrj0vFb0QrnO6INPrEtQ7ZAmegCV++cY4QVP3zutR749BmZdEFKPnt7BTkevMzWfqhm
	SZXgB+7Z0+FFXPtPA34hYM1XShXh/TdpHvhfaTKzrmpiM7M7NyQQHluADegRaCq/2OWpApmlQ/D
	I=
X-Gm-Gg: AZuq6aJ0USPu/OpIDju4B14w6tpfCNDjSAn8MVFqUX3ChzI3QBLPl7J+QkrNrrY72u8
	+q1bRKTqsd5MlJqLhhmURUkeSjYQ7URMP7unn3EXb0hnD5ev2wqrmUX0blDuOb1v3hn0tzxQNpR
	3zzJqbKmzIu4C3qZAQtTISPmsalvOVADvRq301x75Nx8K/oQyyT1D9bdiZ+xEdr+lyFya6T9eDk
	6efcOjc7CtIEGGZfoRt/3t2ailocjBSKJUnam+UsZupBPaBtMwGo94riMJ94fHk/GdKdndOw5Ur
	E0MGu0SasbHjcwaIlApDyZsXKaoA4nQLGhFaAiaaChUm96RyBOBoukis0g+Elotz9RuWZpM7fnY
	pffH2cx4nHAa5ikkdB/9iySecdsePo989eTISiIQPfDBpzOnJZO6bzS7QHljk3SdT31iKaNvWrA
	ucyWtW7TMp8j7tWj5yRs8wgYcpcnuRhyPSDjE=
X-Received: by 2002:a05:620a:3941:b0:8c6:a26b:7e92 with SMTP id af79cd13be357-8cb4bf7ea70mr126050385a.15.1771016817299;
        Fri, 13 Feb 2026 13:06:57 -0800 (PST)
X-Received: by 2002:a05:620a:3941:b0:8c6:a26b:7e92 with SMTP id af79cd13be357-8cb4bf7ea70mr126047085a.15.1771016816688;
        Fri, 13 Feb 2026 13:06:56 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5b90adsm1772204e87.88.2026.02.13.13.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 13:06:54 -0800 (PST)
Date: Fri, 13 Feb 2026 23:06:51 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
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
Message-ID: <lvaxthcmqvjit4hnofqikxog3vi557elctiqc3nj3ere7rs47v@xcnwzrzc6koy>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-5-d3ce4f61f030@fairphone.com>
 <zvagnaxqgrpm6bagw6zuov4oi6o4b7vmy673oh5st22tec2swl@abvblxgray2s>
 <7zdyb2wnojudnrnomnx4aiwvni3e6i52kfioflb3gslztsizkw@ofvvkvrv5f3s>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7zdyb2wnojudnrnomnx4aiwvni3e6i52kfioflb3gslztsizkw@ofvvkvrv5f3s>
X-Authority-Analysis: v=2.4 cv=FvMIPmrq c=1 sm=1 tr=0 ts=698f9272 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=EUspDBNiAAAA:8
 a=6H0WHjuAAAAA:8 a=qLpTsGN6TSyvEDe6a9wA:9 a=CjuIK1q_8ugA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDE2MiBTYWx0ZWRfXwa5Wx9rYe1fC
 iPvqDT0KvxgXunZDb0LA6Ez1PLdng4LUR0wxf+5+TXhTwGUdDE1Gji96CSLYzozBpex9n2OzRiQ
 QGCI1cwELuR6TuFIEy+QrhNbsX1kdKQUlLuLRemdhkJVdOqkjRhirUxtTJIhLfw4a7VtQODiYGQ
 wLWucaH/e2RfK0Enhjk1hMvEQI+W3bWiQRyR90m8kN0ypXIiZaYYk7jRahT5dNY7W8TVp1FEo9h
 jMBa2sZ8+agY3xfLLenynPmCDU7LnVVO3GsMUxD24dCYzJHWDpOgAZHvWIyuoP6dXQDG1/er1jO
 eScY+bsH1Qc3xOSvzkKdqbNtpMswKf4zc0YW6VAd78UgRTE3nOVVOgjJAwz9/VrD6QhXNe6cYgr
 nazf4F7LwPh8XQ+hz6/iJuW2EoXc1eirnj0jWOO7oETWzAuYjDsd3LQrynTROmzJb137gCH17HY
 7ubroW2j5O0B9kzz+fg==
X-Proofpoint-ORIG-GUID: _VcmuI3Hcf_xEhogLJ144UP6rvuq1Xk3
X-Proofpoint-GUID: _VcmuI3Hcf_xEhogLJ144UP6rvuq1Xk3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_04,2026-02-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 clxscore=1015 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602130162

On Tue, Jan 20, 2026 at 04:52:43PM +0200, Abel Vesa wrote:
> On 26-01-20 16:49:26, Abel Vesa wrote:
> > On 26-01-12 14:53:18, Luca Weiss wrote:
> > > Add the nodes for the UFS PHY and UFS host controller, along with the
> > > ICE used for UFS.
> > > 
> > > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > > ---
> > >  arch/arm64/boot/dts/qcom/milos.dtsi | 129 +++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 126 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
> > > index e1a51d43943f..7c8a84bfaee1 100644
> > > --- a/arch/arm64/boot/dts/qcom/milos.dtsi
> > > +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
> > > @@ -1151,6 +1151,129 @@ aggre2_noc: interconnect@1700000 {
> > >  			qcom,bcm-voters = <&apps_bcm_voter>;
> > >  		};
> > >  
> > > +		ufs_mem_phy: phy@1d80000 {
> > > +			compatible = "qcom,milos-qmp-ufs-phy";
> > > +			reg = <0x0 0x01d80000 0x0 0x2000>;
> > > +
> > > +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> > > +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> > > +				 <&tcsr TCSR_UFS_CLKREF_EN>;
> > > +			clock-names = "ref",
> > > +				      "ref_aux",
> > > +				      "qref";
> > > +
> > > +			resets = <&ufs_mem_hc 0>;
> > > +			reset-names = "ufsphy";
> > > +
> > > +			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
> > > +
> > > +			#clock-cells = <1>;
> > > +			#phy-cells = <0>;
> > > +
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +		ufs_mem_hc: ufshc@1d84000 {
> > > +			compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> > > +			reg = <0x0 0x01d84000 0x0 0x3000>;
> > > +
> > > +			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
> > > +
> > > +			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
> > > +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> > > +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> > > +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> > > +				 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
> > 
> > Maybe I'm looking at the wrong documentation, but it doesn't seem to exist
> > such clock on Milos. It does exist on SM8650 though. So maybe the TCSR CC
> > driver is not really that much compatible between these two platforms.
> > 
> > I take it that the UFS works. Maybe because the actual TCSR UFS clkref
> > is left enabled at boot?
> 
> Oh, nevemind. I think I was looking at the wrong SoC.

Is that an r-b then? ;-)

-- 
With best wishes
Dmitry
