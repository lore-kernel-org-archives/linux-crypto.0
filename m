Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578212;
	b=FCiIOY3/PGBuiCL91tSJ9KwNhFrxLqkDAdd+k/zQXh0gpH0RGhEOCQsKpaxDpq43Hcfj
	 mC3bI6ha5OfJitAE9vrEbpnuiHAJ+M2ofySVmyGqWIk2KJZC3qW3FrcARLEIx6ftRqQ86
	 a6TCdU2jq7goh+//VAgI/pC4XhSxPoni9HwgrDLrv7eKWaypE4wcr3iw5SJRB7FuVnKv9
	 JeWQ0g8NetfpWxtRVP4Mo/CxOo3Ab4kpz99h95XblNYawfgJxsqvZdCcQXWN6h3CZBizl
	 0fa3bTMkQ1Y/SjM6dsDm6mYB8j+DrU+D7GI/RC0fru0EtmO0+VkGPTMxFaHQxqfE7xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
	b=EO25z8vu7K73/qp56fV8/k5nafCCRZE6Yp4mMUcuQDkAeyEIiU7UWj+NE+iDUwhiaqbY
	 LcUnWM4LBS/RASE8h05ykwhh7Hr0lCcHHS6Vs0k2R4Y3irnN7GRFdiBnfIeVDQtlcs//t
	 RQSuDFf9uJ1nn77Ocz/38n/CDeudA3fd18GCzrko8q7UgmwS0mUHh+ETTCMEgcZAuRege
	 MBdL5iHTyfXdWPjQ+U2NUigKnBf+lIomB94R7c2AQKgOSTcubWUcM37LC4PadgpFnxV8X
	 9+JhNQBgkIkMdsOKc9glgyJ9VzOmHqu77jSvRodBEivyGFhbk9xLJUhox3EPjgWt2XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vtmuE2oV;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD3C606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:43:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCD3C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vtmuE2oV
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso51634515e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578210; x=1796183010; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
        b=vtmuE2oVGauIrw3nw//ZRqa1Bm3QZKItEoasIwcVX9zrlHG8SuDm1FNC6p/gUdoCEd
         yHcuQCJcOHFRBmJFJKXfAGas6SUgywo7/jrc2g6j8F9XTF2b/sxKqB0jEOEKU6hcamJD
         14q5wpHZOiOYBFQNK1KIDLyZtVxRvTUkoz5xbfEqORlxb8vKYDH1TeXKi/hjuairq+qA
         HTvMC4VMbQS+O6o/T+dsXXY4CLm+Y3int+QGFaVf07vXbbJ1XD+bkPcMviZ16o0nVfp6
         SJwxhNBkbj291YKuzpmUYMuCOa8IOYkLoIsbsJMwBcDS7LNdUGB5sWgmcof0KICa8jIT
         BQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578210; x=1796183010;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
        b=Vwm70wb0pVmvVPBbCuXT9gjiOAhHGSGy6biKfMpMVBttThtV/i2WzZWqMyJika/95x
         knh1rLxIF53t8miA4CtiK0cLIXdCrKWFKc1Hkj6SLcdVP8pd2MPetbjlkGPi6t5A4Zm1
         zncSJaHidO06Jti2DF+czF0pehEqk+57+YCZWBot+cR9XUY0mxPfVugRjgnE+/5yHkND
         KkCCmMI4TfYj8Y7wNV3uYegORjmsxsShCloiFwsmoVlyTN5Z/Hgw+mL+aLv5nsP/hona
         waX7Lr3LeHvMZmcV/7Eyw5LCcXgMFssFfpWRZ5oGAO/Zb6KIWmkAQgJib/7Te5X0rGuI
         YGTw==
X-Forwarded-Encrypted: i=1; AL+hErG2wkcOm+cwSSygBFMbPJYvBLcN10hU4ybhKEipDvJwQ9vpsh+ROlskExzd3/k/FC83C6q/3+9cWDQrVrI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9TS8YN/6L2oq2hN43uTZ9VRJlI1D/EAf3CGMMrPudV/Kj0uMhT
	gMQx5W7SKOUCY6qNnNnwTcsSvZzaWGijKY+1ubg9DNr0PAxVUdYa0xUV
X-Gm-Gg: AZFdTZd2nWpu0jzRxlsf1Xiei9hOCH3YieNANuulA0ZG1p3K9GujT4x8qZiS3X3rcoA
	8PlO+8r/DbRdGKC14qNEfZ5hlS5ARfyf0sVfqsIoQXLS7GD0DneldJpikvz7u9ph1KXTW3Fvtx1
	IpcbIRufxw9BWFJp4MHVz+QDZn1RYr1X0hytk5f5tu05uzuTUjp+ehsxjn0/6fP4q6D98v6x+78
	UqqdOIuEGikuKt1l7jdNYMCF7x74tbP2PWzaUYvbbDLF0N4LKmG6Ck1XK84uuw6a8JQcxGbWTqs
	0jQK7g8DNoMKCNYyaP6fEUqQHuvtX+FA06JUxC/9vd0mg0Sfqi8WiH/Ysaabf4wG1bYT2Ke1UIO
	x39ZUZMFcjFGz6RvD+m+ZFf6CVJ9FHsBZ4Q85T2k4etlTk/gSiJhb5MWLRp+AktEZKZJWm8EA4M
	iRl2pXdEwmZEYfZyQeZ89QR4BQhs5m4yyTqFvKzN6V/EP8ODpxcSI5I4Ex/2A94zm+0Z2GqPebK
	p8HiCYkiwo2iBZnj408RT4MbMT9PqYNUJMKQUOJQJSTkUlLR7TWBJL2GQKYkFEPt1e53aVM3aWW
	HUf3xhREHHkwsOKNWNgvQqn6G/8t/p68yeB9sA==
X-Received: by 2002:a05:600c:4f4b:b0:49f:fd2d:23c7 with SMTP id 5b1f17b1804b1-4bb888226c0mr405465545e9.27.1795578210149;
        Tue, 24 Nov 2026 19:43:30 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Subject: [PATCH v3 00/14] Add initial support for Qualcomm Halliday and
 Samsung Galaxy XR
Date: Wed, 25 Nov 2026 03:42:56 +0000
Message-Id: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEJZBmsC/4WR2W7DIBBFfyXiuUQwBgxWVeU/qj5gGBJaL41xr
 EZR/r3YsZRuUl+Qhplz7ywXknCImEi1uZABp5hi3+WgeNgQd7DdHmn0OSbAQHHOND3Yponenqk
 fE0WFvrBQS+cZycj7gCF+LHLPL7c4nepXdOOssVYMeDxln/FWdrepNr9NxqZtaQDJilLkDLJqE
 uRrb39BrnmjhQJuWBBBel9N8C8TnaNKWikE1KilWZkWU7Ir9HijoKBH17c09S52oc+pvApax87
 Hbp/oBJRRIZlw3KFWxu76lLbHk20y1G7z8zQL1zYhnX/iWG0wGIC6BG4lGlMIHRwPUjMePNYCS
 kQuEE0g804PMY39cF4uNvFlhes45vtxJp47AW04F7bW3JS7fWtjM7ewCOUJ7zBXP+B5DHAGRKG
 dckJ9ha/X6yeVRL2YOQIAAA==
X-Change-ID: 20261108-halliday-dts-e6ed3a2b5cd0
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=6234;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=azYIy7Z40yIDlSuh5Mz7oT8vPni9I9knitlR28s/doo=;
 b=c4hT+PD3H1S/NG0t/y9kGVB5kkO7YV/E1HObCKHUAhFxdB4WxSWz/1gZuM/CZn7D0I4dGm0NR
 6uXdXdBlMaYB5Q4KJ33WFtgDmbPylfAcJ2vCwPNZyO/Ahtphyi5BZfH
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

This series introduces initial Devicetree support for the Qualcomm Halliday
(SXR2250P / Snapdragon XR2+ Gen 2) and the Samsung Galaxy XR headset
(board compatible "samsung,xrvst2").

With this DT and the driver series, the headset boots to an initramfs
with a shell over USB NCM.

UFS, cpufreq and the thermal zones work too. PCIe with Wi-Fi and more
will follow.

Dependencies:
- The dts patches need v4 of the Halliday TLMM series and v2 of the
  clock series:
  https://lore.kernel.org/r/20261124-halliday-tlmm-v4-0-3e3a1d0fb4eb@gmail.com
  https://lore.kernel.org/r/20261116-halliday-clk-v2-0-28208928da36@gmail.com
- The dts patches also need the interconnect series, which is applied
  to the interconnect tree (branch icc-halliday).
- The SoC ID patch needs "soc: qcom: socinfo: Drop DT bindings with IDs":
  https://lore.kernel.org/r/20261123-qcom-socinfo-id-dt-bindings-v2-0-4504c1ce869a@oss.qualcomm.com
- The cpufreq series and the TCSR binding are applied to the cpufreq
  and MFD trees.

This work was made together with Claude, ChatGPT and Gemini.
Reviewed and tested on my Galaxy XR.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
Changes in v3:
- Drop the TCSR binding, it is applied (Lee)
- Replace the qcom,ids.h and socinfo patches with one that adds the ID
  to include/linux/soc/qcom/socinfo.h, on top of "soc: qcom: socinfo:
  Drop DT bindings with IDs" (Krzysztof). Remove Konrad's Reviewed-by,
  because it was for a different patch.
- Rebase onto qcom/for-next, where that series applies
- The cpufreq series is applied and is no longer listed as a prerequisite
- Add the Reviewed-by and Acked-by tags (Krzysztof)
- Link to v2: https://patch.msgid.link/20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com

Changes in v2:
- Order the patches by subsystem, with the SoC ones last (Krzysztof)
- Squash the "halliday" codename patch into the board binding
  (Krzysztof)
- Add the SoC ID patches, which were a separate series in v1
  (Krzysztof):
  https://patch.msgid.link/20261108-sxr2250p-socinfo-v1-0-06244862f5c6@gmail.com
- Move the OSM L3 binding to the interconnect series (Krzysztof) and
  the cpufreq-hw binding to the cpufreq series, so that each subsystem
  gets its patches in one series
- dtsi: Keep the Linaro copyright of sm8550.dtsi, which the layout
  comes from (Krzysztof)
- dtsi: Drop the empty chosen node (Krzysztof)
- dtsi: Sort the thermal trips by temperature (Krzysztof)
- dtsi: Put idle-states before domain-idle-states and
  arm,psci-suspend-param before the latencies, like glymur.dtsi
  (Konrad)
- dtsi: Use 0x0 for zeroes in reg, ranges, dma-ranges and
  redistributor-stride (Konrad)
- dtsi: Break the reg-names, interrupt-names, clocks and clock-names
  lists into one entry per line (Konrad)
- Cc Ulf Hansson for the rpmpd binding
- Link to v1: https://patch.msgid.link/20261109-halliday-dts-v1-0-289114ab8197@gmail.com

---
Stanislav Aleksandrov (14):
      dt-bindings: interrupt-controller: qcom,pdc: Document Halliday PDC
      dt-bindings: power: qcom,rpmpd: document the Halliday RPMh Power Domains
      dt-bindings: arm-smmu: Add Halliday SMMU
      dt-bindings: usb: qcom,snps-dwc3: Add Halliday
      dt-bindings: phy: qcom,usb-snps-femto-v2: Add Halliday HS PHY
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Halliday
      dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday UFS
      dt-bindings: crypto: qcom,inline-crypto-engine: Add Halliday
      dt-bindings: thermal: qcom-tsens: Document the Halliday Temperature Sensor
      dt-bindings: firmware: qcom,scm: Document Halliday SCM
      dt-bindings: arm: qcom: Add Samsung Galaxy XR
      soc: qcom: socinfo: Add SXR2250P SoC ID
      arm64: dts: qcom: Add initial Halliday dtsi
      arm64: dts: qcom: Add Samsung Galaxy XR

 .../devicetree/bindings/arm/qcom-soc.yaml          |    4 +-
 Documentation/devicetree/bindings/arm/qcom.yaml    |    5 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../devicetree/bindings/firmware/qcom,scm.yaml     |    2 +
 .../bindings/interrupt-controller/qcom,pdc.yaml    |    1 +
 .../devicetree/bindings/iommu/arm,smmu.yaml        |    2 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |    4 +
 .../bindings/phy/qcom,usb-snps-femto-v2.yaml       |    1 +
 .../devicetree/bindings/power/qcom,rpmpd.yaml      |    4 +
 .../devicetree/bindings/thermal/qcom-tsens.yaml    |    1 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |    2 +
 .../devicetree/bindings/usb/qcom,snps-dwc3.yaml    |    3 +
 arch/arm64/boot/dts/qcom/Makefile                  |    1 +
 .../boot/dts/qcom/halliday-samsung-xrvst2.dts      |  218 +++
 arch/arm64/boot/dts/qcom/halliday.dtsi             | 1871 ++++++++++++++++++++
 drivers/soc/qcom/socinfo.c                         |    1 +
 include/linux/soc/qcom/socinfo.h                   |    1 +
 17 files changed, 2120 insertions(+), 2 deletions(-)
---
base-commit: ef922b721a5e99348fc1f5801fdeb427ee14ee9f
change-id: 20261108-halliday-dts-e6ed3a2b5cd0
prerequisite-change-id: 20261108-halliday-tlmm-f250374110e0:v4
prerequisite-patch-id: 93f99b14fb93baf1aa68e010d29d463cfb616b9e
prerequisite-patch-id: f94f62e85a4afa1d5caf06ca16e2ea2abe1e99ed
prerequisite-change-id: 20261108-halliday-clk-362190f4f5dd:v2
prerequisite-patch-id: 765d40b7543dba6580852939a5c3d177f12d0a1e
prerequisite-patch-id: f12c958fceb125bcefd8dc9de139f30a371f85a4
prerequisite-patch-id: a6559b14fa1badec8e7752940362d68306523557
prerequisite-patch-id: ef47e531053032f65d3d600e2213c8a78e50f20b
prerequisite-patch-id: c4b2cbea76a00aeb699d706e09a899aa18e510d9
prerequisite-change-id: 20261108-halliday-icc-65a5442be859:v2
prerequisite-patch-id: 94cd5dee75e96876c6a42852cf6d1b52df1c7ace
prerequisite-patch-id: 9ad58176d603ffd84e7f1239c3b646cede4c8a3f
prerequisite-patch-id: a5df517be2541ab439d324dfe23ceb4c71a0e655
prerequisite-message-id: <20261123-qcom-socinfo-id-dt-bindings-v2-0-4504c1ce869a@oss.qualcomm.com>
prerequisite-patch-id: cba901b3668891005366e6c699866823187d2e6b
prerequisite-patch-id: 165b8370594197636821e98c434c0db01db0f953

Best regards,
--  
Stanislav Aleksandrov <lightofmysoul@gmail.com>

