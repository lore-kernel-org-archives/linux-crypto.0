Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE64C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 May 2022 14:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348926AbiEQObJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 May 2022 10:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348966AbiEQObE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 May 2022 10:31:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6823817072
        for <linux-crypto@vger.kernel.org>; Tue, 17 May 2022 07:31:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id f2so18014758wrc.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 May 2022 07:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wVhR+tLTgWRBv165klscGkwBvwtkGY4K+gXBpaEt39o=;
        b=AVNWGASSw6V5RUrPE0Xe922Dr1PoPah/DHCQjXENO9s0HFGB/eYpWl6axQWl/QnFZH
         uRmMiarJD/nw2TwKyvyACE+uNu/LtM636YM+bXBmDWbMz/LvizwmSvb0uhzKoKggSF9I
         RddWK4xmLBsCErMkW0NkfvF8unM5J4Sy7tB4XDdauDZT+qkVIm80Ijx7DdSpJQlMeNUQ
         9MruKiM1t0I8MvBJdkw8JEuhdV4K7V79+VHa98U7QbGacXpl6JEqLz3ahlSfKlJq2FYV
         w4pzBlJMAMO9CapLPiqmyQnhrxlET8Is5fQXqESFEI2JcPHofkbd9BYb47Gp15j9BJBN
         XJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wVhR+tLTgWRBv165klscGkwBvwtkGY4K+gXBpaEt39o=;
        b=3fAO5RFWPnb1SOLfU9pn/KNv+A55WuEf6ynEpIwNImCcxT6qnwKl8+5K0ELR29l6Tp
         /pNkchyovbPHlADAXGLjbEn4E5UYKWDybh4SyIp5srKQnKzde2He/xDFux+7ZoFjYjrp
         PS6PdscuNYUt2B6ozMtwDuexA2Pv/QQTZUm36s5gKMzVlQDirsea/he/p47EDKgheqwk
         uEtxhNFP9XDCVLXuGgyg+GDQnaKPzZPrcnyX/c9kZa8Gs0p9OKHgoCt41cWLrQTqnRyQ
         2DmgnBMryAhWTdQdn+hR7q1xwCzDHXC7XC1wHNpvbOxfPB7zXE9YgW42BGzLaoyzRjf+
         OmQw==
X-Gm-Message-State: AOAM532kJG/fwGzzll6Q562D3oKgubpH1g14mx/YqAcM+MqmJeU06YH+
        iGkAKjFup5CGAkAQZbXPlq31ZpJlyCrKuQ==
X-Google-Smtp-Source: ABdhPJy3hzj7GtXAEMbX3XakDsp6tLitaXQroFjB5zMWxiGotgppusI9e/fS5ffNwObVzm/mABJOww==
X-Received: by 2002:adf:ef8a:0:b0:20d:1028:3c36 with SMTP id d10-20020adfef8a000000b0020d10283c36mr6256611wro.481.1652797860454;
        Tue, 17 May 2022 07:31:00 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:b946:2cd:4ff6:1fbf])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c460600b003942a244f2fsm1956398wmo.8.2022.05.17.07.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 07:30:59 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390/crypto: fix scatterwalk_unmap() callers in AES-GCM
Date:   Tue, 17 May 2022 16:30:47 +0200
Message-Id: <20220517143047.3054498-1-jannh@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The argument of scatterwalk_unmap() is supposed to be the void* that was
returned by the previous scatterwalk_map() call.
The s390 AES-GCM implementation was instead passing the pointer to the
struct scatter_walk.

This doesn't actually break anything because scatterwalk_unmap() only uses
its argument under CONFIG_HIGHMEM and ARCH_HAS_FLUSH_ON_KUNMAP.

Note that I have not tested this patch in any way, not even compile-tested
it.

Fixes: bf7fa038707c ("s390/crypto: add s390 platform specific aes gcm suppo=
rt.")
Signed-off-by: Jann Horn <jannh@google.com>
---
IDK which tree this has to go through - s390 or crypto?
maybe s390 is better, since they can actually test it?

 arch/s390/crypto/aes_s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 54c7536f2482..1023e9d43d44 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -701,7 +701,7 @@ static inline void _gcm_sg_unmap_and_advance(struct gcm=
_sg_walk *gw,
 					     unsigned int nbytes)
 {
 	gw->walk_bytes_remain -=3D nbytes;
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	scatterwalk_advance(&gw->walk, nbytes);
 	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
 	gw->walk_ptr =3D NULL;
@@ -776,7 +776,7 @@ static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsi=
gned int minbytesneeded)
 		goto out;
 	}
=20
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	gw->walk_ptr =3D NULL;
=20
 	gw->ptr =3D gw->buf;

base-commit: 42226c989789d8da4af1de0c31070c96726d990c
--=20
2.36.0.550.gb090851708-goog

