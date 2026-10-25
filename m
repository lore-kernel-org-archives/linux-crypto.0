Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887144;
	b=Y1jFZHEZ8IWIamkfrh3Tt0lyiePUcw/gbQk4KAxBS4r6KcNGrOMxg5BNvkoBuAzobdaL
	 pDwhcLsHUXjQnoIqL/EfLIsn3MNnMbR2Pe6bLhndjB37OwnhX1jWLUZ73pJmAY16ci1N6
	 cQr4bOpPGPD289Gbcqc9JFHI5Kjk2cE6XTuh2c5IdXanpvlURsZoda0C16DEoEQFRP+MX
	 GE5Zs1ypn0uctVTizlgEJyAouu7FL9AoZlb9vB08bQsMSAPl1vG0SiRDXr36JXR3NbOZr
	 28B1B0c43G42PlcnG0g5AATdU9XtUcPZR/iCmP9Gw4/vw8sGk3nslcgskvXnLrltkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d0/08Y7FCHEGVevGTNjTfPTBox7sBeP1ImWEFHXBc7U=;
	b=N+dx5JCyQpKpdb+ASC0u0DSSae51+AvxjSWgg0DwKeCerOTY2JGJrPkc3rxf+32DhmCr
	 LfZL2w4G+rghi/DLKzAmDJ6SJhJWWVkEzEBfhB4J5zGpVG/excojA7KPRAGO6sGSPZPZR
	 sQY3CJecCRpKSTF/AI3mQ0OKEZWUWBa07lLqdp1t9Xes81fVdNu5IAXvgRAyds+/ofnY7
	 GnUXlgalt+CFhETdHbB98owjUdrMeewyB7lCSEP5yGTxsYcOiQY+xBFSEjbTWX+VbJUSS
	 8JUGuP3cxQhuBS+yXp/81eADl7RnvEZWuTZEOYyazwBJej2AzFWQYnlCpIPSAFAprHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WN4Hv2Iq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 0ABC4606A31A;
	Sun, 25 Oct 2026 00:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WN4Hv2Iq
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 33C6F1F01825;
	Sun, 25 Oct 2026 00:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887143;
	bh=d0/08Y7FCHEGVevGTNjTfPTBox7sBeP1ImWEFHXBc7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WN4Hv2IqQWLVRP/M4vAiyAP5X3mm8J5IoQ2L1ebzSJC7Dl93iyjjKp8RDsjnL4SfI
	 uTa3vB52skHgrJf+3C21jON6CVuJSSF65O9+D8Awt3RhVlfB44q1YPdXk5+l9YxSZ8
	 xcAKoY46pCgH6u5EM1/bRZOxT6swuFe++psPWLIgBafboJtLWQVNB8yn8ycHljFVwR
	 VA9jow8jDmAHT69hWz2+4G80yO1m/Vm/XCutHlD5JNVPmw7y/qKSrB1S+WRVtrxwuq
	 ZfEsu4cyM4LbH0mwOWXKDdSoMEOPC68q+Gesd8EcIF8oQqwGCQyODUAeOQJ0IIzgsJ
	 t70zM+F6cZ4VA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list),
	fsverity@lists.linux.dev (open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO...),
	linux-crypto@vger.kernel.org (open list:RHASHTABLE),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v3 4/6] KEYS: Introduce keyring_is_empty()
Date: Sun, 25 Oct 2026 03:10:12 +0300
Message-ID: <20261025001105.1824178-5-jarkko@kernel.org>
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

Introduce keyring_is_empty() in order to decouple for dm-verity and
fs-verity how keyring internally manages the keys.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/md/dm-verity-verify-sig.c                      |  2 +-
 fs/verity/signature.c                                  |  2 +-
 include/linux/key.h                                    |  1 +
 security/keys/keyring.c                                | 10 ++++++++++
 .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index b2b55c41e2cb..2ccb71bfb3ca 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -153,7 +153,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 	if (ret != -ENOKEY && ret != -EKEYREJECTED)
 		return ret;
 
-	if (dm_verity_keyring->keys.nr_leaves_on_tree &&
+	if (!keyring_is_empty(dm_verity_keyring) &&
 	    dm_verity_keyring->restrict_link)
 		ret = verify_pkcs7_signature(root_hash, root_hash_len,
 					     sig_data, sig_len,
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 0302a4e506ec..890d33b9d812 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -67,7 +67,7 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return 0;
 	}
 
-	if (fsverity_keyring->keys.nr_leaves_on_tree == 0) {
+	if (keyring_is_empty(fsverity_keyring)) {
 		/*
 		 * The ".fs-verity" keyring is empty, due to builtin signatures
 		 * being supported by the kernel but not actually being used.
diff --git a/include/linux/key.h b/include/linux/key.h
index 3b8af14fb323..df2034fc5436 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
 				struct key *restriction_key);
 
 extern int keyring_clear(struct key *keyring);
+bool keyring_is_empty(const struct key *keyring);
 
 extern key_ref_t keyring_search(key_ref_t keyring,
 				struct key_type *type,
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 5281da9d5bf7..4642754db6bf 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
 	assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
 }
 
+/**
+ * keyring_is_empty - Check whether a keyring contains any links
+ * @keyring: The keyring to check.
+ */
+bool keyring_is_empty(const struct key *keyring)
+{
+	return READ_ONCE(keyring->keys.nr_leaves_on_tree) == 0;
+}
+EXPORT_SYMBOL(keyring_is_empty);
+
 /*
  * Describe a keyring for /proc.
  */
diff --git a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
index 1f9601ef22f8..792449d356cf 100755
--- a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
+++ b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
@@ -746,7 +746,7 @@ test_keyring_inactive_when_empty() {
     log_info "TEST: Verify dm-verity keyring is inactive when sealed empty"
 
     # When keyring_unsealed=0, the keyring is sealed immediately while empty
-    # This means it should NOT be used for verification (nr_leaves_on_tree=0)
+    # An empty keyring should NOT be used for verification.
 
     log_info "Keyring state (should be empty and sealed):"
     list_keyring_keys
-- 
2.47.3

