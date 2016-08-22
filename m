From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 15/28] x86: Unroll string I/O when SEV is active
Date: Mon, 22 Aug 2016 19:26:40 -0400
Message-ID: <147190840032.9523.7491479364800390492.stgit__11518.91035629$1471910496$gmane$org@brijesh-build-machine>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <brijesh.singh@amd.com>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linus.walleij@linaro.org>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <mingo@redhat.com>, <msalter@redhat.com>,
        <ross.zwisler@linux.intel.com>, <bp@suse.de>, <dyoung@redhat.com>,
        <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <toshi.kani@hpe.com>,
        <mathieu.desnoyers@efficios.com>, <devel@linuxdriverproject.org>,
        <tglx@linutronix.de>, <mchehab@kernel.or
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0044.outbound.protection.outlook.com ([104.47.40.44]:51573
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756683AbcHWABI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 20:01:08 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

Secure Encrypted Virtualization (SEV) does not support string I/O, so
unroll the string I/O operation into a loop operating on one element at
a time.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/io.h |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index de25aad..130b3e2 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -303,14 +303,32 @@ static inline unsigned type in##bwl##_p(int port)			\
 									\
 static inline void outs##bwl(int port, const void *addr, unsigned long count) \
 {									\
-	asm volatile("rep; outs" #bwl					\
-		     : "+S"(addr), "+c"(count) : "d"(port));		\
+	if (sev_active) {						\
+		unsigned type *value = (unsigned type *)addr;		\
+		while (count) {						\
+			out##bwl(*value, port);				\
+			value++;					\
+			count--;					\
+		}							\
+	} else {							\
+		asm volatile("rep; outs" #bwl				\
+			     : "+S"(addr), "+c"(count) : "d"(port));	\
+	}								\
 }									\
 									\
 static inline void ins##bwl(int port, void *addr, unsigned long count)	\
 {									\
-	asm volatile("rep; ins" #bwl					\
-		     : "+D"(addr), "+c"(count) : "d"(port));		\
+	if (sev_active) {						\
+		unsigned type *value = (unsigned type *)addr;		\
+		while (count) {						\
+			*value = in##bwl(port);				\
+			value++;					\
+			count--;					\
+		}							\
+	} else {							\
+		asm volatile("rep; ins" #bwl				\
+			     : "+D"(addr), "+c"(count) : "d"(port));	\
+	}								\
 }
 
 BUILDIO(b, b, char)
