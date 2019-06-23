Return-Path: <SRS0=ZGow=UW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFFAC43613
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 01:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC52020679
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 01:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tzzplFjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbfFWBkI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 21:40:08 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42854 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFWBkI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 21:40:08 -0400
Received: by mail-yw1-f67.google.com with SMTP id s5so4376348ywd.9
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 18:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6qwBlkavQsZFdfvrI0rrr9RPLzQk1oY16UOPP3aJ5gs=;
        b=tzzplFjOgB702qG9W7ro+S4Fd3scZGKPBMQvrByQm2y4IR3EPBibc8j4ZXzJmkSPIH
         tiT9Fr+e5wFhgS3Ww9tm9i57M9zZnf9CWH3hjR5I4OPfEkAHtbLVpMdlFyOZQz7xMrMo
         0F/U4ysp4BQszwTlUqawdGeaiLI8YvclixyHitujo/g9wgwZI07J+3vFiU9jijQ81XIt
         3LqbrZmQ9sYkRGwDy/42HP2kw02e//nACkAmG9sxeDHkhrEBRyGhuUwv9wM9aVIq2Zm6
         vcxUwbW1cD00xRoXINRCGf1y8Lz9SUy0Gswm6VsEl0jJiruX5Fyo25Rgm2x1h/UNrnWw
         W9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6qwBlkavQsZFdfvrI0rrr9RPLzQk1oY16UOPP3aJ5gs=;
        b=V5NVdxXZAdYvBBK1nGqP13UrnyOTZnjMUDVxwDrWkNEuYHA2YMVOcAraWmWBvPBVAt
         Qwe/SPZOZ4V0supURxYht36f6C6huPNOOXGNDUQd98WeFtkMlBaj48iC+WTIjxYuoY0f
         Q1jwn0H7SyJBUY1/DoDuBGrkc4VC3MXmDbGNnbyEbPvplkJdLR49xMKatK+mDDkTVwfR
         Cma5IBTO748qUbnL0xkxry0NTFgUBRbRoxXDD+5RhUoUtz558vvXxYrNoCt9OluIX5P2
         BvUmERKMLEnYHUihKBBlpGrNPqA+a0YUBJiKAm+BmEZAOQsQsesTCSTmkbPxm/tjY2HT
         TkTg==
X-Gm-Message-State: APjAAAVzEWjdM6kKPbIx/IFECAg1BGCB8avW+j6xR3qOqMzBRyPFTxAh
        2k2NyN8E9jIgZJ2qdahHVoc=
X-Google-Smtp-Source: APXvYqwP37dpSxznlK38aXXNY7Eopa8h6bZYSVOfJF0JeNuDlRnYRKEYWZI5uVO9AM5xQSj0vQhrpA==
X-Received: by 2002:a81:6987:: with SMTP id e129mr69132194ywc.283.1561254007475;
        Sat, 22 Jun 2019 18:40:07 -0700 (PDT)
Received: from localhost.localdomain ([68.234.129.38])
        by smtp.gmail.com with ESMTPSA id j8sm1823449ywa.62.2019.06.22.18.40.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 18:40:07 -0700 (PDT)
From:   Aditya Parekh <kerneladi@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, trivial@kernel.org,
        linux-crypto@vger.kernel.org, Aditya Parekh <kerneladi@gmail.com>
Subject: [PATCH] Crypto: fixed a comment coding style issue
Date:   Sat, 22 Jun 2019 21:40:00 -0400
Message-Id: <20190623014000.2935-1-kerneladi@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Aditya Parekh <kerneladi@gmail.com>
---
 crypto/fcrypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 4e8704405a3b..3828266af0b8 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -306,7 +306,8 @@ static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key
 
 #if BITS_PER_LONG == 64  /* the 64-bit version can also be used for 32-bit
 			  * kernels - it seems to be faster but the code is
-			  * larger */
+			  * larger
+			  */
 
 	u64 k;	/* k holds all 56 non-parity bits */
 
-- 
2.17.1

