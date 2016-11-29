From: David Michael <david.michael@coreos.com>
Subject: [PATCH] crypto: rsa - Add Makefile dependencies to fix parallel builds
Date: Tue, 29 Nov 2016 11:15:12 -0800
Message-ID: <8737iagksf.fsf@coreos.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33596 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755800AbcK2TPP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 14:15:15 -0500
Received: by mail-pf0-f180.google.com with SMTP id d2so33533893pfd.0
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 11:15:15 -0800 (PST)
Received: from callisto ([2603:3024:1c06:3af3:bfa5:a6ff:8ac8:141d])
        by smtp.gmail.com with ESMTPSA id g63sm96901268pfd.60.2016.11.29.11.15.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Nov 2016 11:15:13 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Both asn1 headers are included by rsa_helper.c, so rsa_helper.o
should explicitly depend on them.

Signed-off-by: David Michael <david.michael@coreos.com>
---

Hi,

Our automated CI builds randomly fail with the following:

../source/crypto/rsa_helper.c:19:29: fatal error: rsaprivkey-asn1.h: No such file or directory
../source/scripts/Makefile.build:289: recipe for target 'crypto/rsa_helper.o' failed

I've added the following line and run a dozen or so builds, and they
have not failed since.  Can this patch be applied?

Thanks.

David

 crypto/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 99cc64a..bd6a029 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
 $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
+$(obj)/rsa_helper.o: $(obj)/rsapubkey-asn1.h $(obj)/rsaprivkey-asn1.h
 clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
 clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
 
-- 
2.7.4
