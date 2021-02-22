Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9594BC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722DA64DF5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 15:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhBVPNg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhBVPN2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 10:13:28 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A168C06178B;
        Mon, 22 Feb 2021 07:12:46 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v21so785031wml.4;
        Mon, 22 Feb 2021 07:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bS+BhtUH3R5L/9GDlP7BU+Ce2CmxRyCIWCNfBp1I6gM=;
        b=V5cR30vb5ardXeLt1d88QjtqI6/PZWMibuMU6FBWH9EF+5K4B7ctOb8EB9Nyw2+5O/
         B9DRlg8fmqjkflRlIWXPb5PmqND8ANbJzfMVVl6CfSc/H95nHm1PyuLvjBrysK2xDjmV
         eQLwLsWF227SCr5APVYITzaqAgCw//AAItH+IWl2SAeN4LzRXmXEYvJ6PecDGNySDc4p
         IoZJSdblCMO+SeXF9z861+jky4AvY48blDSwbc8Fqk59soEOkZ0EbZpniMgaPfg21OVW
         xxChBbjW63ip25O/FvjUxtYu+nOdaku8Z27gVkmqS2yhU3cjha3zgR6FIYJxsFTOQmWY
         2aZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bS+BhtUH3R5L/9GDlP7BU+Ce2CmxRyCIWCNfBp1I6gM=;
        b=P7zPVmfq0L2FAyVXIzZhSK7oMqnyiAIkV0MrS5/63SBRIn9XPlwvo27JoWJMbF56iX
         ETGTCFppToRu764Ooa/cv2OaYxBMaI+uRWGD5GKz5KXURio3O6b6dEwJ1d+CRPRnlXTp
         5PpZnYRx7xtoFxFkdSh7my4EMI6ncMwRJqgNKyMMqpvGRqd//wBIe+9nt9pKVhiomx0i
         u2M+/WHA7GV8LEm2M7Rz3jC2EX5yhcCrFA9UjheG1MlmD64YAnovVV7FEudBHoCC7c2Z
         3gJu1in0Nf5XOxeRX2ZOVPqkjN+hIdg9NK952SqwLM4n1xLC4d1jIBRx8b3nwTxGvE4t
         WaeA==
X-Gm-Message-State: AOAM531Bu6FcuwTYrCyEBwBIjqQ29d+pu45+ud8MBEsfS399aoId+1kJ
        2Y1QVoYtcCAZSZppYz3dt1G6qmw8umO45MJl884=
X-Google-Smtp-Source: ABdhPJw11x5IL7ncOL+63QUugBE7PetgqUhUecRWWpL8gsY5S92hRrmOrK8XXRALroxCO+KKqgCkIA==
X-Received: by 2002:a1c:7705:: with SMTP id t5mr14179710wmi.148.1614006764022;
        Mon, 22 Feb 2021 07:12:44 -0800 (PST)
Received: from debby (176-141-241-253.abo.bbox.fr. [176.141.241.253])
        by smtp.gmail.com with ESMTPSA id l1sm25932031wmi.48.2021.02.22.07.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:12:43 -0800 (PST)
From:   Romain Perier <romain.perier@gmail.com>
To:     Kees Cook <keescook@chromium.org>,
        kernel-hardening@lists.openwall.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Romain Perier <romain.perier@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] crypto: Manual replacement of the deprecated strlcpy() with return values
Date:   Mon, 22 Feb 2021 16:12:13 +0100
Message-Id: <20210222151231.22572-3-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 crypto/lrw.c |    6 +++---
 crypto/xts.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index bcf09fbc750a..4d35f4439012 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-		if (len < 2 || len >= sizeof(ecb_name))
+		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..1dfe39d61418 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -396,10 +396,10 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-		if (len < 2 || len >= sizeof(ctx->name))
+		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')

