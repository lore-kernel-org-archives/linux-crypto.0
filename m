Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88E4C12002
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 09:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF6A61175
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 09:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbhGUIUP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 04:20:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42694 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbhGUH74 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 03:59:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7F64122077;
        Wed, 21 Jul 2021 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626856777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aIKkY/oksyNCRT46/tzea6WLOM5qQKhBXPzprEVpLXY=;
        b=wxbNsWTwFTx00MqsmrBFuJ9Ug3oYW4LCMMbNCEEquwr12jpsO6S968p4uHHCiqH9KjcwrM
        x0aYZatZ6XrWGmYLBqG4/47Z/ZcRsnBEQzQVY+Ir/PRy86V9UOAE0SC3/uIAEquN65+fKt
        yxoioJ8VIarRC60E4Vuz5BPJg1kzETw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626856777;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aIKkY/oksyNCRT46/tzea6WLOM5qQKhBXPzprEVpLXY=;
        b=T6a3c+SOulfKuR8LZ3QbFkafEEQ6oVnynzx8LIQodFl0M3aD1SpBQDJms6DsU+A3jcoiPo
        vPBCGagnjTy2boCA==
Received: from un68u.suse.de (unknown [10.163.42.126])
        by relay2.suse.de (Postfix) with ESMTP id BBE7DA3B8E;
        Wed, 21 Jul 2021 08:39:36 +0000 (UTC)
From:   Mian Yousaf Kaukab <ykaukab@suse.de>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stefanb@linux.ibm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, tiwai@suse.de,
        guillaume.gardet@arm.com, Mian Yousaf Kaukab <ykaukab@suse.de>
Subject: [PATCH] crypto: ecc: handle unaligned input buffer in ecc_swap_digits
Date:   Wed, 21 Jul 2021 10:39:05 +0200
Message-Id: <20210721083905.15144-1-ykaukab@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ecdsa_set_pub_key() makes an u64 pointer at 1 byte offset of the key.
This results in an unaligned u64 pointer. This pointer is passed to
ecc_swap_digits() which assumes natural alignment.

This causes a kernel crash on an armv7 platform:
[    0.409022] Unhandled fault: alignment exception (0x001) at 0xc2a0a6a9
...
[    0.416982] PC is at ecdsa_set_pub_key+0xdc/0x120
...
[    0.491492] Backtrace:
[    0.492059] [<c07c266c>] (ecdsa_set_pub_key) from [<c07c75d4>] (test_akcipher_one+0xf4/0x6c0)

Handle unaligned input buffer in ecc_swap_digits() by replacing
be64_to_cpu() to get_unaligned_be64(). Change type of in pointer to
void to reflect it doesn’t necessarily need to be aligned.

Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
---
 crypto/ecc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/ecc.h b/crypto/ecc.h
index a006132646a4..1350e8eb6ac2 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -27,6 +27,7 @@
 #define _CRYPTO_ECC_H
 
 #include <crypto/ecc_curve.h>
+#include <asm/unaligned.h>
 
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
@@ -46,13 +47,13 @@
  * @out:      Output array
  * @ndigits:  Number of digits to copy
  */
-static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
+static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigits)
 {
 	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
+		out[i] = get_unaligned_be64(&src[ndigits - 1 - i]);
 }
 
 /**
-- 
2.26.2

