Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21927C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiBJOdM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:33:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiBJOdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:33:12 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252E4233
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:33:13 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id fj5so12951931ejc.4
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=yZqr/7eaz7q6/mAp6HZD54HGq2GYcRYzLMhlOyPhqvY=;
        b=RP3wrYD3fK7b3UDCNOhEQ4G2rzSYVN/UFaKvY7CmWVCnuPb/dgu4JnzVTX6etlu07F
         WEVNu8w4V/l6A4OobJfRsvf8F3zy2kgkhpnNVKm64KY8wHE19Rqq7x9gU+Fc8YfJCTtc
         0YtcFRnfIBymFxOi3I350SZ2Yu+ke+MBSr8UfC2OjI29qMRBgz7ggAKHWppkl2Wbmj1D
         N2y2NpSQey5KbaB5VOThwcXd85BdyArMG8zEEVL9TaRNOmmQibp+aWTpXIG9FdP+2MJ8
         Zwld9oERRfMB9rzpCvwhMm/AIcof9mz8TQXxNbBV3Y26hjb1ouD02ihpUkRoD7t9gVf6
         WHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yZqr/7eaz7q6/mAp6HZD54HGq2GYcRYzLMhlOyPhqvY=;
        b=lGKZ6Ph1ajz0I5zu7wIdCBVdWT8Zxq+0y2tap/qhIwfR4s/h08bXtdbq2Zcb2mctAy
         /CNiSJ0+zmBp2Iq7dO1nT9podNp2IB3Sb8es6dQZxbecsaKBfcUCLY+OaziAPQsij54N
         MpZMc6p2BLevycKbju+RCWnvc0CQjxp7VUSoZxqV6TvmQZ+mXd1CTkVOTV00Z4x114Vy
         4Td252lyeFrr9J7dDjkqwSnLeSyCw3XkrbKg0MFooMvwoOsEfgTZSSwVMNgChzTN6n43
         uTWByo/1djepV0JBo8VcNMssu4CbAaGV4AIv1qvses2HJCo/fLR1Aa2Xya/ydHexVZ4/
         tR/w==
X-Gm-Message-State: AOAM5319y5m6qss1fSRNxyXsBeZvzlhqhCE7EkHto44LCd0yESeo6tB7
        NDNdQd8foDt9JV/dVl9quzvGPmAmN0im0BkS33TmL7uoDWs=
X-Google-Smtp-Source: ABdhPJwqd6DjMwOnuGUs7lTmp6HxhyN1ID/QmLEdjk0nO3NN6ta/WiOWva7R23Wg6UW1GAwBEXteUXVvKQCpYOC7HjE=
X-Received: by 2002:a17:906:99c6:: with SMTP id s6mr7071224ejn.522.1644503590022;
 Thu, 10 Feb 2022 06:33:10 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 10 Feb 2022 22:32:58 +0800
Message-ID: <CACXcFmk-aYykec-paGy9S-kRy4ipZkhX009qdtJo+fPjopPCiQ@mail.gmail.com>
Subject: Subject: [PATCH 1/4] random: Simple utility functions
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simple utilty functions used by patches later in the series

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>

---
 drivers/char/random.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3404a91edf29..c8618020b49f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -356,6 +356,27 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>

+static void xor128(u32 *target, u32 *source)
+{
+    int i ;
+    for (i = 0 ; i < 4 ; i++)
+        *target++ ^= *source++ ;
+}
+
+static void add128(u32 *target, u32 *source)
+{
+    int i ;
+    for (i = 0 ; i < 4 ; i++)
+        *target++ += *source++ ;
+}
+
+static int get_hw_long(unsigned long *x)
+{
+    int ret ;
+    ret = get_random_bytes_arch((u8 *) x, 8) ;
+    return (ret == 8) ? 1 : 0 ;
+}
+
 /* #define ADD_INTERRUPT_BENCH */

 /*
-- 
2.25.1
