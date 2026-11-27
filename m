Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795821308;
	b=sPnGLlLXdTSAC3IEBnfARc9YDeXkHZd009K1SLc9NGXV2+CSg1gYPMladyo6bHpCJyW+
	 s6YPDIo1OJ4zS1xLRVqOA4HhSZuwHsNcT1HwCUBzFgVo2Eydl1sj2HDN562n8KZIlK1Ph
	 o3bPJauyl6pkrYfLFsqujfaNmHJiTo4AFvTNfeLSXvfEOEb/6D7UpFj0EGoxJ/erpQ6NR
	 NkBIfQgs4/xg9s2Rz7nOv7pjqFoqcAAMJtKmZ+kpIxrMmaehoW6T7UsxP1RuLUkS6nJtN
	 iv3ChcdldvcJEaU5ziAx5EIK4/H1zapYh4u8sXHbK0sjraNHDS+GlTBjO1bMF9ozeOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795821308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
	b=0zXaKWNDsnL6Fha/yWVioRrFSZw/HhqGXVG9gJFS3XQuZNDQ0By8KXP/sqZbP4t4R7Hi
	 4i4FA/60scviKpquq8vTTBWeqRcx66YxHqRI7kLGJlxLwZWj5fsEQ/oFA/kqhADEl0PYJ
	 GzwbmLET1RkpUaf0ZparEqbK47j+L7bPyZvLdkMxyQ6gCRP970XVO6r8ikAJPhXAjSDJW
	 oRDRXwa4lg7sloXXXE/zQXNR56fSxlwqRTxJp9F0SK4p4BJgDnjdFFHK+xzX3u59hrQTw
	 9G8Ak4hfS0T95ctmgt6Q0jSI3L0qljpAO1IZXbwP1F5iXgCAr6SIqnhtUj2a9vsUOhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WDrBk4z3;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6981C606A323
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 23:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6981C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WDrBk4z3
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso7591039f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 15:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795821306; x=1796426106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
        b=WDrBk4z39jTSJg7fP1LZv5pSAmcolbmVo4wwWMjjlFQboYBu3wN5rJ9GYnYJV50K3+
         tkw+jwH1lJXR7gVV/OBT9/yk7tTAiZrdu2ajb+eYT+UVhWfUsEfp6iR0FSExSHMDzvsZ
         3fpjMgMby8qPK4rdWEnPxtHr3jKM0uthso6MfAww0lrr5k/+C3OtKtXfdvcLi7gHPltW
         qCeMSaWpCWUuLbQVELMCkcXgultuZ6nRhj58FRGzZaFMWHaLx3Tjc30C/hZ5vAlCSiMn
         7dF5c687gdpqCnnInSFJs2GpiUdsUfdCYGv9dUppGS+08fFr1MS5RebwLf1K2w2KKf8y
         FyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795821306; x=1796426106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U1M+MDeqlkODjZ50qKjXMO75f40J30DxxF3l7NYSGEM=;
        b=DKgbXFVPUwRmOR3bN3hhGuxOel7B1OR35R9wNyLGbcT3Zt7pKHveaCJ7Md7trIrOh9
         /FOo3XwSk0DCZAG71xtPDUgwcSWc3O4wFuw+QY6mt08F+83Nj1m/AKlHUWoMR8tq/153
         5yfnuZrlhSwTPFlWuW9CAMrtlKVLRozFDBikPvxOskW1U1mk+YuT1DB/VYK+6UUmkH1M
         4rXMUuP23diZdDqe704H5FsJocNLdj6jAUJtpr/l5YqWd+UGqq1A0E+k4nHv753qQFkw
         nxEsX3DsyXqkktLDTS1MJ0iF3z6hR6og8jwGsRsUVvlzoqJSMMQbnbxGp21gam/IrCWY
         PbYA==
X-Forwarded-Encrypted: i=1; AL+hErFmc6inpnFdiqzfr+q92n7umpCxiz9MfHfTsA8mGM+xvKjhagDhbJhQHy6oQu1P081kmQVbWmxAR1Qe1hU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DeDYEIt16n6OWEf96ReU6BfpEYDfUZn8hdAC9tM4xiSvl7JJD
	6MGRxJ1v6htPUuhs9mX+59XQxT1dO+jFY3vIJSj/Elnr1QEfj9jwlQp7
X-Gm-Gg: AZFdTZdShDwjIlo5WAQF/Y2Dow88itukWCwg2yE9fT6iMPZDSMhXeMjb0GF4VRaoqAE
	+QqRGU6Vx5uPHLFbucY4bLctZdomf7Z1lYP40OJCTZGm0DKMH7ra6L1/JSs//jhYDhUn2yPcCU2
	mrCrZ7tSBU0FGA73lg5aHBuUUqxBVy6Tiy/8WZAwjvpHlKUAA7MYu9B4VBFHYleN6DSSwcAizBC
	fC+2sO1ydYvBZGkGcvRpVFj+PHY3EZ1MqWqd0wG3zD/5cR6+WKoEH/TyqlrEtX/y9ACfX+RuAea
	1VJtiFC7EVlEhLwRzFfwsqEfb5uLxJi9OJSCG8YpsUP2hmEaYAweOADrP2NdnUHmJ1LsLdy0SsA
	smlKdPol9bawdIElxczsRHZK9Af2WVjAXyUbniI5o3ftmj/bK6ekxndaJC8ldk6K9BLYS7O0FXW
	ROP19EeKdZUoIXpHCFTekx/VItPmpHpxZXk6gPtkrANAHAGZvOHpUg6I6ciH+E/7JQY+bKS3Zcu
	wt8hjF13XibPh+678sa2PYHlN9KCuVLeu4zcCeyiJkE8bt+AVI7psC6HjkZGhPZ9N5GW2jM9chZ
	9IhdMQa2QaNzTZeloTlMtLc1gAg=
X-Received: by 2002:a05:6000:178f:b0:4bb:c85e:d565 with SMTP id ffacd0b85a97d-4bbc86e17b5mr14733028f8f.55.1795821305534;
        Fri, 27 Nov 2026 15:15:05 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67fe48sm45269880f8f.23.2026.11.27.15.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 15:15:03 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 14/14] arm64: dts: qcom: Add Samsung Galaxy XR
Date: Fri, 27 Nov 2026 23:14:45 +0000
Message-ID: <20261127231445.3623202-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <87280d80-9047-405b-8dcc-11276d34d2dd@oss.qualcomm.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-14-5c8311c0b70b@gmail.com> <87280d80-9047-405b-8dcc-11276d34d2dd@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Nov 27, 2026 at 02:58:40PM +0100, Konrad Dybcio wrote:
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Thanks for the review.

I've implemented support for almost all of the hardware in my
local branch and I have found that the headset exists in multiple
revisions.

So, I'd like to make a split:

rename: halliday-samsung-xrvst2.dts -> halliday-samsung-xrvst2.dtsi
add: halliday-samsung-xrvst2-rev22.dts
add: halliday-samsung-xrvst2-rev25.dts

The .dts files will initially contain only compatibles.
The real differences between the revisions are the DMIC drive
strength, the display panels and their supply voltage, so the files
will be 'empty' until I send my sound and display series.

Is it OK if I send the split in a v4, or is it better
to do it in a follow-up?

Best regards,
Stanislav
