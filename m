Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C93A156256
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 09:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728899494; cv=none; b=OoujxZ7SHyUh88I6by23GS+61DkMgqqi0WQsD+NmJy2Yx5NODc2e+sbVmyS+fNI9A6oGw2pWhLIMHbqQXnIsGk2ctRLCn+BRwy1MDrTlyXH2O83pd1kOQsy1BnztF1iN45e6gJZ0H9BIU0AD54EOG6KZXOQawxMAKOQzqQFnDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728899494; c=relaxed/simple;
	bh=Mi1kRey+SakT7K4CNgM7OVwB5YrrjM85Non+7rT0NKQ=;
	h=Message-ID:From:Date:Subject:To:Cc; b=XMHLo0cYq1VF+EMeIMztdlMd0vQvQStbNqzdhQ5ab298zbBUnRYoLX6dpcmmKPn3oxNBiRf8cJvQy28/35GfTUh3DE85aE+cERhkGVEFqIKL9R3o8+Ao0D24eUv6n12Kya3voHTXfpVqcYVK34HPo5/CXvqcN5wXlqvl7DuAUHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 68162103B3F3A;
	Mon, 14 Oct 2024 11:43:09 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id 4941860E4720;
	Mon, 14 Oct 2024 11:43:09 +0200 (CEST)
X-Mailbox-Line: From ff7a28cddfc28e7a3fb8292c680510f35ec54391 Mon Sep 17 00:00:00 2001
Message-ID: <ff7a28cddfc28e7a3fb8292c680510f35ec54391.1728898147.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 14 Oct 2024 11:43:01 +0200
Subject: [PATCH cryptodev-2.6] crypto: sig - Fix oops on KEYCTL_PKEY_QUERY for
 RSA keys
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Commit a2471684dae2 ("crypto: ecdsa - Move X9.62 signature size
calculation into template") introduced ->max_size() and ->digest_size()
callbacks to struct sig_alg.  They return an algorithm's maximum
signature size and digest size, respectively.

For algorithms which lack these callbacks, crypto_register_sig() was
amended to use the ->key_size() callback instead.

However the commit neglected to also amend sig_register_instance().
As a result, the ->max_size() and ->digest_size() callbacks remain NULL
pointers if instances do not define them.  A KEYCTL_PKEY_QUERY system
call results in an oops for such instances:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Call Trace:
  software_key_query+0x169/0x370
  query_asymmetric_key+0x67/0x90
  keyctl_pkey_query+0x86/0x120
  __do_sys_keyctl+0x428/0x480
  do_syscall_64+0x4b/0x110

The only instances affected by this are "pkcs1(rsa, ...)".

Fix by moving the callback checks from crypto_register_sig() to
sig_prepare_alg(), which is also invoked by sig_register_instance().
Change the return type of sig_prepare_alg() from void to int to be able
to return errors.  This matches other algorithm types, see e.g.
aead_prepare_alg() or ahash_prepare_alg().

Fixes: a2471684dae2 ("crypto: ecdsa - Move X9.62 signature size calculation into template")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 crypto/sig.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/crypto/sig.c b/crypto/sig.c
index be5ac0e59384..5e1f1f739da2 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -84,15 +84,6 @@ struct crypto_sig *crypto_alloc_sig(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_sig);
 
-static void sig_prepare_alg(struct sig_alg *alg)
-{
-	struct crypto_alg *base = &alg->base;
-
-	base->cra_type = &crypto_sig_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
-	base->cra_flags |= CRYPTO_ALG_TYPE_SIG;
-}
-
 static int sig_default_sign(struct crypto_sig *tfm,
 			    const void *src, unsigned int slen,
 			    void *dst, unsigned int dlen)
@@ -113,7 +104,7 @@ static int sig_default_set_key(struct crypto_sig *tfm,
 	return -ENOSYS;
 }
 
-int crypto_register_sig(struct sig_alg *alg)
+static int sig_prepare_alg(struct sig_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
@@ -132,7 +123,22 @@ int crypto_register_sig(struct sig_alg *alg)
 	if (!alg->digest_size)
 		alg->digest_size = alg->key_size;
 
-	sig_prepare_alg(alg);
+	base->cra_type = &crypto_sig_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SIG;
+
+	return 0;
+}
+
+int crypto_register_sig(struct sig_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int err;
+
+	err = sig_prepare_alg(alg);
+	if (err)
+		return err;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_sig);
@@ -146,9 +152,15 @@ EXPORT_SYMBOL_GPL(crypto_unregister_sig);
 int sig_register_instance(struct crypto_template *tmpl,
 			  struct sig_instance *inst)
 {
+	int err;
+
 	if (WARN_ON(!inst->free))
 		return -EINVAL;
-	sig_prepare_alg(&inst->alg);
+
+	err = sig_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
 	return crypto_register_instance(tmpl, sig_crypto_instance(inst));
 }
 EXPORT_SYMBOL_GPL(sig_register_instance);
-- 
2.43.0

