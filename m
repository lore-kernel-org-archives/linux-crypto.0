Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C424C8828;
	Thu,  3 Apr 2025 02:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647620; cv=none; b=dS0e2gCmXIa1D9ZKNZGU508Jb/8l8lXtvcMXo4L3NSNCl+IBca2i/ypuhje3AAukbX1In0CLPCcLCXvyvP2Ky74akdRfgAQOL9RZ8WM0NmFA/UH4eLYgX+pYVbYhLADNrGMGoOT9wITNz2exXbI6R6CrXnj68TWdfbBwjnsL7jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647620; c=relaxed/simple;
	bh=mZEH9KP0rG4OJgz7xRS+8Enm0WcKmn8TTdTEu7MCrrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GcKxKn385dir9OyuFpntU8YeKvPLK7ae02+pXedMtmR9iOftHDbmmfMGFY+ypCBt0UhJKS3qQ5sbSu3oygA2pGVjqU+fxSQS8cBFU53E4uo+yoEnnu8PPI8AbQHAVLnFi4BLAboVJkOtF/ZPsqTENBtYiArmzuVa5jr2aaewF+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AKZC5Y+S; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AKZC5Y+S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qfn0RHsgPDoPqoC1r7+j/kf0VdcV4uMNStpbKM8IwAg=; b=AKZC5Y+SClnmFFLkweM4OMgI7K
	HFk3lR2DT3eHmAGjXiQkqsPTRFl8IIa2K+zdHV/u2CFhWM9C3qAC6h1DF5VZZ09OjqLmQm6HUMRlp
	s73wgoTECsRocTd1n3lqIk1F1efFLj8XSUCbdHCN4fltV+56zmdoOiZtWGmnAg4uSHL9AaTvzKlhl
	2/gal++M30IbdBzOoTOzvXRrSHZ4XyrWi/z5htDI8Px7MB21nGV48951WdBnYl/9TlKHW0NOGnU6i
	fFk9bkeywPvhlJGjyW2P6cDlsyXP16+niO4gSW9kWzIn/Agjl4x0QcLbrZ11Pg586w2avpg3R0rk3
	i+mUHy0Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0AOa-00CL1E-0C;
	Thu, 03 Apr 2025 10:33:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 10:33:32 +0800
Date: Thu, 3 Apr 2025 10:33:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto: hash - Do not use shash in hard IRQs
Message-ID: <Z-3zfJ5hRl3_tZxJ@gondor.apana.org.au>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403021453.GA2872965@google.com>

On Thu, Apr 03, 2025 at 02:14:53AM +0000, Eric Biggers wrote:
>
> The thing I actually have more of a problem with is that you tend to start
> making random API changes without any of the necessary prerequisites like
> updating documentation, or adding debug assertions to catch violations of new
> requirements.  You've already started removing the fallbacks from shash (commit
> 3846c01d42526bc31), but neither of those things have been done.  So we're
> currently in a weird state where the shash API is explicitly documented to work
> in all contexts, but you've broken that.

The documentation is easy enough to fix.

---8<---
Update the documentation to be consistent with the fact that shash
may not be used in hard IRQs.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 58f9d3c9d006..5fde27039a06 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -847,7 +847,7 @@ static inline void *shash_desc_ctx(struct shash_desc *desc)
  * cipher handle must point to a keyed message digest cipher in order for this
  * function to succeed.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -864,7 +864,7 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
  * crypto_shash_update and crypto_shash_final. The parameters have the same
  * meaning as discussed for those separate three functions.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
@@ -884,7 +884,7 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
  * directly, and it allocates a hash descriptor on the stack internally.
  * Note that this stack allocation may be fairly large.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 on success; < 0 if an error occurred.
  */
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
@@ -902,7 +902,7 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
  * caller-allocated output buffer out which must have sufficient size (e.g. by
  * calling crypto_shash_descsize).
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
 int crypto_shash_export(struct shash_desc *desc, void *out);
@@ -916,7 +916,7 @@ int crypto_shash_export(struct shash_desc *desc, void *out);
  * the input buffer. That buffer should have been generated with the
  * crypto_ahash_export function.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
 int crypto_shash_import(struct shash_desc *desc, const void *in);
@@ -929,7 +929,7 @@ int crypto_shash_import(struct shash_desc *desc, const void *in);
  * operational state handle. Any potentially existing state created by
  * previous operations is discarded.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the message digest initialization was successful; < 0 if an
  *	   error occurred
  */
@@ -951,7 +951,7 @@ static inline int crypto_shash_init(struct shash_desc *desc)
  *
  * Updates the message digest state of the operational state handle.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the message digest update was successful; < 0 if an error
  *	   occurred
  */
@@ -968,7 +968,7 @@ int crypto_shash_update(struct shash_desc *desc, const u8 *data,
  * into the output buffer. The caller must ensure that the output buffer is
  * large enough by using crypto_shash_digestsize.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
@@ -985,7 +985,7 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out);
  * crypto_shash_update and crypto_shash_final. The parameters have the same
  * meaning as discussed for those separate functions.
  *
- * Context: Any context.
+ * Context: Softirq or process context.
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
