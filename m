Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5725C39479F
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785438864; cv=none; b=m9naZM5h2CRuQ5z7HZAQfWX30hZkz8O3qIOSO8BGhWp+3sF7eFXRy/jctPCjxrgNGsmduU9smTu4HK1HrZ0GMrjn2OedzL/yTEyRyUrKI04rlQ5p7FfrWbfg8dq1L8lq15ZlTb+KIrvgwqXfrcfRwEOxYPqiGhpxxvncNRpyd0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785438864; c=relaxed/simple;
	bh=Al41u0D2pnJS8WocszBwWiSEn2YksALdmQcPmnCVh2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XSXFU0NqbIzY8bj1+5OpIubOr6QdNTwU7bvd1UcXriEukjWFQLr+h8JsWUIW9bvMt7tozZfVMiCFlKP17EfK58tOoP6OCyBgoJREPPVA0sNyK3ZKWtiBAvyjTLlTl6umw+w4ICstK91BxtxS1bqjujnxgHIhAZQ5E0RnGtyaV3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r3q9OBP9; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3q9OBP9"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caed617615so1724895ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785438862; x=1786043662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QPVJbWuKxr05NUtfKny0+sjUmegHOFlNmdHQ6QVfAkg=;
        b=r3q9OBP9LHgUhCm8VJVc3lzD8MPzvy844pz6X32RSLYl0kalSMZ1KRJeOabtTZh10T
         YEiApqP+wpe1GMMOCNao2tesnfhj0mJC3JeV/dhaM1RLj8vqjFZDhUIBlwXNAZLkui29
         9watxnwZ9w742g/7J4/ZCsPP1xZddYISy/WDhVXJMV0fj2af9laHe8CHSkI8biM4vtR4
         dQEa61DXfJEEUNe/jNAAl3ood2ts3hm/BsClk23derkq/MVuGdgHxesAQ//1sRiKHNzB
         t0QfaeDVZukGexS70WsB17lSXJpfdoHO3yXW3TKeHaELigg4QSBxyh6udcKKjJ3qKH5v
         n9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785438862; x=1786043662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QPVJbWuKxr05NUtfKny0+sjUmegHOFlNmdHQ6QVfAkg=;
        b=DvWDsEzu73CGrkJ3ghjsNg+pixoQm0zKGZ4x2IMneq4EawymTkkR4DaLFdvKMFnMDy
         ao/pwY2Fl7YezQHgxexRv7P3zkSc0hUSgRIhgzWBAC4tG7MdNS3z60LXvIhlAXQFa/72
         +HoMq2Ixpzv4ZCMO3WpMhbDFe5d2/VYM0MOFJIky6N5nOJKTbv1qwYqa8B7nT4dLtt1T
         KdFWIv73061GCjoOZjn8ecTPPziY5f+LMlCRtRGj2r47RczxpY2otZLt/evkwPdw9E86
         PeMHGLzhQnbciZjGrP5slFgcvL44yygKj95KWRhm3HmpyxMDTEPcEHkgO1rdj9n5BNcr
         YJqQ==
X-Gm-Message-State: AOJu0YwLoSKqN6Z3PRkrT6HOcpp9GwaSv4UzpvPZz9qKEZdtB+9+6n6n
	J7luxbDXdaHc4nEsJPZQZCyuwyFNwgLEnGutvinc+5RzGgGy8eOUhyA/4AXAoHct
X-Gm-Gg: AR+sD12UnwZEXBE7hxqkriWWny7wZmvdtBBAPrjRYnmfjmzlil3BeAYpcbrrXfM7P7f
	NWHKhXFWmksOp4+Cy1DqCjyJLPgQLSs1CFFVOeZDzABkSH608ywy4bVPzdocWTlp1bA2rJX5Ux2
	p1YW2oJtEEIGxYUXdc0Q6cZlsIaNTLaNGPJH9t09vHpiP8oCIPZxwWTis99OKd6RmGlx5238WNa
	xshafAuSGYZ0xssaae4ihyrT98vsmUGCZOJ0E8s9XQZtDHbYOemVrjA7JQbPYnn1+uvSOh6ymZy
	MMVhb7xbwXFY8dwRR1AjKP7UPQSVr7eThWflw8sEM/oDEdqcPKnttAA8AylWjTxphf0hlTK67dz
	ZB0BoJLY7A3s+qNaZ70lKfkAq4Tls9F716APUXa9ybgsJJPXRLSL4Mu6tgbogzb1Q1G8TPRA1J3
	2w9+7ba6th4g/q7DmR2txKWKPinsV0tAUMVDaoyvPvrZyc7TNu0v97VsxRnoSJM4N7jayIV6DGl
	5OIvAoVRUgBf53uh9/ribRNR5gvirjoR2RF+XdLOy+UOhnzJRIgXtOYyxDc3u5OpXnEOAJMD5ev
	EO+qB4rvjB0CIy9v5qddxv0JP1oV9eAUQO23Fg==
X-Received: by 2002:a17:902:f601:b0:2ca:329:3da1 with SMTP id d9443c01a7336-2d035c4d126mr35655755ad.16.1785438862471;
        Thu, 30 Jul 2026 12:14:22 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c50f2asm30755595ad.82.2026.07.30.12.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 12:14:21 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc - fix racy teardown with devm_request_irq
Date: Thu, 30 Jul 2026 12:14:20 -0700
Message-ID: <20260730191420.1043871-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver uses devm_request_irq() for the IRQ, but cleans up the
tasklet and DMA rings inside the remove function.  Since devres frees
the IRQ only after the remove function returns, a window exists where a
pending hardware interrupt can reschedule the tasklet after it has been
killed, leading to use-after-free of the descriptor rings.

Fix by switching to plain request_irq() and adding the corresponding
free_irq() calls in the remove function and the probe error path before
tasklet_kill(), ensuring the IRQ is fully torn down before the tasklet
is killed.

Rename goto error path to err_tasklet as that's more descriptive.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0271b5e4d923..fd010bfb7020 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1294,14 +1294,14 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	core_dev->irq = platform_get_irq(ofdev, 0);
 	if (core_dev->irq < 0) {
 		rc = core_dev->irq;
-		goto err_iomap;
+		goto err_tasklet;
 	}
-	rc = devm_request_irq(&ofdev->dev, core_dev->irq,
-			      is_revb ? crypto4xx_ce_interrupt_handler_revb :
-					crypto4xx_ce_interrupt_handler,
-			      0, KBUILD_MODNAME, dev);
+	rc = request_irq(core_dev->irq,
+			 is_revb ? crypto4xx_ce_interrupt_handler_revb :
+				   crypto4xx_ce_interrupt_handler,
+			 0, KBUILD_MODNAME, dev);
 	if (rc)
-		goto err_iomap;
+		goto err_tasklet;
 
 	/* need to setup pdr, rdr, gdr and sdr before this */
 	crypto4xx_hw_init(core_dev->dev);
@@ -1310,12 +1310,14 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	rc = crypto4xx_register_alg(core_dev->dev, crypto4xx_alg,
 			       ARRAY_SIZE(crypto4xx_alg));
 	if (rc)
-		goto err_iomap;
+		goto err_irq;
 
 	ppc4xx_trng_probe(core_dev);
 	return 0;
 
-err_iomap:
+err_irq:
+	free_irq(core_dev->irq, dev);
+err_tasklet:
 	tasklet_kill(&core_dev->tasklet);
 err_build_sdr:
 	crypto4xx_destroy_sdr(core_dev->dev);
@@ -1331,6 +1333,11 @@ static void crypto4xx_remove(struct platform_device *ofdev)
 
 	ppc4xx_trng_remove(core_dev);
 
+	/*
+	 * Free IRQ before killing the tasklet to prevent the interrupt
+	 * handler from rescheduling the tasklet after it has been killed.
+	 */
+	free_irq(core_dev->irq, dev);
 	tasklet_kill(&core_dev->tasklet);
 	/* Un-register with Linux CryptoAPI */
 	crypto4xx_unregister_alg(core_dev->dev);
-- 
2.55.0

