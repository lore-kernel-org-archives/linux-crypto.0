Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54514C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3354F20772
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="skRpZ6uz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgGAVsL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgGAVsJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 17:48:09 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297D5C08C5C1;
        Wed,  1 Jul 2020 14:48:09 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k17so1828151lfg.3;
        Wed, 01 Jul 2020 14:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yx5C9IbCh6UxqSI6M2MmfQ5Bt+VI86VaCeOax5GWogk=;
        b=skRpZ6uzAavbXXgKa5pgcDzDSscSZA2jTVS4cfKE5WMoFy5aGuZTKxxpA/efp18UVZ
         YxDIYGnUMqpw68XqZrU4ayhCXdhE/RBAhUIIRiLZf7VuDuHG3nd29aKKfpX6eF0l7Jk7
         mpMGks+Ic1TQ2ggwE9dD4BNJVKmQKb8MWA+KYt5dAZqkE2xisb/fdS+3b7P4v630aG7E
         M81+/8md0B+d68rfYhd9dYoThjUMAMu174zGC8XDaIAAqQivjPTRNinxFP3AQD0e0vTy
         FByktaFnxE2n4tUN3Nrl/ULRj5hg1CpR9XQSKa0jYdZRHbhSFSzcOnGm6sanfpe3mI9z
         HrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yx5C9IbCh6UxqSI6M2MmfQ5Bt+VI86VaCeOax5GWogk=;
        b=a39OgSC7aX5pQjKtu+ziiTw5jAofwo0bKpr/mxcL5Li+7jt6yPgcgXCcABWthDvbNq
         geQo68bn4BTiNYjx8MgSuTJgBfyp8ZaGXDuYkifSL+ZjsqU9CUMZf2UcqEwzUrUFnf5j
         80u0jDg4ErKomqpDWyGNtzdMLkUXrfYtjXIHNUnuVugUjRgchkbm1oyP9C5ZgOOjkmMD
         MKwNKf7x/JarHZyvVcGbTPfYkXbZBNn1LObll9QVwuaDoOa3leqymC0vwFqYcIeXVbDX
         jvMRZpSV2xMs+ijqG6Rl/8tSSwJ/EpZEQoidtAAsmtYp/P3g8Vn6uzgbajAIC3zXh/zN
         8ckw==
X-Gm-Message-State: AOAM531M68MNU5fAD6DnlKXeuipCVay9mMmp/pQ15yngfuJMfhIWnzRD
        tHq7qHrRdttw/lUMo+ilEG8=
X-Google-Smtp-Source: ABdhPJw77kGBwg24cE7SpCT3b6UBF20pBJ8fzxNdijqMVq8hycUKWaav9wR4+veojUW9fMCE/Cjoww==
X-Received: by 2002:a05:6512:6ca:: with SMTP id u10mr16825434lff.184.1593640087713;
        Wed, 01 Jul 2020 14:48:07 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-241.NA.cust.bahnhof.se. [98.128.181.241])
        by smtp.gmail.com with ESMTPSA id d3sm2476812lfe.93.2020.07.01.14.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 14:48:07 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] hwrng: virtio - Constify id_table[]
Date:   Wed,  1 Jul 2020 22:09:48 +0200
Message-Id: <20200701200950.30314-4-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

id_table[] is not modified and an be made const to allow the compiler to
put it in read-only memory.

Before:
   text    data     bss     dec     hex filename
   1746     192       8    1946     79a drivers/char/hw_random/virtio-rng.o

After:
   text    data     bss     dec     hex filename
   1762     176       8    1946     79a drivers/char/hw_random/virtio-rng.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/char/hw_random/virtio-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 79a6e47b5fbc..a90001e02bf7 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -195,7 +195,7 @@ static int virtrng_restore(struct virtio_device *vdev)
 }
 #endif
 
-static struct virtio_device_id id_table[] = {
+static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_RNG, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
-- 
2.27.0

