Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FB3C3A59D
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8CBA206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfHPVQd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 17:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfHPVQd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 17:16:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30411882EA;
        Fri, 16 Aug 2019 21:16:33 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28B5E87A3;
        Fri, 16 Aug 2019 21:16:28 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] crypto: sha256 - Move lib/sha256.c to lib/crypto
Date:   Fri, 16 Aug 2019 23:16:08 +0200
Message-Id: <20190816211611.2568-4-hdegoede@redhat.com>
In-Reply-To: <20190816211611.2568-1-hdegoede@redhat.com>
References: <20190816211611.2568-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 16 Aug 2019 21:16:33 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Generic crypto implementations belong under lib/crypto not directly in
lib, likewise the header should be in include/crypto, not include/linux.

Note that the code in lib/crypto/sha256.c is not yet available for
generic use after this commit, it is still only used by the s390 and x86
purgatory code. Making it suitable for generic use is done in further
patches in this series.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/s390/purgatory/Makefile       | 2 +-
 arch/s390/purgatory/purgatory.c    | 2 +-
 arch/x86/purgatory/Makefile        | 2 +-
 arch/x86/purgatory/purgatory.c     | 2 +-
 include/{linux => crypto}/sha256.h | 0
 lib/{ => crypto}/sha256.c          | 2 +-
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename include/{linux => crypto}/sha256.h (100%)
 rename lib/{ => crypto}/sha256.c (99%)

diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index dc1ae4ff79d7..85b05c9e40f5 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -7,7 +7,7 @@ purgatory-y := head.o purgatory.o string.o sha256.o mem.o
 targets += $(purgatory-y) purgatory.lds purgatory purgatory.ro
 PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
 
-$(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
+$(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 $(obj)/mem.o: $(srctree)/arch/s390/lib/mem.S FORCE
diff --git a/arch/s390/purgatory/purgatory.c b/arch/s390/purgatory/purgatory.c
index 3528e6da4e87..a80c78da9985 100644
--- a/arch/s390/purgatory/purgatory.c
+++ b/arch/s390/purgatory/purgatory.c
@@ -8,8 +8,8 @@
  */
 
 #include <linux/kexec.h>
-#include <linux/sha256.h>
 #include <linux/string.h>
+#include <crypto/sha256.h>
 #include <asm/purgatory.h>
 
 int verify_sha256_digest(void)
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 8901a1f89cf5..6ebd0739106e 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -9,7 +9,7 @@ PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
 $(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-$(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
+$(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
index b607bda786f6..7f90a86eff49 100644
--- a/arch/x86/purgatory/purgatory.c
+++ b/arch/x86/purgatory/purgatory.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/bug.h>
-#include <linux/sha256.h>
+#include <crypto/sha256.h>
 #include <asm/purgatory.h>
 
 #include "../boot/string.h"
diff --git a/include/linux/sha256.h b/include/crypto/sha256.h
similarity index 100%
rename from include/linux/sha256.h
rename to include/crypto/sha256.h
diff --git a/lib/sha256.c b/lib/crypto/sha256.c
similarity index 99%
rename from lib/sha256.c
rename to lib/crypto/sha256.c
index ba4dce0b3711..b8114028d06f 100644
--- a/lib/sha256.c
+++ b/lib/crypto/sha256.c
@@ -12,8 +12,8 @@
  */
 
 #include <linux/bitops.h>
-#include <linux/sha256.h>
 #include <linux/string.h>
+#include <crypto/sha256.h>
 #include <asm/byteorder.h>
 
 static inline u32 Ch(u32 x, u32 y, u32 z)
-- 
2.22.0

