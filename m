Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989F4ECAAA1
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 02:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbiIFCwB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 22:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiIFCwA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 22:52:00 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E59F5F124
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 19:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662432718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9SNYQWnprxxClMNnaeVCmK6Kfg/AHOIpiytMtyCNb8=;
        b=m4F37Bjc1x3XpYXwOxe7ItGlNnSxmw3m4nwR25fjdl8et6k1m7oBDq6FVM61KrhiIyO0Qq
        x1wjYAOKwix1K/XgjznuDSfUez+tBwMZGXOa8nagXgQsAwoVQEkm19iMnzd16qmRQVFEdO
        S6d1RAqP7WpVjfBhVpjOqG4jn8+zJajCz+73jyJpmr2CIyV/YfZyZUCwlZsfSrsvqhLz66
        5A6U9dO4XQBdVo7wCI4QBZSi/8PZtzM7Rzm1AkPafYkLFbsIhdpB5WGqWAsYq77GshUAkj
        PwPavKl2gFKqurKGS0mMsx2j+NlO36t17L+Ovr21AC9b1XUCaC5E96UxHXWQ+w==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-622-D6flh4ZTPpmVigD8flmrZg-2; Mon, 05 Sep 2022 22:51:56 -0400
X-MC-Unique: D6flh4ZTPpmVigD8flmrZg-2
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 5 Sep 2022 19:51:54 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
Date:   Tue, 6 Sep 2022 10:51:50 +0800
Message-ID: <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CRYPTO_AES is needed for aes-related algo (e.g.
safexcel-gcm-aes, safexcel-xcbc-aes, safexcel-cmac-aes).
Without it, we observe failures when allocating transform
for those algo.

Fixes: 363a90c2d517 ("crypto: safexcel/aes - switch to library version of k=
ey expansion routine")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
v2:
 Add fixes tag

 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3e6aa319920b..b12d222e49a1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -740,6 +740,7 @@ config CRYPTO_DEV_SAFEXCEL
 =09select CRYPTO_SHA512
 =09select CRYPTO_CHACHA20POLY1305
 =09select CRYPTO_SHA3
+=09select CRYPTO_AES
 =09help
 =09  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptogra=
phic
 =09  engines designed by Inside Secure. It currently accelerates DES, 3DES=
 and
--=20
2.17.1

