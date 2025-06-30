Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAF234CF5
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751278902; cv=none; b=lGht0uFFo0zDmSzIcNciJBqD/hXAxiSeMM7V9GkUn7HXSsEKcIHPGuv9H/ppf2LUez/i/eW1K+IW7ojLmYF51Zj1E5QcMM639ZynHvvnEza1P0fu9d1x1sj9fk3P2fcNSoJkMA6G5kEq5lYiE+7Ei50tfp19PkrQAOBB3+4VGVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751278902; c=relaxed/simple;
	bh=6BYE8AWJQLw8WAxO3Q5aBUTeX661u26mmGmL2fLnCZI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ZMWte7gXrGUqnavwgketK7hnIDbExh7q2oki11a66LE2f4YHBKu7r6zsvOtsSr7qa+q8pwN9/G47kSDHNun7FRn/BLvFh4O9OMkUM4vTKnj6oqc9WoJAu6fhK348Zy/savK5e+cz1NnnMcAB0RIFBNeAVlnbXegcAUBW7TruN40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=IrZueZJ4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="IrZueZJ4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae36e88a5daso373058066b.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 03:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1751278898; x=1751883698; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91/ZncbDlmcGCt22EAMRhuZKL6uaG/hY8UyZ2Q+pYCo=;
        b=IrZueZJ4qgDMos5cOw6vsmAKPNI7cL5oHlBxR9UC1YhL+Gik/jTsoOe6XDscbMCl/D
         m0b1kr5wj7n3L0V7y6Gu2taGzuNze2Trz/4F1hoehV3UkaCRyOYZv4FTAZrixGoXDCAL
         Ra1lqJVB3V41Bag3if4dM7UPHCeXCsx+seRMCn4xlr5ZNTzn5tZzCD1+ZJgfiE58pMj4
         k6y6iBv4TNPQowcdRpGeLnYeAWQjQ2JzHgL8eT1PYbAbBm4rGdx1FUt/OygzgsenUAeb
         75KzQYafl73kX3Oa9A+8PbNa0dpos0iA2Aa65Cxrg2FkYdFlf78aMhT5bCYVDMC6TetI
         mL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751278898; x=1751883698;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=91/ZncbDlmcGCt22EAMRhuZKL6uaG/hY8UyZ2Q+pYCo=;
        b=l+r1TMnIgKfgVJDFRigI7vIfn2W0HWekkpVNFuLdjr2aoOEw6NcyF2X2Vx5Qjv87ra
         HlbL6BE+4GTnNRpsKucB4ld1lO2EPkr4jblk8JW9R5eZP+riM0pUX952yw3A+wR9W8TE
         /BtfWy43ZlKpA0gvDYmzJ0/3WENfbRaYR1kPyVFjRZIv7zLOK2e84ZiXF+im0+xhIEjt
         KxaeUOtDcpF8seeLN4FSsDD/5Rzbx6McBW8+kuOWh6eMGGIt3GV9lAqnjzaeTI4+x5up
         xfMYjQ+cyJCNu2mQtKNFlIZ62A7bp5docs2+G9ivwOo0gbfY+vDui4+tu4s5HBuzwfND
         RcMg==
X-Forwarded-Encrypted: i=1; AJvYcCUMwTIL3NaVeGVlfh8H1k5QGIEqtSMdmd2BwJHLdS1HN7pduL8tG8rbj4MnE7Y6dQvJHS8eC+eDkSl1UwU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7dft3TuE19M1zZ+8QTNZlpEcMNYQrNpUmYA9uix7qfd62jVtf
	B2qzWNHc0OaVpZV4/qYblR4yNC37loEEwou74dnhlIWn8Vq7JbLxi/enIpHwOoWGA68=
X-Gm-Gg: ASbGncvi1suh8Icc2jb6JbZSlO2kGufw1Nn/liicQyi/cT0K5Ng+eXy5iowIr5i5hWU
	7oezPXUbvWPj9sAbFdxfqD4wAWswRGnuKZ/iPAVFv+DmF9x24rjfVaserj4xrcYX6xprXI8zaYd
	ZeDO4Xcg4QFAX0NF/DMOSCKWGu4nFy25rvabEDTRVrOLxogZxt4gum1NBTBnqUFpVktFs/xZxne
	hN3bMPUej1w+DWhr3EkrCkVmAWNrjqc9anvo9PTesPkgp03ACajiZsq0fguuL4MIzMdNy/CWbWf
	IWDgPMb7AR1MMNIfbEH0D0trgx7S0Kk/LiQ6W6YQ5N53h7BAkENC7b1PJ4zfKMPrDr7SkG2tXc4
	yv/xp3BkJ6N6jINaGSBIYN2ByFUsjaZj3aSfgXdR3zywQL7K4aDeiKatbPxMttINlrIvfYBU=
X-Google-Smtp-Source: AGHT+IG0udIx5/vSjab4jTXQgQOixHxgW8J50sJp+ilVqsU6WQ7uEmPrf6nFFV5tvDzy3dhkra701g==
X-Received: by 2002:a17:907:9691:b0:ae0:c6fb:2140 with SMTP id a640c23a62f3a-ae3500f374emr1085087666b.32.1751278898278;
        Mon, 30 Jun 2025 03:21:38 -0700 (PDT)
Received: from localhost (2001-1c00-3b8a-ea00-c4de-d39d-05f4-c77a.cable.dynamic.v6.ziggo.nl. [2001:1c00:3b8a:ea00:c4de:d39d:5f4:c77a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae35365a95esm649858666b.59.2025.06.30.03.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 03:21:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Jun 2025 12:21:36 +0200
Message-Id: <DAZSK2NT6TAT.1N6A4I8ETH92W@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <dmaengine@vger.kernel.org>,
 <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 14/14] arm64: dts: qcom: Add The Fairphone (Gen. 6)
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Konrad Dybcio" <konrad.dybcio@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Joerg Roedel"
 <joro@8bytes.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Manivannan Sadhasivam" <mani@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Vinod Koul" <vkoul@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>, "Robert Marko"
 <robimarko@gmail.com>, "Das Srinagesh" <quic_gurus@quicinc.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, "Jassi Brar" <jassisinghbrar@gmail.com>,
 "Amit Kucheria" <amitk@kernel.org>, "Thara Gopinath"
 <thara.gopinath@gmail.com>, "Daniel Lezcano" <daniel.lezcano@linaro.org>,
 "Zhang Rui" <rui.zhang@intel.com>, "Lukasz Luba" <lukasz.luba@arm.com>,
 "Ulf Hansson" <ulf.hansson@linaro.org>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
 <20250625-sm7635-fp6-initial-v1-14-d9cd322eac1b@fairphone.com>
 <4200b3b8-5669-4d5a-a509-d23f921b0449@oss.qualcomm.com>
 <DAXA7TKVM4GI.J6C7M3D1J1XF@fairphone.com>
 <6d4e77b3-0f92-44dd-b9b0-3129a5f3785b@oss.qualcomm.com>
 <DAXEA131KUXZ.WTO7PST1F3X6@fairphone.com>
 <3fbae47b-d20d-426b-a967-b584e32b8c6e@oss.qualcomm.com>
In-Reply-To: <3fbae47b-d20d-426b-a967-b584e32b8c6e@oss.qualcomm.com>

On Fri Jun 27, 2025 at 5:34 PM CEST, Konrad Dybcio wrote:
> On 6/27/25 4:44 PM, Luca Weiss wrote:
>> On Fri Jun 27, 2025 at 4:34 PM CEST, Konrad Dybcio wrote:
>>> On 6/27/25 1:33 PM, Luca Weiss wrote:
>>>> On Wed Jun 25, 2025 at 4:38 PM CEST, Konrad Dybcio wrote:
>>>>> On 6/25/25 11:23 AM, Luca Weiss wrote:
>>>>>> Add a devicetree for The Fairphone (Gen. 6) smartphone, which is bas=
ed
>>>>>> on the SM7635 SoC.
>>>>>
>>>>> [...]
>>>>>
>>>>>> +&pm8550vs_d {
>>>>>> +	status =3D "disabled";
>>>>>> +};
>>>>>> +
>>>>>> +&pm8550vs_e {
>>>>>> +	status =3D "disabled";
>>>>>> +};
>>>>>> +
>>>>>> +&pm8550vs_g {
>>>>>> +	status =3D "disabled";
>>>>>> +};
>>>>>
>>>>> Hm... perhaps we should disable these by deafult
>>>>
>>>> Do you want me to do this in this patchset, or we clean this up later =
at
>>>> some point? I'd prefer not adding even more dependencies to my patch
>>>> collection right now.
>>>
>>> I can totally hear that..
>>>
>>> Let's include it in this patchset, right before SoC addition
>>> I don't think there's any pm8550vs users trying to get merged in
>>> parallel so it should be OK
>>=20
>> Okay, can do. Disable all of them (_c, _d, _e, _g), and re-enable them
>> in current users? I assume there might also be boards that only have
>> e.g. _d and no _c.
>
> I suppose it's only fair to do so, in line with
>
> d37e2646c8a5 ("arm64: dts: qcom: x1e80100-pmics: Enable all SMB2360 separ=
ately")

Sounds good, I've prepared this change for v2.

>
>
>>>>>> +&usb_1 {
>>>>>> +	dr_mode =3D "otg";
>>>>>> +
>>>>>> +	/* USB 2.0 only */
>>>>>
>>>>> Because there's no usb3phy description yet, or due to hw design?
>>>>
>>>> HW design. Funnily enough with clk_ignore_unused this property is not
>>>> needed, and USB(2.0) works fine then. Just when (I assume) the USB3
>>>> clock is turned off which the bootloader has enabled, USB stops workin=
g.
>>>
>>> The USB controller has two possible clock sources: the PIPE_CLK that
>>> the QMPPHY outputs, or the UTMI clock (qcom,select-utmi-as-pipe-clk).
>>=20
>> So okay like this for you, for a USB2.0-only HW?
>
> Yeah, maybe change the comment to something like:
>
> /* USB 2.0 only (RX/TX lanes physically not routed) */
>
> to avoid getting this question asked again

Ack

/* USB 2.0 only, HW does not support USB 3.x */

Regards
Luca

>
>>> Because you said there's no USB3, I'm assuming DP-over-Type-C won't
>>> be a thing either? :(
>>=20
>> Yep. I'd have preferred USB3+DP as well since it's actually quite cool
>> to have with proper Linux. On Android, at least on older versions it's
>> barely usable imo. Can't even properly watch videos on the big screen
>> with that SW stack.
>
> Bummer! Not something we can change though :(
>
> Konrad

