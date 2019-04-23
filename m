Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A470CC282E1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 16:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3F5217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 16:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfDWQ36 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 12:29:58 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44832 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfDWQ35 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 12:29:57 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id CC3BB72CC58;
        Tue, 23 Apr 2019 19:29:55 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id A8A024A4A14;
        Tue, 23 Apr 2019 19:29:55 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] crypto: ecrdsa - select ASN1 and OID_REGISTRY for EC-RDSA
Date:   Tue, 23 Apr 2019 19:29:54 +0300
Message-Id: <20190423162954.7859-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix undefined symbol issue in ecrdsa_generic module when ASN1
or OID_REGISTRY aren't enabled in the config by selecting these
options for CRYPTO_ECRDSA.

ERROR: "asn1_ber_decoder" [crypto/ecrdsa_generic.ko] undefined!
ERROR: "look_up_OID" [crypto/ecrdsa_generic.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git crypto/Kconfig crypto/Kconfig
index 4446833f6eca..3d056e7da65f 100644
--- crypto/Kconfig
+++ crypto/Kconfig
@@ -264,6 +264,8 @@ config CRYPTO_ECRDSA
 	select CRYPTO_ECC
 	select CRYPTO_AKCIPHER
 	select CRYPTO_STREEBOG
+	select OID_REGISTRY
+	select ASN1
 	help
 	  Elliptic Curve Russian Digital Signature Algorithm (GOST R 34.10-2012,
 	  RFC 7091, ISO/IEC 14888-3:2018) is one of the Russian cryptographic
-- 
2.11.0

