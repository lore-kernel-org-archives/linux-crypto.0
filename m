Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EF5343D7B
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 08:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207507; cv=none; b=L3H3XdkiLWEdcXPDB78RfDIf7hhTSs6DSaxoAjrItIhVNOowZ3XoCm3qgQ7JDrb/LUtkJBEBmyV8GhawhVmBlZAIwgVleuDz3G+YUYqFs3IPryFw2dvaiKDlircazZTLyqRv2p8KhAS6lylQudLnLCRBc2P8rvlu+PYV+7u8Z0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207507; c=relaxed/simple;
	bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Ic55ku4uI5ivBoensxw9yUJuUU6hJNoN6ZQWbIEa8Liajz+PqG+0N152rFTUuy510j05mYdwpF6vJah7OmoaJI1UNLBnAdkpJNaPAKFpAYks++kszjmqwVg2t5Nkr/W5PEb/U4rjZHkAI2Vk1uIeVa5VngN+CI0hnME+H1PNobg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=IVDV/ohy; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="IVDV/ohy"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so1291853966b.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 00:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768207502; x=1768812302; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
        b=IVDV/ohytU0ay9yHJck6OOYUe8a5wpddekOQJo+U5YWT2V7t/wB/w1wM+T359sNeAS
         /erSG0qpj9K6RgDKVMgo+wIkKDGzISr5/G5/A1XAIS0n5zVJNFSkEhdMlSm5jwr0G23T
         Z/3ndWqyQF3fF6xiTHEUIF9zY3+b8hCEWF2Z7FUzH4GE7XXao6fOeF5bfbW8f4rb2oNr
         9hfFfRB44rZHT7HPM9Kh+dbt6P2gRJh3Vta9wqwutcA+LKnkqhGClFiP0oK5Vo/st/WC
         S0qaDsP4HZja8WEof5/2gfZz3eR6KLMF+kNBsJts+8HlHPEA0rg+4ZiXwHqFbfu0hZCC
         S2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207502; x=1768812302;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
        b=acKDjf++m9yiC41eQbOfueeFPaXwR9X1BbyatGXlYfOT849zApgkcB3rW457PGMwFn
         /tEwn1OCmxfQbLw+jeuTP0J/Z9NIn34T+qP6c//wLXVDJU03hGRO0lRCWrYCPLOnA7Pu
         0qnZnwTfofK9x6LwW6iku3798DwipDWQMDijeBwidcFQ3oC0MuZZXxqTWIaEaISqM2l0
         N+RPmoC/A0wQjSwbMSqKNhrHeTScMA5Z2NYD5i+pz4Lvf3mt6QFFSX5pbSy5EW0p8XKx
         vIG37DbNqj0jDXyDDuPwA1/YIMIFDSjF02vcaPr+UoQiNoqL0C4exo7LvvJt0PwM04YC
         57LA==
X-Forwarded-Encrypted: i=1; AJvYcCVivaLZaNt3IWHqEuO/NiFkF51yBq0cilTNJgaDUkRuIG2No3FdVbbae8N8W/UIqmCt9JE+POBowAiJT+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMIpYcWOPiH2i9yMXmPIm/Uvc0q9thTGDnMCvlmf2QsiY+SgOk
	2nqOAqiWW7+IebQt631QTiZ5wJFlK3S/S/pvaMxpb2WVIf5/sGHT9a3GobA2zr0XpoU=
X-Gm-Gg: AY/fxX7gGxwMlcBjrLg5ug4umbM71sZsVVvbZa51QpLnppKSggQks3zgR4AoxsZpP0c
	/1eolnyOX/wTH5HEO3j3BEthn1nzMZjyYeHp2tATM4dp4qZyWmMIG+Dp90RN2r7jDrV5qL9fZUw
	vCvOSAvslHpbeezJZif4I++WmmiOWI04dktOSxKJd6e3P5bIcWCJDtf0tYOSmS+qPmLTKDWtyBU
	3TiJa6ob3NUZqh71A1rMADEXkV+H+Sy5sQl0TWJKv+7DAOou3h7bkhAMwTnXBIg89stLOgA5wub
	HdUk4S7JZwzTflkQ7b71vbaXlgjWF0Xj89Vyq8LMOGGUeNINXpG5etnZ9iLq1S84ewTH9sISunm
	/Y4AVTv5LbdbgNIeltT4jqqY7GPJzHmrqsrbpzRYeU5XneX1rGUWvcdKi85eijXbM48HU2esQoh
	31upnTJwTx57Bb64H6zgnlyTsIWvj0DGrE17gncy3Kc6j0zbZ6gU/jJgEX
X-Google-Smtp-Source: AGHT+IGkp8lDjqeILjtMZ5LR+GI7r23/qVs+xlIeG79Zdksfi1ggdUWAo2X+W6SgmX5SlFgujBUWTQ==
X-Received: by 2002:a17:907:1c25:b0:b7b:e754:b5ba with SMTP id a640c23a62f3a-b8445033422mr1833442366b.56.1768207502041;
        Mon, 12 Jan 2026 00:45:02 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a5187afsm1834263166b.58.2026.01.12.00.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:45:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Jan 2026 09:45:01 +0100
Message-Id: <DFMH8W40TCJ0.XCTHNRJFJE4T@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Neil Armstrong" <neil.armstrong@linaro.org>, "Luca Weiss"
 <luca.weiss@fairphone.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley"
 <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>,
 "Bart Van Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <2486dc4b-71f3-4cd9-8139-b397407d7e4d@linaro.org>
 <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>
In-Reply-To: <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>

Hi Neil,

On Mon Jan 12, 2026 at 9:26 AM CET, Neil Armstrong wrote:
> On 1/7/26 14:53, Neil Armstrong wrote:
>> Hi,
>>=20
>> On 1/7/26 09:05, Luca Weiss wrote:
>>> Add the nodes for the UFS PHY and UFS host controller, along with the
>>> ICE used for UFS.
>>>
>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>> ---
>>> =C2=A0 arch/arm64/boot/dts/qcom/milos.dtsi | 127 ++++++++++++++++++++++=
+++++++++++++-
>>> =C2=A0 1 file changed, 124 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/=
qcom/milos.dtsi
>>> index e1a51d43943f..0f69deabb60c 100644
>>> --- a/arch/arm64/boot/dts/qcom/milos.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
>>> @@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&sleep_clk>,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* pcie_0_pipe_clk */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* pcie_1_pipe_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_rx_symbol_0_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_rx_symbol_1_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_tx_symbol_0_clk */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 0>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 1>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 2>,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>; /* usb3_phy_wrapper_gcc_usb30_=
pipe_clk */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 #clock-cells =3D <1>;
>>> @@ -1151,6 +1151,127 @@ aggre2_noc: interconnect@1700000 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 qcom,bcm-voters =3D <&apps_bcm_voter>;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_mem_phy: phy@1d80000 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 com=
patible =3D "qcom,milos-qmp-ufs-phy";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg=
 =3D <0x0 0x01d80000 0x0 0x2000>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
cks =3D <&rpmhcc RPMH_CXO_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&tcsr TCSR_UFS_CLKREF_EN>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
ck-names =3D "ref",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "ref_aux",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "qref";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
ets =3D <&ufs_mem_hc 0>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
et-names =3D "ufsphy";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pow=
er-domains =3D <&gcc UFS_MEM_PHY_GDSC>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #cl=
ock-cells =3D <1>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #ph=
y-cells =3D <0>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sta=
tus =3D "disabled";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_mem_hc: ufshc@1d84000 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 com=
patible =3D "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg=
 =3D <0x0 0x01d84000 0x0 0x3000>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
errupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
cks =3D <&gcc GCC_UFS_PHY_AXI_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_AHB_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
ck-names =3D "core_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "bus_aggr_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "iface_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "core_clk_unipro"=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "ref_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tx_lane0_sync_cl=
k",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "rx_lane0_sync_cl=
k",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "rx_lane1_sync_cl=
k";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
ets =3D <&gcc GCC_UFS_PHY_BCR>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
et-names =3D "rst";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
erconnects =3D <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &mc_virt SLAVE_EBI1 QCO=
M_ICC_TAG_ALWAYS>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gem_noc MASTER_APPSS_PROC Q=
COM_ICC_TAG_ACTIVE_ONLY
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cnoc_cfg SLAVE_UFS_MEM=
_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
erconnect-names =3D "ufs-ddr",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 "cpu-ufs";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pow=
er-domains =3D <&gcc UFS_PHY_GDSC>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req=
uired-opps =3D <&rpmhpd_opp_nom>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ope=
rating-points-v2 =3D <&ufs_opp_table>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iom=
mus =3D <&apps_smmu 0x60 0>;
>>=20
>> dma-coherent ?


Given that downstream volcano.dtsi has dma-coherent in the ufshc@1d84000
node, looks like this is missing in my patch.

>>=20
>> and no MCQ support ?

Not sure, I could only find one reference to MCQ on createpoint for
milos, but given there's no mcq_sqd/mcq_vs reg defined downstream, and I
couldn't find anything for the same register values in the .FLAT file, I
don't think Milos has MCQ? Feel free to prove me wrong though.

>
> So, people just ignore my comment ?
>
> Milos is based on SM8550, so it should have dma-coherent, for the MCQ
> I hope they used the fixed added to the SM8650 UFS controller for MCQ.

Not sure what this should mean regarding MCQ...

Regards
Luca

>
> Neil
>
>>=20
>> <snip>
>>=20
>> Thanks,
>> Neil

