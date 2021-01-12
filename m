Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB416C43332
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 16:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E4282087D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 16:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbhALQMy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:12:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391926AbhALQMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jan 2021 11:12:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610467882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7GrmVz3g5PnC6MejB1/FJv7gDiKaAZjfigOkKnsP7RY=;
        b=gDfpJjm2Wic4KapOMGhAGjFavNgHiW9aV8jDp7SOAD3V3wjSJIsswtntqhiHKc+GI6STFH
        aho4xLMjGqUi1GUPdnKlARYEuNLvMPrnkIHu3Y/BO2+eV94x8BZShGe7Selq8gnnmWjAOZ
        YzPEm6QWYVARE0fdmgzy/P+rPXpED+4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-NVLciomDN8y4JMLnP10Wfw-1; Tue, 12 Jan 2021 11:11:20 -0500
X-MC-Unique: NVLciomDN8y4JMLnP10Wfw-1
Received: by mail-wr1-f69.google.com with SMTP id r8so1342193wro.22
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jan 2021 08:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7GrmVz3g5PnC6MejB1/FJv7gDiKaAZjfigOkKnsP7RY=;
        b=cvP4Dew2/Qf3G+cX7VQtcBhcn5OmBExMXiRQCmiBtHvVb1sTsDlUQrKjQ9Zli0E2g6
         MR49DYGmi4CMsPEcTWOKeUCBvXrIRTRBvpM4dC3quqq1wYLnaQpaJ2OdBN2fzyGMYhdM
         Nt7kg0oYYdwJqRkipUthnKRPT8EIj7rDSTOvdUB2ZDqlNMWcfeIAm5JdKTNuA61n8yWV
         MPNKnOhfcvpdNhGxffNw6oojcWXjf7TN4xzlzQh7DwZrnT6iCqaPFt2lonkkkCSRZk1G
         jiS/m8yYYPN2C4J0dPnR2qQjmXx4t+hHz+9ULSyv4njS2GfOLepgATouJXlvyvM0UYzv
         3YPA==
X-Gm-Message-State: AOAM532xkewUrWxoJ6GhGXgybldhYkL9dxRAfDhNi+cp2q5LX2GG3LzF
        Nhkuv+c0H2/s6keQMCQx5SfuinhmEbv+1UYjXbbfrpnBrTFFJF/Oo+tN/GtJh9DdB8pSB1B40N/
        1pL6JVto7W0tAo2uaj/FH6RYw
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr4317087wmc.105.1610467879455;
        Tue, 12 Jan 2021 08:11:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9gtHso6LQWZ01xitLmZ7DVGmvVKcp38eals66lkxaBqWRIlrF6/TqEJ1hfzciMThkNCz2Iw==
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr4317069wmc.105.1610467879236;
        Tue, 12 Jan 2021 08:11:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e15sm5765658wrx.86.2021.01.12.08.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 08:11:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2A2DF180322; Tue, 12 Jan 2021 17:11:17 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] crypto: public_key: check that pkey_algo is non-NULL before passing it to strcmp()
Date:   Tue, 12 Jan 2021 17:10:44 +0100
Message-Id: <20210112161044.3101-1-toke@redhat.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When public_key_verify_signature() is called from
asymmetric_key_verify_signature(), the pkey_algo field of struct
public_key_signature will be NULL, which causes a NULL pointer dereference
in the strcmp() check. Fix this by adding a NULL check.

One visible manifestation of this is that userspace programs (such as the
'iwd' WiFi daemon) will be killed when trying to verify a TLS key using the
keyctl(2) interface.

Cc: stable@vger.kernel.org
Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 crypto/asymmetric_keys/public_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..35b09e95a870 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;
-- 
2.30.0

