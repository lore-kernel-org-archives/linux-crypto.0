Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F2BC31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 11:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C988A208E4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 11:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfFQL7s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 07:59:48 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53163 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfFQL7s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 07:59:48 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mq2vS-1iObZe1orS-00n8eA; Mon, 17 Jun 2019 13:59:32 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: serpent - mark __serpent_setkey_sbox noinline
Date:   Mon, 17 Jun 2019 13:59:08 +0200
Message-Id: <20190617115927.3813471-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:nlRKSlHgvz2m3fKSfZ7wC9E0KZXX9jzM/z2eRxUPOPM/3xpzPV+
 Zw3rBSyaQGObcrKRgaRZBxPqG/R0UConl0Iztg7s7WYIyKPn7P3/rl6YDLBpg4Wze3oViSl
 AbUC34gVy0QvoEIx7GO+gSyXbln6QnK7KQ1WhH6FQ5BIPcxQOnQdQojUzLZutskEY55LrCR
 uGptJwdiqTHn0XAHHUjdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3c/M2mR4H6w=:n/NbLMsUQ62zu8ZHsbJLcH
 zV+JBLdWrhAArxRLcX3E2VpK0xEiURubZba5QlXHF3JvBl0Q0Kp8G7vdEoJmSs5j0GwmkyL3o
 5dRwdGPNWcrmWt11IU0WAvt8cK4T2ak8c3fwmzzQwEigCekU/h55VKvNYT24rgTm4iHX7PSk/
 aWtRQjtrOOhUlt1PRfrRsf8trlX05V5N5kmsnRGRG/nOXy7B+I5bL4tmN6dx146S+mR96kxEu
 xAHrCf6ShdehcK/uXN/FgrCjlGEt6oYFupHkmfBS79w+oqq/BWGEh6lW0AjnGu4SJS+P58H0g
 gYXJ2pl4sxktGQQzhBzPDv3N++NFzsGTz5P63s+/rgx6SQhJkPw4OUajRd4KLKf/59sSnYglV
 m9CWbNbxZGmXdxhRujDksY/XLnnNGC8FTR+nZGq3n6MK83hCquDeGg1pj3CQ+lkxhalKbmI35
 itORR+B7VGRpqd7WeQaLv1GvSO7GAubUgryDiq9WP3lPFnEas7Uw8CNpRgXQYBvE8BVRCrdOC
 x98PvOuwhSELH2Zlhjqc8rs14vUpvH/dyjLsvnyVYz6BCjc7EM4sGz8F/c7Y8T8T7iOIMoIC5
 bAG/PXQL20Y4xzcr9qXgV1CZad8HrupmPF5v57TptwICd6UBUtRICj9RInHHNmwFWgYEEClmZ
 Tqgf8ubm98ekNFiEPD4hfSkBikODvaS9UB8yIeGwTFW00XXNkunUsTEXnhcTXbmXD3EQTDcgh
 1rZ2etgkbKeTh0RQivoyC6fiipKJ3pYp9eygbQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The same bug that gcc hit in the past is apparently now showing
up with clang, which decides to inline __serpent_setkey_sbox:

crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]

Marking it 'noinline' reduces the stack usage from 2112 bytes to
192 and 96 bytes, respectively, and seems to generate more
useful object code.

Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/serpent_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index e57757904677..183661faf420 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -225,7 +225,7 @@
 	x4 ^= x2;					\
 	})
 
-static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
+static void noinline __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
 {
 	k += 100;
 	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
-- 
2.20.0

