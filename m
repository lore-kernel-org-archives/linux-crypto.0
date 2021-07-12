Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB9EC07E99
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 20:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0DD611F1
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 20:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGLUsk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jul 2021 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhGLUsk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jul 2021 16:48:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30DC0613DD;
        Mon, 12 Jul 2021 13:45:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s15so29915945edt.13;
        Mon, 12 Jul 2021 13:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dDg6dKdVLJtJjWTE5YR4R8BahCCcS2EwH/pICn0zM0g=;
        b=VvA9gF1cQzfsFJJuZw2k6deH0TrKgAqzG7Lh3UsbcHfVdGVULX6QCCBcDJkyEzUz6S
         4M0lhD/f0O3zOV/qW/FH+AdiIPmjmsUduCXl6hYUHdp0jGxO78/bsxoJe7yL4u47uXAT
         tIbgGLcdyJo2USYyUEiAAC42fyPLUXRMCVa3JkgqjQ4V0cgkjc3wrkDUPdEYzp64M1/4
         kW+QcOi3Npa4jrni6tUvOEtIWOGIx/uQf0sSsamDOx8HwRbNEELxMo2PCR1eJWjfQjNo
         XuctAP+IH3aZE96KMW8ZiFzNDr+Jwl7oANfweKQq9/jpchIKc9rys4gkFmtEyMKvWiCa
         /JgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dDg6dKdVLJtJjWTE5YR4R8BahCCcS2EwH/pICn0zM0g=;
        b=uFRD2yGrsEjFTeQcKxAHvGrQId5fahUUNMCTUEIS54Y9YO9NtJ17PuLB7GqSxBOYhl
         S9eSbrf16awof7Vq3R75Bx3OYEF1YF3rL/4KMHa9BqlYbRalgtHajgEikwLTnyUvV7qc
         grLoB27GuPQVSXCmupMypWXEh3gxzNuJjJsJs9sPxjkTM0qDmpVAw35NDbj7QMxptw0l
         53g5z6DOf1/OSeMB2W6lx2F8OvuDVY+q7dQHVGgmAN+IRj0p0PYL9HsA9pnVNeXaJtYa
         yfoG0Yd7Ml1FkThjGvYFq0WVkh9bN3F76DAmADrJtdjrwSoEMyvkaPgihx43SUTjepd3
         8TpA==
X-Gm-Message-State: AOAM531aXxX44/AaSt1SXpNE/RzAbLYsTacBv1aeNiD7/7Fo+LtCnWxE
        XvKxD6bqtu0eJ/3Ba7PDdZ8=
X-Google-Smtp-Source: ABdhPJxTE8FRlr/SGGLVlQazu5h0rWf2qLy5L/iBr8vz6rqGAo+osxrbvsDwkpP/yPqJf49D1JCo5Q==
X-Received: by 2002:aa7:d5c8:: with SMTP id d8mr882407eds.165.1626122750086;
        Mon, 12 Jul 2021 13:45:50 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id p26sm6814303ejd.80.2021.07.12.13.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:45:49 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:45:46 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     haren@us.ibm.com, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] replace if with min
Message-ID: <20210712204546.GA1492390@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace if with min in order to make code more clean.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/crypto/nx/nx-842.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 2ab90ec10e61..0d1d5a463899 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -134,8 +134,7 @@ EXPORT_SYMBOL_GPL(nx842_crypto_exit);
 static void check_constraints(struct nx842_constraints *c)
 {
 	/* limit maximum, to always have enough bounce buffer to decompress */
-	if (c->maximum > BOUNCE_BUFFER_SIZE)
-		c->maximum = BOUNCE_BUFFER_SIZE;
+	c->maximum = min(c->maximum, BOUNCE_BUFFER_SIZE);
 }
 
 static int nx842_crypto_add_header(struct nx842_crypto_header *hdr, u8 *buf)
-- 
2.25.1

