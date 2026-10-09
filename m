Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535B74DD3BA
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 12:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791549393; cv=none; b=Fp3fc1edfht60zJdtol+K+Xmk9AiBgozupXZD27/2RfKiRjbIVVv2wW8vVTRpQ9TWkRp38pJVOCrcP3opmg1dlSFOyUWeQuwTF0Y/JQ6lzQ1NUU6U82wdDJfs8YUkBnPEwCZHPiM1JiHoQpbUEZkDbvW1Px+i/z6M6IRQTW2FBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791549393; c=relaxed/simple;
	bh=J9Vp/L9a9L9wvDsoyFD6hHJaqf3TKVp3NA4B8AAcq18=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbnunPlG6m44m6hGmq1jLu6YWIfN/Kxckcr55i+8c3CDlmDvSXau1urZPmmxGaMzK6wwcNYJupe+nYjdGT4iH8qxG/im6IziHmyUjANfkgilLZLermMLhAL2b16oLD6m/SdupYpwztBv1hV3KDQHEh9Rbl7v8Pmxo+YEMJ0hSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Bor+F5Q+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Bor+F5Q+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:cc:to:subject:message-id:date:from
	:content-type:reply-to; bh=H9TYFwMfYzt6ahylBkl2WulXx+ayEFsbARQlR7vHY7A=; b=Bo
	r+F5Q+qQK97Qlev+rEa1PphCwoJKwhThEzbpbhny731uuUC+R3LwlsyQ0EfqUNwpkVmr/F9V9XOu9
	G5wYUI2XC4A2HG85P3myCTRADtokxVE16qByMbQbrcuPtCP3d/tZTd78AwPyU800P+dzD15Xydzfw
	0qivgXI9QYHiVT6T0ZhyrsCRQ8ACYz3K80QFOg3An3aSAu39e355umValRTzvDCAxF+5hXmlVb/2v
	zi9lbhrevqlkvPtUdvsJER97psYm59SCITacvRxV4+jUg154IhivU/DTqXqx3lFpu7fjJ6tbJ8dYy
	4SjQ4wx6DQStrrp5TbuuT7MgFb/D3MFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xF9pm-00000002Dcd-3TyR;
	Fri, 09 Oct 2026 20:36:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Oct 2026 23:36:22 +1100
Date: Fri, 9 Oct 2026 23:36:22 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: hash - Preserve withheld block in export_core
Message-ID: <asjfxnGfCtvD7QJL@gondor.apana.org.au>
References: <asjVaVGfI3JhoQja@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjVaVGfI3JhoQja@gondor.apana.org.au>

v2 changes crypto_ahash_export_core to import the updated hash state
after export_core, rather than the original (which causes the partial
block to be lost).

---8<---
Some algorithms (cmac and xcbc) withhold one block for finalisation.
This breaks crypto_ahash_export_core (only called when there is no
partial block data) because the exported hash state is missing the
withheld block.

Fix this by performing a hash update of the partial block if it is
present before doing the export.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index d86c78f8d550..28c58933845f 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -634,6 +634,43 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_export_core(ahash_request_ctx(req), out);
+
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		unsigned int bs = crypto_ahash_blocksize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+		unsigned int partial;
+		int err;
+
+		buf += reqsize - 1;
+		partial = *buf;
+		*buf = 0;
+
+		if (!partial)
+			;
+		else if (partial != bs)
+			return -EINVAL;
+		else {
+			struct crypto_ahash *fb = crypto_ahash_fb(tfm);
+			u8 state[HASH_MAX_STATESIZE];
+
+			err = crypto_ahash_export(req, state);
+
+			ahash_request_set_tfm(req, fb);
+			err = err ?: crypto_ahash_import(req, state);
+
+			sg_init_one(req->sg_head, buf - bs, bs);
+			req->src = req->sg_head;
+			req->nbytes = bs;
+
+			err = err ?: crypto_ahash_update(req) ?:
+			      crypto_ahash_export_core(req, out);
+
+			ahash_request_set_tfm(req, tfm);
+			return err ?: crypto_ahash_import_core(req, out);
+		}
+	}
+
 	return crypto_ahash_alg(tfm)->export_core(req, out);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_export_core);
diff --git a/crypto/shash.c b/crypto/shash.c
index d4a6c3b6fa37..d9e9377cbd6a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -225,6 +225,31 @@ static int __crypto_shash_export(struct shash_desc *desc, void *out,
 
 int crypto_shash_export_core(struct shash_desc *desc, void *out)
 {
+	struct crypto_shash *tfm = desc->tfm;
+
+	if (crypto_shash_block_only(tfm)) {
+		unsigned int descsize = crypto_shash_descsize(tfm);
+		unsigned int bs = crypto_shash_blocksize(tfm);
+		u8 *buf = shash_desc_ctx(desc);
+		unsigned int partial;
+		int err;
+
+		partial = buf[descsize - 1];
+		buf[descsize - 1] = 0;
+
+		if (!partial)
+			;
+		else if (partial != bs)
+			return -EINVAL;
+		else {
+			err = crypto_shash_alg(tfm)->update(
+				desc, buf + descsize - bs - 1, bs);
+
+			if (err)
+				return err;
+		}
+	}
+
 	return __crypto_shash_export(desc, out,
 				     crypto_shash_alg(desc->tfm)->export_core);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
