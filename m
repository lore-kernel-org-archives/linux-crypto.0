Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9CB67E
	for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2024 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730022347; cv=none; b=Kromnrpr36aOO/IFfvlvYZ7rU8xMFgwY74PtpsT6X7Ua6bJTftmX03PJsliljzCNoTFrHx2VcdOvOALRXH5bS2GwGHkEmEry5FXec9Qz4WayWuByFIzzx6DTDrQVmqoybAv50zOCMW/bJGuBCoX1XwnQQe23CPMzieTOXN3j7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730022347; c=relaxed/simple;
	bh=t7lDNliTpNt8+tVIak/WAQRRXRLpgvq5Ul7Q8xb3jRY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=YyYbRcoeRGrgwfJIXm3WNQB1DYChvnVewsNYRQtsuGkRvZ/X+rLq4Y4QcuxmPMvI2JP04bGHaglc/DWJpTWOMQFJSdD357ac2c0K6UOV/EBYD0gcCO4wn4casEZd9jOTSC0JypNPzXOHgi0icCHdUkE+2y1NBf3+P4q3fKwA4gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qgYxLnd+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qgYxLnd+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UQYUuWSNMpohmWfeqoh2kdhr+Z3O839+gSASIhldFMc=; b=qgYxLnd+9ZM3CSCdVtFskbmcjj
	eFI7nlP3+8opNA6PhDRfKmRF2Il5G1FG31++47CQOnFd5NKwpknT2zZW5lkxc8IuXntDDqrIyOxmS
	zFeuUyeKfe76nEQFRIBxioYeFwJYtRlSjyVPPIRiO8Wer81YkmkhCi1yoHLKyjbZxJdMmcYV/D2BL
	Xp0ICPuAw087Ayy2fyAGc1I/tCjO+6hfbIyzOtNu8oBoD7PMyntz/oBTlSelmiHX2CPXyw3OimF1P
	cpGtUAxyZpPks50Y2KWmAtg0O5tmmt8/TZMSRCGQecVmO4pJ0XelsTYX9H9g1Zzmz8EBAJ1ud6Gsn
	67PLIUSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4zq8-00CRGd-0Y;
	Sun, 27 Oct 2024 17:45:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Oct 2024 17:45:40 +0800
Date: Sun, 27 Oct 2024 17:45:40 +0800
Message-Id: <7e696eecae80b88dd374b75d5f59a8b24debc575.1730021644.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1730021644.git.herbert@gondor.apana.org.au>
References: <cover.1730021644.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] crypto: ahash - Set default reqsize from ahash_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a reqsize field to struct ahash_alg and use it to set the
default reqsize so that algorithms with a static reqsize are
not forced to create an init_tfm function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 4 ++++
 include/crypto/hash.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b1c468797990..52dd45d6aeab 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -875,6 +875,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
@@ -1040,6 +1041,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0cdadd48d068..db232070a317 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -135,6 +135,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -151,6 +152,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5

