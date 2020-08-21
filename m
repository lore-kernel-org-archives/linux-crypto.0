Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED08C433E3
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956C520578
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="qzhMfMz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgHUNqp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgHUNoK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:44:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21461C0617B1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u18so1915205wmc.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=qzhMfMz2pYo3dfCmE2jcOiTQ7QRc8eVbVvW8h/IQFjSwZms5FsJn+SElHNWJKDCuN6
         jGVWaJnbEK84vGImJkA+0rfJmhQ60sxlZQyeDfUCOkc0DQkIbIPqwRXYaKn4wXO0Jki/
         itGtJ2j0/7clFZeN1H9t9Fl2WrmlC2oALvGqiTuo8lzkGLSzF6VydprwtvOrvppUsuwL
         d0QmRQ436m/9f357AWW0/Cj3eMK5td/LSyz7rapUwPvVOgiWeRZUoOByR7MROFUJQqHr
         VL9r+LIlweL4MTHW7nHbgJwryAXi57ITFVAxEXW36H8XMGlizGYQ1MuLkgwLBoEkMDIJ
         fwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=VymA0vNxL2UMpoqhRsCmxpl+fz/ycMDW9EYZy0VqpiK26GtZ+zPfWg7h3rhbtXgPYO
         bzkwcpynzGiCHGGPxALNFqAfZXCg4RqFD1ozCAxOFKDzO3gSsLMmqSGAU1Brf+Gftgfy
         wRD/XU9sUZT/s/PgcP65n2JVTZzW7N5/c5dz2WaCvtcNUw+gAn0haZ+IQVNdWQ1fgrEj
         ggb6w2FKHPLkGVwIYoPaNceFvP0/SsGhLMea1zQN0wdRjeIZ2xEVbOG3327dnw3cLt1K
         bWgUPM8gNiAuiUT4428xK3ioNkAxzmbOfA9glZ71WSfkYmQms9F3R0q3vFifBwItaL5N
         a/cw==
X-Gm-Message-State: AOAM5307TDsxK3pJUJY+e0xU31E5dKLm/FtoRer5N7bEpYa5cDkiVaVX
        Dy73Wf0kgBd4P5VTZdBuSbypzA==
X-Google-Smtp-Source: ABdhPJzREPM8AZSbvPI16D0PfUUSdv2MuGQx5rglejeds4xHN524lCmTUCCQJyNMjOoHOavRs3rPvw==
X-Received: by 2002:a7b:c015:: with SMTP id c21mr3272411wmb.87.1598017436851;
        Fri, 21 Aug 2020 06:43:56 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 202sm5971179wmb.10.2020.08.21.06.43.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 06:43:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 13/18] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Fri, 21 Aug 2020 13:43:30 +0000
Message-Id: <1598017415-39059-14-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new stat_bytes counter in the sun8i-ce debugfs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 6bbafdf9d40c..910b510d7bb2 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -276,6 +276,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -289,6 +290,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.26.2

