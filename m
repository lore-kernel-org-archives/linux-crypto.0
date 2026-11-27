Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780929;
	b=I9ARSreRO1GC9KXFydCAZOmyJMixvhFBt1Jr6b6AuwLa3RstZhxPWCFLctr6yVHdhJrI
	 GdmCzG7IJiTIn1ZRY/+mn5p1gZa4mptfoUHZJ5qvdXAkWjb/gdKLQsdzGtqIseLbl8JHb
	 kypi24nyGP+JSso7dUYopVLzXiftHrwl50rlchJiycWv0GUJTQyJgEX1JEhX9zTIDkH0c
	 RV9OWw1CjOJCwMs5nig1YLt9gQXQatHVBsLXY5V9syLXdKz07zC6Zhl+rrYoBov3kaDAJ
	 3nWF/+XvxhQL46H7DpmQ3EyrEh0uja2/g58SQpAGyI9lW0ekoQTHb76y6FInrS49Orw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=X5YVvV6vHMcU5kHSKr3HyFQG5tHJwE0SH4iS9jSSmfI=;
	b=F5VlOGZPcQGqaA+k+VunBzrPIGf1RiqQlP498VD8lFBtAYS5dSAKmYFQkVOIs4LzJwTZ
	 ciJcd/4ddgy2jt76cQfhDF1baePGYe9B6txMMYUi44hC08/aJ4rAcX5umBMdPmHEIYsFA
	 OlOLDLyeV00yny0UlGoKk0m/KI9kU8l+IN6jkL+j4ep+gGv3fx0S9z8zVN2Mdp7yBGhXB
	 SsxrsJiBuANUtPEKih7nFVqE+y1pY4mZSBuYZNv8prrBD/U89JbNWJguqgpUFAWACtg5J
	 hiKR62ipgVM0/yRP9+vDg9nLjM9iI6LWf+K1JXdwy75CILgnGWhABEVw9VSAZdAWPRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BNTGZnLi;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49014606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49014606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BNTGZnLi
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-497614c95f0so4574053f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780928; x=1796385728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X5YVvV6vHMcU5kHSKr3HyFQG5tHJwE0SH4iS9jSSmfI=;
        b=BNTGZnLi+nuoqEAUzLgrNo7Oy9isPiKJMMljUrMwoCTuau7ce6UNgXegXzXBs0iorK
         lnWHfVnP97mIv+91kT3kK/dvWxjNRO70eR+zZQRR31DgBtuH7tmhOq93LwA9p6pUHtVh
         RrCqjHLvyt9HIP+N5M0huvUSZl+PNf5pANw2O6SFIuthC5bwFNM0CwM2krpfSLf9iv7A
         GhaewoB/n4iWHosBwojXM9brEgDA6MdElr4cfnKSrKTzLWuB5qrm2CZ8JxTSaniy0Ld0
         rTAbu0eIie/fYeoou0PruDtvkHMhn7QQ8WfYKC+UqP/OKg5aymmtUKHWY/8I4m3ccW57
         N7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780928; x=1796385728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X5YVvV6vHMcU5kHSKr3HyFQG5tHJwE0SH4iS9jSSmfI=;
        b=r2nMMGNNEkXrSiG6ZlED7sLaEPIRp+1ocyIsPY47+x2//uowKZoca1SplsaIA84/3q
         jazBd2qDW86EJW6x1EzMI9MvNykAiiOflr+FRCakyrSHPNk8L5TDyK//Sf+gu1mkCUNe
         Ut4doryDS1mSEmLFxA+lvofJNyvMFpmJjGfdxkELJQSGibcueZV1DsITt/1RpgR0J+BK
         X3C19A4kXYVL0P6yU4gTXYChAVwQU86hFiKNZs89RyW94RKaTJqy9wnx3kmWxYNp2a8R
         KKFMSHa9jZfyhEP0+vzrB0GvBJ8avD4ztCLrB09ROCw+yY29xxCC+YMYwcjQcvoQSh3W
         vTyQ==
X-Gm-Message-State: APuU4Z9N7KupjOznifqAkRzJ5InRykWkWL55x8Kk7V94DV1vbF/8I+H1
	Trhiuw2hK+CzC5PvF+Xe01BOFfQJfUGTBkKWdUGW5BcxLez3hs/ZI4PK
X-Gm-Gg: AZFdTZdu+XhQ822aHwGCHBuMCst89LPsW3I+xqujgnXrnfPx9e1UYQ2jGCiHuj37o84
	2SuRd1ZGu+DDDSdscoFR+tIRRE3sGLz94rxWKDCHlWNOrPD1//r2wmCPOg/tCNMTBfVbbmyckYZ
	5ufBhWvUJeL3O/tk+vIOzTSw68gqwbMi5zXpHh8sqyuJw/5bodqmRv6NHv074BrGz31X12zbKPX
	P8DmEowzSKSZun7IY48jJW3KU6+HSWk/kUrYKJIdAjwqXY/hwP6x0H95ZoIU0iNMaSxc6qvITMd
	xQYUc1DhXplm+WiJlQTz8MLj3e8oh72/QJinphLyDqvUFVlwpjs93PXvm4CBJgMDBgPy4EWRK9+
	p5Y/xok9lC5f8E8/Mcl/cXp+s2hXv+vPPRNW1FxgqVywTq49eUMB1lPx2meoIaEr4tPdeBE2zPn
	LW3M0JTg248dhlnQCZHx/wPHxEmnthFMDqcNzaSHDxE+ufwdNvgnlayxgIAQe5oVi1Q6hrIrLS9
	vLU6HAksTwglBX0BhuJbMSjlfGw/+m9j5rttAJ95mdB43XGjeuZev1Kciy3Ap3iknn4yYEacELf
	KWsiZG9qvQWkKLPNA8d2iAETSz6cx1/1szhp5JH4yZgtciM=
X-Received: by 2002:a05:600c:848a:b0:4a1:fbd2:f689 with SMTP id 5b1f17b1804b1-4bb8880993amr464473645e9.7.1795780927493;
        Fri, 27 Nov 2026 04:02:07 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:06 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 27/30] crypto: amlogic: fix probe and algorithm registration error paths
Date: Fri, 27 Nov 2026 13:01:00 +0100
Message-ID: <20261127120103.1532882-28-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

Fix error-path issues found during review:

  - meson_allocate_chanlist(): propagate a negative platform_irq_count()
    (e.g. -EPROBE_DEFER) instead of replacing it with -ENODEV, and unwind
    the
    channels already allocated when getting or requesting an IRQ fails.
  - meson_register_algs(): clear algs[i].mc before calling
    meson_unregister_algs(), so the entry that just failed to register is
    not
    unregistered again.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 8ce3f6640753..c11d7d8250ea 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -106,7 +106,9 @@ static int meson_allocate_chanlist(struct meson_dev *mc)
 	int i, err;
 
 	mc->flow_cnt = platform_irq_count(pdev);
-	if (mc->flow_cnt <= 0) {
+	if (mc->flow_cnt < 0)
+		return mc->flow_cnt;
+	if (mc->flow_cnt == 0) {
 		dev_err(mc->dev, "No IRQs defined\n");
 		return -ENODEV;
 	}
@@ -117,14 +119,18 @@ static int meson_allocate_chanlist(struct meson_dev *mc)
 
 	for (i = 0; i < mc->flow_cnt; i++) {
 		mc->chanlist[i].irq = platform_get_irq(pdev, i);
-		if (mc->chanlist[i].irq < 0)
-			return mc->chanlist[i].irq;
+		if (mc->chanlist[i].irq < 0) {
+			err = mc->chanlist[i].irq;
+			i--;
+			goto error_engine;
+		}
 
 		err = devm_request_irq(mc->dev, mc->chanlist[i].irq,
 				       meson_irq_handler, 0, "aml-crypto", mc);
 		if (err < 0) {
 			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
-			return err;
+			i--;
+			goto error_engine;
 		}
 
 		init_completion(&mc->chanlist[i].complete);
@@ -169,6 +175,7 @@ int meson_register_algs(struct meson_dev *mc, struct meson_alg_template *algs,
 			if (err) {
 				dev_err(mc->dev, "Fail to register %s\n",
 					algs[i].alg.skcipher.base.base.cra_name);
+				algs[i].mc = NULL;
 				meson_unregister_algs(mc, algs, count);
 				return err;
 			}
@@ -178,6 +185,7 @@ int meson_register_algs(struct meson_dev *mc, struct meson_alg_template *algs,
 			if (err) {
 				dev_err(mc->dev, "Fail to register %s\n",
 					algs[i].alg.ahash.base.halg.base.cra_name);
+				algs[i].mc = NULL;
 				meson_unregister_algs(mc, algs, count);
 				return err;
 			}
-- 
2.47.3

