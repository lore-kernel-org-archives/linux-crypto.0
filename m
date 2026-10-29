Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316343;
	b=mmLeTa5WUGz3y+6+zv6p3OkNbPn/m4esBKvDk8Hd6K03/XDnedfeH+oss53y3ATRwC5x
	 c4oD34e2tlCs41nPWwAexZMvaWhxvXSFOcwHVCbxMvrSb7xB4U6wMLbd/MielRMLVamSh
	 qm/63gU0Qv3rYRboepaSuhCxvPs53aRfkwCjMqsiL975vCUTqOkSNQsoxeTBNT0rGsvuJ
	 FxFhHtxmMqBXG+2exP9/V1knAfr9tUnL9fKmPExfU/n6uCVX1ANs9jwCzv+as/EkDYBf/
	 9h/QzQdUnNchiL4zES9Dgh7D58zFs3Z5TIM7jUExPQ5UmVvKTvQ6bSHPG5FF8GFPzLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uy/FZh24B32RYF0ZgiKoGJHXlBRYP7HqQOuRiOOjXeE=;
	b=LS6MDKGgtsAODh/0Ih6bmsdgV0HF4eRNJzShiFPdmHsuHvVDCrKs6/dThW4wYoJsOCm1
	 zgc6nz/8WHcuXQb9oAsMxNL4oIVTu0Co9zUm5LIEIhQwN5RAq1pxrbvebWCDMmhxaMVHs
	 766bzLtlbrmU9GJYGP9A0fIlMD1gNhskfvOTKZWgZWhY1RmII0QN6XOQm8atU7kpeySD2
	 MEJE0JOI9VWYQRKvwdyPVaUVafdQ/k0JNKa/M+p4Ipg93OU4973X/eTaGdaivp3wk1LTR
	 Mo9rnVifEtUxM5i7tap4Zg60FlzuyBaYOmSdCSm/8P/Sr4nxo0xyfZHgMom9XpxZvJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="n/UfjZG4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D93EA606A31A;
	Thu, 29 Oct 2026 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/UfjZG4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A7A761F00A22;
	Thu, 29 Oct 2026 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793316342;
	bh=uy/FZh24B32RYF0ZgiKoGJHXlBRYP7HqQOuRiOOjXeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/UfjZG4Xre6CtdKbTCQPofGneqZlZHEt/PF/tXrPp/zphplFkx0MAcItFQeicMWW
	 zUpED7Jle7zZ4V/nsPgVEFr8TofdfoK1fk3ZKLuC+7hWk/OCl/e/fIP2hnYoRTviZi
	 hWVdzNIbN4JKVWQZn34gJM7dL9kPxLR2UU20xjUOM2OItlo4pTLUhCnXMGUpL+YiF2
	 uh5N+dtNYyzCmhxVUxFKFtchSQ5ds0unIwm2uGKTr8FGYRDhqV7r0z7xD9m1y3heSO
	 VcM16OMo1CXD4Q8ODXLxqMYnLxy66ib0QiYT4HJ1g71PJ0VL88NezJVsWlS2m2CWDk
	 ZnrNnganPBxfA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-crypto@vger.kernel.org (open list:ASYMMETRIC KEYS),
	linux-kernel@vger.kernel.org (open list),
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	fsverity@lists.linux.dev (open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO...),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v4 1/3] KEYS: Introduce keyring_is_empty()
Date: Fri, 30 Oct 2026 01:24:09 +0200
Message-ID: <20261029232437.2581640-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029232437.2581640-1-jarkko@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
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

Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
fs-verity how keyring internally manages the keys.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/md/dm-verity-verify-sig.c                      |  2 +-
 fs/verity/signature.c                                  |  2 +-
 include/linux/key.h                                    |  1 +
 kernel/bpf/keys.c                                      |  2 +-
 security/keys/keyring.c                                | 10 ++++++++++
 .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
 6 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index aadcf5e4a47c..cad21e9144ed 100644
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
index c4486e938a06..20ca43f5eab1 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
 				struct key *restriction_key);
 
 extern int keyring_clear(struct key *keyring);
+bool keyring_is_empty(const struct key *keyring);
 
 extern key_ref_t keyring_search(key_ref_t keyring,
 				struct key_type *type,
diff --git a/kernel/bpf/keys.c b/kernel/bpf/keys.c
index bffc356839ac..24e0416abc99 100644
--- a/kernel/bpf/keys.c
+++ b/kernel/bpf/keys.c
@@ -29,7 +29,7 @@ struct bpf_key *bpf_lookup_keyring(void)
 
 	if (!bpf_keyring)
 		return NULL;
-	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
+	if (keyring_is_empty(bpf_keyring) ||
 	    !READ_ONCE(bpf_keyring->restrict_link))
 		return NULL;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 5281da9d5bf7..ac48d6204915 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
 	assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
 }
 
+/**
+ * keyring_is_empty - Check whether a keyring is empty
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

