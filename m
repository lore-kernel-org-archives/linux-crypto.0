Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9485AC0032E
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Oct 2023 00:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjJUARd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 20:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjJUARc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 20:17:32 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F2BD6E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 17:17:27 -0700 (PDT)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0FAA63F18D
        for <linux-crypto@vger.kernel.org>; Sat, 21 Oct 2023 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697847446;
        bh=PuueNGchp+/Mt3jvaX6HDVjE2P5ULCrANke79lmr0h0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HFT5HOnLPuyovfj57WXkrT2dencna+mqDtvPuzYwCy1T+mF3xOEWJKJbEpZOUik/N
         XRTK1NQcdttGq+nLaxGLc8efewuYnb5Ci6TJ281J6/caLDC69rgdqmCXj8NUxsAb42
         cE5clIni1VL/ZrMuyaoqwOsDvuaKwMmMVno9r93frvRRPRQ8jFjrVYL4EAbEOp+Tub
         aRKVnjWNhuf3U2VsO9ASL/Ext9wnE8Qkv68XNOV9olBsarca7nDESrzaOb3wjsKs9e
         H90JX14HlXbxwePWoC6ox7U4PA1UwLUntjVjsBZI3uz8tX4KA3f/qnSh9+mOSX/hvm
         xY4K1KHghGQaA==
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40839252e81so7983555e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 17:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697847445; x=1698452245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuueNGchp+/Mt3jvaX6HDVjE2P5ULCrANke79lmr0h0=;
        b=N6ducr3I3RdR8RAEZlJeXL2oWxOoxuQYAD0QnG3jzbReSteQvYBTM5Lc3EAHSnY53O
         NXarcIs403H9lQ7DxCMMKxplngmPc5DPFZE14u2Gmtlv7gOfrFODxGWvEbW0yKKPecAX
         BuGc4xqvNHWl9+eRNs0SMBV71OETigL/qeHQEQdJkAcUmjq0mf/3IgkNZ559gKbcezDI
         dk93mxRqiZwugzeKwsc9u1R43zUR5ookyO5xWRA2Zd1Rb9aiwgLIdpCVBJMZe46A2eC0
         SOw2jgf/okcqgbfzwZKFk1sA+VCwn0ibSgVb689wTG1FOFcJ4+nOLV4g7QsWPUJIPOJA
         otzw==
X-Gm-Message-State: AOJu0YwVGnIe+baRyNka3oq1Dkfnaycmv3bfH/K0JmoPGoBXfjv5v0b6
        2ACnG8IoKCm44N5D3TFGNGD5PfTcAMYPH44Jie9lzLfZXw5jJxeQJFc9hw5lGv2rPIOHfbV7Lfs
        dP9RF6ENWTExEVQ3XP5YuGIZkILtmO/Kq8GzXcJj9Yg==
X-Received: by 2002:a05:600c:4f12:b0:401:bdd7:49ae with SMTP id l18-20020a05600c4f1200b00401bdd749aemr2887980wmq.18.1697847445116;
        Fri, 20 Oct 2023 17:17:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMVZnMB+J/FgQa8VZj36mJZ4kpObp0cRp5CFimotrdvSauQhycWrR5IHWAFgVCgfAWTIETmQ==
X-Received: by 2002:a05:600c:4f12:b0:401:bdd7:49ae with SMTP id l18-20020a05600c4f1200b00401bdd749aemr2887969wmq.18.1697847444697;
        Fri, 20 Oct 2023 17:17:24 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c488600b004080f0376a0sm3207801wmp.42.2023.10.20.17.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 17:17:24 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: mscode_parser - remove sha224 authenticode support
Date:   Sat, 21 Oct 2023 01:16:58 +0100
Message-Id: <20231021001658.1602526-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010212530.63470-1-dimitri.ledkov@canonical.com>
References: <20231010212530.63470-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is possible to stand up your own certificates and sign PE-COFF
binaries using SHA-224. However it never became popular or needed
since it has similar costs as SHA-256. Windows Authenticode
infrastructure never had support for SHA-224, and all secureboot keys
used for linux vmlinuz have always been using at least SHA-256.

Given the point of mscode_parser is to support interoperability with
typical de-facto hashes, remove support for SHA-224 to avoid the
possibility of creating interoperability issues with rhboot/shim,
grub, and non-linux systems trying to sign or verify vmlinux.

SHA-224 itself is not removed from the kernel, as it is truncated
SHA-256. If requested I can write patches to remove SHA-224 support
across all of the drivers.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

Changes since v1:

 * Correct spelling and grammatical mistakes in the commit
   message. This is a request to replace c1d760a471 ("crypto:
   mscode_parser - remove sha224 authenticode support") in cryptodev
   repository with this one.

 crypto/asymmetric_keys/mscode_parser.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index 6416bded0e..855cbc46a9 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -84,9 +84,6 @@ int mscode_note_digest_algo(void *context, size_t hdrlen,
 	case OID_sha512:
 		ctx->digest_algo = "sha512";
 		break;
-	case OID_sha224:
-		ctx->digest_algo = "sha224";
-		break;
 
 	case OID__NR:
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
-- 
2.34.1

