Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2934479DA
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 05:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765343423; cv=none; b=pIN9oYAWVdy9MZEVBN2KCRdwPyORepxxLcxQmYFyaVePcig9gM2I0uV3PKX/PDd23r9ksxcCbc0VYS3jO4V4ObRzncYfUxDjYBQp1SFZlPu512auVoU1ohBeIK92w1zoxhLvKtoheLB0OuS/3MMQ69ctxa/IstvrNHVZXrMoTYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765343423; c=relaxed/simple;
	bh=bTa6N8dDPhiUcCHPgHGvCiaKmQpQ67AqcDF4d+4yiiA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=pXdizXjXRBkWmZU+auShF3+DWCpeSaD9BN+ObGPpCQ/C0aB+m8EA/GySd1aozor00YCWHU04eZQ+enPf9lGa9dY0gwb+d3d1hIzN9JFIKQRp2scQ5WSWb1KmuH0TjDoTKnx3qHDQPQ+Jy7+9gJ6EuddjU4C0AHOZ3QL9pG3ebqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=US9eSX2G; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="US9eSX2G"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47796a837c7so57218955e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 21:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765343418; x=1765948218; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XEAFrvxTFkX/hsHogJSu8gbmrA35vtUoTfUZCahOAo=;
        b=US9eSX2Gux3qtYiKAzrV/ClG5/x5hWpJRhW54VTuMWaZmR5+UIMXNvR2hWC+eD9+nH
         ECp7MbUqGxucNT3BGJE/KUnIviyMgu9g772ZvxwGB5URNtN/g7TbUZHOPIAR/b0ybtLm
         mvQjfP4GA2D/E8JTZL/f2VNgITeFuGlE1DWTAUfBDaMg8NTRSHCxluZQKz9pR+9Q5l3R
         hJ0mpHopyaPdOpjtz8Tsd0G5XGJWR7x7BmuQRziXEbPnjZBSCCb2h+Jk04raAcScgBKQ
         F02EreWWmfqhYs/8fJkw4Jx2NMig+1BqnlaJVEGUuE/Etq0bbjtOBxik/Dn6o+abZN4j
         0jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765343418; x=1765948218;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7XEAFrvxTFkX/hsHogJSu8gbmrA35vtUoTfUZCahOAo=;
        b=T6kyYda8OOW3/2Unq7cp5PG23VOwAsU6I5yOJRJNyLYpBnSSrpIhkUaoQgK8vGoEF4
         sUPGqPD1wcBu+ba+Dtw1BdfBy97NPLLzStZh6Q8uqlYf1rGZIGGu/Kc34xuiuiSuaiCM
         DXFRqNLe3m4k+x1D8nbKI0siwlCqgJ9O3f/ZQL4EqNgPGtO16xtMEM8Ha4reXM6Asa2l
         hM7ES6GmRcMe4szPv0hvle2DZDupLi+zHyZTO0g/WSWNODbLND99tZbNwsY6bnb2DtLU
         /XqVrnoN9bpFw5KIEM3twRxaxSecLyfgNFna3xgolyzAIUwLiX1JMTH7BlKtTzaJJm4K
         HbCw==
X-Forwarded-Encrypted: i=1; AJvYcCWxhCPb6DAgiHCBCNXN2clSatdCs7MV1B/H2hx+VFlOd+0rVmjzA7ulMQTIz6FvTFkwARV2s6uGZxVSb0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIMq42HUdR9V0n/xYjfKCv6L5b5+pgUv5/o7EcR+35ZzJLD0Tj
	eR+Rtv6ZOWwXhpNVd61h2y1XYIxpSKtVc29e/6Gso6yjVm11eL03bIWLcjf7pDp4OBc=
X-Gm-Gg: ASbGncsbUgRdB57KUNBEEfiskp2S0XShg1WY82yq3L3/2lGcT23ZSvDy+Xlpi1UUJgN
	SjMI13QtdgV7Xd02DjwM2Ch3qWewQOStKETwGVGo82ZDNOIoAvOgLS7VoUqtEDibWxRLJcuVdMD
	JuoJy1cl79QxAYTIi32VcT94yEN3kkvaieQnskxEOP2KCedI2gADDSerdZLs1iVcVIU+Ke235+U
	6wan72MnvL7S9IDS4Rh/dT16QAjNfQ5m3dj+QLOa2IdmJNemkgUVWfIB/2QCV1u6QtN5vCNMevJ
	wtaW8+tPFuahztIenoTDpooAmySR3qTADPZp7/nEJChu7LUdCVHUDrS5u1PHx58+twCplkfU+iW
	lDIpnorX6dQ+VNmk/yxWaVFfVo1cbYPj5i32HwGRpEG0hzC4hBrW8Eh9he1CUyCr6/APwIb3XzC
	7teF8en/MeEN36978O0NX+WI8VIPObU0gOFOCdnnr/T71iEfvIhyPNZ+wJ
X-Google-Smtp-Source: AGHT+IFStEHj4aPWOmBIPigikYjX84huKXBNQQdaiQ5/PB/m10ZW9YmQM7+d11ZDgrKcwq+XC/p6Dg==
X-Received: by 2002:a05:600c:a48:b0:477:9c73:2680 with SMTP id 5b1f17b1804b1-47a838064fbmr7353855e9.23.1765343418405;
        Tue, 09 Dec 2025 21:10:18 -0800 (PST)
Received: from localhost (fs96f9c361.tkyc007.ap.nuro.jp. [150.249.195.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e2a0dd6c28sm17688049b3a.30.2025.12.09.21.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 21:10:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Dec 2025 14:10:10 +0900
Message-Id: <DEUA0F5Q4TJH.2A7A0WJE6UH6Y@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Viresh Kumar"
 <viresh.kumar@linaro.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Manivannan Sadhasivam" <mani@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Vinod Koul" <vkoul@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
 "Bjorn Andersson" <andersson@kernel.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
 <phone-devel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>, "Konrad
 Dybcio" <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v4 5/9] arm64: dts: qcom: pm8550vs: Disable different
 PMIC SIDs by default
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Dmitry Baryshkov" <dmitry.baryshkov@oss.qualcomm.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-5-b05fddd8b45c@fairphone.com>
 <jyyamotpswptzirtido6iufroxpdu3dyqkf4zs3hkfqj6mt6f2@sklyrpyahzjb>
In-Reply-To: <jyyamotpswptzirtido6iufroxpdu3dyqkf4zs3hkfqj6mt6f2@sklyrpyahzjb>

On Wed Dec 10, 2025 at 10:55 AM JST, Dmitry Baryshkov wrote:
> On Wed, Dec 10, 2025 at 10:43:29AM +0900, Luca Weiss wrote:
>> Keep the different PMIC definitions in pm8550vs.dtsi disabled by
>> default, and only enable them in boards explicitly.
>>=20
>> This allows to support boards better which only have pm8550vs_c, like
>> the Milos/SM7635-based Fairphone (Gen. 6).
>>=20
>> Note: I assume that at least some of these devices with PM8550VS also
>> don't have _c, _d, _e and _g, but this patch is keeping the resulting
>> devicetree the same as before this change, disabling them on boards that
>> don't actually have those is out of scope for this patch.
>>=20
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>> ---
>>  arch/arm64/boot/dts/qcom/pm8550vs.dtsi                   |  8 ++++++++
>>  arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi             | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8550-hdk.dts                  | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8550-mtp.dts                  | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8550-qrd.dts                  | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts          | 16 +++++++++=
+++++++
>>  .../boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts     | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8650-hdk.dts                  | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8650-mtp.dts                  | 16 +++++++++=
+++++++
>>  arch/arm64/boot/dts/qcom/sm8650-qrd.dts                  | 16 +++++++++=
+++++++
>>  10 files changed, 152 insertions(+)
>>=20
>> diff --git a/arch/arm64/boot/dts/qcom/pm8550vs.dtsi b/arch/arm64/boot/dt=
s/qcom/pm8550vs.dtsi
>> index 6426b431616b..7b5898c263ad 100644
>> --- a/arch/arm64/boot/dts/qcom/pm8550vs.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/pm8550vs.dtsi
>> @@ -98,6 +98,8 @@ pm8550vs_c: pmic@2 {
>>  		#address-cells =3D <1>;
>>  		#size-cells =3D <0>;
>> =20
>> +		status =3D "disabled";
>> +
>
> Would it be better to split pm8550vs into 4 files rather than disabling
> irrelevant bits?

Maybe, but imo that's a different discussion, here I'm just making sure
I don't need three status =3D "disabled" properties in my milos-fp6 dts.

Regards
Luca

>
>>  		pm8550vs_c_temp_alarm: temp-alarm@a00 {
>>  			compatible =3D "qcom,spmi-temp-alarm";
>>  			reg =3D <0xa00>;
>> @@ -122,6 +124,8 @@ pm8550vs_d: pmic@3 {
>>  		#address-cells =3D <1>;
>>  		#size-cells =3D <0>;
>> =20
>> +		status =3D "disabled";
>> +
>>  		pm8550vs_d_temp_alarm: temp-alarm@a00 {
>>  			compatible =3D "qcom,spmi-temp-alarm";
>>  			reg =3D <0xa00>;
>> @@ -146,6 +150,8 @@ pm8550vs_e: pmic@4 {
>>  		#address-cells =3D <1>;
>>  		#size-cells =3D <0>;
>> =20
>> +		status =3D "disabled";
>> +
>>  		pm8550vs_e_temp_alarm: temp-alarm@a00 {
>>  			compatible =3D "qcom,spmi-temp-alarm";
>>  			reg =3D <0xa00>;
>> @@ -170,6 +176,8 @@ pm8550vs_g: pmic@6 {
>>  		#address-cells =3D <1>;
>>  		#size-cells =3D <0>;
>> =20
>> +		status =3D "disabled";
>> +
>>  		pm8550vs_g_temp_alarm: temp-alarm@a00 {
>>  			compatible =3D "qcom,spmi-temp-alarm";
>>  			reg =3D <0xa00>;
>> diff --git a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi b/arch/arm64/b=
oot/dts/qcom/qcs8550-aim300.dtsi
>> index e6ac529e6b72..e6ebb643203b 100644
>> --- a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
>> @@ -366,6 +366,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &sleep_clk {
>>  	clock-frequency =3D <32764>;
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts b/arch/arm64/boot/d=
ts/qcom/sm8550-hdk.dts
>> index 599850c48494..ee13e6136a82 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
>> @@ -1107,6 +1107,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &pon_pwrkey {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/d=
ts/qcom/sm8550-mtp.dts
>> index f430038bd402..94ed1c221856 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
>> @@ -789,6 +789,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &qupv3_id_0 {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts b/arch/arm64/boot/d=
ts/qcom/sm8550-qrd.dts
>> index 05c98fe2c25b..3fd261377a0c 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
>> @@ -1003,6 +1003,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &pon_pwrkey {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts b/arch/arm6=
4/boot/dts/qcom/sm8550-samsung-q5q.dts
>> index b4ef40ae2cd9..81c02ee27fe9 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
>> @@ -533,6 +533,22 @@ volume_up_n: volume-up-n-state {
>>  	};
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &pon_pwrkey {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts=
 b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
>> index d90dc7b37c4a..0e6ed6fce614 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
>> @@ -661,6 +661,22 @@ focus_n: focus-n-state {
>>  	};
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &pm8550vs_g_gpios {
>>  	cam_pwr_a_cs: cam-pwr-a-cs-state {
>>  		pins =3D "gpio4";
>> diff --git a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts b/arch/arm64/boot/d=
ts/qcom/sm8650-hdk.dts
>> index 5bf1af3308ce..eabc828c05b4 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
>> @@ -1046,6 +1046,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &pon_pwrkey {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts b/arch/arm64/boot/d=
ts/qcom/sm8650-mtp.dts
>> index c67bbace2743..bb688a5d21c2 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
>> @@ -692,6 +692,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &qupv3_id_1 {
>>  	status =3D "okay";
>>  };
>> diff --git a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts b/arch/arm64/boot/d=
ts/qcom/sm8650-qrd.dts
>> index b2feac61a89f..809fd6080a99 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
>> +++ b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
>> @@ -1002,6 +1002,22 @@ &pm8550b_eusb2_repeater {
>>  	vdd3-supply =3D <&vreg_l5b_3p1>;
>>  };
>> =20
>> +&pm8550vs_c {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_d {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_e {
>> +	status =3D "okay";
>> +};
>> +
>> +&pm8550vs_g {
>> +	status =3D "okay";
>> +};
>> +
>>  &qup_i2c3_data_clk {
>>  	/* Use internal I2C pull-up */
>>  	bias-pull-up =3D <2200>;
>>=20
>> --=20
>> 2.52.0
>>=20

