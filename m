Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E084AF9D4
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552305; cv=none; b=MJasiO8ojDE/tlNu5DZHV35fzez9r9hoPoTZ8v59PeCktx/2iNlEUoK4GG7lE02EVsgX2HyVYYNKdft6zA7z6TdVnfvoVv8KkuJktVfWS3TdUt8j3awb8Ts8p9ouJRCFkTHptVCp+sLzK5z7AArP4GrnH/3G3T9RlpdJ6rGPPBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552305; c=relaxed/simple;
	bh=E6KPxvJHH1VHldmIFR1xanm+ALnTwrvx3H+X++MBV5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHKKVM9npMtYgo3XQkKtB6/lvjRk0+WIl6p5K6vOMqLVw3k/hBJ5qbttP+WcxRdSDyYqgIcM4njEuX5xNPl66MaIkWfuB3foZ1nddYzALg1tqUbEUIoIUGwbLddVOQ6ZVDodiFmSwrAf/H+xMustoMiwMZfpFYrYMsjUCGpmNOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fOrJCv5D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fOrJCv5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A1COWvN1IxP74U37pvhe+s+4DbmU+5bH+TwCyZ5ozBA=;
	b=fOrJCv5DehyCnN5vcPl0xECFm3773kWbb3DRUGo73drMKrVzcBsiJvNcQeYATNafAN9zq9
	meDrJJ20cI4ahKQrXJcox7SzZtjjvza3oOjLM7Wm9EZjUmaomsPP4rmz+ug70v44MRtIvy
	zNZHktl4BcIeh7vBXmUjgN2sV49v4iI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-YwrMlN3-M7KbdZtlt_MnxQ-1; Wed,
 16 Sep 2026 05:51:20 -0400
X-MC-Unique: YwrMlN3-M7KbdZtlt_MnxQ-1
X-Mimecast-MFC-AGG-ID: YwrMlN3-M7KbdZtlt_MnxQ_1789552278
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5B5D1955F2A;
	Wed, 16 Sep 2026 09:51:17 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4210B1800446;
	Wed, 16 Sep 2026 09:51:14 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 10/13] x86/purgatory: Compile purgatory with -D__NO_FORTIFY
Date: Wed, 16 Sep 2026 11:50:12 +0200
Message-ID: <20260916095022.604354-11-thuth@redhat.com>
In-Reply-To: <20260916095022.604354-1-thuth@redhat.com>
References: <20260916095022.604354-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

A subsequent patch will add #include <linux/string.h> to <crypto/sha2.h>
to use memzero_explicit() there. This will introduce a conflict with the
purgatory code: purgatory.c includes both, the <crypto/sha2.h> header and
the arch/x86/boot/string.h header. The latter provides its own prototypes
for a lot of string functions which clash with the fortified macros
from <linux/string.h>, causing the compiler to emit errors like this:

 In file included from .../linux/include/linux/string.h:383,
                  from .../linux/include/crypto/sha2.h:10,
                  from .../linux/arch/x86/purgatory/purgatory.c:14:
 .../linux/include/linux/fortify-string.h:576:63: error: expected identifier or ‘(’ before ‘{’ token
   576 |                              p_size_field, q_size_field, op) ({         \
       |                                                               ^
 .../linux/include/linux/fortify-string.h:644:27: note: in expansion of macro ‘__fortify_memcpy_chk’
   644 | #define memmove(p, q, s)  __fortify_memcpy_chk(p, q, s,                 \
       |                           ^~~~~~~~~~~~~~~~~~~~
 .../linux/arch/x86/purgatory/../boot/string.h:11:7: note: in expansion of macro ‘memmove’
    11 | void *memmove(void *dst, const void *src, size_t len);
       |       ^~~~~~~
 .../linux/include/linux/fortify-string.h:208:9: error: expected identifier or ‘(’ before ‘__builtin_choose_expr’
   208 |         __builtin_choose_expr(__is_constexpr(__builtin_strlen(p)),      \
       |         ^~~~~~~~~~~~~~~~~~~~~
 ./linux/arch/x86/purgatory/../boot/string.h:23:15: note: in expansion of macro ‘strlen’
    23 | extern size_t strlen(const char *s);
       |               ^~~~~~

To avoid the problem, let's compile the code in the purgatory with
-D__NO_FORTIFY, so <linux/string.h> can properly be included from
headers like <crypto/sha2.h> in the purgatory, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/purgatory/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 5ce1d42630000..cde8463b4d841 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -11,7 +11,7 @@ $(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY
+CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 
 # When profile-guided optimization is enabled, llvm emits two different
 # overlapping text sections, which is not supported by kexec. Remove profile
@@ -37,6 +37,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding -fno-zero-initialized-in-bss -
 PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
+PURGATORY_CFLAGS += -D__NO_FORTIFY
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
2.55.0

