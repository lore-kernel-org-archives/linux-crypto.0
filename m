Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8AF3164BA;
	Mon, 21 Sep 2026 06:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971127; cv=none; b=URtPPjCjqRjr5Jh3/lih56GJ03CdmM4wwzSTC6K2brb5bKVvlagwzGuTfz+hdwhlSmCBBQSlgL7FlhaHCCSNuXcjLiiwemM46xGtB+WVrJM6Qjtl8LRzaMwp1CwHpELmzzP1nGLTJmq8i2rF9v4imUtJpPPQs3imsRiSrFLhyRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971127; c=relaxed/simple;
	bh=UkhceXFFO5LRDpczSwzSJflrH5PfZcjnY+VqObvGDz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raAWMyP2yuQPE21YQJWeIs6piC6pPpDouBU5xz9qiWOljFPvMg77v2mwytzgRGnOLlYc0R/6i4JZ13bcBn4EQJwodG3BaIprSPyOKjnOL4EkWxP7JjOhhYfWhmN/MPI3ZviGPMNPmjf84vJmOAz3MZxnw0/8S2/iFKtUq9y0YmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZOHesCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZOHesCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C411F00899;
	Mon, 21 Sep 2026 06:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971126;
	bh=Cxan/eeTKGHjC5Y/1BbqvqdN0iZOgS+mVxmPHAEHFkU=;
	h=From:To:Cc:Subject:Date;
	b=nZOHesCEioVpEDYgHEDe9ovFlIm/YY7+PZfIVsdWU9b2Nl7mKWcMe1pK24l2Vekf7
	 t4GEhiev74BOk46tQMdpNOEhJEqeALoib9iM4vOtyYvs7hZdzXXQIE27EJYCzWo2gy
	 nw+OTq+37WUVH68h/M3HbVDdjzFfYni364SjAYM/YF/AM7OpWzdfXjZ/HxFIFYufV2
	 Uov738ksR9i2kJ3rCQOYtdVZnJmmVDPbdzFPyuBqYQhNm8NEGT/PgkUAcqklfsLDZy
	 VRcc3yg68vmVtf7aIqEoQV47hGDhfIfBM13BtDnEYKbVg4ZwQXT9l/ul0HbBF51Znv
	 G9I7Hh+nys6mQ==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] crypto: cast5 - use memcpy_and_pad() in cast5_setkey()
Date: Mon, 21 Sep 2026 08:11:20 +0200
Message-ID: <20260921061120.29694-6-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=728; i=blum@kernel.org; h=from:subject; bh=UkhceXFFO5LRDpczSwzSJflrH5PfZcjnY+VqObvGDz4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkbTnVs3Pbt2fQzna3upTPt7r7NnrH5+q9GR8E32/3/G d6eenOya0cpC4MYF4OsmCLLg1k/ZviW1lRuMonYCTOHlQlkCAMXpwBMJM2d4a+MVJPO6391H7Zu C9JdNO3zxdYffFp7OZvPXl4y445nZgw/I8Pa4mOpPF4KanNkf/6Lfv5QR//JhFcbsvee+r2+7F/ K1CguAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
simplify cast5_setkey().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 crypto/cast5_generic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index f68330793e0c..1de0dc966a03 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -483,9 +483,7 @@ int cast5_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
 
 	c->rr = key_len <= 10 ? 1 : 0;
 
-	memset(p_key, 0, 16);
-	memcpy(p_key, key, key_len);
-
+	memcpy_and_pad(p_key, sizeof(p_key), key, key_len, 0);
 
 	x[0] = be32_to_cpu(p_key[0]);
 	x[1] = be32_to_cpu(p_key[1]);
