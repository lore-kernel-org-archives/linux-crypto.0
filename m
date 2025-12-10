Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD57260F
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331757; cv=none; b=Sc22KyBeMJlr5Y+UfdMfn0XMo+Sgd06PH5AwPdTI431ehn9IYFA+iAb1GYUlC1CkviQygqS6n+alohGlZ1rCW0xUhAzes0d+L63MnHmuCK+tm3zJXKKUK4rnqCstxm83jmBzZuoyj4pMsCiE8ktjzChTiunYomi5N50VcM1cKvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331757; c=relaxed/simple;
	bh=DKLuJf/JXfx0yQ4P8Pqgx98d6NTEQ2xj8uZxS47Qf88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YS9Bbd8v6iQ5sCrrg7rpDj1KeuuYvMQ0k9EqhFSnwWoCYHGAWZ7ZmOiemhDTs03eaQqXZ9OOr92MNtqJfhlfW8vBxaikfMtaYQQ9Lis5NBxoeBbLAa4czYeT7+t0+pT23oTQHwhXAadt5Yl5pJW8cigC+lfbXn+7ZnbOJVPeRPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jo40O+Zp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ETfZ9yPX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jo40O+Zp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ETfZ9yPX"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA0OTQs1722402
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=qAgt24CjLNqR+WvXK3Cl+58W
	cP9a5/vRqB+dhz4UKy4=; b=jo40O+ZpP1Pkrn5fAs9YrBw17xorA6CAwjXi5Omk
	vUEpsooiyknXzmZP+Cha5FQ62VA4z6sBJKISUdYHmr9nBL5yrGOtEZ9NFZ8Z7hSG
	i1ABh52icIy4JlPaNqwc+ATLc0Iv8VOWHczWfX1d97V9WWGVkzZ1rtqtdBNRtnzO
	jrhH4dqmqh4Pk9pmeN6EWGE5IsPQjr4xq+1CWpqcN4XiCjtygXybDOOCq3UIbMlC
	IzoDv5CmzyRka+ug9fktIR5f0/UsNt2ddLGP0Pejo4KohjDN3DFRPn6WpSlbW2f5
	XhSVnDbMtjodA/0njMo3eMJ1XjGprwRH1+ZVs6mG7NhWzg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4axqu59gyr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:55:53 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4edad69b4e8so7617751cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765331753; x=1765936553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qAgt24CjLNqR+WvXK3Cl+58WcP9a5/vRqB+dhz4UKy4=;
        b=ETfZ9yPXYw3dPyrcpl1sRKTSwwbzbMdInN1GTYQFJG3d42EB59JMfUuIjzJMvBGY65
         PEMe++vuWzIRifxyCHoH6mvowD07zvGL4wifBL+d9FvrH1PhbB+2e0EV5f0uhXuyKSGA
         XiCc5K9avQg4yXByddnqTpy5KXFskbZfQXkcM/NRle711ZiONx9+1yfB9SKtfOWSNRek
         YqgiF7CrqBlvAphqBzgAS/Gj/pep3o2f3BTKTr3so5VS6mPGVhEThKF7nwdSoIfxWtDs
         D6HiF6JOpM/P3gRRIEMni+FAUT16OJxAuEi4givZm49J3GJm9i/xl60Mzu7K+2Mk4mi0
         Zcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331753; x=1765936553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAgt24CjLNqR+WvXK3Cl+58WcP9a5/vRqB+dhz4UKy4=;
        b=BCd1+HZu7E3uHf811OHIqBHGdUDtDgQG6EwMD2f5Q70G2OTrMaenv93QBrP7yUQBF0
         fap6Uo3TzJOgjdFsIN5cUtKglmaJFcZ3IjWU3f/bSRFC56K7jVaAb017RDUsYQtm12eL
         sZjEsSa/3/0uOO9WaSC4n+d/p47Ktle0QcxnGzXTZ57PTNTeGGnneauLKu5V9Fdd2tUn
         ks3XswhCn/rU0ycl1NZUHpMBKJ3O4Lyg7v+UQ5Rw3sm6do52cvVpnYbRBgr11cmrRYc4
         o3wVGABcMV/7xO+7C4pvyRZGhfiziVD+FUoo/9Cvsx3LN1t23OFQhyItLfa7ohrckcFv
         0dmQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2wO98iw6nlZkeA9kV1Kt3U9gwpohUvbtylIDLvdve6slk9CyWXQXO9A+CFyIxo8SGi9LdJBvNsak0xiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDiOYdvr8g+x9eZCTWCuOAzQ/vEChmqwCwXo+DAm6jo0VQ1ctR
	3fUjZnj/iUSDhnkvssSM++mSkiyDzTGCCiewwrQd8ifyf8z1VBNEyO0RnNpkOR0sbpnebbdsNcq
	wsjjaAa1v59xWCwna+pJbozSeCwdg6+xUfPFHEY7UQvRSabnKxdfztJat3i8fkJEX51g=
X-Gm-Gg: ASbGncuqzjK+g2NkSKSzinqSlvu581Q6DWKleBflo9FHi03aBb1BwN4pIh8E77heMTM
	POVyevpfVTgfd14+jHi7bc30V0oqVxSSBPt9+cd09Ej2FOmsm9TAtKwVpN2St8vDRmM0T6zYcnK
	LNN84YuU1/wbEupgW80FKLXPt9mhA9OSDymhig3QT/b3RcW7DGfh+bxEvjZn0GECyc6YU5jokkV
	h6LvVfkZ4bKGIRb3Uty2NKV8lsA2AtgdUIz5FakpTpSMzQIcYOj54WaCW6Wzst6+C0B6NaQ/IsM
	qUBR1TXtz2l92e5rwgl5HyQ2ZMKQ1fcOcLJ9f72tuZxlN7liF4tUfkbouu+FfKd8o4KegrKe+Yy
	x2LXoO5SZchqtkU57jHGpeRfeVay3fqfoMFbb78wn/iUfV48QqkM9bruZ77nM2zdRvTlYVDlDeN
	9l39Meu3yXGIB4cR1/aatdsJ8=
X-Received: by 2002:a05:622a:241:b0:4ee:27a9:958d with SMTP id d75a77b69052e-4f1a9aefc6dmr52953451cf.16.1765331753016;
        Tue, 09 Dec 2025 17:55:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGK5XK3i3G3Us0uj0x5snz5jiGDnyHy4S/JJpNtTObFaEy+FoqP2sYHhTDnJM9LoVKGdlTvXA==
X-Received: by 2002:a05:622a:241:b0:4ee:27a9:958d with SMTP id d75a77b69052e-4f1a9aefc6dmr52953131cf.16.1765331752469;
        Tue, 09 Dec 2025 17:55:52 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7c1e2c2sm5815838e87.63.2025.12.09.17.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:55:51 -0800 (PST)
Date: Wed, 10 Dec 2025 03:55:50 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v4 5/9] arm64: dts: qcom: pm8550vs: Disable different
 PMIC SIDs by default
Message-ID: <jyyamotpswptzirtido6iufroxpdu3dyqkf4zs3hkfqj6mt6f2@sklyrpyahzjb>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-5-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210-sm7635-fp6-initial-v4-5-b05fddd8b45c@fairphone.com>
X-Proofpoint-GUID: Uu_n8BZ_ceZUz8-fhYSFatKHjEhLvIoa
X-Authority-Analysis: v=2.4 cv=Y7/1cxeN c=1 sm=1 tr=0 ts=6938d329 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=6H0WHjuAAAAA:8 a=BWpuR-d3BRky3lTXAc8A:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-ORIG-GUID: Uu_n8BZ_ceZUz8-fhYSFatKHjEhLvIoa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDAxNSBTYWx0ZWRfX3YTmmyZEUxO7
 FQM8iDVStqJYV+GU93Lze1ocJb+WSnguFvIHPne8Hy59Qyw0XjeHXp8tuvUOr7lG38oR4ROYNzp
 MoVK8Xh6k2hDJOTJZU+KDZMe9zehCfCaQaKzHgeXj+bzdJHi4WOx6NhWt8i/4Bh6C9T1/ldekwF
 r2e6ZWZYZjUnMrhixGGuHnRD/nXQabsGWLQpolJJmeB8I8tPdKnJcoRpXJqWPCZWCaWrUwC20YR
 WBqlgxlOF5FjuscITgGlv8vgX+hfCGq+lMQZ3YwV2jEINpZhjvmcO4elEG08cYUXwikGz6qecMR
 R17aQrG1MjCuWH9ZDK5KXR7XyYBTEb9c4q4loMKd+Qxo7Lq0BwSH+J1lBhh+dTmxG7ZrPRLfmm+
 YtSx0Vmp2t8PAJIyZU/noGt5dvV3OA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100015

On Wed, Dec 10, 2025 at 10:43:29AM +0900, Luca Weiss wrote:
> Keep the different PMIC definitions in pm8550vs.dtsi disabled by
> default, and only enable them in boards explicitly.
> 
> This allows to support boards better which only have pm8550vs_c, like
> the Milos/SM7635-based Fairphone (Gen. 6).
> 
> Note: I assume that at least some of these devices with PM8550VS also
> don't have _c, _d, _e and _g, but this patch is keeping the resulting
> devicetree the same as before this change, disabling them on boards that
> don't actually have those is out of scope for this patch.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/pm8550vs.dtsi                   |  8 ++++++++
>  arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi             | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8550-hdk.dts                  | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8550-mtp.dts                  | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8550-qrd.dts                  | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts          | 16 ++++++++++++++++
>  .../boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts     | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8650-hdk.dts                  | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8650-mtp.dts                  | 16 ++++++++++++++++
>  arch/arm64/boot/dts/qcom/sm8650-qrd.dts                  | 16 ++++++++++++++++
>  10 files changed, 152 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/pm8550vs.dtsi b/arch/arm64/boot/dts/qcom/pm8550vs.dtsi
> index 6426b431616b..7b5898c263ad 100644
> --- a/arch/arm64/boot/dts/qcom/pm8550vs.dtsi
> +++ b/arch/arm64/boot/dts/qcom/pm8550vs.dtsi
> @@ -98,6 +98,8 @@ pm8550vs_c: pmic@2 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		status = "disabled";
> +

Would it be better to split pm8550vs into 4 files rather than disabling
irrelevant bits?

>  		pm8550vs_c_temp_alarm: temp-alarm@a00 {
>  			compatible = "qcom,spmi-temp-alarm";
>  			reg = <0xa00>;
> @@ -122,6 +124,8 @@ pm8550vs_d: pmic@3 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		status = "disabled";
> +
>  		pm8550vs_d_temp_alarm: temp-alarm@a00 {
>  			compatible = "qcom,spmi-temp-alarm";
>  			reg = <0xa00>;
> @@ -146,6 +150,8 @@ pm8550vs_e: pmic@4 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		status = "disabled";
> +
>  		pm8550vs_e_temp_alarm: temp-alarm@a00 {
>  			compatible = "qcom,spmi-temp-alarm";
>  			reg = <0xa00>;
> @@ -170,6 +176,8 @@ pm8550vs_g: pmic@6 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		status = "disabled";
> +
>  		pm8550vs_g_temp_alarm: temp-alarm@a00 {
>  			compatible = "qcom,spmi-temp-alarm";
>  			reg = <0xa00>;
> diff --git a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
> index e6ac529e6b72..e6ebb643203b 100644
> --- a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
> +++ b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
> @@ -366,6 +366,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &sleep_clk {
>  	clock-frequency = <32764>;
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts b/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
> index 599850c48494..ee13e6136a82 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
> @@ -1107,6 +1107,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &pon_pwrkey {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
> index f430038bd402..94ed1c221856 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
> @@ -789,6 +789,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &qupv3_id_0 {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
> index 05c98fe2c25b..3fd261377a0c 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
> @@ -1003,6 +1003,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &pon_pwrkey {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts b/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
> index b4ef40ae2cd9..81c02ee27fe9 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
> @@ -533,6 +533,22 @@ volume_up_n: volume-up-n-state {
>  	};
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &pon_pwrkey {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
> index d90dc7b37c4a..0e6ed6fce614 100644
> --- a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
> @@ -661,6 +661,22 @@ focus_n: focus-n-state {
>  	};
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &pm8550vs_g_gpios {
>  	cam_pwr_a_cs: cam-pwr-a-cs-state {
>  		pins = "gpio4";
> diff --git a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
> index 5bf1af3308ce..eabc828c05b4 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
> @@ -1046,6 +1046,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &pon_pwrkey {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
> index c67bbace2743..bb688a5d21c2 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
> @@ -692,6 +692,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &qupv3_id_1 {
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
> index b2feac61a89f..809fd6080a99 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
> +++ b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
> @@ -1002,6 +1002,22 @@ &pm8550b_eusb2_repeater {
>  	vdd3-supply = <&vreg_l5b_3p1>;
>  };
>  
> +&pm8550vs_c {
> +	status = "okay";
> +};
> +
> +&pm8550vs_d {
> +	status = "okay";
> +};
> +
> +&pm8550vs_e {
> +	status = "okay";
> +};
> +
> +&pm8550vs_g {
> +	status = "okay";
> +};
> +
>  &qup_i2c3_data_clk {
>  	/* Use internal I2C pull-up */
>  	bias-pull-up = <2200>;
> 
> -- 
> 2.52.0
> 

-- 
With best wishes
Dmitry
