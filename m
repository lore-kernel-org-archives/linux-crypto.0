Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521FCC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EC1B206EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrqsgFOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfKNK65 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:58:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56070 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNK65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 05:58:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so5178121wmb.5;
        Thu, 14 Nov 2019 02:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wum+r9IxQN+rS5FkOk3xObRIwf5TgCXVqI8T5QkIBqs=;
        b=FrqsgFOnekzjR9uZnWUA765s2vX5/GglVbd4qZX7FBAB4MP/LUJZGFRBbdisoKt6ul
         hwrC4BjfOqB2gZuYhYAKAuP0M7XpCyc/eoZySf4+rz1tvWBW9IZF9xA7rPY+zB/GGRhb
         Zr35xPfg5lxfAtvrums/zq0TdOOKMQR3kBtlWFD2UTuyhW+zyrns/H5/2FeLOmzEhMyo
         b9U6JRu5Hsp2l+icsg+gC/wYm/Gkktc7fpFmmZZ3aQ7RfTUC18JhEq7ernKfuZbDrm4h
         jb8xaSDjo7WNq/EbxTn1FDuwMTJlFVwvSLm461bQzkSSdnvbYF/9BrzU1dnkydbSC2nA
         tPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wum+r9IxQN+rS5FkOk3xObRIwf5TgCXVqI8T5QkIBqs=;
        b=Iehh5pDjAgSNMFcrouNJOZgEH0DzBtprDl+fBtA1lSxzKBTIB2joLKu2KxX5Sqy3H9
         a0RU9mLK55s01+eMd+KCnP8sjrBHJEeBRt3oHlrRF6zD7+xV0ep6/J12/9vfMFLzu+1r
         jHexzn7orNBV8OmWqRchBtJI8zUFpoiXQDEAOAbHicK0ABuDEPKnb4JVXyz1V8OOQLI9
         vVMamojdVqFmAJkNT12u7LpKDJAue8uGqS/x+HMr3R5F2mBQSQ7UcahVqibOA3z6B6Z9
         NqOi6fzqOvPvGJUZEDETafrE4rPEPEkKDjU6S8E0kqLi8JIeDumsoEe/Eg1bGw3+OnZH
         prYg==
X-Gm-Message-State: APjAAAUbQOgcYBPCg8BdUBmb+A4gklsm68w5rGgBeEHwXyYa1NM4BfiQ
        v6rUrIBLgl3pvq/igYmUIr0=
X-Google-Smtp-Source: APXvYqxnAvodHB73Hk5uW2nPyXQaCzxyAot3j5TwEn2X3eEDfwaH3GPorH+nW5QLGR2PwC+ozN60oQ==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr7713976wme.90.1573729135385;
        Thu, 14 Nov 2019 02:58:55 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w4sm6585278wrs.1.2019.11.14.02.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:58:54 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss: hide the Invalid keylen message
Date:   Thu, 14 Nov 2019 11:58:52 +0100
Message-Id: <20191114105852.21672-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the "Invalid keylen" message to debug level, it adds no value, and
when CRYPTO_EXTRA_TEST is enabled, it floods the console.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 5ab919c17e78..cb2b0874f68f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -540,7 +540,7 @@ int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		op->keymode = SS_AES_256BITS;
 		break;
 	default:
-		dev_err(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
+		dev_dbg(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
-- 
2.23.0

