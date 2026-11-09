Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184481;
	b=fBafXbbEdX5F10/i2QANpcKppcXgwRWPZ57OoA4XCpHfJ/11f1lzP7cuyLt6/7eDBTau
	 z8FbXIPLoXiZ4ulh5cYZ2qMBOnb9za/Xi3XZ/7GFLxljqS/ApodkD2Pb6aRUQ772onCIM
	 6JL+4a3r3CSwZkpR6nsq7e9L19Ml7iBYpQwsNiLC7V2wcvgXKLCTt71cUu+Kjcbbir35N
	 DXCdD1NG3Q831XZcQyP0whoF/jHKHzWzFKLNUPUasCxm6NusYf86Cyi2XRJ2Wa03T8KaI
	 1XxzJwHwqpVCYCQFcA68z8SWjT/fcCQzz+WmfSzrxj2pVSnOdqIHp3vlJDVCbDoAQwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
	b=RAkZEPN+yEfYH8JNmr3XkWwsrTx/toTZx43LBuTL9uRa2SINviY3sflYVCjXL+av0yiZ
	 o1sBTBaZ8vP9W2762Jp3aUaCg5UNrGfyAe1Umq5AuvZeQ170j1Wu2IbpNUqVR4LZbR4iB
	 zNjrEhUOQqtB1CbtKibTrVPK1DaYncxxycgUHSc/10CBckVXuP2kinVxN9ILlkF4N+o12
	 dbL78e2RPk7TB2pyZT4LId8RcL1qqKfbl0wYoT/3yJINJofIrVUYYpqnWyEsFlaRJZsxC
	 I+PoQDHZ/Dbkzy1iSqQyDw7cuCe2TRIUvK98jM1xXTyQzoTpnpCQWAAyD2cv6JhBO3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IVXS0Dfp;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB874606D821
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB874606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IVXS0Dfp
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-49465892f7bso241836f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184479; x=1794789279; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=IVXS0DfpUIsNMmmlCVLQc/sr3m1dEoc2PxYn9Q1ZBDZgge7WUtw+jdTyqhCup5beuX
         p5UkKtqsdQor407ZN5+sThyv2nEYmcDa0uUa+CnKgMYC7zlI6qui62evwV2DL9VYinBy
         BarYqmMFrc3QEZTIlC8ssJP3XT4AbNHEFJZW9AzKMaUXkbZAhWMFSvOd7SRW3KD8cBll
         drhaytrMXaHy1ToVY72wpbCvSuNZPazRJo4cICaGRiht28G8IVeEueDOvEoNfrZLf8pw
         YGCplgziHwLWFFjwnfizo2aTCI9Yr266yhB2sLiV1K7bPAt2DOuj7ztQV7B0vgLaulZy
         apqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184479; x=1794789279;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=Wnzb/q6UDlP2IiVVwycy9g7Bws2ZCzL2qszPhLcJQl5J5BBjza/JNWpo10iBPNs1R6
         5GWZLamJrVwyHUGq61vXjdRPoAau+w5ZRmGDq0cxdA4fj0cSBmEcJLI6TQaS3vem2HAZ
         cVSqv524J063yL462n+N6WxG93GMDZy0iWF5656W5Wc+5x4bqNUJdD4hVoILThYOPIYQ
         lADEdmWwTYQcUrYSQhrItWnnb055xQ2DJXHhcscQImpVEJxK1yzwOgYDaDlMAFckjlmS
         dwsoub0xD2UiTBB+5z6bsY+8UuhCr3fRyAT/Y7xbBBxZOFRA0rk1IawxWiFUm0jk1AaA
         plfA==
X-Forwarded-Encrypted: i=1; AL+hErHL/citnXlydDa2FSr4OG4zL6uYxr5jAl/LM3PhIgS/6pMwVQnV8dpfkd03SjeCE5XhnrOdZiQy8fNDzCQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/d2VhDCE5ToCGuE7nb3MzVijX+c3frXw+zHa2YVvZLnSjdW37R
	9g4ONrRKHPtASBk4oeU6v44PsGn2GhZXPg16SCnlFkiPXOWBmFyKBZhz
X-Gm-Gg: AYBFou0M9KX452VhV6d6LEsipEg/biTXpxjNUcDBh+SoGuGSlfwk1kHIyNIx7LLYbTO
	yskVRJrDSTxYYivCInnbj6fYEzhhkoUgw/OAZfqGULP2fCDG5BbR0/MAb9tfcczRthl+5tZVaDt
	zLIBbueU82oUZjoVLcJdq9u4mRzx+23RlhZFy3c3+L/hX4dc+xohd4WHDnCd/JNsQ41n4d7arb2
	yOXTuQmkT2pVL2M7OoRvab2p/Oxe5/2Lj14c21k7f4D4zioFxi0h93c37tr2NOLlGryd2xWR9F7
	kaffLmFSSkk+PWdWflGrNBdbfv1D2ILKTDlM4vBrSCE4LzaOljaZ1GNN76Mbg3I5g1oHx5WHZRa
	RSJ36Yu/cSuOldtnJhB44U61u2fXY3O36F2cWwhP6/2fOBSMGXkoxMcnNZcWY3Dp71l0lrnYOw9
	t2zWhohkHlnqz82W5hvlFMQ/3BDBzHZSejv4gpzNcjg+bODe5XSmw9+PNcpUe3orD6IAH+9+N4S
	D6xvf3KJf6TdlkHvwI0W6rd+/KCIo2HJ7Fzwre/FsUEMYJmCCt2q2YQvpkMD2a/R012//mFj51W
	k+ebbIq69A/PrWWEAthb+wsZZhosQICiYy/xd/rD
X-Received: by 2002:a5d:6f0f:0:b0:48e:679a:4aeb with SMTP id ffacd0b85a97d-49586a3c015mr4911501f8f.3.1794184479389;
        Sun, 08 Nov 2026 16:34:39 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:25 +0000
Subject: [PATCH 13/17] dt-bindings: thermal: qcom-tsens: Document the
 Halliday Temperature Sensor
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
Message-Id: <20261109-halliday-dts-v1-13-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
In-Reply-To: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=829;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=QaX1Uqhi9JFBTyniSmrOqgkrx65fb+cn/pSnBpltl3Q=;
 b=Nal1T+ROAiQwIycyxEfKMIQ4y4aGW1L0uJ4HewmCRmGIZfSJuQVD6Fg2qPRcOrHnEpA/WiD2I
 u4aa5TB+J3JDBwhP4O82nlPD61zqIxNlRPMGwQQVcuKGnMJPv1tp6Q6
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Temperature Sensor (TSENS) on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index c78074fbcecf..3b440f395fe8 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -57,6 +57,7 @@ properties:
           - enum:
               - qcom,eliza-tsens
               - qcom,glymur-tsens
+              - qcom,halliday-tsens
               - qcom,hawi-tsens
               - qcom,kaanapali-tsens
               - qcom,maili-tsens

-- 
2.55.0

