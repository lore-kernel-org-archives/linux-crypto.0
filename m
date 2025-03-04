Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBEB1E3DF4;
	Tue,  4 Mar 2025 21:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741123994; cv=none; b=jBaPsQA0+QwFg/UL3hJ4rwzyZfcedDfJgKZFXfdxzwlXjUnLX86+G8oWim15oYIv+oInkBmE3B0d648Y7mbGmvlO5naIxt4Gkp/ZE8xfXjqMn7pN+eamnGwYU8AR8IhzeD6n+sNfWjgn57/HmlzY6FQo2QiXxDfKuBTulYbb0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741123994; c=relaxed/simple;
	bh=7W0cGEGfopwD6mibxiQVtjZTTbr9k+ZHhlaN50TgDzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJGM9uHsftZqZsNZY+z9ZaROY97i+Er6FRHz6d/TAbf9/TTezbWJpldDwXeYBgwWtNwdWT5+B76JPdYaEg1c13Ra0J4BH7lvJ+PSepL0izVg2CfnK20Xgs4qSa/8cEOGmHtS7PuQ0akzWYQZwgIBhqqrjXVJ+LKU2fO9APmpnWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTTr2Atb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTTr2Atb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ABFC4CEE5;
	Tue,  4 Mar 2025 21:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741123993;
	bh=7W0cGEGfopwD6mibxiQVtjZTTbr9k+ZHhlaN50TgDzg=;
	h=From:To:Cc:Subject:Date:From;
	b=MTTr2AtbWuvaAbUONgoKcbknK7saKPj3gCNnPwQfYjBPay+oLknLFUHOp+Ywha81h
	 X4pgN9cJ6Jgw6/m1Pff51bZMeNsli06ySZgDVekHnu8FY2AvXi7BHbgZAp2xKobM2O
	 ynmYWDLbOhvKZ7CgyR5NHQ6iLoyM1ywFvJAIM7p8BI8jaS5SS9wak28VoLsqN/4ktJ
	 Cc/LnAtaa6SQEY1hwMeCGGVXv3Z1uUEttTYGKwDskrkAd0pANLn3tZhADJnjfYWt+t
	 8zZaWTv7K51TAG2SV9fRUqnlFXHSTiZtrWdduYwcokh1hwTSOX3e4uvLy2Cby/Z45s
	 LXAg5YQkeXosA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] x86/crc32: optimize tail handling for crc32c short inputs
Date: Tue,  4 Mar 2025 13:32:16 -0800
Message-ID: <20250304213216.108925-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
taking advantage of wider CRC instructions.  Note that crc32c-3way.S
already uses this same optimization too.

crc_kunit shows an improvement of about 25% for len=127.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This applies to
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

 arch/x86/lib/crc32-glue.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
index 4b4721176799a..e3f93b17ac3f1 100644
--- a/arch/x86/lib/crc32-glue.c
+++ b/arch/x86/lib/crc32-glue.c
@@ -55,11 +55,19 @@ u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 
 	for (num_longs = len / sizeof(unsigned long);
 	     num_longs != 0; num_longs--, p += sizeof(unsigned long))
 		asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned long *)p));
 
-	for (len %= sizeof(unsigned long); len; len--, p++)
+	if (sizeof(unsigned long) > 4 && (len & 4)) {
+		asm("crc32l %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u32 *)p));
+		p += 4;
+	}
+	if (len & 2) {
+		asm("crc32w %1, %0" : "+r" (crc) : ASM_INPUT_RM (*(u16 *)p));
+		p += 2;
+	}
+	if (len & 1)
 		asm("crc32b %1, %0" : "+r" (crc) : ASM_INPUT_RM (*p));
 
 	return crc;
 }
 EXPORT_SYMBOL(crc32c_arch);

base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
-- 
2.48.1

