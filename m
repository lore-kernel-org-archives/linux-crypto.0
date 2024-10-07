Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7E1D90D3;
	Mon,  7 Oct 2024 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313371; cv=none; b=AM4j7JNMmshjeLWm5/kDP5hTKRdB3cgCM/w7BNNOiyqIAviuqHCnnZqUMKxjkyRlxawwO9dD4C1xl09euc7YPtw1j/JqfQrjkqhZipB9eE+Go0xiKjyMW1x7Bkj6fDJVq9dm3U07i23tDXJwKRbJHuJvg8PkCoEGTB8S+eh0OOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313371; c=relaxed/simple;
	bh=uUXzZRGTOsCHhO5wiewVtgT3oIHAUzqRQWNce2x5Cpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BaaQSjGps56HClecKyUJ5sBNJl/2QcIs3mtGLVMaDF04osprLl1nUcxu0uSabUHsYQZx6VXa5DgaZIl+dfI65vsEr/ITFmY0mRW8fhu/CsmYewHo8HOnz8Pxv4SzFued2kLs7lmcPnCvCrgkV5mtyo+0FDhIMGTqXtw6b/+U7Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=uCi0A54U; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="uCi0A54U"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497EXR3A003950;
	Mon, 7 Oct 2024 17:02:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	I0LlClbgeKDBHJrm3HldlhZvNAnt4HDdPl4EU0YX6zc=; b=uCi0A54UigacpP8b
	EWJWXMHODBTuB+ieZqoxhr5y4mYPP9P8RaGlrlT6uewrOgZMWDyNnrF6Ml68lq9Y
	F6D9OKv9+DkL+4sABpBOGe/udyd5SZxAjKFkWBt3IO82+5c2HdtsF68EYot6ffR0
	+aSzGJm71CWso9RHA16ciar0EGpZTAurmqVJWjBRUuF71Y5KO4AU/xMJwVBf0ddJ
	uRd2YM0b99Ne1/FVsDxvMuwvz6d2DiAiP2f+YwGUA6gz2lKfk2AXYC0T88KpDnKb
	S1c5ulM1dew4y608JrP2jSbVOi+HUFEZn/Rl0D61p8a/UknMp+AgpE4iJ/cjGgDc
	iPpSng==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 423f10ptcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 17:02:22 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id C2F7C40046;
	Mon,  7 Oct 2024 17:00:52 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 149DD226FAB;
	Mon,  7 Oct 2024 16:59:55 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 16:59:54 +0200
Message-ID: <d4bfc454-5a20-4cee-85f6-118323c46eca@foss.st.com>
Date: Mon, 7 Oct 2024 16:59:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] arm64: dts: st: add RNG node on stm32mp251
To: Marek Vasut <marex@denx.de>, Olivia Mackall <olivia@selenic.com>,
        Herbert
 Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>
CC: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lionel
 Debieve <lionel.debieve@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-5-gatien.chevallier@foss.st.com>
 <869fe073-c20f-4611-ae84-8268a890a12c@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <869fe073-c20f-4611-ae84-8268a890a12c@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/7/24 15:55, Marek Vasut wrote:
> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>> Update the device-tree stm32mp251.dtsi by adding the Random Number
>> Generator(RNG) node.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> ---
>>   arch/arm64/boot/dts/st/stm32mp251.dtsi | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi 
>> b/arch/arm64/boot/dts/st/stm32mp251.dtsi
>> index 1167cf63d7e8..40b96353a803 100644
>> --- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
>> +++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
>> @@ -493,6 +493,16 @@ uart8: serial@40380000 {
>>                   status = "disabled";
>>               };
>> +            rng: rng@42020000 {
>> +                compatible = "st,stm32mp25-rng";
>> +                reg = <0x42020000 0x400>;
>> +                clocks = <&clk_rcbsec>, <&rcc CK_BUS_RNG>;
>> +                clock-names = "rng_clk", "rng_hclk";
>> +                resets = <&rcc RNG_R>;
>> +                access-controllers = <&rifsc 92>;
> It would be good if someone finally sorted the access-controllers 
> property in all the MP2 nodes alphabetically ; that's separate 
> patch/series though.

I'll pin your comment to take a look into that in the near future.

Gatien
