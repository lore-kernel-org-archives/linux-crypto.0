Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85DC2931CB
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792119395; cv=none; b=f1cFkiMrmGuvdLZIOKaLBW3mP1fpqhQS2K9jW6x6NpYkdJ5ZjMs2xZOJAI6RRoqIJqeyI9wxxWeyFJ6wgkH2IMzmbo4iD2N9lgmw2bCfiteiT+5YDCgPpCReK4URHPfQTdhmar9SZb3K/t/vi/k0yyC69zgSQ8NF5KN7reovAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792119395; c=relaxed/simple;
	bh=ly9Gp1edPrykZwMrtTjoN923qXipFzVP+nvyEDSatSw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hmA35Yf0M+0oCBwo48D+E/Qu3a+qD7JbsOPnIX6GL9Fkj/jMZKsb0/wNERlJnRDYtBYa5Mh2dk9yIpLGt609k+Pfft29VMoNcUZXYmxvuxK946HiHxWHi1AiYg1zPTWAwa7rwVe7M2x3Yaofz4RsMv1jbc2bv9fVlAHihG1s7RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bc1vbril; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bc1vbril"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ab4178ee33so3511796a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792119393; x=1792724193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YBCbS2lucYXeU4DN4VBsPd4Qhjg270QLVoP9SuEmw6w=;
        b=bc1vbrilynUwrpnwHhAOjwbc6ov+/8dohY9r/UYwxeELQhlJyWtoV70fxOGtyf6hwE
         KJa7k3xIFj8ovIfOgLaVDsTqUCQQcjY9qmtjxWImkFinp9N4nslBYC9dnyaFwxgmQlSK
         SpftShmeta+hoKIY9NMwTZ3vDH6oD1eQmTglGC+/DrJ4VA6z3iMSmTRC1vY3R4qBe2FL
         AJ4BAXtSrws1TxGHS4ZJAc46HKJPjl03Mt/b6AIYorZUGN36RvpHeRItLEHf5ExlFGnK
         bsUoqV05FkZ4+1VYt9kBnzxUqIgpYYc+TTroO9uFvESc3ZbwniUFg2zIMd8idpBz7ZIj
         tC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119393; x=1792724193;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YBCbS2lucYXeU4DN4VBsPd4Qhjg270QLVoP9SuEmw6w=;
        b=J7p9R6RoFNGVW96Omdeqhdv8qJRD/y7lg8tku/6BjnLlceu0OO0NgP7dQYZnDjMond
         yWSnC7QEqFfw9gKshTC1a7wKdfwsEOn0brMvTi0kmlIEoX/EizC9X/iu7oDNogQnhf0h
         9t+ZUznHtN0JMbqgCOAfjyrg6GClYUw0/odubFk8Sd47Btn4hnqpRcBVoEHui8jo+Oby
         87Mm/cc9wTeDExlOK0I4lsnwrX5cxMmy66kWrzhgL+ylSmmiU6Kw6EE8Rw0dRmksWlDM
         JoevszmYQ57ttQsOr20cJPCGbXgC8Iw/XeM/SbGZNWOcxlGJDb5OdDXv1gmaddFkO5yQ
         +Hsg==
X-Forwarded-Encrypted: i=1; AKwUvBxzGwGZyQX+DfVJhd1ydi3MdJAen2q2C6p2mggkCAEHSNXK5dj17/QA1p58SeQK1XSF2C6KNt6HdRaWpBk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLz1ug4p95KcCoWVRLi8nDoOgrs6ETAyqrlWV5d9Hy6cDbW1ADD
	jnSVFFyP8sq2+fxHEZ/q0PZU44l4E+F80jW3gY0af0NTnOPSVy8QM0sm
X-Gm-Gg: AYBFou2wJYX1T/zJPQpwzGF8h6/6mvo5TaGS7cuG+uo8z8KUVseyk1BE2DYUVxti2y+
	Ve3OjH400YmIFgPguEruPVXcoQbPrJ+67KrTOHZDIuMYRkfxL3QQXDVzaMwWkFd89qi2W5H5d0X
	lKJRv3o1A4Z/o0XMq7Cb191iCXpcckBeaGCf1nMH/t6Y97Fj72+ZikP/7gFcu76bfm+0q7h32vA
	qUxD9xXsI7PNW2+pmejNKVn4R46jz/jBG9PhNCMtq4zwQ1Ubd8W7Pdho4gLOTXLCMiGbsPHmxz1
	9At4RDJmVp8/qF7DEyZF9/r7Z4Lu73SfJSDS7a3Pvl6J6xN9YlqSnyA0PhtwlJC7JmJyNNBDBHj
	bNfytAHRoAxQ6dR/rIxiVb4JHg6rQWd3h/Nl0IBqtU+gdx0nxvwib7aQCYejQQWnsba/lvH2oGs
	Ls7E93TDZIdfQA7UGOSQ5ArvUYjuzPwVQ2kwCOPQwjeeHVPBH+T3jiCXJfJz6AXHXLY4FMyFp88
	42+Ra8dfzlxKQ==
X-Received: by 2002:a17:90b:4d0f:b0:3ac:97e3:73a3 with SMTP id 98e67ed59e1d1-3ac97e3ca4bmr3748539a91.6.1792119393174;
        Thu, 15 Oct 2026 19:56:33 -0700 (PDT)
Received: from arm-a100.. ([140.112.28.118])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc43a1e1esm1917554a91.1.2026.10.15.19.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 19:56:32 -0700 (PDT)
From: Tzu-Ching Yang <shingekinocore@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none function-like
Date: Fri, 16 Oct 2026 10:56:13 +0800
Message-Id: <20261016025613.2690485-1-shingekinocore@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

unrolled, unrolled_full and unrolled_none are object-like macros with
lower-case names, so in a file that includes <linux/unroll.h> every
later identifier with one of these names is replaced with a _Pragma()
operator. A local variable or struct member with one of these names
fails to build. A function parameter named "unrolled" is worse: GCC
expands "unrolled" to an empty pragma, which leaves the parameter
unnamed and removes the name from the expressions that use it, and
GCC 11 and later accept that with only -Wunknown-pragmas warnings.
For example, GCC compiles

	static int add(int unrolled, int x)
	{
		return unrolled + x;
	}

as "return +x;".

No variable, member or parameter in the tree uses these names yet, but
the header is already pulled in by <linux/lsm_hooks.h>, the vhost and
libeth headers and a few .c files, and every new includer exposes more
code to the clash.

Make the three macros function-like, as unrolled_count() and UNROLL()
already are. A function-like macro is expanded only where its name is
followed by '(', so variables, struct members and parameters with the
same names are left alone. Convert the only users, lib/crypto/blake2b.c
and lib/crypto/blake2s.c, to unrolled_full(), and explain the empty
argument list in the header comment.

No functional change: blake2b.c and blake2s.c preprocess to the same
output as before, and every object that depends on <linux/unroll.h> is
byte-identical in x86_64 (GCC 13, Clang 18), riscv64 (GCC 13) and arm64
(Clang 18) builds, apart from the DWARF 5 checksum of the two edited
source files in the arm64 debug info.

Signed-off-by: Tzu-Ching Yang <shingekinocore@gmail.com>
---
unroll.h has no MAINTAINERS entry (hence Andrew on Cc), and the only
users of these three macros are in lib/crypto/, so I think this fits
the libcrypto tree best.

Testing: x86_64, riscv64 and arm64 defconfig plus the includers of
<linux/unroll.h> (all LSMs, IMA/EVM, BPF LSM, vhost, i40e/ice/idpf),
built without the patch and then rebuilt with it in the same source and
output directories. Make rebuilt exactly the 135 objects that depend on
<linux/unroll.h> or blake2{b,s}.c, plus the composite objects that
contain them, so those are the objects compared. lib/crypto/,
security/, drivers/vhost/ and idpf give the same result with riscv64
GCC 8.1 and 16.2, x86_64 Clang 17.0.1 and arm64 Clang 23.1.1. GCC and
Clang still report the BLAKE2 round loops as completely unrolled.

Stand-alone, with only <linux/unroll.h>: GCC 11.5, 12.5, 13.3, 14.2 and
16.2 build the add() example from the changelog, and it returns x; GCC
8.1, 9.5, 10.5 and Clang 17, 18 and 23 reject it. With this patch, a
variable, struct member or parameter with any of the three names builds
without warnings and gives the right result with all of these
compilers.

The patch applies as is to next-20261014, libcrypto-next (40f47fa10a1d)
and net-next (518bf436318e), and none of them has other users of these
names. A user added elsewhere with the old spelling (unrolled_full
without parentheses) fails to build rather than silently losing the
hint.

Not addressed: a use followed by '(' is still expanded, so a function
or function pointer with one of these names still clashes when it is
called. With arguments, that fails to build. Without arguments, GCC
still turns unrolled() into an empty pragma, so a call to a
zero-argument function unrolled() declared before the header is
included is dropped with only warnings (Clang rejects it).

unrolled and unrolled_none still have no users. If preferred, I can
instead remove them, as Simon and Maciej suggested when they were
added, and convert only unrolled_full; that also removes the case
above.

 include/linux/unroll.h | 12 ++++++++----
 lib/crypto/blake2b.c   |  2 +-
 lib/crypto/blake2s.c   |  2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/unroll.h b/include/linux/unroll.h
index 186b71de74..8fde8006eb 100644
--- a/include/linux/unroll.h
+++ b/include/linux/unroll.h
@@ -16,7 +16,7 @@
 #endif
 
 /**
- * unrolled - loop attributes to ask the compiler to unroll it
+ * unrolled() - loop attributes to ask the compiler to unroll it
  *
  * Usage:
  *
@@ -33,10 +33,14 @@
  * on what iter x will do with variables) is not a strict requirement, but
  * provides best performance and object code size.
  * Available only on Clang and GCC 8.x onwards.
+ *
+ * unrolled(), unrolled_full() and unrolled_none() take an empty argument
+ * list so that only a use followed by '(' is expanded: variables, struct
+ * members and function parameters with these names are left alone.
  */
 
 /* Ask the compiler to pick an optimal unroll count, Clang only */
-#define unrolled							\
+#define unrolled()							\
 	__pick_unrolled(clang loop unroll(enable), /* nothing */)
 
 /* Unroll each @n iterations of the loop */
@@ -44,11 +48,11 @@
 	__pick_unrolled(clang loop unroll_count(n), GCC unroll n)
 
 /* Unroll the whole loop */
-#define unrolled_full							\
+#define unrolled_full()							\
 	__pick_unrolled(clang loop unroll(full), GCC unroll 65534)
 
 /* Never unroll the loop */
-#define unrolled_none							\
+#define unrolled_none()							\
 	__pick_unrolled(clang loop unroll(disable), GCC unroll 1)
 
 #define UNROLL(N, MACRO, args...) CONCATENATE(__UNROLL_, N)(MACRO, args)
diff --git a/lib/crypto/blake2b.c b/lib/crypto/blake2b.c
index 55d6c437f3..1f885b1f83 100644
--- a/lib/crypto/blake2b.c
+++ b/lib/crypto/blake2b.c
@@ -81,7 +81,7 @@ blake2b_compress_generic(struct blake2b_ctx *ctx,
 		 * Not worthwhile on 32-bit kernels because the code size is
 		 * already so large there due to BLAKE2b using 64-bit words.
 		 */
-		unrolled_full
+		unrolled_full()
 #endif
 		for (int r = 0; r < 12; r++) {
 			G(r, 0, v[0], v[4], v[8], v[12]);
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 24f7f34334..2260ed9a3d 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -76,7 +76,7 @@ blake2s_compress_generic(struct blake2s_ctx *ctx,
 		 * Unroll the rounds loop to enable constant-folding of the
 		 * blake2s_sigma values.
 		 */
-		unrolled_full
+		unrolled_full()
 		for (int r = 0; r < 10; r++) {
 			G(r, 0, v[0], v[4], v[8], v[12]);
 			G(r, 1, v[1], v[5], v[9], v[13]);

base-commit: 40f47fa10a1d19c74f48a13d97b2eb19d5fb938d
-- 
2.34.1

