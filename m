Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D035C33C8C
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC9C207FF
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFDHoVhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFT35 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 14:29:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51395 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFT35 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 14:29:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so16231229wmd.1;
        Mon, 06 Jan 2020 11:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Ur3CxFG0cQbKNwUJ75Zx2lXsthVwW+wWDfRyfXmnKM=;
        b=MFDHoVhhfNfJOoS+7B7TS0SyZvJrXkAmv9gGVyRrLcFaG6lMwTT7g8Nw48eUSo/ihd
         iE09TrqHNUuJ1yrNx8eqPe/Bf6gJegD+DVCBYVFa3za5W8hLkWvdoLTpZDEEiHtar4+Q
         pKqqaX4vnkREBw8bLnRfq2kh5v610vdQecjHN/TN8/sSUkLUv+JvKm8Jsa/rdrblmhq0
         uhLdN8vIor7xFd3r94ysMJs7hOqQZN08M/sKaaagiqHpkuGpBI7l5slMNOoFkja7LlFr
         5lUstKr4VwNTFvhDrVj8RMeFN1GPti+JFk5/Hjf9t0KfwFGuOpMcuYVstzFEf8e8EJkN
         F22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Ur3CxFG0cQbKNwUJ75Zx2lXsthVwW+wWDfRyfXmnKM=;
        b=Ne6fHnwxMAdkpvT/ZBwkxsuRx5p5OhGVZi/ZW24MHalyPM7hB454YjzR0OdCij3Ss1
         exu4VeGdEjuEAlGxYYhhXPRATLvo7SoFNeu2D7/gmsxclCZtH//3bIfUtDhzjHcKwDnK
         bBUwSG6elt4m7pASCzPL7IjKIbWroBuc1X55soXLevBSJR8iRFpVmbFEDQLFdCfwv4gi
         LhrN+xL0J2+YDTEBd8Gfjt3VpMgBzZ5bz/RG8hXwKBYNIoBrzmlpYgnR1dviwawUJbcz
         Og7yOXWdNz2ERYL8Ih+5EJkhlsOmiG0Gou9qsd+BjrpuebtYbmHFP6f5KpCmVX7LPChN
         JJPg==
X-Gm-Message-State: APjAAAWWBtXvJBCQU7fHG+7vcWmV9dubX4KZMZHJ1/LHOZS+OJcen4+Y
        Xugyfc1FmB4F/HuCVxARi5k=
X-Google-Smtp-Source: APXvYqyQllloLFr5JAArKfaDOfayLtkqaScpZ+uJ6DkBjZ3d+DoyF58NzIDEURVT4mhNYEGilCH9JA==
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr34934742wmd.5.1578338994696;
        Mon, 06 Jan 2020 11:29:54 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id g21sm23802398wmh.17.2020.01.06.11.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 11:29:54 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        narmstrong@baylibre.com
Cc:     linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: amlogic: fix removal of module
Date:   Mon,  6 Jan 2020 20:29:50 +0100
Message-Id: <20200106192950.23475-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.
Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index fa05fce1c0de..9d4ead2f7ebb 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -289,7 +289,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 error_alg:
 	meson_unregister_algs(mc);
 error_flow:
-	meson_free_chanlist(mc, MAXFLOW);
+	meson_free_chanlist(mc, MAXFLOW - 1);
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }
@@ -304,7 +304,7 @@ static int meson_crypto_remove(struct platform_device *pdev)
 
 	meson_unregister_algs(mc);
 
-	meson_free_chanlist(mc, MAXFLOW);
+	meson_free_chanlist(mc, MAXFLOW - 1);
 
 	clk_disable_unprepare(mc->busclk);
 	return 0;
-- 
2.24.1

