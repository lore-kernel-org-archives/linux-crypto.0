Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F8A15E5BB
	for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2024 12:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726576748; cv=none; b=jYWb4K67Nhw6Tt/B7XmVnMd4D9RsOOCs5PkrNrzyi/hpg+LPBziTKvEGzLcK828e50yj7z2N3T360a9kfOPFbu11qOhyl5n0D+fJegCgHJh1M9TGLmA0e6oIzs6yPfTWOXFeGW045tpujIC6AjwCBHkLND3ow8ne5s4srbovj34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726576748; c=relaxed/simple;
	bh=148/lEGgmgGxbrTXtSWwdIBZ4Yuze3Yabt2s1Uo9KjY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IhVm+LI24TzuO4vGSTpaLoQr47PJwRTSRyHuFRGOZHzuU4Apun0ABBfyb9gdXijZMNb16Z3/LBOZaT6UI+3PGOh/Rgm7lqxSpdyOPWvg2ToAAovu5m9YmV3OpaRnEP5wxQaAHNfMNkNRIJfU0WS+HrM/IbAu+IRCLVX8BgIXdWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VcsVdfnk; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VcsVdfnk"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c255e3c327so7172431a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2024 05:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726576745; x=1727181545; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yz2qir9ddPeGAiVRdxv7WrzwH5Kt/9L2kVnL+tcULxk=;
        b=VcsVdfnkQZX//dHRC7IZY+R6eiwTC8FVx+jKFEQfxia1UtSCVvC+pW2j026QQxkiGK
         fdrlHEubkDrb18paFOE0bvDK1n0VEuYK8Ng+MBer1ADeuRtLf6dupusTJubzmACWGv1f
         NldmGGzRd+TTGH6KTFqz+RPlnBdJ3+2JcQ3ZRg6g6g9WLjUxL+iH3n90UmBt6J0+GdXI
         C6VDlm6EYbUskIgqPkk89NHVzSsSmp+oeCUdIKPLagVc97yf05IEQv9F7/Au8UO0k3Kf
         cqwmGUzqcFASsIEu3Fg41NJoqdicb8nNbHoosZClR/yret2IBJLNXpfmfkMBlsRTFA0t
         vueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726576745; x=1727181545;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yz2qir9ddPeGAiVRdxv7WrzwH5Kt/9L2kVnL+tcULxk=;
        b=P8Uwl45Uo2nFjDHsE0MytEAqrdcocbrl+FFHiDRQ/UnojGX7kWLumgFxMCEwgW/nYN
         xmp5Nwq67pwxhNSe/BuZaaLGdPR6n+CpYlQ05Tnvs5DS99kcpbxGACALmHnYekhdc1am
         EMQoet7H+JRR3Ohts61O7TvGR75FQQ+tGC8PWgZNRTQKaPmL3EiwJ/G14UxW8CEB/rsf
         wQG6saljdWiUQ+J0q0G43Xh94VCwSGDoyMLWVAk/AF8gmP9oW3SrDsGLYztPUrjGDyjf
         jfM40ZZsKOGuORPlJEnOFJn/DQn/kPWuuLSTjiFN1vatJ5/t03NGQjHmPuHaVfO3Z6F+
         O3CA==
X-Gm-Message-State: AOJu0YyLRn43dDo8+DyaBNS3jbzqz7+8kbjGv3GBci0auhS94zWlAF/Z
	BOgwdjhZF+mvZDWRE2tXJWS61plZHvRu6bAyF/Nuhm4dwhzYuFKOyZspo/HQ+Mk=
X-Google-Smtp-Source: AGHT+IECmxGumBVlRXvrBTW4hUFGT2ZndGSPGKd6LUX3PzShZtwbduSSstPVT6+ifgdxnZK5sCXeQg==
X-Received: by 2002:a17:906:c153:b0:a8a:8a31:c481 with SMTP id a640c23a62f3a-a9029615808mr2318964166b.42.1726576745327;
        Tue, 17 Sep 2024 05:39:05 -0700 (PDT)
Received: from lino.lan ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610968b9sm442738466b.5.2024.09.17.05.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 05:39:04 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 17 Sep 2024 14:39:03 +0200
Subject: [PATCH] hwrng: iproc-r200: enable on BCMBCA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240917-bcmbca-hwrng-iproc-r200-v1-1-58cf8a83ad97@linaro.org>
X-B4-Tracking: v=1; b=H4sIAGZ46WYC/x3MMQqAMAxA0atIZgNNEaxeRRxsGzWDVVJQQby7x
 fEN/z+QWYUz9NUDyqdk2VMB1RWEdUoLo8RisMY2pqMWfdh8mHC9NC0oh+4B1RqDMXIkctZR66D
 Uh/Is938exvf9APNRfdFpAAAA
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 William Zhang <william.zhang@broadcom.com>, 
 Florian Fainelli <florian.fainelli@broadcom.com>
Cc: linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.0

The Broadcom Broadband Access (BCA) SoC:s include the
iproc r200 hwrng so enable it to be selected for these
platforms.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 01e2e1ef82cf..84d46b2a44f4 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -101,7 +101,7 @@ config HW_RANDOM_BCM2835
 
 config HW_RANDOM_IPROC_RNG200
 	tristate "Broadcom iProc/STB RNG200 support"
-	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB || COMPILE_TEST
+	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BCMBCA || ARCH_BRCMSTB || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the RNG200

---
base-commit: 98f7e32f20d28ec452afb208f9cffc08448a2652
change-id: 20240917-bcmbca-hwrng-iproc-r200-dded11828178

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>

