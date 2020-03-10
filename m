Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E107C10DCE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60D30222C3
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="XM6cVLrd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgCJVFr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 17:05:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38925 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 17:05:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id r15so12639732wrx.6
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2020 14:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SxdCCnMLPzc1gk7NOaHqgh6xVdTLhPkejBZ7rXFt8JI=;
        b=XM6cVLrdy7hGwgekxhqJmCmOZg4vlJgbTgkwLG8gof7XVxE1MTEJHacWumfBaG/dl6
         4JBgkzeOw678+yC60e4kwnlFj41wmKUv7+ufoiu8lMYyxSAUEBpGnCSnLdCvHtRckRRs
         NrWtZr7RgHxQC6s55Ekqe7qKWFStnGCZKvXViTTRq0U3/Kkqf9OGEWzCWt134kjKOMbf
         CPOVJKHcqoj1EFJQ6/smaH9Gm6LiTBoedbLrbd6rAvyJtu43roKRbqbTIefRZNFbeZ7J
         dtDwrg01ExRlfjxrQvcCSI45nYkWDVhaDnzJXv/KxkRaItU/ilevTBkK7qzSh7QlQdlc
         VMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SxdCCnMLPzc1gk7NOaHqgh6xVdTLhPkejBZ7rXFt8JI=;
        b=mbxq8oFfD59QvYddHWwFPvxlw45VmzZDkJN7td5ZZdhRfC++jwH2DO7vJzvI0sJfoK
         tCkVpH/KJXDeLhL0DiLoprNxhZswNjMW9SVRjtYJA3I4ZsZHjU+k9Na2OHOVHivgN56p
         oJKcpwL2Uz3x/c4djIO9pzAolkvWAYZV3oVMhv3sWP4IP3nEmDOpC+TNW0qIWnrQ4LQ9
         WO4NkjLx1J4DzmGg+ZRWoe2fcMChVGUaX1MGfu/SSuuwcdHNSkjr8DSR7hBGal0T1nWc
         Zz4NIpRyM+VvRPzKmlWa5E7WTjSYzayUMCtEfCHaM6t6fStsdZN1Bi6w0tDzE0oiP0e8
         RyLQ==
X-Gm-Message-State: ANhLgQ0Dg2M/D/3dH+AP2nqSKr9eSSZQgz25961ngRpeWuIgbFQnN6z9
        EtaxKYU3bHwHdQednfGbacil7w==
X-Google-Smtp-Source: ADFU+vvARBPTMbQyR9qicXTgBArVoylboMmVFLc3VGsV+6Obg12ltLf2qwKr50cwqzpf22ZzE+FUWQ==
X-Received: by 2002:adf:a555:: with SMTP id j21mr29884781wrb.409.1583874345178;
        Tue, 10 Mar 2020 14:05:45 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id f127sm5783049wma.4.2020.03.10.14.05.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 14:05:44 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 1/2] crypto: drbg: DRBG should select SHA512
Date:   Tue, 10 Mar 2020 21:05:37 +0000
Message-Id: <1583874338-38321-1-git-send-email-clabbe@baylibre.com>
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

