Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B54C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCKQ0W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 11:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCKQ0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 11:26:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393CDDB23
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678551930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OBRwTopEw0dwu9lEDf0/COJ56MV55wT/icRDi86Rorw=;
        b=hgKiwc5K3AEYc1ozz2s6L/TDjL85M5wqTU3p+4JCzmoUOGsIFEEdfDu909UTLmUpk+9UaM
        cVmcZTu/kqQWhCsGCuUSVrjaq8mc56TuNc9PU9cC9OXJQrOgpP1VD28IjOy3ZNL5yrdtl/
        w7+RTX18d72KGr31lYH6YSxcm2uKFW4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-DaybakvMOzOBdiabZOac_Q-1; Sat, 11 Mar 2023 11:25:28 -0500
X-MC-Unique: DaybakvMOzOBdiabZOac_Q-1
Received: by mail-ed1-f69.google.com with SMTP id v11-20020a056402348b00b004ce34232666so11440903edc.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678551927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBRwTopEw0dwu9lEDf0/COJ56MV55wT/icRDi86Rorw=;
        b=tVutKl+jIqVbq/VA9DkqJ8et4tZPu/x0+0RBb0eswXYMyBeZZOkXe9y7u5Q47EoGhW
         JcC0SjOVt+4s+2RzcMDzaDiKEt5FP4NqLvgPmH3EQhPapbtQBLu4uTc1EFWW+sancaCE
         VVCp7q0YhWQXdc1HwCQyyzEJlLCPVXUhwnXa9CH7MMZMQARm8ZwdbiCErA7QWwp0kiBN
         YeStzaQ5Y5tbn6HTQ31j1jyAXW8VJN30VKJNAuRqa5mHPwip6zD08gk5dS5jC+uuA1fb
         bxJql2GcnnwxqL0fRBmVC4xH60MJPj65kTYcGIZBGtijZRxd0B6PFvwq/rP+zCK8g4Li
         bAXg==
X-Gm-Message-State: AO0yUKVOiGKf+aBhULwEZi034bRl3sUBol/nWhTJHdCqYa9E9afAUTMG
        VvQ+/WJEyzXf7Slq2OHnfOHgmO8ZNlr59dHxzwuUEES/5tHskYOls4Ja6N9iVNAE5xJSoP5HCrY
        +ab/4A+fxWNwLv2YZNcZyDL9G
X-Received: by 2002:a17:906:ceca:b0:8c0:386e:6693 with SMTP id si10-20020a170906ceca00b008c0386e6693mr27174997ejb.63.1678551927311;
        Sat, 11 Mar 2023 08:25:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+rB5736nbPM8uObuYQm7AkW2LUTsc52rqURJ7YquC4fxKP64uuIVCUlPeNSQ0YVhQKJDLigw==
X-Received: by 2002:a17:906:ceca:b0:8c0:386e:6693 with SMTP id si10-20020a170906ceca00b008c0386e6693mr27174950ejb.63.1678551926672;
        Sat, 11 Mar 2023 08:25:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r9-20020a50c009000000b004af71e8cc3dsm1336817edb.60.2023.03.11.08.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:25:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E9359E2874; Sat, 11 Mar 2023 17:25:23 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Demote BUG_ON() in crypto_unregister_alg() to a WARN_ON()
Date:   Sat, 11 Mar 2023 17:25:12 +0100
Message-Id: <20230311162513.6746-1-toke@redhat.com>
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

To avoid such hangs on shutdown, demote the BUG_ON() to WARN_ON() in
crypto_unregister_alg(). Cc stable because this problem was observed on a
6.2 kernel, cf the link below.

Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index d08f864f08be..e9954fcb61be 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -493,7 +493,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
+	WARN_ON(refcount_read(&alg->cra_refcnt) != 1);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
-- 
2.39.2

