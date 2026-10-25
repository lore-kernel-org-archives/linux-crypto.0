Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887121;
	b=sUNMV/EEQdUyPljyNeDfkpgTe0vb415eoKkZqPA/o2ntVI15LxOM5FwZ5MH+ZVKIqHCB
	 8qT6KrnqXDUyOw1Zhy5GZb/l7PLF3dTTvv81CUsmN0mdwS1msNrcpeSkyvKjo6c9bEXiQ
	 MJQ3VD8nrLpF1u7aw1zJYQ6DDmQS4DmE1fDW13EdjdQUHx1fJ45iL+khDJebqj554zcFs
	 qvgbBEQNDq38pMl7bS325H67Uo2V1HVeCarzYRmTn44ZdpopgTkX5AYW9hq9nO2Q30oLr
	 uGoaQerX7RpMM8F/uotRWmGXugO2AKgCi1HgCT8wW4Gzw0gSU4EK/WkPJfww2NwCRrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rIGPAv7/zPFbNwYxOD2kgwfOMkyaHEeBIaAk6kpu4To=;
	b=jLSgfOC1aIAnQReUx1x7Wt6w+KSnpXRv7brIlMUKErYgv9Tj7DcOeiJwrYL5MkCX71kL
	 S4rI0R84WPTMn0r0T+00U12mMrTMvj/Pk5F+rW0dmjGI3g0TfQ9kBd7lb21wfRpESGG1D
	 dgnmAnGfkRhQobCZzgxnOfwuHZD7wS0fIjaPfatkr67Dm66tNXciRRnivoUjmSvaG6VPr
	 sldC+GzGSQXT9Y52zPj8a9zTBkVtgPJzrBhB0zxnH5h+fSZYfZSMTCCvHivUEvkccHoBb
	 4N/nJ4SUVwC57oMh2rIAThOAjfqn7CsIKXs387XRQSZ+19ZuWRWjmY4VwXkOfKS0q6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1zINBwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 78CA4606A324;
	Sun, 25 Oct 2026 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1zINBwc
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5D2B1F01825;
	Sun, 25 Oct 2026 00:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887121;
	bh=rIGPAv7/zPFbNwYxOD2kgwfOMkyaHEeBIaAk6kpu4To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1zINBwcMH8BoYOnbv+CJZQFhjcHbt8RZR6zkbS0IXyayJ6IIJZURyLi/SrVFddJT
	 7q+O7BpFM0qF7oPqUAEea59WOX2C30Z5rOOwsMQ5TKbzus8VoBfEnEyM1l/dQedP0E
	 NN6QQiedP+xoCwb2dw2nKlZP+RTFcHDu4Y4wAxuk6a2ya994bWKhOBOQdq3T0eoeGr
	 1T02csxorD/Y8bPiPHF9AeBSRVSf2LsOb9s/E/U7PiKu3rnPQNNz08UzTRywSAXLId
	 GCvYoVr9vkTaV/Oyl2663WNVEJK/BcEths8swgBjPkBfJHDBXt5IF1g9hclyra3I8A
	 ykpiLSsp595dw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.org,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-crypto@vger.kernel.org (open list:RHASHTABLE),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH v3 2/6] KEYS: Reject descriptions larger than KEY_MAX_DESC_SIZE
Date: Sun, 25 Oct 2026 03:10:10 +0300
Message-ID: <20261025001105.1824178-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025001105.1824178-1-jarkko@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
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

KEY_MAX_DESC_SIZE includes the trailing NULL character. Descriptions
generated from payloads and in-kernel paths bypass the userspace limit.

Reject descriptions at or above KEY_MAX_DESC_SIZE with -EINVAL at the
following sites:

- key_alloc(): before quota calculation
- __key_create_or_update(): before key_set_index_key()
- keyring_search(): before match_preparse
- request_key_and_link(): before match_preparse
- request_key_rcu(): before check_cached_key()

Cc: stable@vger.kernel.org
Fixes: f771fde82051 ("keys: Simplify key description management")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-3-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/key.h         |  3 +++
 security/keys/key.c         | 10 +++++++++-
 security/keys/keyctl.c      |  2 --
 security/keys/keyring.c     |  7 ++++++-
 security/keys/request_key.c | 14 ++++++++++++--
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 26139c3adf62..3b8af14fb323 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -37,6 +37,9 @@ struct net;
 
 #undef KEY_DEBUGGING
 
+/* Maximum length of a key description, including the trailing NUL */
+#define KEY_MAX_DESC_SIZE 4096
+
 #define KEY_POS_VIEW	0x01000000	/* possessor can view a key's attributes */
 #define KEY_POS_READ	0x02000000	/* possessor can read key payload / view keyring */
 #define KEY_POS_WRITE	0x04000000	/* possessor can update key payload / add link to keyring */
diff --git a/security/keys/key.c b/security/keys/key.c
index 6ebb8691551f..e88548f1a704 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -245,6 +245,8 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	}
 
 	desclen = strlen(desc);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		goto error;
 	quotalen = desclen + 1 + type->def_datalen;
 
 	/* get hold of the key tracking for this user */
@@ -829,6 +831,7 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
 	key_ref_t key_ref;
 	int ret;
 	struct key_restriction *restrict_link = NULL;
+	size_t desclen;
 
 	/* look up the key type to see if it's one of the registered kernel
 	 * types */
@@ -869,7 +872,12 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
 		if (!index_key.description)
 			goto error_free_prep;
 	}
-	index_key.desc_len = strlen(index_key.description);
+	desclen = strlen(index_key.description);
+	if (desclen >= KEY_MAX_DESC_SIZE) {
+		key_ref = ERR_PTR(-EINVAL);
+		goto error_free_prep;
+	}
+	index_key.desc_len = desclen;
 	key_set_index_key(&index_key);
 
 	ret = __key_link_lock(keyring, &index_key);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 36ffba0ebba6..d6b10fd67627 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -24,8 +24,6 @@
 #include <keys/request_key_auth-type.h>
 #include "internal.h"
 
-#define KEY_MAX_DESC_SIZE 4096
-
 static const unsigned char keyrings_capabilities[2] = {
 	[0] = (KEYCTL_CAPS0_CAPABILITIES |
 	       (IS_ENABLED(CONFIG_PERSISTENT_KEYRINGS)	? KEYCTL_CAPS0_PERSISTENT_KEYRINGS : 0) |
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 7143f3079d20..2c54f7f84c55 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -957,7 +957,6 @@ key_ref_t keyring_search(key_ref_t keyring,
 	struct keyring_search_context ctx = {
 		.index_key.type		= type,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -965,8 +964,14 @@ key_ref_t keyring_search(key_ref_t keyring,
 		.flags			= KEYRING_SEARCH_DO_STATE_CHECK,
 	};
 	key_ref_t key;
+	size_t desclen;
 	int ret;
 
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
+
 	if (recurse)
 		ctx.flags |= KEYRING_SEARCH_RECURSE;
 	if (type->match_preparse) {
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index fa2bb9f2f538..ef00c2b08fe0 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -584,7 +584,6 @@ struct key *request_key_and_link(struct key_type *type,
 		.index_key.type		= type,
 		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -595,8 +594,14 @@ struct key *request_key_and_link(struct key_type *type,
 	};
 	struct key *key;
 	key_ref_t key_ref;
+	size_t desclen;
 	int ret;
 
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
+
 	kenter("%s,%s,%p,%zu,%p,%p,%lx",
 	       ctx.index_key.type->name, ctx.index_key.description,
 	       callout_info, callout_len, aux, dest_keyring, flags);
@@ -787,7 +792,6 @@ struct key *request_key_rcu(struct key_type *type,
 		.index_key.type		= type,
 		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
-		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
 		.match_data.cmp		= key_default_cmp,
 		.match_data.raw_data	= description,
@@ -797,6 +801,12 @@ struct key *request_key_rcu(struct key_type *type,
 	};
 	struct key *key;
 	key_ref_t key_ref;
+	size_t desclen;
+
+	desclen = strlen(description);
+	if (desclen >= KEY_MAX_DESC_SIZE)
+		return ERR_PTR(-EINVAL);
+	ctx.index_key.desc_len = desclen;
 
 	kenter("%s,%s", type->name, description);
 
-- 
2.47.3

