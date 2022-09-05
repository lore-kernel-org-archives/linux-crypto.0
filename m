Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BB7ECAAA1
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 04:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiIEEQD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 00:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiIEEQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 00:16:02 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD14D22534
        for <linux-crypto@vger.kernel.org>; Sun,  4 Sep 2022 21:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662351361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyLRC/HXJQzbNsEggZ5hesrJmXE8eSpUpvyD9azmo18=;
        b=hJIQtlL5XZ4ulE4O2+g7x/BWDVMYZXex3wmauON7H7tBZO5ljQnICruuRgy851IX38b2id
        lxj6vd/Kultr9jI76Fi+h9R+CZG4c0Iz9Ld5mZAhbBRnheM2jwtTIScMBXwRvQffILeSNH
        GD+gK45nfqBCb6FqLBB1knIKwnpI3H8afQAbdjBjKL3gOTB0c3+LUF0IcutpjQTPle/B7Y
        +uef5LzeC7A/WQzT557Mfb/5iudVuGtL3eKKKDJYH/MDK8FHpexJF2HV7DnRpSr3kuD9DU
        yH9+sJZVXwhyiCKYw8f/4dnGaFE3Jz0D4Rgu1mQmmkh9RAyqExVDJQ816zoDdA==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-321-WyYANILmOp6YjgdGpRM8Hg-1; Mon, 05 Sep 2022 00:14:52 -0400
X-MC-Unique: WyYANILmOp6YjgdGpRM8Hg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Sun, 4 Sep 2022 21:14:49 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH 2/2] crypto: inside-secure - Select CRYPTO_AES config
Date:   Mon, 5 Sep 2022 12:14:44 +0800
Message-ID: <ba011c14c0467c094afb062c3fe2cafe16c2b6b0.1662351087.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <b08e76c7ff0e46e25e21ee0827fcf3b0e94556bf.1662351087.git.pliem@maxlinear.com>
References: <b08e76c7ff0e46e25e21ee0827fcf3b0e94556bf.1662351087.git.pliem@maxlinear.com>
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

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
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

