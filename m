Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8976C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 17:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE26C65138
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 17:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhCARDr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbhCARAv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 12:00:51 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4318C06178A
        for <linux-crypto@vger.kernel.org>; Mon,  1 Mar 2021 08:59:41 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bm21so10683770ejb.4
        for <linux-crypto@vger.kernel.org>; Mon, 01 Mar 2021 08:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4oJoA6B6oYun1MBDGiIBhCpP/MGXMAVgrys8t2dvQA=;
        b=1nAxWJ5P2/fx+YfJJQr149keglLZ+ujy5tKOA88wzia4CYKay8Ir27hOlzbVRRtYRF
         p4tU7vEzTZJRImkAjKZHkUbJOEOZDMZNYWTtlS77KE6RK9v0Z/Tp+gD52IgKK25w2o7S
         g9kOhk9ajjZYw0oQbmuAtBz288U4R7gLBlUbKrN4g+toTjyapop2Y91SHkqB7eDQLggO
         R0rc40vzM5tgNJcNni9m94eFwxDGDnB40tK6PCGX/JIDMjG1Kx3JpIv1ish9fUCAWVJF
         CHN1yy9cd8XmFDtGPpxJd49OUExUiIE0VsIsa/U4UATvoIEEzAf4x1WkUoNdXlb7s5/y
         8rxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4oJoA6B6oYun1MBDGiIBhCpP/MGXMAVgrys8t2dvQA=;
        b=RSep8K1n2/38FKVXzgHRX7oa1UcBHuUwYRdRCNeN8d03xkKbQZZnJ3ysFtNyFL0r7o
         tqw90mMEPXKcz/O1N2/skriCILKAYF7aoBVaNu8E+UfXZmOMR7gjJeWcqrRg28pkdQqd
         jqZrC79wPytuAk+XJdrKxCZw4/QouZFaS9NZgpt4sXklioQ4LO4vBdXR+Xt9W+zqfw99
         NzbNhti2W8Wq+H17tOWOb/l3sHTM0OR+3zS3Yx2bwvoaTic5E17AHVfswY8xVLRWv5o1
         5N+fAJBaHX3j8bA4fNn2T1/nmoIxDiJZmglXO34O9kKwGcydQNPeKABBYw1/YeenZoxK
         wG5w==
X-Gm-Message-State: AOAM531RFvpwUZMg3qgPMqm1MNO7pn8Gx2KutSnK4OS0i29vsxLZsElv
        iT/4916TxAIQZuaVvuR9iLplng==
X-Google-Smtp-Source: ABdhPJwqSZaO89ENV98Xn1yjlxmUOxVjN6G6f4xE3BfuzhVq3Ii+hcNvfGR0V9ZaEEkkbIKwY1BksQ==
X-Received: by 2002:a17:906:c402:: with SMTP id u2mr16687226ejz.546.1614617980335;
        Mon, 01 Mar 2021 08:59:40 -0800 (PST)
Received: from gintonic.linbit (62-99-137-214.static.upcbusiness.at. [62.99.137.214])
        by smtp.gmail.com with ESMTPSA id pk5sm14168991ejb.119.2021.03.01.08.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:59:40 -0800 (PST)
From:   =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
Subject: [PATCH] crypto: expose needs_key in procfs
Date:   Mon,  1 Mar 2021 17:59:17 +0100
Message-Id: <20210301165917.2576180-1-christoph.boehmwalder@linbit.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, it is not apparent for userspace users which hash algorithms
require a key and which don't. We have /proc/crypto, so add a field
with this information there.

Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

---
 crypto/shash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2e3433ad9762..d3127a0618f2 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -477,6 +477,9 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "type         : shash\n");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
+	seq_printf(m, "needs key    : %s\n",
+		   crypto_shash_alg_needs_key(salg) ?
+		   "yes" : "no");
 }
 
 static const struct crypto_type crypto_shash_type = {
-- 
2.26.2

