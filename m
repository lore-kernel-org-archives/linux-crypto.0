Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BB0C76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 13:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449CF20873
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 13:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390350AbfGRNug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 09:50:36 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56811 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbfGRNuf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 09:50:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MBlpC-1hiZQe46Xs-00C92P; Thu, 18 Jul 2019 15:50:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] crypto: aegis: fix badly optimized clang output
Date:   Thu, 18 Jul 2019 15:50:04 +0200
Message-Id: <20190718135017.2493006-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:uwVqefWDs4o63p6iE6Irj25ryb6bdvtC7Hrf93yaHtWNB3UyaJp
 4OkfB2kFOY5aXDuTVLHY0gjWaXZSUkd3hdU7IXfyQfGDuBfNtrAcmaozeItDwwk75ge58G1
 sBfVJ6df5mTpV5Y8kgpJ0tPbdf/YlMfhVkrn+9yxYQAHpRDwi5aDbittwSsgXq836kuLfO6
 atp6LgcOt/SEcndX4E/nQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aCIrsaK3jkM=:ZKGmbmo1TdnpLnjvQ7TKLR
 UK81lUNUbJPH6N3UzauZAmgjkh8XdIXJfHlA2yxaBZzaQbahE13aQU30plQa8EoM4NcHktAFu
 BUo1N5DZRWhcPq/pKVsolC5wrOu+Vknahoism+3/CG/QZEWno0G4XuiVW9G+2TL3erKB06AuV
 MIzkPjX1BEtl2PAg5AcrNJX76hAt9fcMTIdZweDC1+uxgEPYaRvAe8qCSRU+ODacG89bmlRgc
 urdUX2XmkHq9ZVppXO6zqwXsmJ4fMdqhTTf+mWJf/pgBP/oDacehSNQsQSVTlQVNgaYWbeJeZ
 NZrwJGaQ0PwcIwFcHoUpMMQvc0HQVtD1Ks5mybVvvNE454pggdn21V2drwBY/dWWKEKhOIOp2
 RXbyfy2JFwvjzyQ8a3s7gcvYcvrftA8rwk8MVtcNoMITl9+vHJpqARtMOuHduPjK8styPiOwP
 rzrfdqasn4dgnKvRD66DQgKxAN/dc9HJL0gyYl1RjAw2WIO6W16rERZu1pqnLrh3O4ifiAOl+
 /vWjCU54+pwusGnbn3yox0/vQwpOY8vHJ8zcmSOuTPIwv3I4Te0NnwpSiVZqXwu+EmzR2geNb
 mfcsvg2dhNFODniKVonHEPqOjwIGS2kTAD7VVIpi520lhplRTZbXOVLW/abWpyW/u9AtZBnKT
 LoyJ7SIEpUDk5tdJdw0k/STEE3V7OZVaAW3OnNSLyjehfTJt7elnuWaxP0uuy9cap+zntpV8P
 hM0gm+T/uxbOZLVE18lo0/HPejnoQkbgy0IMcw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang sometimes makes very different inlining decisions from gcc.
In case of the aegis crypto algorithms, it decides to turn the innermost
primitives (and, xor, ...) into separate functions but inline most of
the rest.

This results in a huge amount of variables spilled on the stack, leading
to rather slow execution as well as kernel stack usage beyond the 32-bit
warning limit when CONFIG_KASAN is enabled:

crypto/aegis256.c:123:13: warning: stack frame size of 648 bytes in function 'crypto_aegis256_encrypt_chunk' [-Wframe-larger-than=]
crypto/aegis256.c:366:13: warning: stack frame size of 1264 bytes in function 'crypto_aegis256_crypt' [-Wframe-larger-than=]
crypto/aegis256.c:187:13: warning: stack frame size of 656 bytes in function 'crypto_aegis256_decrypt_chunk' [-Wframe-larger-than=]
crypto/aegis128l.c:135:13: warning: stack frame size of 832 bytes in function 'crypto_aegis128l_encrypt_chunk' [-Wframe-larger-than=]
crypto/aegis128l.c:415:13: warning: stack frame size of 1480 bytes in function 'crypto_aegis128l_crypt' [-Wframe-larger-than=]
crypto/aegis128l.c:218:13: warning: stack frame size of 848 bytes in function 'crypto_aegis128l_decrypt_chunk' [-Wframe-larger-than=]
crypto/aegis128.c:116:13: warning: stack frame size of 584 bytes in function 'crypto_aegis128_encrypt_chunk' [-Wframe-larger-than=]
crypto/aegis128.c:351:13: warning: stack frame size of 1064 bytes in function 'crypto_aegis128_crypt' [-Wframe-larger-than=]
crypto/aegis128.c:177:13: warning: stack frame size of 592 bytes in function 'crypto_aegis128_decrypt_chunk' [-Wframe-larger-than=]

Forcing the primitives to all get inlined avoids the issue and the
resulting code is similar to what gcc produces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/aegis.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/aegis.h b/crypto/aegis.h
index 41a3090cda8e..efed7251c49d 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -34,21 +34,21 @@ static const union aegis_block crypto_aegis_const[2] = {
 	} },
 };
 
-static void crypto_aegis_block_xor(union aegis_block *dst,
+static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
 				   const union aegis_block *src)
 {
 	dst->words64[0] ^= src->words64[0];
 	dst->words64[1] ^= src->words64[1];
 }
 
-static void crypto_aegis_block_and(union aegis_block *dst,
+static __always_inline void crypto_aegis_block_and(union aegis_block *dst,
 				   const union aegis_block *src)
 {
 	dst->words64[0] &= src->words64[0];
 	dst->words64[1] &= src->words64[1];
 }
 
-static void crypto_aegis_aesenc(union aegis_block *dst,
+static __always_inline void crypto_aegis_aesenc(union aegis_block *dst,
 				const union aegis_block *src,
 				const union aegis_block *key)
 {
-- 
2.20.0

