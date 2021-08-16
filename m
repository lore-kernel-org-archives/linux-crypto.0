Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3291DC432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 12:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1665063274
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 12:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhHPMpW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 08:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhHPMpV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 08:45:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402DFC061764;
        Mon, 16 Aug 2021 05:44:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r7so23516006wrs.0;
        Mon, 16 Aug 2021 05:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DJtQNdsaxbxXPd+1fbcf6zTZaliIWObu1grzvpCsw7Q=;
        b=ty3ZQ4MBZ9QNySq22cxPNfiCh3sjEYho2Mj1RVFTelHUITguMF7yG0NZFzeuuPadko
         ME56w21NQABREfhotE7xxpe/kiug4Leeb2w080Rzz/RtwxZU8SELC9nC8eIKPjs0/YmG
         bYY1f1UgcX2KTW4AxnSYK7bLbszO86FoY9cT+XCNbsTFxdnOP06sEtC6OtjgiWfCinH6
         QV1VxH6LQAHTkleg7noCeFHdKckiD18oaC0cayEw3dWvluWDFo+VMWXMS71rFKkKpUyr
         INbze26/Dxh0qfJuOiDDr9UfT3KxBbimkkRrY/FR+nFQDSsDLeQ5FRud7PAs3++W/iiN
         jOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DJtQNdsaxbxXPd+1fbcf6zTZaliIWObu1grzvpCsw7Q=;
        b=rrK2hrFlUi41+R7jVuJukaeU4pOJXtEi+sdi/wtMqOvmWMtsegfk6v0/Ad9+smLuxw
         NNRvH0WsI6M8X8/I/YErljy8CYWSIDY3UuYYs9s/JnCyrbnoLQJzeq+pA0ZJxggnnEGP
         7WcdwpzQOYrpKWvk/ksEmfJOcmlM4SFLqYq4Q5v+k8SJK122KsHy8tBKaZPHxB+DqREq
         PFx8NTgiBIRjBdi38F9yQ7kgGVEUS+2E0cwaggQkyaeGuqIJD68wGw2N+72KpyOToC4V
         nyqCMCq4oQD/JEIBm/MQ2a99JMeHoz59u9xMRHPVKiwSuxRQyAujOC5m2cOC27DUZRRW
         gfPw==
X-Gm-Message-State: AOAM530XOGwx15+I8Mq1/c+JgoSoMOJGWaQM0zwIMRhfDt5FfAXc8m0y
        BmWXigPziT8kSuywTzk1YwYYIplJdZQ=
X-Google-Smtp-Source: ABdhPJy/ZcykOyZGSyodpCi4n2tEX1JG/ESBnQKzhENL0IJ22TIb2lYZrXg9POpFr0vDgEly3ztb/A==
X-Received: by 2002:a5d:58cd:: with SMTP id o13mr18277136wrf.421.1629117887732;
        Mon, 16 Aug 2021 05:44:47 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id l2sm10564848wrx.2.2021.08.16.05.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 05:44:47 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] crypto: remove rmd320 in Makefile
Date:   Mon, 16 Aug 2021 14:44:33 +0200
Message-Id: <20210816124433.10411-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
removes the Kconfig and code, but misses to adjust the Makefile.

Hence, ./scripts/checkkconfigsymbols.py warns:

CRYPTO_RMD320
Referencing files: crypto/Makefile

Remove the missing piece of this code removal.

Fixes: 93f64202926f ("crypto: rmd320 - remove RIPE-MD 320 hash algorithm")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 crypto/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 10526d4559b8..c633f15a0481 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,7 +74,6 @@ obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
-obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
-- 
2.26.2

