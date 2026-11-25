Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795579772;
	b=vfbdpfBKRKEieVD1wf2iUTgMdexbqUS0JeNtaUibXSpWxZBO/hMcOAwAWKjbKPROnwiL
	 BndJdIxg5HTeZyXNQJNDik51uHEAJlM+abY8IUF2txxal/6Pdo83eoQDL9F0UlzHUA7kg
	 +KS5VNanNgKjrbxLWWEBRiOcoRQSYAq63Ovi6z5XBMFpez2B69UvFGw6AgXQgNS6HFLCR
	 E3z9wmRuoV56OqC8D7F6yMz3Eta8tWNlk0zu2q4uB5Xy7dxnRUUFJ+vjOVOhh+IpiBvq2
	 ydRr8qf15LPptqkCgRTsyIIXj5pyJXlnAEBLRbrJ7FBAhrJpDxiihADpYXFylVCKkAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795579772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
	b=odojmrTarYv8FxE+msbxljjY95RuS7rF2yqe9TnQIqplimFfDFxvcfbyKaYBta4Yaf2q
	 G6nzcf1r597thcdcP9eYBzM31zzQQDdqpQE9L8pkx0kNkE81CktrIv+fcDAoxTA0L4ABO
	 6x/OiHptg1mmHos8932jufxgXpZ+VEG4PdtAYUIdL77UY/a06PQqyy4jTwh/XXFKUMdwU
	 1JNrSwPU7J08P8gGUkgPbTRvdZX1g1q0Q2ZaIMo9zsdjuDxzCjmSRZ2y0s+8spH6fbGUE
	 0yHVhTjGw864gPvmdyOQ9HWjPRaF6teJz+OnS4jOYgo4mWf5nv8ZQrbT1IVZIBdTURA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZwakwhmB;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6952B606A327
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 04:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6952B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZwakwhmB
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so4283607f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 20:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795579771; x=1796184571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
        b=ZwakwhmBUNFk5iieZQuNuzg1aYv/WU3M6e57aS/xhN8ERjUWlGzPwm4Vj6GhXU4RuT
         M5KfMt2t9wkGnlEFtmxO6DJu7e/h/EZ4saO8H8yUZAU5An49KWFI/pquGlJbGXGK7ahJ
         f3p7+yVN421LRBxmbIkePqSLExjExEtaMkKEqXIuB1g2BUyLeMduhdapnFoE9UDhI+x4
         qQtI4MdDCYzSuPSGGpLRvqpn4RbekVMD3UKzNAdefC8jaY09xl7LhXSAu6iYrb7lsVvc
         n84TkwmDIhen9PmVwU0vTW7KJbxeNHsoid/k/horLxl8mkyD59PrbGhDthSxUrcQ5HhQ
         Hb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795579771; x=1796184571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
        b=Ki2jwaUytgeZ4WLQG46RodRv6PLGTPgr2toYt5InuddQe+vZgmMGbpeKkhqK7T0b+q
         u6yIosdBau2d1ktP1KzbuRCyztvF2GdotPyZrWanodgZnnbLgMA+zQoeLdrKqaLWuWZW
         +G6ZhFQJPKIu80PciZfOXHdjknbmWqGCnkHOuz8Ec5jNur9wE13EkabThdaa91nC2Wc1
         GanSJjPzRkCj5HJI2q6tHPf0xN+8jSK5+3kW5p8gcjGr9zEwrhRIXQB2rF4w3W07SfFK
         7mhFeBz7tlj+yq8cTKS/3bYVLkpTaQmWDt9nUqf2Z/heSNbtNBjYxvH3mq+1+DRm6dhH
         +Wkg==
X-Forwarded-Encrypted: i=1; AL+hErEx9dFEWktxvjgsIGwApu41DDcgWlhZqU/ns975k2J5+4PwIrZ3zgvLSvTKkUxaU1M5w1wuvo2uVpmccbs=@vger.kernel.org
X-Gm-Message-State: APuU4Z8o630XwGkmR1+Q3AuhaSnpcwHDnXZl0RK2yBPrSLIkOi96JsJ2
	+Z1sFRq1nPfB3SLBa/FTslajV1Y8TmddVU5/Uf8bjA9QSB28Bj4675QF
X-Gm-Gg: AZFdTZd7Aal86W3SYsEv8x4yK6hO9itbyaDuwXGNLA/GqKiPT5moDrfJuDtgbr6BVxp
	cWQ8AP8GsC2QaacbfG1uBpMZloFRKSqy2sVMUf/KI4djTR5BwLObC5ryU6n4zTsQ36ZO4/2Mb74
	YdghHt/nbv4RDeL4vjaaQ1LtRSvImMDeMlgAItbpgCEDBJHV0FobfQT8hEwuoLTda6xk1kfQhnX
	LroCgIZedpy91gVaTsMnD11D0KP6rM6+sh7QfklNN4AYEymafyyfdVkhSVevpDPuiaDHwApBRh/
	KKQE/MlQAX4BM/L6HzRzf4CfKtSmoHzhjYmfuifyio+oe2+VNnj25pwDZaeyYSs/KS/FrpVhkKO
	A8eCmDX/OlLkyeOiUl10lMex1eifhX0NQAcziJ0h93L2fO+v+I4NTawWmp5jFAdJOKihycbbh/u
	1uwnGj27nK6/4djdgSdS948ijTL6+L7GpLryCBMqSSXBo0NvGNIPi13kUiQFFDLRncctlFm9Noz
	Ylhb0ItLQ6MMZnJVGcpdhPuNgZoQsVim3+Lk7hkaKi8aiwEb0MdwI4x5Gc/iCuNTjdhuKo/btA9
	uU6JpATITWzxJgBYtx2Hr/E1g9g=
X-Received: by 2002:a5d:5888:0:b0:487:1ac0:32af with SMTP id ffacd0b85a97d-4abb47b0fb1mr31743230f8f.51.1795579770667;
        Tue, 24 Nov 2026 20:09:30 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b5f6sm29545143f8f.34.2026.11.24.20.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 20:09:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: Bjorn Andersson <andersson@kernel.org>,
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
	Ulf Hansson <ulfh@kernel.org>,
	devicetree@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	olteanv@gmail.com
Subject: Re: [PATCH v3 13/14] arm64: dts: qcom: Add initial Halliday dtsi
Date: Wed, 25 Nov 2026 04:09:14 +0000
Message-ID: <20261125040914.2399053-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-232541@kernel.org>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com> <sashiko-outbox-232541@kernel.org>
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

On Wed, Nov 25, 2026 at 03:58:44AM +0000, sashiko-bot@kernel.org wrote:
> - [Low] arm64: dts: qcom: undocumented qcom,halliday-cpufreq-epss
>   compatible
> - [Low] arm64: dts: qcom: undocumented qcom,halliday-tcsr compatible in
>   tcsr node

Both bindings are already applied and in linux-next:
https://git.kernel.org/next/linux-next/c/7ceab1723610
https://git.kernel.org/next/linux-next/c/1cf95fbec47a

Stanislav
