Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4FCC433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 16:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A94D208B3
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 16:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgGSQ3v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 12:29:51 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:52162 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGSQ3v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 12:29:51 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 09F3CBC053;
        Sun, 19 Jul 2020 16:29:44 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        broonie@kernel.org, hankecai@bbktel.com, hankecai@vivo.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] arm64: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 18:29:38 +0200
Message-Id: <20200719162938.60161-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
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


 Documentation/arm64/arm-acpi.rst        | 2 +-
 arch/arm64/crypto/sha256-core.S_shipped | 2 +-
 arch/arm64/crypto/sha512-armv8.pl       | 2 +-
 arch/arm64/crypto/sha512-core.S_shipped | 2 +-
 arch/arm64/lib/copy_template.S          | 2 +-
 arch/arm64/lib/memcmp.S                 | 2 +-
 arch/arm64/lib/memcpy.S                 | 2 +-
 arch/arm64/lib/memmove.S                | 2 +-
 arch/arm64/lib/memset.S                 | 2 +-
 arch/arm64/lib/strcmp.S                 | 2 +-
 arch/arm64/lib/strlen.S                 | 2 +-
 arch/arm64/lib/strncmp.S                | 2 +-
 arch/arm64/lib/strnlen.S                | 2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/arm64/arm-acpi.rst b/Documentation/arm64/arm-acpi.rst
index 872dbbc73d4a..8f675c38c244 100644
--- a/Documentation/arm64/arm-acpi.rst
+++ b/Documentation/arm64/arm-acpi.rst
@@ -273,7 +273,7 @@ only use the _DSD Device Properties UUID [5]:
 
    - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
 
-   - http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
+   - https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
 
 The UEFI Forum provides a mechanism for registering device properties [4]
 so that they may be used across all operating systems supporting ACPI.
diff --git a/arch/arm64/crypto/sha256-core.S_shipped b/arch/arm64/crypto/sha256-core.S_shipped
index 7c7ce2e3bad6..dd4867742a2e 100644
--- a/arch/arm64/crypto/sha256-core.S_shipped
+++ b/arch/arm64/crypto/sha256-core.S_shipped
@@ -19,7 +19,7 @@
 // Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 // project. The module is, however, dual licensed under OpenSSL and
 // CRYPTOGAMS licenses depending on where you obtain it. For further
-// details see http://www.openssl.org/~appro/cryptogams/.
+// details see https://www.openssl.org/~appro/cryptogams/.
 // ====================================================================
 //
 // SHA256/512 for ARMv8.
diff --git a/arch/arm64/crypto/sha512-armv8.pl b/arch/arm64/crypto/sha512-armv8.pl
index 2d8655d5b1af..48c9da50b7ec 100644
--- a/arch/arm64/crypto/sha512-armv8.pl
+++ b/arch/arm64/crypto/sha512-armv8.pl
@@ -20,7 +20,7 @@
 # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 # project. The module is, however, dual licensed under OpenSSL and
 # CRYPTOGAMS licenses depending on where you obtain it. For further
-# details see http://www.openssl.org/~appro/cryptogams/.
+# details see https://www.openssl.org/~appro/cryptogams/.
 # ====================================================================
 #
 # SHA256/512 for ARMv8.
diff --git a/arch/arm64/crypto/sha512-core.S_shipped b/arch/arm64/crypto/sha512-core.S_shipped
index e063a6106720..421cb9977d39 100644
--- a/arch/arm64/crypto/sha512-core.S_shipped
+++ b/arch/arm64/crypto/sha512-core.S_shipped
@@ -19,7 +19,7 @@
 // Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
 // project. The module is, however, dual licensed under OpenSSL and
 // CRYPTOGAMS licenses depending on where you obtain it. For further
-// details see http://www.openssl.org/~appro/cryptogams/.
+// details see https://www.openssl.org/~appro/cryptogams/.
 // ====================================================================
 //
 // SHA256/512 for ARMv8.
diff --git a/arch/arm64/lib/copy_template.S b/arch/arm64/lib/copy_template.S
index 488df234c49a..fce1e070c13a 100644
--- a/arch/arm64/lib/copy_template.S
+++ b/arch/arm64/lib/copy_template.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/memcmp.S b/arch/arm64/lib/memcmp.S
index c0671e793ea9..8b7c94917f98 100644
--- a/arch/arm64/lib/memcmp.S
+++ b/arch/arm64/lib/memcmp.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index e0bf83d556f2..dc816480cebd 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
index 02cda2e33bde..3cd7ba7311e5 100644
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 77c3c7ba0084..ff1e38b96d1c 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/strcmp.S b/arch/arm64/lib/strcmp.S
index 4e79566726c8..9dab831b1558 100644
--- a/arch/arm64/lib/strcmp.S
+++ b/arch/arm64/lib/strcmp.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/strlen.S b/arch/arm64/lib/strlen.S
index ee3ed882dd79..f981b639d549 100644
--- a/arch/arm64/lib/strlen.S
+++ b/arch/arm64/lib/strlen.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/strncmp.S b/arch/arm64/lib/strncmp.S
index 2a7ee949ed47..0243547021b2 100644
--- a/arch/arm64/lib/strncmp.S
+++ b/arch/arm64/lib/strncmp.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
diff --git a/arch/arm64/lib/strnlen.S b/arch/arm64/lib/strnlen.S
index b72913a99038..ffe5ba5a3387 100644
--- a/arch/arm64/lib/strnlen.S
+++ b/arch/arm64/lib/strnlen.S
@@ -6,7 +6,7 @@
  * This code is based on glibc cortex strings work originally authored by Linaro
  * be found @
  *
- * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
+ * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
  * files/head:/src/aarch64/
  */
 
-- 
2.27.0

