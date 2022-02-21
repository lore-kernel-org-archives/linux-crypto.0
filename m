Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D95DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Feb 2022 12:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357422AbiBUMJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:09:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357332AbiBUMJI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Feb 2022 07:09:08 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B99C201B9
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 04:08:45 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d27so26702993wrc.6
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 04:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eRwXQ22zhUvx1o2PZ7ENLpRDM+5TmK2L3Q+xebz6RZg=;
        b=qmw5zddLshVBKDNx9LmeyGeFD06unJdxUalh9qYp20aANFXunS0qfedH7kKreKAi1B
         TuZ66MDF1UKDbxZfJtTct+TBv4WAKrXribxlOnzuChMAnS3sDdKtTRU18+ju9/hFQSxs
         EhLx/h9ZR4eCkZxp1ViV4aDidIOXtwLywqNfVkjll1JeohtBMUWIZN98n1+RDri/GkOj
         vLCnqS9rwSkHDW6XYSZV9Oe834ro/eJCV+XoXF40hYLL4DMMubP/riKiaLy7jIuAEmp7
         wi+n0NwOGdXFC6avheY2YvwGHhX3elgBsAo6php6McGHit+QF9Qq9ovwKve12Rs6xaT7
         cVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eRwXQ22zhUvx1o2PZ7ENLpRDM+5TmK2L3Q+xebz6RZg=;
        b=DkqN9wfyg+D7E+m2XpRkBHhSifUuMfHibvb6L8FjjM267HE0LkX/DfOhEuqdbK3rQr
         oQwOH1OCSakuFn+fweJNWaZiUiVMw1dsZ32YRlny5DRPtNepEDeW9ZtST2eOUetj/sVG
         BUgLrEbumCPUzN4PQFLXGA3FLSaVgujWkN94KCL/AVY78JmG/yY8sEH3tM2Xw9hvwV9b
         SqNFvcwUkU1tQxPEq/AAYSi3Mi3zq/2k3upK+OHsxpf10WsDgGs84d5n9U8+184PQoSm
         8+BMdHhYBndj4Z/qO9LKusPalNvdmOFC2Hav5qRI1ikAyZGFZagUVemATX1cYbwRD4LE
         cjHw==
X-Gm-Message-State: AOAM5327ZCvFvJN4o5W+ElQMqUr2uwr4lRpKdQ7E0/dp48wkrm9ol00l
        Tz3EKbMRoqYasf3RPNDmvfjoHQ==
X-Google-Smtp-Source: ABdhPJy6vbpLlKF2o118HSZXUs4RfBWx6RmuHRbHpvyirVgJKBWwM1e3MmCtrMzPWWHPKMXOLsmeIQ==
X-Received: by 2002:a05:6000:154e:b0:1ea:7622:64ec with SMTP id 14-20020a056000154e00b001ea762264ecmr676608wry.600.1645445323857;
        Mon, 21 Feb 2022 04:08:43 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a8sm11821546wra.0.2022.02.21.04.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 04:08:43 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        linus.walleij@linaro.org, narmstrong@baylibre.com,
        ulli.kroll@googlemail.com, wens@csie.org
Cc:     linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 4/5] crypto: gemini: call finalize with bh disabled
Date:   Mon, 21 Feb 2022 12:08:32 +0000
Message-Id: <20220221120833.2618733-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221120833.2618733-1-clabbe@baylibre.com>
References: <20220221120833.2618733-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Doing ipsec produces a spinlock recursion warning.
This is due to not disabling BH during crypto completion function.

Fixes: 46c5338db7bd45b2 ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 53e3fefb81de..14d0d83d388d 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -264,7 +264,9 @@ static int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *a
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
 
 	err = sl3516_ce_cipher(breq);
+	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, breq, err);
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.34.1

