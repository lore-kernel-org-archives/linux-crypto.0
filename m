Return-Path: <SRS0=xEWH=4H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1892C34047
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6975F24656
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="WG8TvWG6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgBSPvo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:51:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46517 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBSPvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Feb 2020 10:51:43 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so1065179wrl.13
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2020 07:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SxdCCnMLPzc1gk7NOaHqgh6xVdTLhPkejBZ7rXFt8JI=;
        b=WG8TvWG6SdqvPlkWHu1tYyS7atYkUmQ/2T6OOrqhei+src9ixS/dp2nmlmUYrtZCI8
         GLCnPV/T2pKb3b4s0yDajOrcgHppSLyWquybj2IubK6tZKOBL9M3ILbfgrwK+QP72rX6
         ODlII/frYI2Euy3C72TyeU41rjM72CuRpGym7Y4rKNwAvMIfKe8g1i9atC9G0urqTp13
         XMvK/O69EqeHhp7SgIM9AzPxCvVtsr8aC+E3IvE0MYznloVlLeQWduKwPzLesBjizm3I
         cYUseZdWTeI31GLYxXDar3dTlaGBOg+CeUUviX/CJjj0DGtXJdufE6v7GifjbvqhrxAS
         zxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SxdCCnMLPzc1gk7NOaHqgh6xVdTLhPkejBZ7rXFt8JI=;
        b=gr/s8mhK55A78tDbRuLSk5ZvJ2x4vynLbBLWvkwa/SzfsGwOxQoPgYBgw756+BFvuv
         McP5y26R2WaF9AZtICgNOUW16EAUKGg/KyIDVkc/AhuOSCAMG5gj9L/5HOvev1pKJg3D
         3We12jtODnCPOLRfGx+OxAABXl71dnZlKNfcTR/ahkq+g+qyf8gmgSVv6q8qUUjGd+fY
         l5hXL9Y+E0HZ4Cg7LfldZ8DnK8JzXN9GXyh6nIE+woR4h5BleS5vuRnOFY399BxZfMR2
         WxXaUbI7OAQxuUyplbq3mVEWFqAiYZMFH72l0d7en3GQ5yJ0apBWFQQsutZNFMQ11eI+
         JGAw==
X-Gm-Message-State: APjAAAVLnJo4UJs917cvMKos2sDEPDwaD5LBMCG4bsZugdxj53Nr1FTl
        1SRpImRf3UrsSHBxT9J4JkRt8fLHzXQ=
X-Google-Smtp-Source: APXvYqziXIqHYoIbx4t7/2B41O3tOH3T9OGsND8i6paWUysLrcMOXobTmO7+GXjQuKBFQQiBYqNH5g==
X-Received: by 2002:a05:6000:145:: with SMTP id r5mr10522854wrx.325.1582127501532;
        Wed, 19 Feb 2020 07:51:41 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id d4sm251578wra.14.2020.02.19.07.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 07:51:40 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: drbg: DRBG should select SHA512
Date:   Wed, 19 Feb 2020 15:51:34 +0000
Message-Id: <1582127495-5871-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since DRBG could use SHA384/SHA512, it should select it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c24a47406f8f..6d27fc6a7bf5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1810,10 +1810,12 @@ config CRYPTO_DRBG_HMAC
 	default y
 	select CRYPTO_HMAC
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 
 config CRYPTO_DRBG_HASH
 	bool "Enable Hash DRBG"
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
 	  Enable the Hash DRBG variant as defined in NIST SP800-90A.
 
-- 
2.24.1

