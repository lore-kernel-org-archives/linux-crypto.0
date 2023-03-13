Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD14C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Mar 2023 09:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjCMJSV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Mar 2023 05:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCMJST (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2023 05:18:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3465FFA
        for <linux-crypto@vger.kernel.org>; Mon, 13 Mar 2023 02:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678699051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PALIqLlKg2GDdZ3UjcapC6mNS6Y/72QSCU5pkVKimfk=;
        b=GwlH57OYrKD6k2QwbQJc78aKPNuJPJ1XzK3T1GkzwY9S+j3LIIkdiH+QT6963s1nkv6v8B
        TL3lmrU2x5g09uIec7hIfq5P0gLtG4dxvZWwartkQVQqzB7naqJ5+cV++9JJcGfYJ1L4QX
        G5Wb47K5n15tDiNfr1RxZ9Xpah3GIlk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-JZIcwCV9ODu48pbJllHIYw-1; Mon, 13 Mar 2023 05:17:30 -0400
X-MC-Unique: JZIcwCV9ODu48pbJllHIYw-1
Received: by mail-ed1-f69.google.com with SMTP id dn8-20020a05640222e800b004bd35dd76a9so16119927edb.13
        for <linux-crypto@vger.kernel.org>; Mon, 13 Mar 2023 02:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678699049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PALIqLlKg2GDdZ3UjcapC6mNS6Y/72QSCU5pkVKimfk=;
        b=GBE1nxt6NUfg3x46OnifVPUqTBm+ffd7/uwtfI2Jy+UKdSwD8T18TkObMcs7M2+C/g
         1I84EoXMMjVho1gSkLbQTamXu8JiD5iZ4Uy48qXON7EBWhe9oSMuDxuv7mCIRvH1+fQV
         GdzMsWlBR4qbemOPiQv8JrE0bOjKQAA4ERcADA94eYGBsWknqbPZUTos274lLzaKboam
         jvYMig7H+HgkUDzl83UMFP2WjNUyqrnuhtNVTMJ5vfEjPX3PduXDuNlGfIP6wuYWdN/i
         j/y/FSKW8AvLcHzBRZRy1tKlJzUT4TxPmUuyeDzklaK4aY0E4k6Hoo4OmEiPYOJPMHty
         cHEg==
X-Gm-Message-State: AO0yUKV5bseJ8IMkgrczS2xRJuSufX7b2NshMxgiSoCvke7c+R0twOVV
        brQLycqCElaKq4nMB+5pzX7ln5ZUWg7cQJWJLlU+MYNvfOyX3p0H3N+6hbtC0HkDGzRU6NZTC8W
        MZPtowOWmUKZ3yQ/7pGNN6bTC
X-Received: by 2002:a17:907:20b2:b0:91f:723b:8d04 with SMTP id pw18-20020a17090720b200b0091f723b8d04mr7757645ejb.28.1678699049358;
        Mon, 13 Mar 2023 02:17:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set+s8ziOEYmIxZzjuqn+zHkdK/VTYAgSg4adtZ63uwaJqLAC+a8GiSsrhkC8qnhxtGv5uyBERQ==
X-Received: by 2002:a17:907:20b2:b0:91f:723b:8d04 with SMTP id pw18-20020a17090720b200b0091f723b8d04mr7757628ejb.28.1678699048937;
        Mon, 13 Mar 2023 02:17:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709063e5000b0092435626c0asm2103342eji.29.2023.03.13.02.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 02:17:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23B0D9E2974; Mon, 13 Mar 2023 10:17:26 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: Demote BUG_ON() in crypto_unregister_alg() to a WARN_ON()
Date:   Mon, 13 Mar 2023 10:17:24 +0100
Message-Id: <20230313091724.20941-1-toke@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto_unregister_alg() function expects callers to ensure that any
algorithm that is unregistered has a refcnt of exactly 1, and issues a
BUG_ON() if this is not the case. However, there are in fact drivers that
will call crypto_unregister_alg() without ensuring that the refcnt has been
lowered first, most notably on system shutdown. This causes the BUG_ON() to
trigger, which prevents a clean shutdown and hangs the system.

To avoid such hangs on shutdown, demote the BUG_ON() in
crypto_unregister_alg() to a WARN_ON() with early return. Cc stable because
this problem was observed on a 6.2 kernel, cf the link below.

Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Return early if the WARN_ON() triggers

 crypto/algapi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index d08f864f08be..9de0677b3643 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -493,7 +493,9 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
+	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
+		return;
+
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
-- 
2.39.2

