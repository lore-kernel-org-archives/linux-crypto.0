Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958A82FDC4D
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068863; cv=none; b=ovUk6j6BLmpTW4EbepUBWFzMylC0gpbHLR9ySnriFmfpMt0Db0/0MF2l8yKoQ5jQsEW4s+zhIfvzqZfPei3K9qyZSRLki+YSw5VHGWjqh2l/c4ahp+rKaB0VLAlgia8+VEm5kOKoc5eRZ1EdU23j77oTDyP1nWB+iKc35f2Z0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068863; c=relaxed/simple;
	bh=t5R4UW31UoUE7aHekeSNbKI9qdNJcDF4TdGs9lVlvwU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UQGq9Ta/cN0I9eKvvDpKVMlUHXT02RrVZu5BF0nUEWlImPIYZ4sP2iVlEd1XWu2mkMWE8aB6gOefF5x2MkIIqutxGYGAcSo5qd1lWL3HD92/Fwh9woGs9l3AdMoNnVDJ5hHG3YEYwxNs5jSFWnHK1AKHeJHiIexHgCt4lGqk774=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=nErYQFrP; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="nErYQFrP"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-3e4aeaa57b9so211317f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1757068860; x=1757673660; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GqjeSvXCrahhKJFKiSx2ZS2MamV+BQDmtkvvhQaFj0M=;
        b=nErYQFrPLnzJ0M837wBnQPML0jsbi5TPv3oemfRLLWRNEqxOfLUPLoJHLz2m1Z5I8f
         D3XlQpk17/+ID2Sov2g1VyhbtqAG8LrMuuSgY9ef7SopGhX3r0NukZadHnCDXDblPkaD
         wT+uIKVHupThisXo5aSbma/O74JK/worJFX+t5pO1bF5F+iGQ/WV4OfK8OcrDf0wxubR
         Rawf8VLL4YpN7XIpf0bGEtAUvxCaZlrF7/KedGzawNWM8TF1wlTm+Ark0aNhnfEd+ucu
         2PUZPLnLgDtcGr5O2n/8mneAcimvVAGAYjd1v2NLuJ9eiM4XRdVPBUk+nig2t9z0og8c
         ue2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068860; x=1757673660;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GqjeSvXCrahhKJFKiSx2ZS2MamV+BQDmtkvvhQaFj0M=;
        b=aunj8m6dzBUHaZAVt5ZlupB1Q5/kMqcEU2NEUUDa4f7bH3fiJ8s9FFT+wpDjoWKPZv
         +srBZMkmbqIl51b0y3Cg9jU6SF4nCdLA9oeNiAxVlo3WcXTqwB7mDHwtLNHQVuU9yH6l
         cllGJdmjOJLjYXEl7yU54Cp/ZKtKk2G+VrE9ixWj2IR+2urQPmQePy5KlasId6dFXjI+
         0MPcIMd7xQDmw0AC4ylan/xx1QL1/hzC3JpU/kjDssygPjiyS3/4lexZwj7fR0BdpLSR
         ckCPAWQttem5VqSAn0Jy01mD79NpMAipB7nm9CoQhmkAmXZ0cQluG0WADZmOTJovkeFw
         Y+jw==
X-Forwarded-Encrypted: i=1; AJvYcCWZkbLzO4kaF+r6lFBJU5VeagVKrphUPbIIIKxK5j5qsTank5v5TH3k+QzMXbGZAroUA+TTuZHMvB5xG3g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+KfpDhOEq2kbk4M+m33sqpk7CBC/tCmADsTrg4ajWbO9+7JoE
	xnQcZk254v5Qam4m1zeGEerQBkreaZXoMA9fucoYUUJdQcxWN4ovHm+i/C+cGrh/6e4=
X-Gm-Gg: ASbGncv7ImATKx6gvqYCu6j2HO3qHfdh212Izx/qGdSt2VeuMraYnHpKDoHud5KHmlE
	2pG+hvOIrgqNTAud9e2pjlHvy8vH3XXGH6v88aMnc5vVWZX6FKH7N2YAl5BB0IxPY/STYQQtG7n
	acI1SIIKTft38uz7j47uGduFcDsEQiaur+HIHLDC86wS4ERCItATNnKifHVTefMhr55QoRv2Ofs
	4tqmzYK/70wWwxafXQUiWe7eDfhcH+L0CDAmtgkrcX+LgiWPBUJ/5kNHG1xpC4pbwofDb2g6i4L
	AXmdfhgIuvAhRGT/MMGK1FPSZzss/CBpY53tra5AmInqqSsFLGXEnEI7NLxu1QuW2KbBe7BkSk8
	fmG9WnLUlBP5QWHSqnWA4M9s75SPfZX/SXbcmL/WC2xGLa+aIudQVAPQHfdXJVgynq0iJWMlC4J
	0o+k14wpsL5hNFt3KycrzDNj7ZYkchAg==
X-Google-Smtp-Source: AGHT+IGACoEn/nbo6e2DyckGACB/CNW4OVzXkDG8m1N/cYcO1zHIfjpCrYFjRtT8AHuW/9OW2nHiOg==
X-Received: by 2002:a05:6000:2185:b0:3d1:e1b1:9640 with SMTP id ffacd0b85a97d-3d1e1b19c98mr12582044f8f.30.1757068859889;
        Fri, 05 Sep 2025 03:40:59 -0700 (PDT)
Received: from [172.18.170.139] (ip-185-104-138-158.ptr.icomera.net. [185.104.138.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm20990738f8f.3.2025.09.05.03.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:40:59 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH v3 0/7] Various dt-bindings for Milos and The Fairphone
 (Gen. 6) addition
Date: Fri, 05 Sep 2025 12:40:31 +0200
Message-Id: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB++umgC/22STW7cMAyFrzLwui4oidTPrHqPoguKojoCOvbEd
 o0Uwdy9ipMiSBptpEfwfQQe9TSsujRdh/PpaVh0b2ubpy7cl9MgF55+6thK14MFS+CtG9dr8I7
 GevNjm9rW+NdoSBGqVnJShm68LVrb4wH9/uNFL/rwu7O3l+Ib+nx6BcM/8KLXedPbMss6GkyFP
 ULEHM87Hmze5HIYS2DwKpoMaIiI4iH3d9WoWhxwsUixug+u3kG+dxqWxFEKRYci0SraIo4Z1SO
 DTe9dmIwjcsgupJyzBJ8pSyo5FbXFcr9dDELvXSpBDBSxhJlspX5CdQCg5J0EMpZ9KBg/zBKjv
 s9KFJNiTcCQQlAjJZFFG6jWjFn42ZV51VHm67Vt59Okj9t4xJmAhufgL23d5uXPsdzdHMm/xk2
 f7XE3I4wlSXHWKovJ3yq35XaZJ/3ahxzI3b5hgvn0O+y2YzTWxCEmAvoPc7/f/wKRA4eteAIAA
 A==
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
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757068857; l=3748;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=t5R4UW31UoUE7aHekeSNbKI9qdNJcDF4TdGs9lVlvwU=;
 b=mjMaowhNsly/zEKdyzh/hul06MF3DpyjaK7gVEMVYiaf6Ivc6lj6N3MeRPBWNYHmfJrRKlB8f
 v04JNynDydODI94kqZ4CMNQym0Bs1p31FHxAA6xv4IM8oxlUahGV10C
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document various bits of the Milos SoC in the dt-bindings, which don't
really need any other changes.

Then we can add the dtsi for the Milos SoC and finally add a dts for
the newly announced The Fairphone (Gen. 6) smartphone.

Dependencies:
* The dt-bindings should not have any dependencies on any other patches.
* The qcom dts bits depend on most other Milos patchsets I have sent in
  conjuction with this one. The exact ones are specified in the b4 deps.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
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
Luca Weiss (7):
      dt-bindings: cpufreq: qcom-hw: document Milos CPUFREQ Hardware
      dt-bindings: crypto: qcom,prng: document Milos
      dt-bindings: qcom,pdc: document the Milos Power Domain Controller
      dt-bindings: arm: qcom: Add Milos and The Fairphone (Gen. 6)
      arm64: dts: qcom: pm8550vs: Disable different PMIC SIDs by default
      arm64: dts: qcom: Add initial Milos dtsi
      arm64: dts: qcom: Add The Fairphone (Gen. 6)

 Documentation/devicetree/bindings/arm/qcom.yaml    |    5 +
 .../bindings/cpufreq/cpufreq-qcom-hw.yaml          |    2 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    1 +
 .../bindings/interrupt-controller/qcom,pdc.yaml    |    1 +
 arch/arm64/boot/dts/qcom/Makefile                  |    1 +
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts   |  790 ++++++
 arch/arm64/boot/dts/qcom/milos.dtsi                | 2633 ++++++++++++++++++++
 arch/arm64/boot/dts/qcom/pm8550vs.dtsi             |    8 +
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi       |   16 +
 arch/arm64/boot/dts/qcom/sm8550-hdk.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts    |   16 +
 .../dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts    |   16 +
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts            |   16 +
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts            |   16 +
 17 files changed, 3585 insertions(+)
---
base-commit: 87a9e300217e33b2388b9c1ffe99ec454eb6e983
change-id: 20250623-sm7635-fp6-initial-15e40fef53cd
prerequisite-change-id: 20250620-sm7635-remoteprocs-149da64084b8:v4
prerequisite-patch-id: 33c2e4cd2d8e7b9c253b86f6f3c42e4602d16b7d
prerequisite-patch-id: 0688b95e4ac7b2f042023a7cb09e0d8cb7929bb6
prerequisite-patch-id: d7a06ece910e7844c60b910fe8eed30ad2458f34
prerequisite-patch-id: 9105660b1ac9a8cd5834cc82e42dc3aa4e64a029
prerequisite-patch-id: 49135534a379bbbc76b5bc9db9de2d2ab9d387c5
prerequisite-patch-id: ec7c10dc254b52f55557f3000e563c7512a67d48
prerequisite-patch-id: 4c1e65349589e4f90a0977e1cd9524275ffb4bca

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>

