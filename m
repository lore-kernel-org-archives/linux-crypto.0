Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51E5C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 02:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A07620657
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 02:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ZoGIw5n1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFDClF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 22:41:05 -0400
Received: from mout.gmx.net ([212.227.17.20]:59599 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgFDClF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 22:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591238420;
        bh=rBeNnWCkETjnvDe3kdb6C2KAvfLQEEfKNU9wifTgN0k=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ZoGIw5n1NnxzuVY9OEPuIxnqoKo2Oq3xIwtsoprjWAwJDw38Q0zSBAg9aNtoYHwoC
         M/9PsarM1tnVyr4QGfUWkjV3P/czxC0SI5jrWVUyI8UaKXyu5G9DQRWr7vY90QK0vJ
         GZUgPGlcxsFo2fczRnyuzCBVGpzotFtUXZl05rLE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from LT02.fritz.box ([88.152.145.75]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MWzjt-1jRUL72wZd-00XKM4; Thu, 04
 Jun 2020 04:40:20 +0200
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] crypto: caam - fix typo
Date:   Thu,  4 Jun 2020 04:40:13 +0200
Message-Id: <20200604024013.5669-1-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Jv9qzEZHPwAEEDZp5lJdXCBS3tYyk3aBIbv2/Enk6Bx3K0gG1Co
 QOEs6nj/Msh7f7SSIY0VYdyanyHWF8iQTGzFrTsl0pVD4nxwNuDesFgqTNcdGd8vrGxqJWr
 f0YIj/EuWgC3mSRRsg7ogmjgaT7wc75WXu8AR4r/eMtY1qrJ17rqiXtSFkAZbU/vGJbHz4M
 XOa01NXQ8HtkEIH4KXDiQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0Tw0YKok6IY=:pnp0uOOJgLNhUNhzFHp/bX
 GBZqcUdrURimf8IGTnMcdlRSci3lPvUEfhdlYe4chHNhRnUROAnxMMS3NShgfYXBgHA7lPX2Y
 n9Q9tk0s9KasV5q6uOTsNGBYXRUgtT7f4LLwTAzccZyaY6WgkqDOgPcMCLsQ8UOc9LDI9LImn
 p61Yl/r1tbK5uLCPJm3JQxonLNh3NlyqmAn6y9MwBM1SV4wVzDAS7rd+HHWaulfuUEKC3KL1X
 kI8Nx8AbH9t+/hOaFHd3Pb4QL6+yTbeVAcbApPhp4zAK52SEA7iMYLDC3bc+zNSS6/y2sMd/s
 35W2WIEMuJ9B1zSVpyMpaZXfecWZ3VE3keoKpYsYF3diwtBbREaKhvbECYIY4Hl769FhOjh/0
 AjeEgFhHUU5yxRPsUVjJBhwxjl//kDR1Uy1wvuBxqspZQifbcFqpENlrKwAoZtWLsQ+ctrSvV
 9yLzlDP7H29LZd7RwFyGhJc/ZPmxM20k4H26jyZmcPHFp60w4/zFTlcUOFYWcYQbbknslgSfI
 Yj02Qksvmm6tMf5ggfvU1S7O1e3BeP/pUSeUFTM5oRsUQjDUARID0A9QDfuL9ZGfwd/4l5KUc
 8m50sADD2OAMEGS+AC/Lqv2k1OtBsK8QCGNC7slPUGJfVFGL8BaGhqle+nC4U+B69pou14BZ8
 PILVRFg/IxFsqVe4x2Fzy35h/ONKskYtXHuWLbpSHLguWJk+TaVIVPAM9MgogHZ+q6NoU3SOd
 /zK3VwobtVe/pg3JkUq4iDwDky9RwfCVN06zMl/vmqRcwY9y5mw/bIDc5GKC3bTHfahKKeZUm
 6qHMt4ZMW4GJYM+9NMldL/FX/Rll1hUfb9q4JMHWW1f0a831m2HH0SnkX6KL/MI+Avs6l25td
 YfbceVw+iCQMRajDRV4NmO1+kE0b3deCsK96U4Pk8ocRryg1oHJHiEpWD8ZrVwtt7jG7NVVfY
 cUrwJ8aObM4xpIDEL+WAOmHtLiscj+KrBXmkCGGmwsaY2DJVcvWj8jX8h9uMqGE6T/5e2S10Z
 02wT6TFXv91NGFVHJjrv8fe0gd44HGtIg2meGRTcS5EwYys72Zgikd3L4QlViiBWST3Wo2bLW
 QmaEaw94vDmop78a/VI9ez3cz1kx0asmz4hjcdsaOZ2DmMa5sTLuHQeXhhzTaXHF855Zg2bkV
 sn5z2pH6wU00Pt4zUWoCUryf8XJrx55e+GUwkhhglO12IanO+OoqysD6D4SNa+97U1oBFO8xw
 j0kC6Y4gyqlhW0kt/
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

%s/suppying/supplying/

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
=2D--
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index a62f228be6da..bc35aa0ec07a 100644
=2D-- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -147,7 +147,7 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 	select HW_RANDOM
 	help
 	  Selecting this will register the SEC4 hardware rng to
-	  the hw_random API for suppying the kernel entropy pool.
+	  the hw_random API for supplying the kernel entropy pool.

 endif # CRYPTO_DEV_FSL_CAAM_JR

=2D-
2.26.2

