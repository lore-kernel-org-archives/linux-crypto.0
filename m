Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B9C364025
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778823751; cv=none; b=npOthrDgr/YwRz+xjJNNzgZiVK6CJE1khqRKXBi4RmPXUdqqOWyPua9FcrxGH4ISrFc1FNTCQCAIc80f0r1gU2n+IT1368t4Ojiycm/IH0rd/DIIzp2l/NKB+2tiGrkBTVHQP96reFRcVzpPF/Tuz5rK5gRXC42/J0+neL2XeGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778823751; c=relaxed/simple;
	bh=aVdFf5OymMVSZ4KFTnooyC2hd0qHH4hvBzmghV4dLpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvTnqrUNI7DuqXq1kbs7kxPXo2EPJoDt5VlzjmI3nEjRbJtOshfDhK/dyVb2xHzGiM/IzzxNdBbU0y10kBqL3H5fnp3oC1lUM4bnyrdZoA1JA3iCcw8FVsm93B+IvC760iUPtTf+l4Ys5NaDYXU4GH4AkBqBBwk1wA44rCvR82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4zjnFXG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4zjnFXG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-824c9da9928so4357411b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 22:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778823750; x=1779428550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uA3KbxtyArVx1TPayII+4ue5MWymrrbmptjetuH5M+E=;
        b=P4zjnFXGHsF/eBNiA1ijEPqz/NFATd7mTH554p4nTpVHGlaiIPzSNPOmme5yz7k36/
         DpR+N6STAkUWLTeCPyD/lw6+zaxnuRujKlOW9C/Mkk8GC2CGSCTTQEQ97eSY2tQcYWUJ
         ZQnYF1HtCwdD2QRW8eNCHv0gDugHAcmUGi7FOAPubXii4tDsSTxtzhEPxtSKK8YwhQhg
         ZgvtVdaNIo61i+GjMueX74rfcfVleUAT6JuR7FrXQd4MMDwJDhQ4Ghn3AN4a+drWzJdB
         mPQ9mL55ufgPy3oqpt688fTl8gcE0PnrU8Fm/9F3nkoe7CQ5j4byS8klEGelMiWokk3w
         Gvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778823750; x=1779428550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uA3KbxtyArVx1TPayII+4ue5MWymrrbmptjetuH5M+E=;
        b=UH9qat2etISjQUEw1dff/A4A1pZBBNffLPJmgQQk02yqUrmIFTyCc8s6JxvXNPOAdS
         CKrYQRSx5qSzKRGzknrasH2a/kPkWHcWM2VHHke/zGrOJxPBpFVyKAmR52w9fwHEPXnY
         x9dMXdgaFFKlGa0+gV3UkUFLgxSVLyQ7UGEkXLmwkFBPnwvawLVxsUXb61iEsEYK1BQ0
         ZYGqrmrf+awV7Bdj/YT+2WxTHQran6NRGpvpAA0u+TAXyB4fWuaQiu9+tjXFhErfvGk+
         2w6aiymvQMajv96a0OgsWjBrDVi/sajsBUQF0pjjVCiSErkdaugO8iztt2udG3+cqj4r
         4Hpg==
X-Forwarded-Encrypted: i=1; AFNElJ/1JjOngE0OU5jXHw2HNEf5X2aM58Pe7NdkFirbBC/R6d3/1bmttjvi6wjR0WvWu0XI1sbmB4Ahc+ThfoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE1Uo9hASWTAYn143R3Rn44Qjr+ILhOb2OF33rVIJ9YIQYac3X
	gyyrcu86DjcILKFZBkZu7pkn8Ci3QV38dd4Cj8i29+5Hv5TJp8X6rbFJ
X-Gm-Gg: Acq92OF+7fcTRYAa/Aw78p/ymsgyvpAbMr9nunV0JiTkmyyiutUri1h0gANXi2D5rSk
	S6a865B/5vhMvFKG4pHwszBQgVB6JcazG++QXt4G82RvzFtYb3ZJhJeWEhc8kbKm1nPx5cva003
	idTV4SSyb432DTLG8myL2Og6vjb5vRN26Wo5VjclBvTjvxtS5tvIn19bUufIk3b2pJodZzYphi/
	be+H8GlSbFxpkH0GCSBizx7N7a8JJKd/ZdUf+qSmYA8F4Mm3jqzb7PfjEJTvkkv4XENEu574MSF
	7hS/4EzfomG8KBXs5F8YHgOIdDKDyQLJkrpideJIuC/5WOX+jZvMuMWbU/HuLm5zXCmzS3BZ4NA
	ObKe6C2aUgUtieBsjn2xmdAEtuqIQykgV198rQEMFb5l+QnnTMAwVOlfiUkY+ZhaLOCp3UAat06
	VbL2IdtYR2vZ2HSfMpHBMGZ46mloBsRz6oRX9k2EGuECXIqc6A/3JOTGB4Z8audMDx3or7+/tQ7
	QZ2FCyCztfZGcCV4aCRMP3J+iY=
X-Received: by 2002:a05:6a00:2793:b0:83f:2568:d456 with SMTP id d2e1a72fcca58-83f33d277e9mr2723997b3a.29.1778823749726;
        Thu, 14 May 2026 22:42:29 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.wework.com ([203.117.161.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm3106116b3a.33.2026.05.14.22.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 22:42:29 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jikos@kernel.org,
	bentiss@kernel.org,
	luzmaximilian@gmail.com,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com
Cc: Douglas Anderson <dianders@chromium.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 1/7] dt-bindings: arm: qcom: Add Microsoft Surface Pro 12in
Date: Fri, 15 May 2026 15:41:46 +1000
Message-ID: <e54aa6c1e190b0e26d58504c5ea1b05fd09d64d3.1778822464.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the compatible string for the Microsoft Surface Pro
12-inch, 1st Edition with Snapdragon, based on the Qualcomm X1P42100
SoC.

Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index b4943123d2e4..aaa9a129908a 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -1168,6 +1168,10 @@ properties:
           - const: microsoft,denali
           - const: qcom,x1e80100
 
+      - items:
+          - const: microsoft,surface-pro-12in
+          - const: qcom,x1p42100
+
       - items:
           - enum:
               - qcom,purwa-iot-evk
-- 
2.53.0

