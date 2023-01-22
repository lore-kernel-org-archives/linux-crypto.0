Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0A1C25B4E
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Jan 2023 15:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjAVPrN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Jan 2023 10:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVPrM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2023 10:47:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C3918B3E
        for <linux-crypto@vger.kernel.org>; Sun, 22 Jan 2023 07:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674402384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=E6jYgjX2bdUMfo7qC2knF1fy2KORUnKc0O3IR4qBP1I=;
        b=MZN+OuCBr83G0nnTEvGOsTOfTCTnXjloRue7z5O/aeJbvGTgSnzFGK295y4t0LO3X5tLNO
        XZGjsbetsyfhBjRXjnyFSa/VyarfT5rVD4IJAurHAjexua7Rctn5Ie2c0ZaB120THcmFYf
        FV0jTFUovf1QszOgMxRAzWB3/TtOI2E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-vfrNIATxMnSaCCBMFqxBMA-1; Sun, 22 Jan 2023 10:46:22 -0500
X-MC-Unique: vfrNIATxMnSaCCBMFqxBMA-1
Received: by mail-qk1-f198.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso7252996qko.11
        for <linux-crypto@vger.kernel.org>; Sun, 22 Jan 2023 07:46:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6jYgjX2bdUMfo7qC2knF1fy2KORUnKc0O3IR4qBP1I=;
        b=fuImegUee5RUY0ZLeuQ1/LJxR7OzgPNUB1ESFxne+LHap7TbyEwP45qvYJJp0gzyOv
         woBHtuADbofTAqGcD8yW3VradZksZBF3AUKmMAf9MhZNQc0kpwg0fsXPLMCg5+oxx66J
         rfRlLp98vCL7a0dBqXSi4ehhHTYkjz1hp+BuQflmjR4NJkuAUcj3ffj6fVw/AQTDJQcX
         T5IVAiIRWayDsj8P+DRBi/lWMWF/oeQAPxnMMc1Ld6H7+7HVLXYO7aa8S/2JkZXRDeAe
         R9jVMhV3E24EnT+pFyGzDma91C+DLUZyshQAa2UmAmm5LvOtPEkPBluGh+mrG0RIDfTv
         gpRA==
X-Gm-Message-State: AFqh2kr031EP5CtDDuUmg1HKjPy4oOBMI7l3pYVP3Wk1iV9Bhmk7d8WU
        S6pl9lVnajIwKEZSg9k1m7KQTIPWGs3cRsmhl/PAlBcY4A1pqWnhSWvQUBU3zkRCbADsjrnGY8w
        I3bTJuhKExngbps64Ws3IYFr5
X-Received: by 2002:a05:6214:350e:b0:535:b22:d8dd with SMTP id nk14-20020a056214350e00b005350b22d8ddmr31727124qvb.5.1674402382068;
        Sun, 22 Jan 2023 07:46:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvzKqhaSc8ThZothYAnzF5/kTMB4L4BWs63as8xoBUPLzodub1dl0JsOxTCxYNPbqC2WLN7Cg==
X-Received: by 2002:a05:6214:350e:b0:535:b22:d8dd with SMTP id nk14-20020a056214350e00b005350b22d8ddmr31727112qvb.5.1674402381836;
        Sun, 22 Jan 2023 07:46:21 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id h8-20020a05620a284800b006fa7b5ea2d1sm29929090qkp.125.2023.01.22.07.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 07:46:21 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     neal_liu@aspeedtech.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, joel@jms.id.au, andrew@aj.id.au
Cc:     linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: change aspeed_acry_akcipher_algs storage-class-specifier to static
Date:   Sun, 22 Jan 2023 07:46:11 -0800
Message-Id: <20230122154611.504808-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

smatch reports
drivers/crypto/aspeed/aspeed-acry.c:606:24: warning: symbol 'aspeed_acry_akcipher_algs'
  was not declared. Should it be static?

aspeed_acry_akcipher_algs is only used in aspeed-acry.c,
so it should be static.

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 6d3790583f8b..164c524015f0 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -603,7 +603,7 @@ static void aspeed_acry_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	crypto_free_akcipher(ctx->fallback_tfm);
 }
 
-struct aspeed_acry_alg aspeed_acry_akcipher_algs[] = {
+static struct aspeed_acry_alg aspeed_acry_akcipher_algs[] = {
 	{
 		.akcipher = {
 			.encrypt = aspeed_acry_rsa_enc,
-- 
2.26.3

