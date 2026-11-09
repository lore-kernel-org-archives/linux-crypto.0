Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214238;
	b=IDVGD0+wXT3S1SQR/mhUIRue1fXWiMCBfOCFQn4ViHoJrACcSIV1MWvNIScV11ibCby6
	 S6aSeU1iolUgOGz5iWy9plhY3N+jMmNO56/nOFuqin6dmEr7n+9gU8FJ/eUAFfWH8lkt5
	 /u68ogGAPhDGHvWSC2SWxuoc3zlTC1DJqLb9pm8P9J/sti3j+DCYH+HRUO0R9LpnaG+rV
	 Z9uxkzkH0rt4XTuHtO8nMuTH5XHGRhQdzfNV7/9v3QGrn8aM/SCqPmIEWqSci5+uGYWKg
	 Qy0+EScpLcB/XIo9j6HAqVaBLe6D65B6U3ei/4zY1t8tRVos2hu4xStqEubMfwVIN6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
	b=DsRvjYFkXhO/VgWNVUkUpHB+kXADtk7dsyVoIkBgp2qnTrXewWld9t5Tft/DsuOKpr5H
	 hWDFnuUCINo0qftRx1vqWXtdALA2W3TbdQ6DkC6KpEka7nqPzZ6OXAfTVHTquaQ8mavpK
	 QFYYVMPL0jhMQdOY3n5oI+6KIdSpl593DSI/eJsOo2npLUw7FKuIVdY61ygkiGOoWRq+k
	 jd5MMrj65RXNPaF9qlkVWJrHXlolMlaulELCwXGvZjj0Ry5rh9m/AUEmVD26MhO6xv8OJ
	 6pljYf7eP+6mseTKMgGiN2NZg+x7mhJ2AM53XQVrLRdLt/MIgLqYr6VlrzURA5Bygpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGqde3Ho;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C224C606A33D
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 08:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C224C606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGqde3Ho
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so5478995e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 00:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794214236; x=1794819036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
        b=TGqde3Hoeoi+P+P1MJHy6yFa7TDuVfP4g4ZGwX2ih4xjRGjRFWnypRzOP1Xa4L0IPm
         s/DPVbSTnEn6+vQabgyMvzXoPqHofh2/mImSCnYL5a12zXk5bVCjZsmkY8NnMPUi2SVc
         xAgwi/orvf9pFkFiAXO532yOUQEFgNvW8m3sxgUIowoBqxTIMXeJ2WTdj1dQHwKMPf0V
         cCNQoCDDyIF0nns6PDu+LZixogYHFd2CbQ0mtJSAP17FhsmRFJQnz4kJM2w5Emebd5cL
         Ug3ZqCYI9cMwu6iJ7WzAlyerv17zrvmPyC1IUPu31nRNXyg9pX/XYW5Pjf8n++ZvU2Ya
         pTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794214236; x=1794819036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
        b=jyuw3pG5+TMtVGkqoe/RhvV0cihq2UhjXCsF6fCTBwUN7WbGvmp8aI2glPXQoqTQsd
         M4rmoSsowVzCjgjq+Pl+s7qvNbtfh8Uljv2XcjNVynQKCTiP8m4v2iRe8o9upzaLfmrJ
         0+rJ07O7IEjW9wdjICUbcoV96A4Gtx3TNOyJ01KVewXPKtt7nwZwasZqClM6EemNPgGW
         pxIGu4Td3Rl2HeKeevZOj0lTuypzdmcFEqU16YA+ZFM9Dd95ssnq+lhcdkVtsaG0klh0
         8pFWSMbgzLNzF86mrb9NZTbPASexRToWgcfNSJAE3wGNgtrEkzgwF/mlXkCXJmrMyI4j
         UxEg==
X-Forwarded-Encrypted: i=1; AL+hErGmkTja8j2pvFstSERiULhbNcSYBKBAmbsKZgrkOPG9sao9tqaTBUJCkLoFpN0kOPkyPH9HrAzbUg/Q1pU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AK/EHSCLbfPRH7mAvXFqGwDSG7vYfv5gdLwRdxVXtjIlFwptN
	VsUIAv+By/3746sXxXCkm7t0Ob/5kBaPL4IykpORyBygk6RGB6RGd2eo
X-Gm-Gg: AYBFou0IA8Rj0dQkG2nGXt1d96G4qcaii6XKXIbiv7s/GB3knaA+bkBYTkUve7T7CLY
	VpqFpPNBGLb/BosEkdInKPHDvCCALjF8OquguSMQROiKRqpXxUuSijtFBEoM2yfzrgFhzxLxjL6
	i5eg7kDiz3dtWrryVr0NmTh5VaYEaPjDAvpvNak0tXmSq2kp7WqKfRMc356PIcVRmoGHC1RjzAv
	mOFdduG+xifT4Q5f2VAp8EVEc0ot0922sCD32JHlPBmNLaAEXiEV1P5Hy1i+iAQ1eq2Wrcpuh8o
	wSYGqvqmZf67THLi6qBY7vYP1FyJ9VX/sr4Yl/jL4/Cl4i1yTclKUUg3N1ZQgmjSmsXsG5PTTUG
	IcwHngbfIGnkIkEz0P0Dzd08pWAhTrfKPMRlmFHD6eNt8kE37n6hj5JRuZRXJo+omXdadOiBzYK
	bTRh/cNjD4hmk6m5FOAdD5FNCD8yokicp/sbipnGLP1onN3RY5oyOfczao6Sih2+7h+ILXiYZTf
	v4/W8i/Q59nDnLP3sPIPkyKv1YZAQqYFnGd++fiMVXDB6tTHL9D12ZbCxBfhZTJuFvtfcWzWnc5
	lnKBnOStnGa8x8qqpUKjmQJn/cU=
X-Received: by 2002:a05:600c:3b1a:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4b963c7e496mr65389125e9.29.1794214235848;
        Mon, 09 Nov 2026 00:50:35 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b79502d5b1sm147015055e9.5.2026.11.09.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 00:50:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
	Lee Jones <lee@kernel.org>,
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
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
Date: Mon,  9 Nov 2026 08:50:19 +0000
Message-ID: <20261109085019.1751534-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9dbfc665-089c-45f7-bca2-74caee322885@kernel.org>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-16-289114ab8197@gmail.com> <9dbfc665-089c-45f7-bca2-74caee322885@kernel.org>
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

On 09/11/2026 09:29, Krzysztof Kozlowski wrote:
> Odd license, suggests you copied it.
>
> You should retain original copyrights as well.

The license is BSD-3-Clause because I used sm8550.dtsi as the template
for the node layout. The values come from Qualcomm's downstream
anorak.dtsi, which has no license or copyright header. v2 will add the
Linaro copyright from sm8550.dtsi. I'll fix the other comments in v2
too.

Stanislav
