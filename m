Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417702264CA
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331020; cv=none; b=bm5zpGLGyndvbQMkDs6DVKA+DXWI3wAm2Rig0QxoPC8IbhwE21Q5Zc5rSy2S69efuD9JtyG3+rhCVvZItz5Fxmg4kkUBywTA2EqxtIE4mtekT12SfDthKJTW1wyASA9FPlYspogGk6oTQYL30DWZsW8Z2uHNSsLXljEDpC3LJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331020; c=relaxed/simple;
	bh=W8/D6Zte+WLuzj1BAkQdHKSbz78N81zx1LJo/v0yIRU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XM3OtlRlxujREzlTuTZoO6obHmxOvp6Cl++pxZ9Sf8VUcW62BV3bLdNGndmLhiswlRI+sAxeWclnfWStbupj4C/HPunbBKlKyc0F56e6+Fo3YCDFj5DOR4+YvwfIWNOYb5effZcF/MGNoNikU7LllR+RYjoVJD46khh4anU9384=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=IJwLtN6E; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="IJwLtN6E"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4779a637712so46604565e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331016; x=1765935816; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=urnGBbYBlge0MPMnEMgs9eDhJcIT7BulOmvs3UtoNbk=;
        b=IJwLtN6EdeV9vU5oSoi58gNLustcSwmWA1Thi8i5/TGrsjiJbizz4ZMmFBZUrZdeTF
         znT/+KyTeIvIjyDyat1rs4FKnZu1IqOO9igv0tppQm+V2OrnsTKZeAYTRb2Y+b26kecI
         LX96d6dSTj8JerlESD5Me44d/XA3XsQ7wNG2gAf5qW1IG7IaN8MMTa2JLJbtw6bQUQ6E
         etlS8FqVzHZ3IokR1OWAcTlMoM/w4MgR1Uun5gFr5QRDh6oQCwRcgLzlZiJm3MXxTecr
         1oSltMo7YyabTtpt0CyYP/Zg+kbiUx+/kO0BWGT3FRdW2tc2zU32SFNtIWlgvbzfdlbE
         5mZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331016; x=1765935816;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urnGBbYBlge0MPMnEMgs9eDhJcIT7BulOmvs3UtoNbk=;
        b=GLHAACr15r4YmCoyI6DFKduLR4JqjfotkWgr616bRXxzIeCoqn2rG7DYypTm47Fm+c
         gStfeLRR6j1QzkzCKI+58MX67emxJGHB7mFElUmI5qhfsDd7foXWH+fRatY47vmLG6T7
         s4JMuCDZW1XdPc12QlPKTrN+U1xIJoIf8axVUVNXUj0TZcGbLg1nCScqb06x6lFzIQUZ
         yIA9u+FLzJ0rYA3Jml6LVy20yecbZ8vOUGtMyajNVIl05zpQn0bQUHxtY+4lPQ8C8IRP
         qqOZ4PxLLs5usCofWh3x37LnV+I5vQVOy8OSem5E1gelT4todnlPgeTFBtLFm/Bektyg
         D91Q==
X-Forwarded-Encrypted: i=1; AJvYcCWdIt3DdyxcopMQ6W120pTW42Mz9bg4bZhfsb2mscOASJ9ymJmpEkt4Adkf7TIfOGNiAfeJ0QTNICqcXQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBOXsD8S2H+cIrao8MVZXYyptXcfa0hr/8LgD4GRc+/qgj5Rv4
	0feA5bYR2dQJ7mUK6UiWv6lUkzdI3IQfmbeyHKxOQRIt5489hBpTbLkmAfaW/VekYyulhsF9vKY
	dLNUyvIOsZ5/U
X-Gm-Gg: ASbGncuclcertTZKNaQFu8djz+U7mejSnd1y0yTNYjUAxpmF0q8xtoljAJcnOMyTiBI
	7lPWIvJGurW0HtHaqcfJRNhtMeF5OOyNKmf7LECXwLWh3YBpm30LllJC/3qIxyjWmzC1ecA9Q7d
	jTUm3dLwHjsuHCoZuCuhTtS0iFPEGG3Jvn8rBHFDNUz0iq7Je8qRMg80ZdZEp7hcSBs7fo9WdX+
	8lfnRPNWaoLkgYNLAl9K9nbbhpebGE1LGkhaFTdpdtZxxJK0IHLKTFnO3qP9EsSI7o6h92sBWT7
	xhWKRIwj1A4upjx3+uFPs9eVXFSuxoJgtwj2qikQgM9H6OTL1OZHUSQAVZDCrMzMGeltf6vvia3
	cLspesUPuHw8kBp8uYdRnBM+Wufsqu4sicODEwDJ1U+9FKbgN6i60jsShpJV3IxRSAcVwOdvC2/
	oxKdrw0feXcQhQ+PbPhp0nSSKdKuLY0kfMfce4SXS5/qDiCr2nDTotn9kmCI3U
X-Google-Smtp-Source: AGHT+IHVpoG1RYPG0Fo88j3DEV1z2Ax9xc3BWFe84CbZR5zOE94zc2qjuEfQYpMaSAgy5ZkutBnSVA==
X-Received: by 2002:a05:600c:444f:b0:477:7a78:3016 with SMTP id 5b1f17b1804b1-47a8374ce6bmr7128495e9.8.1765331016267;
        Tue, 09 Dec 2025 17:43:36 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:43:35 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH v4 0/9] Various dt-bindings for Milos and The Fairphone
 (Gen. 6) addition
Date: Wed, 10 Dec 2025 10:43:24 +0900
Message-Id: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD3QOGkC/23PzY7CIBQF4FdpWIvhR4q4mveYuKD0Mr2JpRWQO
 DF998FqYjLp8pCc71weJEFESOTUPEiEggmnUMNh1xA32PADFPuaiWBCsVZImkbdSkX93FIMmNF
 eKFdwYB68kq4ntThH8Hhf0e/zK0e43qqdX4+kswmom8YR86kJcM/06XPBDHkWBkx5ir/rUYWvj
 fe+2tovnDLaG9dLIcA63n15i3EepgD7OrKSRXwYzTe/UURl4OiN1UejmNpk5IcxbPsaWRnGuXY
 CvOed/s8sy/IHAZUpu3cBAAA=
X-Change-ID: 20250623-sm7635-fp6-initial-15e40fef53cd
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=3801;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=W8/D6Zte+WLuzj1BAkQdHKSbz78N81zx1LJo/v0yIRU=;
 b=iidJCYi5UY3L2gSm3zjrS8o9I3QIjjHa+ajT0HkiP1WdsM3r384T3hm3AJhYRmiDnw4wKu6cH
 yxNWjdO9eZ5Ab46KfOFpWdoij5U2fQS5w4/32PzBKqpbp5SpBTf2udJ
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document various bits of the Milos SoC in the dt-bindings, which don't
really need any other changes.

@Rob: Please pick up the cpufreq, crypto, and pdc dt-bindings, they've
been on the list since many months and weren't picked up by any
maintainers, so it would be nice if you could take them through your
tree. The patch for arm/qcom.yaml will be handled by Bjorn I think.

Then we can add the dtsi for the Milos SoC and finally add a dts for the
The Fairphone (Gen. 6) smartphone.

Dependencies:
* No dependencies on other series anymore

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
Changes in v4:
- Fold in PM7550 & PMIV0104 dts additions from their series, since they
  were the last patches of those series (Konrad)
- Rebase on next-20251209
- Pick up tags
- Link to v3: https://lore.kernel.org/r/20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com

Changes in v3:
- Rebase on linux-next, drop patches already applied
- Pick up tags
- Drop simple-framebuffer to drop dependency on interconnect patchset,
  will add back later
- #interrupt-cells = <4> for intc
- Move protected-clocks to dts
- usb_1: reg size and assigned-clock-rates update
- tsens: reg size & interrupt fixes
- thermal trips cleanup based on review comments
- Link to v2: https://lore.kernel.org/r/20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com

Changes in v2:
- Rebrand SM7635 to Milos as requested: https://lore.kernel.org/linux-arm-msm/aGMI1Zv6D+K+vWZL@hu-bjorande-lv.qualcomm.com/
- Disable pm8550vs instances by default
- Enable gpi_dma by default, sort pinctrl, update gpio-reserved-ranges
  style, update USB2.0 comment, newlines before status, remove dummy
  panel for simpledrm
- Link to v1: https://lore.kernel.org/r/20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com

---
Luca Weiss (9):
      dt-bindings: cpufreq: qcom-hw: document Milos CPUFREQ Hardware
      dt-bindings: crypto: qcom,prng: document Milos
      dt-bindings: qcom,pdc: document the Milos Power Domain Controller
      dt-bindings: arm: qcom: Add Milos and The Fairphone (Gen. 6)
      arm64: dts: qcom: pm8550vs: Disable different PMIC SIDs by default
      arm64: dts: qcom: Add PM7550 PMIC
      arm64: dts: qcom: Add PMIV0104 PMIC
      arm64: dts: qcom: Add initial Milos dtsi
      arm64: dts: qcom: Add The Fairphone (Gen. 6)

 Documentation/devicetree/bindings/arm/qcom.yaml    |    5 +
 .../bindings/cpufreq/cpufreq-qcom-hw.yaml          |    2 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    1 +
 .../bindings/interrupt-controller/qcom,pdc.yaml    |    1 +
 arch/arm64/boot/dts/qcom/Makefile                  |    1 +
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts   |  790 ++++++
 arch/arm64/boot/dts/qcom/milos.dtsi                | 2633 ++++++++++++++++++++
 arch/arm64/boot/dts/qcom/pm7550.dtsi               |   67 +
 arch/arm64/boot/dts/qcom/pm8550vs.dtsi             |    8 +
 arch/arm64/boot/dts/qcom/pmiv0104.dtsi             |   73 +
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi       |   16 +
 arch/arm64/boot/dts/qcom/sm8550-hdk.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts    |   16 +
 .../dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts    |   16 +
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts            |   16 +
 19 files changed, 3725 insertions(+)
---
base-commit: 8ebfd5290c6162d65f83f9a8acdbbf243b49a586
change-id: 20250623-sm7635-fp6-initial-15e40fef53cd

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>

