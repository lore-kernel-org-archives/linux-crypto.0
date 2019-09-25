Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A9FC4360D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3DE21D7F
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EoCQ8h10"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439511AbfIYQOS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52610 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439058AbfIYQOR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so4848968wmh.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vpYX5apOE5ovWt54wDvLpgCFg3w7Y3yfqWQuF42X3Ys=;
        b=EoCQ8h108o9ud79LK9qo/lEUOOMuQ+8osdvhOyjax1WhpI2184srTIyoMNIe740+DL
         PUcEG2HHc8fCdWvJb0SSJwMZIKVyRKNTMVEsFB/8IU8VDms3Ne0Ef83bLBd2cjCrYtCR
         SRjrANqSyHMKwUfeqL39Bkzo2NRv8UpRkVkvQL1q6pPRCeKZJ0h9J2+OnNwtpoZnCsk4
         QZXfquoD3+tk/HriLcgx5buUFhjTYbb1OVamAfkLtzqaItM7tx+AGUk4nIO73VVcZS1E
         j9+B+x5xSA4YGcEfUl9jsKx6VPygEvioFVenr5YkCjIlbkiIo9ejOO4tZXy3lJXs2H0N
         lYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vpYX5apOE5ovWt54wDvLpgCFg3w7Y3yfqWQuF42X3Ys=;
        b=k5wksaYRRKX2rI9YElXe+8fbIyWv+Gmo4NAi2yeSx9g0ER9nsxCUpgkm2rXM2vy9Zz
         Vp+NyiA0TG6F4ZO6Ns/dXK+imLjrugpe3idgaaBglQtSsa67S7zDSl9UDZQcsiWJzQp2
         lnStIAAvPo+S+/r9cNitFo6H8R/kNrMtukuYLXwq084xd26ak7USAD89qcfaTOyw4RQT
         6pjH7mA2pGBQQU4FzAw/zwisSvCfX1HRx6uWsPDjN2bMrCbXqG7pnzJftnrvTXb1Iz6p
         2S3NzFBVPhg3GMR+w0LbNQiXCMcBK11p6oZDSt88DDwdU58xAW/7dvn10tcaSx+ybGO2
         kM8A==
X-Gm-Message-State: APjAAAUhL0QHJbJ1+dVGdn5kA2NFymLavKzpEidRS1vPTm4/8CpTfenx
        1AvlRC+Lm9myNo/Zgc0f37XLVnJkESi2Y9ov
X-Google-Smtp-Source: APXvYqwNRaBDeDani6z4F3/B9eCXG5mzVV5VhoPg/CU7b5DVTv+fWOO/iUVm1vGry6yb/vakYpaOYQ==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr9232689wmc.124.1569428054603;
        Wed, 25 Sep 2019 09:14:14 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:14:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 17/18] wg switch to lib/crypto algos
Date:   Wed, 25 Sep 2019 18:12:54 +0200
Message-Id: <20190925161255.1871-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

---
 drivers/net/Kconfig              | 6 +++---
 drivers/net/wireguard/cookie.c   | 4 ++--
 drivers/net/wireguard/messages.h | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c26aef673538..3bd4dc662392 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -77,9 +77,9 @@ config WIREGUARD
 	depends on IPV6 || !IPV6
 	select NET_UDP_TUNNEL
 	select DST_CACHE
-	select ZINC_CHACHA20POLY1305
-	select ZINC_BLAKE2S
-	select ZINC_CURVE25519
+	select CRYPTO_LIB_CHACHA20POLY1305
+	select CRYPTO_LIB_BLAKE2S
+	select CRYPTO_LIB_CURVE25519
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cookie.c
index bd23a14ff87f..104b739c327f 100644
--- a/drivers/net/wireguard/cookie.c
+++ b/drivers/net/wireguard/cookie.c
@@ -10,8 +10,8 @@
 #include "ratelimiter.h"
 #include "timers.h"
 
-#include <zinc/blake2s.h>
-#include <zinc/chacha20poly1305.h>
+#include <crypto/blake2s.h>
+#include <crypto/chacha20poly1305.h>
 
 #include <net/ipv6.h>
 #include <crypto/algapi.h>
diff --git a/drivers/net/wireguard/messages.h b/drivers/net/wireguard/messages.h
index 3cfd1c5e9b02..4bbb1f97af04 100644
--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -6,9 +6,9 @@
 #ifndef _WG_MESSAGES_H
 #define _WG_MESSAGES_H
 
-#include <zinc/curve25519.h>
-#include <zinc/chacha20poly1305.h>
-#include <zinc/blake2s.h>
+#include <crypto/blake2s.h>
+#include <crypto/chacha20poly1305.h>
+#include <crypto/curve25519.h>
 
 #include <linux/kernel.h>
 #include <linux/param.h>
-- 
2.20.1

