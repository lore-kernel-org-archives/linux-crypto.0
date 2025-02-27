Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7D276D13
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 23:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740700043; cv=none; b=DcWoAeGBsXLi8oe5pVLVbgbKlUaL8LCbB/1MrIoPXRF2oWdWHJwWGGyKbDp5mJPghSCyg9fHcQ4+4Yr5N1AfqJ7/8aHuHGHE21cN5pB6CRcBfNin7O2Vyty4jKyoqkdIiuYRxznziFgDzTe7PyQAlS/8bpKYljwST7+SYaNsNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740700043; c=relaxed/simple;
	bh=y8bFEfkPSHsETto+lXOWDrnpTD/mU3xtm2RfzaD5RB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=om8gAV6gtLMuvMFuv0MGgduOsBwYotXl8FoH8YOL4Tf7O4fhmZyux73lz/t+ZIIlyxYIbd8/wAlh+sgacyio8ut8GkMvCBWJ85C4befVPZG19C761EFd44F4HQi3LIZIAfs4E/KLmrCiA+VEWoqhd/Uj1pdNkx/b5FiT4o06cPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2wl9/dFl; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2wl9/dFl"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaec61d0f65so308423766b.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 15:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740700040; x=1741304840; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+t0diRhztFZloXArsjx7wwxhw/+bIqUM4lylOOEWlhE=;
        b=2wl9/dFlPDjO0co4hmfpEeqqXGLZiK0eY+YiT45Re0tSNuFk1/QCRV9o1R7C5UU6jB
         OtN2uHFd2T9hbHZ1YIXq3ONIv2UE2ptccxnD7UwLVWj9+rL4kea+o/xlt+xuMC8itnUW
         XD14PsRy6noPAgeS/y+AS4wBhvPBUi4O1PJM1xjuN4lekunw1KMZHrATmy+g/Fr3Rkyc
         JbbQ1+OnEUjkVLzzSQ6z711bbuQOkijVvat0hB+wNDDdJM24kPLmfjzfBkFDp9r3wvpD
         QJL8VH2DFVK1IWBmOlRh0pvJIHM0YG4PPJ9clozZdBxevM0RumU39LI5/SoNIwvwIt6d
         u4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740700040; x=1741304840;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+t0diRhztFZloXArsjx7wwxhw/+bIqUM4lylOOEWlhE=;
        b=lRarscXfpdMUDEbJw11HySWdIzBinl9bZlukr4RUS1R9DoFjbFhUaHE+4vYkTFQ/lQ
         G4ms9CkztojJxttJYzZkCFT3JMn77NYRF77Q/MIhRoHXFZ0H6+nGwvHpjYquLIOvx5gl
         Im1EYl5Zp5WoP9wTBGvQi8f38zOW+IpLIKsZf265K1VCvUoc7ppWKGXpW1oilCoKyN9h
         4IdtoOcqP325aTo2ilnEFwnXLF1bTlYd73wNn3ea6yijB/twuvzcq8+wmav7JOy+nHNl
         QUXajC7RRbsqykx4qnX60NJ4bhoBbMAfsEGLeE8fIziROewZVYJCztfEf4jEjVnHd5kO
         8BAg==
X-Forwarded-Encrypted: i=1; AJvYcCV3A8wRuWwFZtiozneSnguTETLK5LGhyFTJ+ohxK6Y9J+ceshvaROGr+1nxIOci4Ug9MafxrpSekOU3xiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB5Z2MBli6bxkhb0EHHQ3xagavRjV3wlONUOwJA0OLvfD0AERn
	/ZrcraQx23dBymTai7MvJS9SQBsMUOhXKV6vTVK2xK+1aay5Ft/RPV9v9b3Zu2URtY/aFPU9QDi
	hU7uEi2O5RBJUHW+G94ev5oDRLIsFHDyRipc=
X-Gm-Gg: ASbGncv62AjGsAPCr/PGBJs5Td1b3U2H4+PgHzO71P2cuo6AgeJzDUJwK+yiRHS8YxY
	3HwB5T92tLe9nrru8suY1S5PZ66Y0S7G31g0OC2S7RD2Ov4JXXBtWchsk1pTb0qdr6fCQHImDlE
	NqRLM9
X-Google-Smtp-Source: AGHT+IGuKXYtAhCotjTCT0GtqrXge6XGZ8jW26Y5V5fFuX9t84HBMBXel9WEY29yiRQ8JOtdqfCxqrlzGYWozPOxXYY=
X-Received: by 2002:a17:907:6d16:b0:ab7:6c4a:6a74 with SMTP id
 a640c23a62f3a-abf25fb8399mr115706566b.16.1740700039593; Thu, 27 Feb 2025
 15:47:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
In-Reply-To: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
From: Bill Wendling <morbo@google.com>
Date: Thu, 27 Feb 2025 15:47:03 -0800
X-Gm-Features: AQ5f1JqJZ47vCyOpVPb_PrJMfpw4X_Wnn4CHu0aPxPJVyWw8-IV6me3jBQW-y8E
Message-ID: <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
Subject: [PATCH v2] x86/crc32: use builtins to improve code generation
To: Bill Wendling <morbo@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 
	clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

For both gcc and clang, crc32 builtins generate better code than the
inline asm. GCC improves, removing unneeded "mov" instructions. Clang
does the same and unrolls the loops. GCC has no changes on i386, but
Clang's code generation is vastly improved, due to Clang's "rm"
constraint issue.

The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
is expected because of the "rm" issue. However, Clang's performance is
better than GCC's by ~1.5%, most likely due to loop unrolling.

Link: https://github.com/llvm/llvm-project/issues/20571#issuecomment-2649330009
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: llvm@lists.linux.dev
Signed-off-by: Bill Wendling <morbo@google.com>
---
v2 - Limited range of '-mcrc32' usage to single file.
   - Use a function instead of macros.
---
 arch/x86/lib/Makefile     |  2 ++
 arch/x86/lib/crc32-glue.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 8a59c61624c2..1251f611ce3d 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,6 +14,8 @@ ifdef CONFIG_KCSAN
 CFLAGS_REMOVE_delay.o = $(CC_FLAGS_FTRACE)
 endif

+CFLAGS_crc32-glue.o := -mcrc32
+
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
index 2dd18a886ded..fc70462ae2c1 100644
--- a/arch/x86/lib/crc32-glue.c
+++ b/arch/x86/lib/crc32-glue.c
@@ -47,11 +47,12 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 }
 EXPORT_SYMBOL(crc32_le_arch);

-#ifdef CONFIG_X86_64
-#define CRC32_INST "crc32q %1, %q0"
-#else
-#define CRC32_INST "crc32l %1, %0"
-#endif
+static unsigned long crc32_ul(u32 crc, unsigned long p)
+{
+       if (IS_ENABLED(CONFIG_X86_64))
+               return __builtin_ia32_crc32di(crc, p);
+       return __builtin_ia32_crc32si(crc, p);
+}

 /*
  * Use carryless multiply version of crc32c when buffer size is >= 512 to
@@ -78,10 +79,10 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)

        for (num_longs = len / sizeof(unsigned long);
             num_longs != 0; num_longs--, p += sizeof(unsigned long))
-               asm(CRC32_INST : "+r" (crc) : "rm" (*(unsigned long *)p));
+               crc = crc32_ul(crc,  *(unsigned long *)p);

        for (len %= sizeof(unsigned long); len; len--, p++)
-               asm("crc32b %1, %0" : "+r" (crc) : "rm" (*p));
+               crc = __builtin_ia32_crc32qi(crc, *p);

        return crc;
 }
-- 
2.48.1.711.g2feabab25a-goog
