Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FD5C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 01:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC6B61167
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 01:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349381AbhIIBzC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Sep 2021 21:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbhIIBzC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Sep 2021 21:55:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90197C061575
        for <linux-crypto@vger.kernel.org>; Wed,  8 Sep 2021 18:53:53 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id n5so95961wro.12
        for <linux-crypto@vger.kernel.org>; Wed, 08 Sep 2021 18:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=nDI0lWOvRbTpmXdIynSWkkEMpzU80DIrknHoEneZpEM=;
        b=Qr3Qn8poEA0yPcd2vxHxZGy2FBd5DQIjZyfHBSteu2GXUC5x/nrGUagWmX5Fgywoxv
         FyUyRCBxHpd7lLhSxpnt7zYMquFWaq3SA7k3sz5Ig/bJka+90PRlgyZUnc6AYM1EOODW
         RcSB1Ch3GK5oXGm4LJJrmqnnKTy3H5+E4vtmILEBcr5j0I+mmUiNDB1/Qm36pwEHoBkt
         p4KhpQKRIOU5qCxeJPEicQvArQHsOW1VaFF5Gz+zAcTe3RuaaRgI588tqyaCZPHyxs5h
         E/+7LRYsuUXrNae9cz3S9Z3SGaYXGLEGiL0q7xaLgC8Fm99soBW1uN9YkYIhr1175AzU
         bWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nDI0lWOvRbTpmXdIynSWkkEMpzU80DIrknHoEneZpEM=;
        b=0x1sySnY+tx23ia3gYalp+U7TT+06Q+0VQ84EHx669D1IYUKbIucTO6Gtu7EhT2Ns9
         HdDAONTAijnkGFvGwgfVxkinnaI161+ZF+eV56pOVcahkLKUSEvG7I2bOAavmzCynVKd
         jUbOWpa8IKQDhkWYq03Ecz4S7999YY+T96WZblP/IGifSdbsde9G7sDyOlYPxR9q484L
         2Ykn4EG+558QPF97IPxWLg5pRfryZhjkb4rp06KzmIA4O7sVQKYtSu5+Jzd0iScVCngh
         jppUgbOI1/kUFrkNg6d3LQ0xGJbVq5nb2gOG03FcgYwpVNR7J2c1bR3H1BEa9HoQvv07
         C4Wg==
X-Gm-Message-State: AOAM533PrXybjU8wkfzwEC1dbzNcFOOtPkav+wo8fFfQ14IzVjjMYMhV
        D63CbpNIrRksnoZTNsCZolLM39MsXCRmzO12BSOKANBVBQE=
X-Google-Smtp-Source: ABdhPJyAHfd/Mi5pPkMCKy5mUHhb65VXCd9cGphVRkRg6NbOW1e8s51U3DFcFcvjXJmxX8opfvhObKGIZOjicGrbtNI=
X-Received: by 2002:a05:6000:1c4:: with SMTP id t4mr545395wrx.414.1631152432061;
 Wed, 08 Sep 2021 18:53:52 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 9 Sep 2021 09:53:40 +0800
Message-ID: <CACXcFmkigZwbL8TtA7rATWhxGzL=1k6UsyLydVmDgp+PZtq8wA@mail.gmail.com>
Subject: [PATCH] random.c: Update RFC reference
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>, trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RFC 1750 was obsoleted by RFC 4086 from the same authors in 2005.

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>

---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..57fe011fb5e4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -303,7 +303,7 @@
  *
  * Further background information on this topic may be obtained from
- * RFC 1750, "Randomness Recommendations for Security", by Donald
+ * RFC 4086, "Randomness Requirements for Security", by Donald
  * Eastlake, Steve Crocker, and Jeff Schiller.
  */
