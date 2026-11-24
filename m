Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521699;
	b=ub8mR/w9Th3g8bB17CT4FzXixA7+bl2ALSr9UgFoMdWb5n6yJhOmF20hn8B7qLKbpxIf
	 jhCOZZKW9MYOL5/ZLUTm+5UgnER2xbiZp9nLv3R+lK2U6Auy1Q5aFtuF51jDqD/AsY78V
	 a3Q6w9NGfpTQK5evqA50Q3S4Fn+QmwyuldV52z6jC4P0Vu1AWaJDAD2D726t6Ef1jfvXO
	 LYIX3b8dBhC4f0dHJMwGdcORJKv0WUp1SN07iRLhpnYc+jACyAfA/7sz+zoOk9V9/HAEp
	 yzOSfF1i/CEgFc8TTKcQQsR8MeMhMo83AnzGQpgjBx/QdDBKP6JaJGP3Pf9DhOX1VQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Zwc/0WX6N0Ikmz6rLp8weMhhFeWo/RMK4JNzjHNKGgY=;
	b=rDF0ok+VVJWvIXc00dK+TKjdyn0R5VQ5WC2LvhNglhscbqsqk0JzsK/yjBLpjRT98wFK
	 ecYcnFfO7eKerPRL3bC38aF7zEoB0MknfuHDjFN+qpLvgLIPy+UGCrz7DRsD2Hv9e6jlt
	 AUpnnoqSszwlBwcL/j4ix7goEm0CixHdGoOXgYu9SaU6bjdu2TJdPNrZRNByCy2XxOKAq
	 0VTkdQtsGrhfwyt+w1IH5GIMc9yhqhann8oe0mru2O1xHOvTbqm2ZjlNB1A+W02GyCbrJ
	 ORqlwpMKdY6MNeDIvjWbOcIie5cMsDmWAseZi6CSagojTh9cwmmg5XuCPW5xTDltQKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg1EaSTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 93B54606A31E;
	Tue, 24 Nov 2026 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg1EaSTl
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CAD91F000ED;
	Tue, 24 Nov 2026 12:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521699;
	bh=Zwc/0WX6N0Ikmz6rLp8weMhhFeWo/RMK4JNzjHNKGgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bg1EaSTlrs1HC33n1oc9x0gXGHpv/pbgZZb5GCAw+hZpLok/UTubpIzVOWtmTaYgC
	 GlC7aGkE4UkcIqhkC89b2VIOxUCGFcAOOr/MJzZ/ajvdaFTCsU0vCczkYZkaWV/Re1
	 pZhD8evoyUzYP3i4gsM0gAS+fkCz8zJj3x7VbS2GaFe2rFKRF9OxH2cyHVLdpfOlB9
	 Y/d/aTNah9akmYHcwjOhF1JLB9xHtOO02p3wwi9PMnOlSicO4AeKW60j0ea3wZ4RNg
	 E4MoYRjaUK1y1gmRNTTqGtpVAwH/dYwjMeZ825ATD6vybFm5vqMNrlNOS5qFibUNyK
	 68o9EpiVjcXcg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7/9] KEYS: trusted: Reject zero-length keys in symmetric consumers
Date: Tue, 24 Nov 2026 14:00:42 +0200
Message-ID: <20261124120044.1481752-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124120044.1481752-1-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Asymmetric trusted keys will not carry a raw symmetric key payload
(key_len == 0). Reject zero-length trusted keys in encrypted-keys,
af_alg, dm-crypt, and trusted_update() resealing.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 crypto/af_alg.c                                  | 2 ++
 drivers/md/dm-crypt.c                            | 2 +-
 security/keys/encrypted-keys/masterkey_trusted.c | 5 +++++
 security/keys/trusted-keys/trusted_core.c        | 2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ab84c4488a15..133cb88e3c12 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -323,6 +323,8 @@ static const u8 *key_data_ptr_trusted(const struct key *key,
 	if (IS_ERR_OR_NULL(tkp))
 		return ERR_PTR(-EKEYREVOKED);
 
+	if (!tkp->key_len)
+		return ERR_PTR(-EINVAL);
 	*datalen = tkp->key_len;
 
 	return tkp->key;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 02038a9cd21d..1e034c747d39 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2492,7 +2492,7 @@ static int set_key_trusted(struct crypt_config *cc, struct key *key)
 	if (!tkp)
 		return -EKEYREVOKED;
 
-	if (cc->key_size != tkp->key_len)
+	if (!tkp->key_len || cc->key_size != tkp->key_len)
 		return -EINVAL;
 
 	memcpy(cc->key, tkp->key, cc->key_size);
diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index e6d22ce77e98..8c6e6bdd8ef7 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -36,6 +36,11 @@ struct key *request_trusted_key(const char *trusted_desc,
 
 	down_read(&tkey->sem);
 	tpayload = tkey->payload.data[0];
+	if (!tpayload->key_len) {
+		up_read(&tkey->sem);
+		key_put(tkey);
+		return ERR_PTR(-EINVAL);
+	}
 	*master_key = tpayload->key;
 	*master_keylen = tpayload->key_len;
 error:
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 11d7d296d063..3721980ed83a 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -249,7 +249,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	if (key_is_negative(key))
 		return -ENOKEY;
 	p = key->payload.data[0];
-	if (!p->migratable)
+	if (!p->migratable || !p->key_len)
 		return -EPERM;
 	if (datalen == 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
-- 
2.47.3

