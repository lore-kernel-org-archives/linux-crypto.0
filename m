Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726279;
	b=e0ehVaAgkB28H48G6CO2QR7id8jDlvMd2yLWhBtvaHXrL1dKdUTo7BEO1nM2BTdoppQY
	 VgEuAymHrG3QTH+0ZMpgWwaDAQqGKz64N/6wDHz6VenOHfoBpHZBLpIs5X3hToA2XnQC9
	 MrKI4UzmzKv38nNv+GTxTaqZjzb/FB+sBUdHRxSMqoS5o45oiuNIgTW64P7nzbFQAlJXo
	 +2pwj2KyLm4KALfehlnfB+kfZ9nX0tc0861bcEt+J/nsoEuScrNtR9zpBelR591zoIaIy
	 zbx+XtrYnIGjdnX5Cq1Z7QCsQgGfmfwfjF5ae5GU5dt5vY62i93PLNUFc62FKOkbiEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xAoZssdEGReXpW+fiyeccugaPyEheAlcfEk5nmlrLac=;
	b=dX9LoitcBZI4vHWQH1GZ5R8GEm0NZPz1lCH4Fxe7ymHJFFIlL2bAAsrm7ksHzpRjgRw+
	 QoyPXZZ8NG0orGaTbduvGEeF63xzeie8PsHBCYnTXYE9EbAWkRfXYC5oS5vY/DQkRtOBd
	 7pwe9vRI1V5XlgpaTDr+W7AIBP9inKCs4DO5CRY8qMC/7RzF2tWSvuvC6K1dTDz/hdOOu
	 P8Bj/wkYi3LW0DZ7u4w8bu0k/UMRBKad0+bPVmMj0lmPrtls6cVvU6EhntUGY0nckTg2l
	 0uSOUvkZoNiryKIqB5Cpc3UzjLhDSoebgUCt+C8oVQgYRE4qJCc9J9puNMpg2zsr11A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WkK/V8+d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5F9D7606A33C;
	Thu, 26 Nov 2026 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkK/V8+d
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4D4441F00893;
	Thu, 26 Nov 2026 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726279;
	bh=xAoZssdEGReXpW+fiyeccugaPyEheAlcfEk5nmlrLac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkK/V8+dueXLBEkkoWesDAREjnXstJ/FCDwYLMVJpSlOx3BlQ0I7EhE8TU/nd4LJ9
	 UX1HFC0zjNLfdobcNdbhKRKtzAVgRDOGrzVfTQnmv4aZarwA0MLOk1gCFNyC1je/IS
	 U9H+TAU1mKblYtyIxJqy31TBpepeOiMqH93DSkhpjVkejodZH4Ifxf4zSDQWYcBKy8
	 HJvcP3J2143jirbGKjF6qYsTHVrK67sG6+fcUwsK6OYHEX1I1BaX4UtubpooOzDwC8
	 6JB/91ZVFRdKH3+0nO9MI4Fasu1PDyAc2yT+upZo+4F+VzSVX9mQWiWdAmBnJ8spnU
	 v/ooefqNa7kRw==
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
Subject: [PATCH v4 09/11] KEYS: trusted: Add private backend data to trusted_key_payload
Date: Thu, 26 Nov 2026 22:50:19 +0200
Message-ID: <20261126205021.2200819-10-jarkko@kernel.org>
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

Add a backend-private pointer to struct trusted_key_payload and free it
sensitively via trusted_payload_free() on teardown and error paths. This
prepares for asymmetric TPM2 keys, which retain backend key metadata
across runtime pkey operations instead of unsealing a raw key at load
time.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/keys/trusted-type.h               |  1 +
 security/keys/trusted-keys/trusted_core.c | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 3db61b57cf73..790ffabb0d18 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -33,6 +33,7 @@ struct trusted_key_payload {
 	unsigned int blob_len;
 	unsigned char migratable;
 	unsigned char old_format;
+	void *private;
 	unsigned char key[MAX_KEY_SIZE + 1];
 	unsigned char blob[MAX_BLOB_SIZE];
 };
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 665b2c37734b..1db6497ba297 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -149,6 +149,14 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	return p;
 }
 
+static void trusted_payload_free(struct trusted_key_payload *p)
+{
+	if (!p)
+		return;
+	kfree_sensitive(p->private);
+	kfree_sensitive(p);
+}
+
 /*
  * trusted_instantiate - create a new trusted key
  *
@@ -223,7 +231,7 @@ static int trusted_instantiate(struct key *key,
 	if (!ret)
 		rcu_assign_keypointer(key, payload);
 	else
-		kfree_sensitive(payload);
+		trusted_payload_free(payload);
 	return ret;
 }
 
@@ -232,7 +240,7 @@ static void trusted_rcu_free(struct rcu_head *rcu)
 	struct trusted_key_payload *p;
 
 	p = container_of(rcu, struct trusted_key_payload, rcu);
-	kfree_sensitive(p);
+	trusted_payload_free(p);
 }
 
 /*
@@ -269,7 +277,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = datablob_parse(&datablob, new_p);
 	if (ret != Opt_update) {
 		ret = -EINVAL;
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -283,7 +291,7 @@ static int trusted_update(struct key *key, struct key_preparsed_payload *prep)
 	ret = static_call(trusted_key_seal)(new_p, datablob);
 	if (ret < 0) {
 		pr_info("key_seal failed (%d)\n", ret);
-		kfree_sensitive(new_p);
+		trusted_payload_free(new_p);
 		goto out;
 	}
 
@@ -322,7 +330,7 @@ static long trusted_read(const struct key *key, char *buffer,
  */
 static void trusted_destroy(struct key *key)
 {
-	kfree_sensitive(key->payload.data[0]);
+	trusted_payload_free(key->payload.data[0]);
 }
 
 struct key_type key_type_trusted = {
-- 
2.47.3

