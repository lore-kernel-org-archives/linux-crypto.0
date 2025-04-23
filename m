Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460D021FF4B;
	Wed, 23 Apr 2025 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745425554; cv=none; b=Q1J5yR8GaRegE8RojLzZOWFSjWfpFX2AwQ8jdh+j1zqljLfyir9JPKW8ubRPazU3wCvo9mtXKjH/rorzAiULiGgisTjnnTwgr0eY16xGC3hhfcp9aTOdxI23kA0G0odJeclrIwXOR1yCkgQkOrTK2Aeadqp5/iWkkbWfBe0qekI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745425554; c=relaxed/simple;
	bh=VsGqFF5gj3xI8K6h8F26IScSEUVGX+2XHW0J4sjFLHE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pbfn3a3YURSPKTR6toxwHjxw6cuSU18RLRKnckIe5d6LhZic830x5sFgG97Wg/ZUoC6SaHAJvWYMILVdBeTqvOtRDHrRbYo2zfV0FzyO5FAX6VbBTUJMYL+Bk14MSuTyLx6wjcaMd/yobFZvsW4QBijgtfpTTHj0q5RP/uMpn2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M21ClDit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M21ClDit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F022C4CEE2;
	Wed, 23 Apr 2025 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745425553;
	bh=VsGqFF5gj3xI8K6h8F26IScSEUVGX+2XHW0J4sjFLHE=;
	h=From:To:Cc:Subject:Date:From;
	b=M21ClDit9hXhddBWq9aeC+iUjg8puJxJ6vrFHdX99QuRM7jHrBH7H8myT+5eRp+eU
	 N5agjaVf2H/lPruzOSKTK0C4tSe/hegFwBeydLn3SFPcGhfkiHhpT1k90wBP53L3Jr
	 d2kwm6HFn4WfyrRausdN5wmYdfE34Y+cDZbnlwD77chzLJGHERxBrLPhhAH2leBT9C
	 UarvERDOUaRA85lSFhQUaBJGc2z0c0McFIFpNLroih4lwwHisS911nHXgm/3nQZRCz
	 5nfb5Eaj7tAZk4sfaZ+NY7ifpd12nAfCTwi2tloEBa+SwivvEdxhfd9MZQg5yQZBqI
	 /GVMm6n7Yy6iQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: x86/sha256 - Include asm/fpu/api.h directly
Date: Wed, 23 Apr 2025 18:25:45 +0200
Message-Id: <20250423162548.2072707-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

This was previously included through another header, but now causes
a build failure in some configurations:

arch/x86/crypto/sha256_ssse3_glue.c:63:2: error: call to undeclared function 'kernel_fpu_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   63 |         kernel_fpu_begin();
      |         ^
arch/x86/crypto/sha256_ssse3_glue.c:65:2: error: call to undeclared function 'kernel_fpu_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   65 |         kernel_fpu_end();
      |         ^

Include the header directly to make it build again.

Fixes: 8e7547473875 ("crypto: x86/sha256 - Use API partial block handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index b3115e207a9f..42b0bb6c8caf 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -36,6 +36,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include <asm/fpu/api.h>
+
 asmlinkage void sha256_transform_ssse3(struct crypto_sha256_state *state,
 				       const u8 *data, int blocks);
 
-- 
2.39.5

