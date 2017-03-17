From: Michael Davidson <md@google.com>
Subject: [PATCH 5/7] x86, boot, LLVM: Use regparm=0 for memcpy and memset
Date: Thu, 16 Mar 2017 17:15:18 -0700
Message-ID: <20170317001520.85223-6-md@google.com>
References: <20170317001520.85223-1-md@google.com>
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        Michael Davidson <md@google.com>
To: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the standard regparm=0 calling convention for memcpy and
memset when building with clang.

This is a work around for a long standing clang bug
(see https://llvm.org/bugs/show_bug.cgi?id=3997) where
clang always uses the standard regparm=0 calling convention
for any implcit calls to memcpy and memset that it generates
(eg for structure assignments and initialization) even if an
alternate calling convention such as regparm=3 has been specified.

Signed-off-by: Michael Davidson <md@google.com>
---
 arch/x86/boot/copy.S   | 15 +++++++++++++--
 arch/x86/boot/string.h | 13 +++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/copy.S b/arch/x86/boot/copy.S
index 1eb7d298b47d..57142d1ad0d2 100644
--- a/arch/x86/boot/copy.S
+++ b/arch/x86/boot/copy.S
@@ -18,6 +18,12 @@
 	.text
 
 GLOBAL(memcpy)
+#ifdef	__clang__	/* Use normal ABI calling conventions */
+	movw	4(%esp), %ax
+	movw	8(%esp), %dx
+	movw	12(%esp), %cx
+#endif
+_memcpy:
 	pushw	%si
 	pushw	%di
 	movw	%ax, %di
@@ -34,6 +40,11 @@ GLOBAL(memcpy)
 ENDPROC(memcpy)
 
 GLOBAL(memset)
+#ifdef	__clang__	/* Use normal ABI calling conventions */
+	movw	4(%esp), %ax
+	movw	8(%esp), %dx
+	movw	12(%esp), %cx
+#endif
 	pushw	%di
 	movw	%ax, %di
 	movzbl	%dl, %eax
@@ -52,7 +63,7 @@ GLOBAL(copy_from_fs)
 	pushw	%ds
 	pushw	%fs
 	popw	%ds
-	calll	memcpy
+	calll	_memcpy
 	popw	%ds
 	retl
 ENDPROC(copy_from_fs)
@@ -61,7 +72,7 @@ GLOBAL(copy_to_fs)
 	pushw	%es
 	pushw	%fs
 	popw	%es
-	calll	memcpy
+	calll	_memcpy
 	popw	%es
 	retl
 ENDPROC(copy_to_fs)
diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
index 113588ddb43f..e735cccb3fc8 100644
--- a/arch/x86/boot/string.h
+++ b/arch/x86/boot/string.h
@@ -6,8 +6,21 @@
 #undef memset
 #undef memcmp
 
+/*
+ * Use normal ABI calling conventions - i.e. regparm(0) -
+ * for memcpy() and memset() if we are building the real
+ * mode setup code with clang since clang may make implicit
+ * calls to these functions that assume regparm(0).
+ */
+#if defined(_SETUP) && defined(__clang__)
+void __attribute__((regparm(0))) *memcpy(void *dst, const void *src,
+					 size_t len);
+void __attribute__((regparm(0))) *memset(void *dst, int c, size_t len);
+#else
 void *memcpy(void *dst, const void *src, size_t len);
 void *memset(void *dst, int c, size_t len);
+#endif
+
 int memcmp(const void *s1, const void *s2, size_t len);
 
 /*
-- 
2.12.0.367.g23dc2f6d3c-goog

