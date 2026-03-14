Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D35330B0E;
	Sat, 14 Mar 2026 04:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773460853; cv=none; b=oJE+dMWIMS3mSOE/Zay1KglzbkhSoIXbTSxTgCohoobq0dWOqR6Mc15uQdNuKtHbUtP0ODVfG18icOUTdcBONuC4jWegiaW8OlHlz5ga+WTuwUeseThIZPK1fuCtxlDQc5Q1UvF3Rc4MTeaRP54hsL4Yr7aK59uGZTLR83A6qNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773460853; c=relaxed/simple;
	bh=BBYPVx30vdvlzUB8hYKKaqRTPVaq4MVEjgs2oxmEHCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTbVYuHEWRgkOrVTDejwxh5HCoEnKIK71Txhstm18h9nEWMuuESD6I7sk8VmQGdOSFEh4ZzBnaJWjFwCQMY6ja7xjERShcV1BGv3aXml/P9JFvJcQdN/6Ct8eHc1oIro6sUpbgB0WaVNsBZZVFqkr/hd2Y9Ko1v9Efk/wOQfum8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmNP1SNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmNP1SNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0722FC116C6;
	Sat, 14 Mar 2026 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773460853;
	bh=BBYPVx30vdvlzUB8hYKKaqRTPVaq4MVEjgs2oxmEHCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmNP1SNcmNtBRth70dpMTnKuoshXttYiKiwlcnwr9WPZ7ZSkpdOIaGG/3uR3Zp0oO
	 iQtFgunrGw5Y3W+G4uwGLlAJB37FJG1/rQi0XKIKlJwfq0TIHCeqQFlRyfU1cIIcJb
	 y8dCpKEmznNUT6JEXgv08sQYt3kBDyVq4fePsL0PjNBAWi3Eo+TsM/8irvwMarBFud
	 Wki/aTIn3my5Np+YeoAe0uXyZJMTBIGqBkMgxiIpc2wFTXk9l+QFimwOoCiQR7L9Bl
	 uYEKrLpgORIusBSolD4xDxvT844PmbPm7H04lz3bC8xqaZO5kqPkn9lwbd6cHURPmP
	 ZwRZ0pA7Hlxvw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins Brendan Higgins <brendan.higgins@linux.devbrendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.comRaeMoarraemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] kunit: configs: Enable all crypto library tests in all_tests.config
Date: Fri, 13 Mar 2026 20:59:27 -0700
Message-ID: <20260314035927.51351-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314035927.51351-1-ebiggers@kernel.org>
References: <20260314035927.51351-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new option CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT enables all the
crypto library code that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS
to enable all these tests.  Add this option to all_tests.config so that
kunit.py will run them when passed the --alltests option.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/testing/kunit/configs/all_tests.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/kunit/configs/all_tests.config b/tools/testing/kunit/configs/all_tests.config
index 422e186cf3cf1..6910b07082da2 100644
--- a/tools/testing/kunit/configs/all_tests.config
+++ b/tools/testing/kunit/configs/all_tests.config
@@ -42,10 +42,12 @@ CONFIG_DAMON_PADDR=y
 
 CONFIG_REGMAP_BUILD=y
 
 CONFIG_AUDIT=y
 
+CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
+
 CONFIG_PRIME_NUMBERS=y
 
 CONFIG_SECURITY=y
 CONFIG_SECURITY_APPARMOR=y
 CONFIG_SECURITY_LANDLOCK=y
-- 
2.53.0

