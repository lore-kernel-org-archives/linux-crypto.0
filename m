Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2727A135;
	Wed, 27 Aug 2025 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307698; cv=none; b=rb2dSTwqEFqeqpHjWyZyePh2vprKbzbmKsxsksYZsSU2HLiwTR82Yhlei+3B9tmWHqEFVmOvkuTfUM9wz9G0FUHSKwA0OYVcORth+AMTpYDJWhjsvSu4CwijHpODCHObFQqWcb/6NUiYiIWWZDYcqPIeTMA+kctz9g1sFVhB++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307698; c=relaxed/simple;
	bh=g1XQPcj5tYdZR7RHqv4B4KYBYDZhxP4CJu6Eu0ySl7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SApKVj13IqpdsNmV5C3lLdFvisZxZbfxlXYmHrTatfsB4uFyXDmv4H5yU2ANfqDlOPlTeEW5ebdz6MH6PZ7Sh0ucz/+7sstZHTe0d9mc+dKL1ETGLcui1KBvaHKw2lJ34umDBFXpMb/b598CJTcQeHFiGkm2XTMyHlH5QLlmoWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAtWYP9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAtWYP9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D79CC4CEF6;
	Wed, 27 Aug 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307698;
	bh=g1XQPcj5tYdZR7RHqv4B4KYBYDZhxP4CJu6Eu0ySl7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAtWYP9pqw9F41rCRT7PMNXh7UMxrQfg6Fh4MWXFo89S9O4tImBUhVwJh8+jJ6cJF
	 0xTMzFQOQVFUdL86hrGWgt5/AiXIbe955v+pzQ1Q+7VEbIOsE366hHAb9VIPTWihbw
	 Bi/wwjcD5X0UoPjaDeqpeM1JGI5Om2eUWasqEIpI8Jo4trPn/TobDNJqoNUMlbr1Is
	 XOIGY57gXcrP1bODzQ/qQMTDZr4Ri3Jy5BvvAXB3yOri392X02lvWpxXlOQwmxy3aL
	 tkTOfrxoyje0qNAYRhMjbpbV+Ma833YSDVyniSzpjjlCjUoWI+WbNFWmWglwWlBcwV
	 FTUoIFe3+SWOw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/12] lib/crypto: chacha: Rename libchacha.c to chacha.c
Date: Wed, 27 Aug 2025 08:11:24 -0700
Message-ID: <20250827151131.27733-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename libchacha.c to chacha.c to make the naming consistent with other
algorithms and allow additional source files to be added to the
libchacha module.  This file currently contains chacha_crypt_generic(),
but it will soon be updated to contain chacha_crypt().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile                  | 1 +
 lib/crypto/{libchacha.c => chacha.c} | 0
 2 files changed, 1 insertion(+)
 rename lib/crypto/{libchacha.c => chacha.c} (100%)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index ca65924e861ff..5749d176be1c1 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -16,10 +16,11 @@ obj-$(CONFIG_CRYPTO_LIB_UTILS)			+= libcryptoutils.o
 libcryptoutils-y				:= memneq.o utils.o
 
 # chacha20_block() is used by the /dev/random driver which is always builtin
 obj-y						+= chacha-block-generic.o
 obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
+libchacha-y := chacha.o
 
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
 obj-$(CONFIG_CRYPTO_LIB_AESCFB)			+= libaescfb.o
diff --git a/lib/crypto/libchacha.c b/lib/crypto/chacha.c
similarity index 100%
rename from lib/crypto/libchacha.c
rename to lib/crypto/chacha.c
-- 
2.50.1

