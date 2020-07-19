Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C33C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 09:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D317D20734
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 09:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgGSJt7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGSJt6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 05:49:58 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF4AC0619D2;
        Sun, 19 Jul 2020 02:49:58 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id A182EBC07E;
        Sun, 19 Jul 2020 09:49:54 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     linux@armlinux.org.uk, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] ARM: STM32: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 11:49:48 +0200
Message-Id: <20200719094948.57487-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 arch/arm/mach-stm32/Makefile.boot | 2 +-
 crypto/testmgr.h                  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-stm32/Makefile.boot b/arch/arm/mach-stm32/Makefile.boot
index cec195d4fcba..5dde7328a7a9 100644
--- a/arch/arm/mach-stm32/Makefile.boot
+++ b/arch/arm/mach-stm32/Makefile.boot
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Empty file waiting for deletion once Makefile.boot isn't needed any more.
 # Patch waits for application at
-# http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
+# https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d29983908c38..cdcf0d2fe40d 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -16231,7 +16231,7 @@ static const struct cipher_testvec aes_lrw_tv_template[] = {
 			  "\xe9\x5d\x48\x92\x54\x63\x4e\xb8",
 		.len	= 48,
 	}, {
-/* http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
+/* https://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
 		.key    = "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
 			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
 			  "\xfe\xf1\xa9\xf3\x7b\xbc\x8d\x21"
@@ -21096,7 +21096,7 @@ static const struct aead_testvec aegis128_tv_template[] = {
 
 /*
  * All key wrapping test vectors taken from
- * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
+ * https://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
  *
  * Note: as documented in keywrap.c, the ivout for encryption is the first
  * semiblock of the ciphertext from the test vector. For decryption, iv is
@@ -22825,7 +22825,7 @@ static const struct cipher_testvec xeta_tv_template[] = {
  * FCrypt test vectors
  */
 static const struct cipher_testvec fcrypt_pcbc_tv_template[] = {
-	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
+	{ /* https://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
 		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
-- 
2.27.0

