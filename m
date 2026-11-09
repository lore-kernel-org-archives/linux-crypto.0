Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184404;
	b=lE2EiS4C4eNE7JucfGWOVydJNPGqN7b3cmdEFBgW3s0TgBA92BAJDevw+mTR7GvAADSA
	 DuS24TVgI1gpNL7bttZ0roJ9brH+mCFoaYZHgMKbjqGYKXdxyyuN92xnj+KgsxmMn6weh
	 BBtymQryvDuaZfhhmu9il0g5H0NueyOzzkOdOMq3vMHO/2ple3etQtkEZaUJtjrYRDR7C
	 LBk4bqTI/w4m39ofllmqy5hr3yGJtCkNFDcsueERBfBk1zbkB1ppBsqMzkmhUURoZhUXX
	 mFDgzgUiHLES+heBJqLLv+5FkoqfIe+aa9dt8DZMumGXcXy81gwaDnaK0X09F9Yn7/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=T85WE9/4pIgxBclKw2OPnN4ipy1Bde6FK+pcC/DL+nU=;
	b=y4Vu5iRsdBTva6pCUnFguKMXPXMIm0BWB1fBG2BjzfTTddg1mL+ikN2uXMkzaxXbTaI9
	 x8y3el0o7M/vr/NReQ+GkfCqf2nZUJJvKJi/1rUCQrBvAQ0Flw9Xe88ZQ/3OMz+d0LN7h
	 QfpqcpYD7r+Vn0Jw05of0Gf9Ihgz6msU09aHjYVEP7QEs4n2yIlYIB19gNOcmGVj66WAJ
	 CYOYN7vyhbJLZYyW3d5RmNIY7jY7QMZ/XO8RWw0p//k6PibOBh1f61ZejFGHzsCDFvI14
	 UBCtAAaaPeHlQpv1zeZudhMTBpkyHmoBNOyeT6LXk/tn3v9RVZC6xsHddc9nWXtO2Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="d4/kEHZH";
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852C606A321
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A852C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d4/kEHZH
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so187398f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184402; x=1794789202; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=T85WE9/4pIgxBclKw2OPnN4ipy1Bde6FK+pcC/DL+nU=;
        b=d4/kEHZHFwXvnN+JE6GB713CG8eV+aLj55UDgYK3y1j4jIzWR5Kjwp4+q9FtbboowH
         MDIeIfmT0PUjSiKqkOUJS0mHdCCHMslm+YdFcQIPhH9NW9U1oUtVMiwo/G/UpkQILbGO
         lVSdCjgVhHdOhDACQuSZERVaz+/sc1KHuTliIw2PHPGDWw+vrgab/EufTJ11omCmvhiJ
         UmzkP6SRw0zm0+yML1p9GitCE52Uk88eYHKPHxQo7pfL6xG2ZlKhW79MTrGk1LPmv1YF
         jUd90Grt85D2JUVc3PRdoKALbQjvk+mMp2PfV0rmjg3MAso/adiN5PjR+m1i6ifPRBRh
         3Osg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184402; x=1794789202;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=T85WE9/4pIgxBclKw2OPnN4ipy1Bde6FK+pcC/DL+nU=;
        b=ug1cdGLpPfcUk4T5656wJEDNpNyIIGglHwxn1ancog5N9T2iZos5QPluGO7C/i8Bw1
         ShnZWOuZBkW8kIcDDr8dd5ReNitgw2W1TSJC/i3JNKZWBigQBos1Twi7Avya7c9uGiws
         iMccOrcPHD9W8b7/bE3GkZY1qgCVyxnDkXL1coE18IsIRKj6+PQOQc2gxfJkIAGDcgKH
         qnEEmE9u7DywB6zx9Q9eN8/zuQQipUhzAivs/+WVAOvWF1UwbOiaw9q0cKtlhLlIxgMG
         Ba6jdogHDoG16pVJjMu0Ia3JQtIu1io85xlyQjOI3O+Xk2BQt+UyCw6Yd3Fv39dQ+MD6
         v3hA==
X-Forwarded-Encrypted: i=1; AL+hErFTnpTJffTYTLJhmgB2CBmzykpx/LjkMRjK4GpHFzJYF2VWITpdNZOR6d54IMURoZyFQctOeSiozu1IQRE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8zWy/XcDGahpMS6qMDNQVtyQF4QhH3bi8ZrC1U6bk8Jrv+14yE
	XUgO38KTTMEkRJJ8lhYd5eRNC+rv9b3vWgNOOPvtPST/1PZArYNXz4wb
X-Gm-Gg: AYBFou1VCYeaBwQrmOJWJ0u8epLiQ7CrxIzDosHntBF5G2DE0/n/BylIrcMS08bdKUg
	mormHgeWlRLpsRKO8s979d3/HKhjR0CtWv7bpyp6uHgZYb149WNMroOfQWlM7NzwRT8DDYtb0V8
	q95UyVLWZJ5qt7sdD4hgAyu8BlYe7fc4JaPeUB6W159ifU5lXSJGaey0V8Df//J58Al+EiUMoVn
	EPSCYngxaOglG1qcDV6d/fzMknsCTz8RZ+/qR/Jxp3XnfwW2yIi3ftBdUmfSK39+pjE0X5Wwyc7
	27jwbncznYkC/0hf8n5YShw84X/MMJQH3/4NvFGdULG4aaanLzlwvM1uQ8aLwpEBbmO/nvbCfjO
	17gBxOM3s8AO8eFo0jlTZFZfqRfm/So0rTvwxogRpjghOSLONBHKeBpZJzzx0bC0FfAE+J171Lw
	UJvh5vTuLSG3k+1vkK5CessCg8fslp+UitGrr9y/XM8t315lhXJis28d6jsPGvHQXWNK1hZf0Ai
	B4pjzIn00CY11pJKk9t6JSqaSU9n/E/AO4E6nBbGMoWD7M+BARdRee9weBTG+KpIf2lNvWMWROo
	a+3nrqmcq9Ep8K8bwJusBOpq2cpe2IDkchoVnDcY
X-Received: by 2002:a05:6000:613:b0:48e:1b11:7ed0 with SMTP id ffacd0b85a97d-495895866c8mr4919311f8f.33.1794184402019;
        Sun, 08 Nov 2026 16:33:22 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:20 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Subject: [PATCH 00/17] Add initial support for Qualcomm Halliday and
 Samsung Galaxy XR
Date: Mon, 09 Nov 2026 00:33:12 +0000
Message-Id: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
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
X-B4-Tracking: v=1; b=H4sIAMgU8WoC/42QwW7DIBBEf8XiXCRYA8b+lSoH2F0aUjtJDYlaR
 fn30iZSK7WHHEc7b2Y1F1F4zVzE1F3Eyudc8mHfhH7qBG7D/oVlpqYFKHBaKy+3YZ4zhQ9JtUh
 2TH2AaJGUaMhx5ZTfv+OeNzddTnHHWL8y7o6V306tp95sPzVT97ekzssiE1jVD6ZdWE1nLX7/9
 h+E86vsHehRJZMs0SNMRpTOBmsMRPZ2vDMxFJZ4WJZcp8458DyQQRfBoiftk+6N5baAItAexhB
 4YCM21+sngQFSdFkBAAA=
X-Change-ID: 20261108-halliday-dts-e6ed3a2b5cd0
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=4240;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=pd8aaBJfTnst2NyWFbIqqoDWH9f0rsjbQVRvbO1ZvfQ=;
 b=ziCTgeR9INftAl++nhbHMRN5UuuOAe9O1l8dAZyqzOQeSOXOhqEJoZb8ANzg3vCtU6bUiOnMC
 Z8pj2yNgEeLD2PYELXx3W1Ha0kiVJJto65DrQYeecHZpxNAkqkfVYCX
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
- The dts patches only need the Halliday TLMM, clock and interconnect
  series:
  https://lore.kernel.org/r/20261109-halliday-tlmm-v1-0-a181d54214cd@gmail.com
  https://lore.kernel.org/r/20261109-halliday-clk-v1-0-20c3ba8be0bd@gmail.com
  https://lore.kernel.org/r/20261109-halliday-icc-v1-0-def7cf786f75@gmail.com

The SoC ID was sent separately:
https://lore.kernel.org/r/20261108-sxr2250p-socinfo-v1-0-06244862f5c6@gmail.com

This work was made together with Claude, ChatGPT and Gemini.
Reviewed and tested on my Galaxy XR.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
Stanislav Aleksandrov (17):
      dt-bindings: arm: qcom-soc: Add Halliday
      dt-bindings: firmware: qcom,scm: Document Halliday SCM
      dt-bindings: interrupt-controller: qcom,pdc: Document Halliday PDC
      dt-bindings: power: qcom,rpmpd: document the Halliday RPMh Power Domains
      dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
      dt-bindings: arm-smmu: Add Halliday SMMU
      dt-bindings: usb: qcom,snps-dwc3: Add Halliday
      dt-bindings: phy: qcom,usb-snps-femto-v2: Add Halliday HS PHY
      dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday UFS
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Halliday
      dt-bindings: crypto: qcom,inline-crypto-engine: Add Halliday
      dt-bindings: cpufreq: qcom-hw: Document Halliday CPUFREQ hardware
      dt-bindings: thermal: qcom-tsens: Document the Halliday Temperature Sensor
      dt-bindings: interconnect: OSM L3: Add Halliday EPSS L3 compatible
      dt-bindings: arm: qcom: Add Samsung Galaxy XR
      arm64: dts: qcom: Add initial Halliday dtsi
      arm64: dts: qcom: Add Samsung Galaxy XR

 .../devicetree/bindings/arm/qcom-soc.yaml          |    4 +-
 Documentation/devicetree/bindings/arm/qcom.yaml    |    5 +
 .../bindings/cpufreq/cpufreq-qcom-hw.yaml          |    2 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../devicetree/bindings/firmware/qcom,scm.yaml     |    2 +
 .../bindings/interconnect/qcom,osm-l3.yaml         |    1 +
 .../bindings/interrupt-controller/qcom,pdc.yaml    |    1 +
 .../devicetree/bindings/iommu/arm,smmu.yaml        |    2 +
 .../devicetree/bindings/mfd/qcom,tcsr.yaml         |    1 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |    4 +
 .../bindings/phy/qcom,usb-snps-femto-v2.yaml       |    1 +
 .../devicetree/bindings/power/qcom,rpmpd.yaml      |    4 +
 .../devicetree/bindings/thermal/qcom-tsens.yaml    |    1 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |    2 +
 .../devicetree/bindings/usb/qcom,snps-dwc3.yaml    |    3 +
 arch/arm64/boot/dts/qcom/Makefile                  |    1 +
 .../boot/dts/qcom/halliday-samsung-xrvst2.dts      |  218 +++
 arch/arm64/boot/dts/qcom/halliday.dtsi             | 1859 ++++++++++++++++++++
 18 files changed, 2110 insertions(+), 2 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261108-halliday-dts-e6ed3a2b5cd0
prerequisite-change-id: 20261108-halliday-tlmm-f250374110e0:v1
prerequisite-patch-id: 5a614cbb038d4083d1ce56b413923dfb4e7c2fd7
prerequisite-patch-id: 36f2dcc3de10d5ccba9eee25b73736189559162a
prerequisite-change-id: 20261108-halliday-clk-362190f4f5dd:v1
prerequisite-patch-id: 765d40b7543dba6580852939a5c3d177f12d0a1e
prerequisite-patch-id: f12c958fceb125bcefd8dc9de139f30a371f85a4
prerequisite-patch-id: a6559b14fa1badec8e7752940362d68306523557
prerequisite-patch-id: 3574a3f99dc1a987a61b4e4a73e0204142604a73
prerequisite-patch-id: 5ff25f591783dea61a6719bffe3961070f7167e1
prerequisite-change-id: 20261108-halliday-icc-65a5442be859:v1
prerequisite-patch-id: 94cd5dee75e96876c6a42852cf6d1b52df1c7ace
prerequisite-patch-id: 730c6d80310f7472ecbcfbdb84dff4cc864d99af

Best regards,
--  
Stanislav Aleksandrov <lightofmysoul@gmail.com>

