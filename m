Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD384C61DD8
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9872922280
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="uhrUcNEK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgKPNy3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgKPNyZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 08:54:25 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1599FC0613CF
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id j19so6490749pgg.5
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+A359lF42tZa73dPiOWZxYbdDHUjaoA4SP1/TVC6kqw=;
        b=uhrUcNEKOBNJHazYbkL0/WF/jWRl6a4lPtR5yUmS/9ZGu9nIeJeSBAYW7AixeYsajJ
         MdTINMXr78JkR3QHYkXVFW6bU/3iPm5GOEoxaIBRV34IVfhMC3DOPR2d5Ij1wyOFHxw7
         SSIcAwr0NphdpCzUpdzlLNuimTIpEcRFEmh/FA5qPhCTPu4xUNW7VYhvfJykv/9jV4Pa
         +y2GKPkUqDCS/I2AYrEUDrv6LpFFe/iBpLAPRTF2wTaUP0kYvhfFKCrAoMR3WucUC5UJ
         unoa8iDF+ShqImnC7uASDcgwnvpRL3fhpyjSjNysN6bM6c12EhXhdAGpHyPP5wWYRlFT
         OoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+A359lF42tZa73dPiOWZxYbdDHUjaoA4SP1/TVC6kqw=;
        b=W52bJsYH6g37QkqNbOXh29XIgAqeBJcaHPz+y1HcHkUL8We8RINcBUbJ2p9iwfr10C
         C2g3GXyzM9y/bPENuY++1Eww0Symve+hQ6prydU7X+JyE5DgkHZPg33Vyjs3Bim1FHq/
         /1nwqZBjVeQtj4Og1/bx7ZLbzu2monPI0g0mzC9jqHM44506gNpdhFe1D/157mWh5Emx
         BYEmLJXBJ03Wp2UCBpT/mZRzXzW5VDbiBajnvme/ajvhFn5+IwZ1EUEyr7JMm5jUAYE4
         3FxlacD/qeqk4avj1WEfpOfQ9flQoDI+ILUvPXbs0tLkqEDonrSqWjp8swKXxGEvT6of
         3/Iw==
X-Gm-Message-State: AOAM530ndeLceOAe85yZ7YZwgvOca/O1ovsKBPNvNqwOoXAOMlsqodPQ
        SiYe4rpnF7NxC+pUAMQJFH0ABQ==
X-Google-Smtp-Source: ABdhPJx7zPBrpHujwVU2oFB8zrUqJuJFYi0hZX7sx2UK8bvDlOvTG38tK788gR3212Yjzqoa2hpXLg==
X-Received: by 2002:a63:4759:: with SMTP id w25mr12628446pgk.414.1605534864664;
        Mon, 16 Nov 2020 05:54:24 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:24 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/7] crypto: sun4i-ss: checking sg length is not sufficient
Date:   Mon, 16 Nov 2020 13:53:40 +0000
Message-Id: <20201116135345.11834-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4..4dd736ee5a4d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if (in_sg->length % 4 || !IS_ALIGNED(in_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if (out_sg->length % 4 || !IS_ALIGNED(out_sg->offset, sizeof(u32)))
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
-- 
2.26.2

