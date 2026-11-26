Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726275;
	b=il8RMsG8SzGrrpr3e2EiMl13WAW6mqpxgq1z/avGcoNAys3ggusmLPkLJUkX+Gq5gZG/
	 Ddh50D6fYB5gYZxMHHf6qxEJe1AaG7Xq7PXm1NvJ911NEDbzViaxCzHVmPNiIx0X5LIKW
	 R8X4dOxGGz/vGTvYPBU84NTP8y838kLaq42cKHw5s7986keP42S4HmlB9zcph+sp1swCw
	 9ib3/EpBx+wfgHMN/rG1F5Lwq4VU8JZzEbcMPOw6PDLKQkzXaYxpACmRQvXo2c43YbgG3
	 c6fbSJbIH5aFKb1aoWCbhR2n7dgHHzVC34Vi6agJxmP0BSSRfZitTKqPRzAxg2x+n1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hA+f6mNsTc9W51csUC2q9wjtv1U7ByYW5lCg1cGqWvg=;
	b=Cb089wmA+lmNISb9QZEX1OHioTQhQBOYaxwPBx6PFte1gp1XFJWUP5Br8mMWx8pqzyCg
	 ZOtB5Ik3I+5Q+OzUW2np68ScOpPlsOBCIAVHcJgB9ICv4ZhVHLxU7pZ/imItfPLkiBUF8
	 qchBPbR2qumzmnNDjrUqHeE4AKzP66GLnOIRcsFvBvSGNg4jEkPBt9p7KLmOV+dDcaF+k
	 FBnhe/wE3eSrh3qQ3P5NtnZKXIPb3WpUClFY5LAcWqX7djvQh+YV4yf+i3mHQPuop9M/I
	 cvQOrmz6MCEKG26PZ2xjPXupNqFR779h4WlGWtkPi6xr1tPVUSp1JFomdQHxqdgKQqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2V0wC0l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A3FE9606A337;
	Thu, 26 Nov 2026 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2V0wC0l
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8BD1C1F0089A;
	Thu, 26 Nov 2026 20:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726275;
	bh=hA+f6mNsTc9W51csUC2q9wjtv1U7ByYW5lCg1cGqWvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2V0wC0l/YN5fmIXMarw2FEV5iHvzPd4E7o0SZM8Af7LlZ1dUyxpwAt9D3SyYZ+px
	 05jUWrefMHrUZv+7VRw9n2+iFh2hBwL5JEKcUKwMBBPwZT+rSfXNlND4STKI0U9IqQ
	 C+zYyEgp0Pd1O3Duji3jQPyt3oku8MOwAYLpX4yLTDcVSb+NPddAgZuqZTsHP31aAu
	 tXcas7DT7jNv42BYisyvS0tk7AvhYFvvFK0SipzfXB4LU+A9BvYonw4JV5/d6JhmEy
	 ad7+eJIvNHQkdloya4KaRUHLujpvazp47grYbhdPS+Mj8f3dgFEI3MEWq+0dQ+rcoF
	 meijcogmMxN4Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v4 08/11] KEYS: trusted: Reject zero-length keys in symmetric consumers
Date: Thu, 26 Nov 2026 22:50:18 +0200
Message-ID: <20261126205021.2200819-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126205021.2200819-1-jarkko@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
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
index 27756fc906b9..665b2c37734b 100644
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

