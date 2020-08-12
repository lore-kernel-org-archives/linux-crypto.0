Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226A0C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 09:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6207207DE
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 09:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfNPn7bD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgHLJWx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:22:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726255AbgHLJWw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 05:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597224171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9hlw27+QAyDvFDOZ0xuy4pyvs7jIU3OJhh819xrt9Fs=;
        b=KfNPn7bDIA1Ff+5dhACm9mkiz7M15KaVYKF1TOQ9tn3QNjsZuNmfFJ2FO0WtQRqmM86xSD
        pvhxJhqylbzFjfbjJjMiy6X3XL57LJlfdhEvqgaQMyrFMVjzf7Q72jAkpzlXGIl0Sf/m37
        HAMhvX0PeiHJ0gdUXCeKFFz7PM768+Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-ShZNlexROIWGOE06zyFzYg-1; Wed, 12 Aug 2020 05:22:50 -0400
X-MC-Unique: ShZNlexROIWGOE06zyFzYg-1
Received: by mail-wm1-f70.google.com with SMTP id z10so658985wmi.8
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2020 02:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9hlw27+QAyDvFDOZ0xuy4pyvs7jIU3OJhh819xrt9Fs=;
        b=apqA6/3cW8jWkudGzhig2U6zxN//6YlbzO7xVL3AIu6F9U3w75BGkf1CmA7xlsHBNI
         h2O3NvfgQ/SIzz4FouaCekux/ZDus/8ivrO0Dfu8mQPqsYSIE6K7yGvR+Ygf2s4CWH4e
         sh7es6WinzEJag3cs5LdKLTwtlp8/D/Ds26twKWgK2lhsA3zF5Zpp6hUnvIiSM12o+8b
         9eemyw0eMp6AK/3d0SoiOFhFp7xa9/FeJCRCpKJEiKaYqJiq8MJ48Ac7ont7nfP1eFIB
         Rzix4U10ncKDyzrgSlscXbIoyMDZnXYbjLLtVvJQmNYkPeQZ6i/mA5U1WvWNrTjT3UPl
         KT7w==
X-Gm-Message-State: AOAM532QvGuxfgugD/hTrM3f2gRaBLOkcLHuuhmqXBghUzEqStzK4XdE
        0fKDruMVfpbpkIPLVDdCKwb2DpWeabY0NsQxTQ/iAVy1548CCjJXAy08mmHH+Ntt5TE9vA8Zix/
        m//jeYk3Lzd7+7nQlONETxoE4
X-Received: by 2002:a1c:80c1:: with SMTP id b184mr8149183wmd.121.1597224168745;
        Wed, 12 Aug 2020 02:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzODqTP/yclC7XuZOG12V+9+647wNxFqQXuseWEwOM5E+ud7pK9q/fzWlSBhsKQ2x/gXW45Tg==
X-Received: by 2002:a1c:80c1:: with SMTP id b184mr8149159wmd.121.1597224168482;
        Wed, 12 Aug 2020 02:22:48 -0700 (PDT)
Received: from omos.redhat.com ([2a02:8308:b13f:2100:8a6a:ec88:3ed7:44b3])
        by smtp.gmail.com with ESMTPSA id s19sm3668091wrb.54.2020.08.12.02.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 02:22:47 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: af_alg - fix uninitialized ctx->init
Date:   Wed, 12 Aug 2020 11:22:32 +0200
Message-Id: <20200812092232.364991-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This new member of struct af_alg_ctx was not being initialized before
use, leading to random errors. Found via libkcapi testsuite.

Cc: Stephan Mueller <smueller@chronox.de>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/algif_aead.c     | 1 +
 crypto/algif_skcipher.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index d48d2156e6210..9b5bd0ff3c47d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -563,6 +563,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->init = 0;
 	ctx->aead_assoclen = 0;
 	crypto_init_wait(&ctx->wait);
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a51ba22fef58f..0de035b991943 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -350,6 +350,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->init = 0;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
-- 
2.26.2

