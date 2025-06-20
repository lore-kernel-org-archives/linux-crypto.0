Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37F01C84DC;
	Fri, 20 Jun 2025 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750392549; cv=none; b=mNaNul+R9H5mbl2uSmaybSjk7/1LY1cRqTthLVVBvjGY2uU6IhHyJJoy4QVAjoHeqB0Wb7DLbZJ9E5EQLDzbg9UJTKn0qiWKY5CXc1A/zHWWHrSciVcGzcN3A3cBG7mS3AZUFIpgp+sIFqiuHeuKRUfhY5aZUDTfin0ggJ/9jgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750392549; c=relaxed/simple;
	bh=IF+c+8Vgyqqs9u7zdJIo9De/8DeCfWzEHq84Tml5TVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+Y0xOPAzFKgbDIT1TjduCgcI2a1n9T5BjVu3hVhZNpOcVyX/JO3YdwzBLcGnB7intb9SfpCYylzHI0i9ZrjPjv4jfYZXb/LRJBw/ykCNhWjKRDUX+v6YIqb8/yAlL8VJAJ/i2i+aoyM9W6kWZu5oZ4wRPfRkCjHVzNPi+lR+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rk4V47vi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rk4V47vi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1xGA506aP6+xhVBW2zr6ks0RSktth8+x0ATXW3hSPDU=; b=Rk4V47viyQe+eMkGB04fqX09zM
	nmbedD8z3YJWaqpaksk9PrOUK84JaNsXNuMaptoAcp9Nar1TYJGDSpvB0fR3iTg4+Q0kAQqzVxk1N
	N1OclYG51tju/uqmK+WJQ/hVOwDT1gP+d9IcD3Z1uvQRxP0DQLiME81fErZtk0O198809BTW2nYmv
	bmLfhJCi8AvwKYvf6XrGzr0hUS3z64rzL+93p+Od65LwkwFZMCQH3DxvcEClGhEgd0YlRBVftwNel
	WFpYWQxxoz7qdBmwIaguBRBocuBFzhbApBW3O8XD7NtTPnyg5WB81Jd1eEtqFLYDr1oklciySCQlS
	fDx42ruA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSSoU-000TUt-1S;
	Fri, 20 Jun 2025 12:09:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jun 2025 12:09:02 +0800
Date: Fri, 20 Jun 2025 12:09:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <gmazyland@gmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
Message-ID: <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>

On Thu, Jun 19, 2025 at 11:17:37PM +0200, Milan Broz wrote:
>
> : Call Trace:
> :  crypto_shash_export+0x65/0xc0
> :  crypt_iv_lmk_one+0x106/0x1a0 [dm_crypt]

Thanks for the report.  The problem is that crypt_iv_lmk_one is
calling crypto_shash_export using a buffer that is less than the
size as returned by crypto_shash_statesize.

The easiest fix is to expand the buffer to HASH_MAX_STATESIZE:

---8<---
The output buffer size of of crypto_shash_export is returned by
crypto_shash_statesize.  Alternatively HASH_MAX_STATESIZE may be
used for stack buffers.

Fixes: 8cf4c341f193 ("crypto: md5-generic - Use API partial block handling")
Reported-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9dfdb63220d7..cb4617df7356 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -517,7 +517,10 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
-	struct md5_state md5state;
+	union {
+		struct md5_state md5state;
+		u8 state[HASH_MAX_STATESIZE];
+	} u;
 	__le32 buf[4];
 	int i, r;
 
@@ -548,13 +551,13 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 		return r;
 
 	/* No MD5 padding here */
-	r = crypto_shash_export(desc, &md5state);
+	r = crypto_shash_export(desc, &u.md5state);
 	if (r)
 		return r;
 
 	for (i = 0; i < MD5_HASH_WORDS; i++)
-		__cpu_to_le32s(&md5state.hash[i]);
-	memcpy(iv, &md5state.hash, cc->iv_size);
+		__cpu_to_le32s(&u.md5state.hash[i]);
+	memcpy(iv, &u.md5state.hash, cc->iv_size);
 
 	return 0;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
