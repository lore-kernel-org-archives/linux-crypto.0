Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E217E91C;
	Mon, 27 May 2024 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716841733; cv=none; b=asxQPntvIr1VE45yBz2JkMgXGnBaFhHLxQjTNLRt3xdqAadP078HhZorSgfPcc/0bLTgqJ+p5qE+I59Mx/rcmgeFtc0lZEJP+pwKjZ+5qxRbwOT6zJ+esFiLGWa3AYXe893V4wwgHcMvBZLu1GVpNM/LKKjiG4hic1H0Vs9luHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716841733; c=relaxed/simple;
	bh=VdklvfCEKaHVCacU+1F3nFSD3rl7oBp3RQBkvn4Txog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nrBigVzUF+giTKj1C/JdTvajKqhsvUHWQ444/fh8MkT8sJH9PKm4EpMnlQ0Khv0Gjdmi7wPYMSo7hb+9AuprORM2IhZqw8eg0iLRRARCbXPZ1VkMw+vIBz0b+BarqUD5UPMXf4stDe+Uq4SXNU7J1JBZO4rc5wZFqBEQJHpavSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0yUbENz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0yUbENz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DB7C2BBFC;
	Mon, 27 May 2024 20:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716841733;
	bh=VdklvfCEKaHVCacU+1F3nFSD3rl7oBp3RQBkvn4Txog=;
	h=From:To:Cc:Subject:Date:From;
	b=K0yUbENzIX3kFTrMZSxeo/SvkFkNLc+9jMIAdhACmoVcbutD4daKTSMOx7yGW+eYD
	 Bd+7x2sAtz0GNztRzWliW7qdvbYZzFEqyelxjOx3OpwfwS7XivsWrO0RfpA7K6PdIF
	 kS6S/sTC5aL1QlRDb7CXmJfJjRN2JeIBknFAhNAwCxtDlFD0fGz0KAHzKmmVIzpkTJ
	 0/pekSyrL0Cgx9eSFxHrgY7iIdtsgAJzMlhsT3aOU2kPWgxBYTUM5FvKtCanxMJxgF
	 QfQvwM9hTKmDWf16IGWIB4zIZzhT7h1jW9NOfEUqF2wb18nzAzhhTdBu+OzrcJFphX
	 4xFQlUq4eYxIA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Stefan Berger <stefanb@linux.ibm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ecdsa: Fix the public key format description
Date: Mon, 27 May 2024 23:28:39 +0300
Message-ID: <20240527202840.4818-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Public key blob is not just x and y concatenated. It follows RFC5480
section 2.2. Address this by re-documenting the function with the
correct description of the format.

Link: https://datatracker.ietf.org/doc/html/rfc5480
Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
It is a bug fix that does not really need a stable backport. Still
categorizes as a bug because by following the existing documentation
you end up with an error code.
 crypto/ecdsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 258fffbf623d..55114146ff84 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -215,9 +215,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
 }
 
 /*
- * Set the public key given the raw uncompressed key data from an X509
- * certificate. The key data contain the concatenated X and Y coordinates of
- * the public key.
+ * Set the public ECC key as defined by RFC5480 section 2.2 "Subject Public
+ * Key". Only the uncompressed format is supported.
  */
 static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key, unsigned int keylen)
 {
-- 
2.45.1

