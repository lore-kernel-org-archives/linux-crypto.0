Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4807FC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2213920828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x9HU+92+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfF0K2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:23 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34278 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfF0K2W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so6715922wmd.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=38BYhMp+Qqctzgii2HzkxX6b3+ad6JE63d8OrKpU3XI=;
        b=x9HU+92+YRSlODOqR3JQBAPBD4lpOxUVs9sF7rp4FOZuodLWSHl4MoDTQZ/h/9FeD8
         repxIWE33NkIcBOIlDLWz0rg+MBcU5eUfQli1AvJ72r2BEu0tTmNB1bLmX24lSpQNMD0
         I+7G36/VCOgfHHbg68wiKw8DQe2kJDb0U8kAWOEiSZWaQGvH0/l7UhXLSev2eZPvcgTS
         pdQ7BHz3QjhnL/fa8mrFHo5LGXo6Z+qIubK+JXYm2WAp/f7GdjxJKiJUtlwonIT/Kr0l
         wZ6qrj284z0uXe1hAxt7XOs74xyeZv94EDA++UMWNyQPhvAW24LMRAYU+sNX385NnxoQ
         2M4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=38BYhMp+Qqctzgii2HzkxX6b3+ad6JE63d8OrKpU3XI=;
        b=o2BS3FKEDBuF7nkUMqUt97ZNrrLmd5fxhYYQ7KYFxTOeS78cWKjr3TqYb52NCTsb54
         8TdyH8uZidtQri2iueX+eqN+Z235GBjdlLNuF3C8jsE3iKOI9wUqYG30AbTQ1UeamIve
         MtqzibrKQSLUakO8E153cJh4R60FDTB+MkQULN4dIneJhIW/ZkVpj3akegSATdhKOPdt
         ynKbc9D8dBZd80atyK/FJ5bnJTIB41KWd21HWLT0bs7iXobUw21YEoR5nSsby4OJMv31
         qIlwG6n2aHRv2I+yoJJ3eUmb3QB4dzWFmhvGcalP5IHoz7c4tpDLoFgNbSQrLHQUAoaC
         Y7Rw==
X-Gm-Message-State: APjAAAWF9VWcRIBR4em9aH28D3vxk6wwIP9S8yvpERcDwP14L28y75HU
        qMWbahXv2q/hAobKI9U4tNCpWtLGA5E=
X-Google-Smtp-Source: APXvYqxaAKgzAYgy/u++v6X4PpBjdb0S4Qs6NcrX7zmP4jh35kMkv47B8u/FldlX0oTei7TDeaGpjA==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr2854853wmk.127.1561631299702;
        Thu, 27 Jun 2019 03:28:19 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 27/32] crypto: aes/generic - unexport last-round AES tables
Date:   Thu, 27 Jun 2019 12:26:42 +0200
Message-Id: <20190627102647.2992-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The versions of the AES lookup tables that are only used during the last
round are never used outside of the driver, so there is no need to
export their symbols.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aes_generic.c | 6 ++----
 include/crypto/aes.h | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 426deb437f19..71a5c190d360 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -328,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
 	}
 };
 
-__visible const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
+static const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
 	{
 		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
 		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
@@ -856,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] ____cacheline_aligned = {
 	}
 };
 
-__visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
+static const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
 	{
 		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
 		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
@@ -1121,9 +1121,7 @@ __visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
 };
 
 EXPORT_SYMBOL_GPL(crypto_ft_tab);
-EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
-EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 /**
  * crypto_aes_set_key - Set the AES key.
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 0a64a977f9b3..df8426fd8051 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -29,9 +29,7 @@ struct crypto_aes_ctx {
 };
 
 extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_fl_tab[4][256] ____cacheline_aligned;
 extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
-- 
2.20.1

