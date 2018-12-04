Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35772 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeLDNNl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 08:13:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id 96so15935027wrb.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 05:13:40 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 1/3] crypto: tcrypt - add block size of 1472 to skcipher template
Date: Tue,  4 Dec 2018 14:13:31 +0100
Message-Id: <20181204131333.15046-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
References: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In order to have better coverage of algorithms operating on block
sizes that are in the ballpark of a VPN  packet, add 1472 to the
block_sizes array.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0590a9204562..e7fb87e114a5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -81,7 +81,7 @@ static char *check[] = {
 	NULL
 };
 
-static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
+static u32 block_sizes[] = { 16, 64, 256, 1024, 1472, 8192, 0 };
 static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
 
 #define XBUFSIZE 8
-- 
2.19.2
