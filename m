Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72296C38BE6
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FB920726
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="BNfZNGy7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgBXU0Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:26:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37487 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgBXU0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 15:26:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so729408wme.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2020 12:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oFJFMPloKOQ/IG47taQgRmVN4tJaMKxeC+zVgEVtvZE=;
        b=BNfZNGy7WdEPe3PKPsg9YivRp+RUhv0+ve6J8VFZEmqTUOfoLrH7KYhCvGR2g01D4a
         Pb2Qd2nnV24DKXlrAiHclHT9p98ECp/bhL/RJPy8WzBhzoWZXL9q7Tx/NpJ+sjQyaXTA
         AytsgDPB+Jh/1R1K6frQ4plfMfnPujtX5tYQufhsqIeCteqiqsPSCbqxu7xebcQ+K3h/
         AKmdd19qKkwx/PXzTZWPeQh4qYXyKesalj0rkwsCXvgOelKj1nfxpxOlufrBMS1Ddes8
         /igORiPavhgkBbvaF3Y0jaWDYsD3UvKoVGAKJnelrQpDPSE8TSOtb0nSK1pgx0YyVmWQ
         2+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oFJFMPloKOQ/IG47taQgRmVN4tJaMKxeC+zVgEVtvZE=;
        b=kXmggYa+LmxWVoYvZsj5Kl3Tqi4T2l9WjKm6wb14t3Riu/QQswntlW4+aYFYH1Nvqz
         RlygnllLI4y3nNtpwRsFuhp2tXOBAcclPNMvpDlLrRBAd8f+qQJUxJTwiHYkDmu3HmZ8
         goAhFpsl2JkUWAK0k0vP7t7SHhYsQTcMcUX7+yoYl1fsJp3eUHWlO3C1TCmQ9DCeytJY
         ZboX+s1o3O+09296szgNryms/zbewSDVI5R4BfQdS/3dhAGK7YsJa5+XuW5IY3KyoqMU
         /u3W19LFdg7i2HUZvtLdZy3W5sFcM/mTKs+gT/FuWormiTpAO4MUIq4cRmGpOWIWAphy
         +WBA==
X-Gm-Message-State: APjAAAWIIg0DUWu4e+GpaqNeb9UIShJFGPb7q4KVy0sSh/st2VNdblxJ
        Zpiwd7szX7g5BewDhmiWGclTtA==
X-Google-Smtp-Source: APXvYqz6tJk9pKs3DlwhvMLLlWxvdmWF7oCGr0eqdeFZlTpXS6ZQYBkZW/MD5mv+P/ZNP0JEtY3uqw==
X-Received: by 2002:a7b:c3d8:: with SMTP id t24mr183019wmj.43.1582575969920;
        Mon, 24 Feb 2020 12:26:09 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id a7sm13356602wrm.29.2020.02.24.12.26.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Feb 2020 12:26:09 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/2] crypto: sun8i-ce: fix description of stat_fb
Date:   Mon, 24 Feb 2020 20:26:03 +0000
Message-Id: <1582575963-27649-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582575963-27649-1-git-send-email-clabbe@baylibre.com>
References: <1582575963-27649-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The description of stat_fb was wrong, let's fix it
Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 8f8404c84a4d..0e9eac397e1b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -214,7 +214,7 @@ struct sun8i_cipher_tfm_ctx {
  *			this template
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
- * @stat_fb:		total of all data len done on this template
+ * @stat_fb:		number of request which has fallbacked
  */
 struct sun8i_ce_alg_template {
 	u32 type;
-- 
2.24.1

