Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7232127E7E3;
	Thu,  5 Jun 2025 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749143781; cv=none; b=PwA5CCJEHSH1QHz0skOIflm1UC9nAE3hboh2NQgR1Tkx7idRXpQmX+P12g/6Qaq7aJTNG7Anz8LVp4iGJb6Ps2kw/z6sbI2fgEP9mFgI6ufAoR1sNe+BDYyXDjwOhryGCQZKnjfRC8nNfogICTG7p++wff3TTcQwtuX0/esRFwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749143781; c=relaxed/simple;
	bh=DgZhQvpBXlB09Hd+4ffRFTQ/OvbWM89FGEGLeEK7fmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FDyahb3fzRfOYZr8hF31OpAWFBnhrFaYlb5XwdDM/8iVnC/+O1ZapXu5sSlqHk43voH/CJh6++6rhAp6HS6SGnQlaE8SYyby22XonKE49lFgFiFrxqEjtp3/dLW7Lh9WwFmUUbNXIQTOpG9nqMGSN3/Mjii81YfEMDAnFS9aYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0Dyyl9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0Dyyl9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFCFC4CEE7;
	Thu,  5 Jun 2025 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749143781;
	bh=DgZhQvpBXlB09Hd+4ffRFTQ/OvbWM89FGEGLeEK7fmA=;
	h=From:To:Cc:Subject:Date:From;
	b=G0Dyyl9ur57H1SxJSwQNt2xUmsRROjSIC33EgvyghqJRlFbD/oLMlItc6/s7SkVQi
	 JiDfKc9C+Gaoog8+rCfi6k0ft1kiL8xLZ62BG76g3PNvvvnhIwKdhYFJ/BhQCswn1k
	 wBnHi1gS+VMTTFgMh4vHtzekLlVEmTl0w75Rsf6kYc4S1nxt34AtxrBB1djuluPotF
	 zh3xHRq1/s6H8LP3JOkDrG0/58UEmSvGZkfifK44VYzkEnV9CEmj+UxgEEnw6GemHM
	 V2ORmUiKwrrriZTuGWxk/38s+kkEzMDeBBmh4mHbe/Tko6pW04Kznzy1Rgd/AsAGkO
	 IzII2OM7Jlo8Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Kees Cook <kees@kernel.org>,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: add entry for crypto library
Date: Thu,  5 Jun 2025 10:11:56 -0700
Message-ID: <20250605171156.2383-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

I am volunteering to maintain the kernel's crypto library code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eecc41c39a9cb..d64d1ddef842b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6372,15 +6372,22 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 F:	Documentation/crypto/
 F:	Documentation/devicetree/bindings/crypto/
 F:	arch/*/crypto/
-F:	arch/*/lib/crypto/
 F:	crypto/
 F:	drivers/crypto/
 F:	include/crypto/
 F:	include/linux/crypto*
+
+CRYPTO LIBRARY
+M:	Eric Biggers <ebiggers@kernel.org>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
+T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-fixes
+F:	arch/*/lib/crypto/
 F:	lib/crypto/
 
 CRYPTO SPEED TEST COMPARE
 M:	Wang Jinchao <wangjinchao@xfusion.com>
 L:	linux-crypto@vger.kernel.org

base-commit: ec7714e4947909190ffb3041a03311a975350fe0
-- 
2.49.0

