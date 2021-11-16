Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB9CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6651B619E8
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhKPL3t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhKPL3b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:29:31 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B19C061766;
        Tue, 16 Nov 2021 03:25:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so2095684wmb.5;
        Tue, 16 Nov 2021 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=KIxL8pBMd//z5YINEw+kh9VMjDTIKYH5lzSpZAefCDI=;
        b=WjtCOMMLpaA8sOhPA/0pKpG5Pjx22ssT5Zy9+XY45U6LQ7ZVk/7eaNAi4nZPfhoT09
         7R4XhIrksJQ1CdNDDFWh1WJBhfGmzbwc+bGMwxKAC6ttM4G5LOS5AySeONbhcI1xHve/
         X5wuPCrQR5rAfnh+sG1Yb7QziO5QrrIOxmSBH//cO0iUYtPws1fjK9ZiCNmVVEUU576H
         haZKIcCgIglMWTisNVK3Vd9dI8GqPpvTeqoEs7+71qxDhH5oTBmrWEgUEAwUF705qJ3z
         4uzlGH6g5wHgOjurP7ylVKCafttBGNEZBHeYJEs+g3xAJo4Rj4avxR+UE9Fy+8Z65bSl
         5fiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KIxL8pBMd//z5YINEw+kh9VMjDTIKYH5lzSpZAefCDI=;
        b=yiEfgKW3d3TAxoGksgOH1hscOjdHkHpsxyUHCNtdy1qFZ52yosuH6wPwn7yFySqzb/
         SD8IeZDHp+TTAev54D3qIWcjwDyq8zLCL3hxw1T1CEJj82/3ZrOUOxYSiiK/bM3CA/ii
         DjGkNJk9tz74XBxm4nmOp3JH9x+OU4tHiQmCW6zWkhC+6W7CE1iIgwi19smIgpkvdBpb
         WyrCiIeCv6bmE+NWkJrN1KitmjMiEifBNxnLlY+yF0Y7CZ8psSDo7+SgcjK6LWznr5IW
         oeSVQwGJ7/uUYsLEd0hWOPiI7l5M+js1KyxwoEOSf/XAFO0Iady/SIxiyuyFbcM1NA26
         uqxg==
X-Gm-Message-State: AOAM533FNYTD0hF+iM6DoiyQMVY/Z7IWmrQMncau++DbnQq4zKlfbMCb
        sD4aXmIBMCDbSRo1+XRtsvDHTl2EMVd6vg623yq7ajo4rM0=
X-Google-Smtp-Source: ABdhPJxnbFQv1dTzlXUN67+XMFz/lUUZpvt7OlTc0tdxapNHsE53zcaflGNH6ScTj3O2csAYZxRXAeBNNWGHy7A7oNk=
X-Received: by 2002:a7b:cf10:: with SMTP id l16mr69365510wmg.17.1637061933897;
 Tue, 16 Nov 2021 03:25:33 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:25:22 +0800
Message-ID: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
Subject: [PATCH 1/8] Replace memset() with memzero_explicit()
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace memset(address,0,bytes) which may be optimised away
with memzero_explicit(address,bytes) which resists
such optimisation

---
 crypto/des_generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c85354a5e94c..105a32e7afea 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -30,7 +30,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
             err = 0;
     }
     if (err)
-        memset(dctx, 0, sizeof(*dctx));
+        memzero_explicit(dctx, sizeof(*dctx));
     return err;
 }

@@ -62,7 +62,7 @@ static int des3_ede_setkey(struct crypto_tfm *tfm,
const u8 *key,
             err = 0;
     }
     if (err)
-        memset(dctx, 0, sizeof(*dctx));
+        memzero_explicit(dctx, sizeof(*dctx));
     return err;
 }

--
