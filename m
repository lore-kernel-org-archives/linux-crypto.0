Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C598C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0C6206ED
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MEtxbYLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfKMSZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:25:31 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46492 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbfKMSZb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 13:25:31 -0500
Received: by mail-pl1-f194.google.com with SMTP id l4so1396890plt.13
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2019 10:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FkQlTXoldDSpdA3XRHwjBvm7XBhk4dajoTajQfALRYk=;
        b=MEtxbYLYLDqKJOwVZpQwr07bqAbP7blBkrIKEe+qSSM+PzgU+W1xQ5xOMPT6NWkA5s
         rjycVONiVR4AZCSO66k8jQI/nHgPmSZA8EKdwNPXcG1C+dxVgIME8hIZfzzYsdvFzQNR
         bObyqobSLlgC0VWqTqqCssDdU0qVnwehbIpug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FkQlTXoldDSpdA3XRHwjBvm7XBhk4dajoTajQfALRYk=;
        b=QwsWLDsb1QOxRbe77gXJEVfeIkuG0GpV38mmet0f6EZyeqOgSlsIih0cAxp3rZYNIz
         M0buliB7CWlA3k9XHbQaNpc9co8zp91z0RqANj6ZTdZKkQIvDPxJO8nzTgvc/JXG5S+w
         Uy6ZxmVd1tFivOhaiPreOKZyGh3PG/Gtzl3RL5u1HknDqYKrf9kt4QRUH9y7Ki1CQ1Ro
         YZAfI3gHWSFOPRkCc2UHAnnVol8gLTw1qQuuKaZoBlyWKkiFFTg2WMXe0horuJx/Mv6u
         Tq+G/wfIf0mT1ZWWk3HUhXo8MHBebgRU6o7PIQJyW7QUaQ9RaH9S1XWMVtEBp2IEBj4c
         TXtA==
X-Gm-Message-State: APjAAAWzDusEAFYBi7yDLJbeOpH+HKnVyhJTH+RncK9m6KzjQpjt8l7M
        zd0PVI8qtb0r9Ru9qJxMDuli6w==
X-Google-Smtp-Source: APXvYqwdr/HsDHCg8rYc+JoYPlqrZVPXvJbvoHDyYD/BcIw5ye1omidirdR4UfblDi7OXzJoXHKdAw==
X-Received: by 2002:a17:902:8345:: with SMTP id z5mr5111902pln.113.1573669528934;
        Wed, 13 Nov 2019 10:25:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e17sm3654982pgg.5.2019.11.13.10.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 10:25:26 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v5 7/8] crypto: x86/glue_helper: Remove function prototype cast helpers
Date:   Wed, 13 Nov 2019 10:25:15 -0800
Message-Id: <20191113182516.13545-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113182516.13545-1-keescook@chromium.org>
References: <20191113182516.13545-1-keescook@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all users of the function prototype casting helpers have been
removed, delete the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 5 -----
 include/crypto/xts.h                      | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 22d54e8b8375..d08a7085015f 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,11 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u8 *dst, const u8 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1

