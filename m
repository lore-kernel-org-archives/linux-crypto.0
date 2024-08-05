Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7669078C8D
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722850714; cv=none; b=h0b7BpfevdtfcmCYUUDiGX8iHm5BrbcXJqkHu9fMnb+/vQ5q2/HUZg3/Zii5YDoxKQlUESHp0SLY6f97d8T6NivBfI1yzPZZPr63+p5uuuiRs0PbUIhIEhlRQOgj0Jb1eNHMKkmYTqZmyUCVjHVdPL27CKiH/hfPL65kyT1Fy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722850714; c=relaxed/simple;
	bh=Hng31Qoc4sf58Djp8lo/kLw1tdT5Sa8WS7Y88AlTrZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hw14xz1iC+bypQOds2NZu25LqXITEFushhz9RsyLKEp1UrBXo7JbAyjGO/ROVvUsyFxEqBAtUfMWJg7gJHyz3Nfu2SDsTeRKSCzr1cU6GPwhod+A/9K9OsaXFZoxQXEhAcTEnntHv45RHjsKmuo3Kj9jsMaK57AahQMEKQftsIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1satTS-002V0w-1M;
	Mon, 05 Aug 2024 17:02:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 Aug 2024 17:02:35 +0800
Date: Mon, 5 Aug 2024 17:02:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <ZrCVK91OPHKVNd8a@gondor.apana.org.au>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
 <20240802164904.GB1809@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802164904.GB1809@sol.localdomain>

On Fri, Aug 02, 2024 at 09:49:04AM -0700, Eric Biggers wrote:
>
> This would work too, I think:

Yes, and we can go a bit further like this:

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index cd37de5ec404..149bc6beae51 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1381,8 +1381,9 @@ gcm_crypt(struct aead_request *req, int flags)
 	gcm_process_assoc(key, ghash_acc, req->src, assoclen, flags);
 
 	/* En/decrypt the data and pass the ciphertext through GHASH. */
-	while ((nbytes = walk.nbytes) != 0) {
-		if (unlikely(nbytes < walk.total)) {
+	nbytes = walk.nbytes;
+	if (nbytes) {
+		while (unlikely(nbytes < walk.total)) {
 			/*
 			 * Non-last segment.  In this case, the assembly
 			 * function requires that the length be a multiple of 16
@@ -1397,21 +1398,24 @@ gcm_crypt(struct aead_request *req, int flags)
 			le_ctr[0] += nbytes / AES_BLOCK_SIZE;
 			kernel_fpu_end();
 			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+			if (err)
+				return err;
+			nbytes = walk.nbytes;
 			kernel_fpu_begin();
-		} else {
-			/* Last segment: process all remaining data. */
-			aes_gcm_update(key, le_ctr, ghash_acc,
-				       walk.src.virt.addr, walk.dst.virt.addr,
-				       nbytes, flags);
-			err = skcipher_walk_done(&walk, 0);
-			/*
-			 * The low word of the counter isn't used by the
-			 * finalize, so there's no need to increment it here.
-			 */
 		}
+
+		/* Last segment: process all remaining data. */
+		aes_gcm_update(key, le_ctr, ghash_acc,
+			       walk.src.virt.addr, walk.dst.virt.addr,
+			       nbytes, flags);
+		/*
+		 * The low word of the counter isn't used by the
+		 * finalize, so there's no need to increment it here.
+		 */
+	} else if (err) {
+		kernel_fpu_end();
+		return err;
 	}
-	if (err)
-		goto out;
 
 	/* Finalize */
 	taglen = crypto_aead_authsize(tfm);
@@ -1439,9 +1443,8 @@ gcm_crypt(struct aead_request *req, int flags)
 				       datalen, tag, taglen, flags))
 			err = -EBADMSG;
 	}
-out:
 	kernel_fpu_end();
-	return err;
+	return skcipher_walk_done(&walk, 0);
 }
 
 #define DEFINE_GCM_ALGS(suffix, flags, generic_driver_name, rfc_driver_name,   \
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
