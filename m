Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6297B288CBA;
	Thu, 15 May 2025 08:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297697; cv=none; b=dJjUtaB3s48KBWCIfb5HomTktffrNuEaN5J6PRpjAcGAptqYVkDW7hnDBKpPuKcxaSuG7LOvYffmfg2X+flm4yGHFoY14oY7vP8p/QGuSXjqh7sKojVdUT5vY0qbbxTdSsPohhf6C7AowthuejVSqiWOyUJmxbJD2Fmll+iFW4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297697; c=relaxed/simple;
	bh=REvG9PoZF4qC28UW2dN+6co/N63wJmy1asBZZNNyuKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql/gQb29ieIT1kYjxld7YUi8Cspz09Gx+RE+mZZYiXMIRqav0/VnMjn0VFrx+BTA4npWLRbH9IH1fBeNMMa6lCeEYQcVKYk+GulJZ2UY6k20cqfeLlud3RZWrh3eFdvcPQCS7Y7KJjvGGURwOEZD+0Akmt3GKQpnc0j92F6AHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NhexO132; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NhexO132"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=91icK5PNxzwuKDZJzD0+QSNbCUtqUUhr45JYxD5rPB0=; b=NhexO132ZeMi1LeM6nhu0gsXXB
	KMsKzqvHNXDaCL9EcHRoxnqAuiV9qrWKHI0KEvRAtVGRk1KKhSP7sXB3NcBs9shi/KahQyfsAIy3A
	iMUUWP/1WippxJm0VM6QV2Cz/zqKsHqRWzCCKaNEXYM9iluXPnGRUnVpyc4F7mCHZJmV6P5xfC0XM
	6megyS9tPE8ho4mY9JAjluZLmP41H7Oj3jqp9udCnOexO07xaze9Y84cJY1tCty6MniS24YcOV1TL
	43bYmYo8DVRfTxFenNLsRMyYruA52aKECpFZ/CfY7FPg31ieaKgNM4hxOjqBEn7ALh4poed/731ou
	7kL0rpjw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFTwm-006GK9-2h;
	Thu, 15 May 2025 16:28:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 16:28:08 +0800
Date: Thu, 15 May 2025 16:28:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: Eric Biggers <ebiggers@google.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: lrw - Only add ecb if it is not already there
Message-ID: <aCWlmOE6VQJoYeaJ@gondor.apana.org.au>
References: <202505151503.d8a6cf10-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505151503.d8a6cf10-lkp@intel.com>

On Thu, May 15, 2025 at 03:41:05PM +0800, kernel test robot wrote:
>
> [   16.077514][  T327] ------------[ cut here ]------------
> [   16.079451][  T327] alg: self-tests for lrw(twofish) using lrw(ecb(twofish-asm)) failed (rc=-22)

The crucial line actually got cut off:

alg: skcipher: error allocating lrw(ecb(twofish-generic)) (generic impl of lrw(twofish)): -22

The bug is in lrw, which unconditionally adds ecb() around its
parameter, so we end up with ecb(ecb(twofish-generic)), which is
then correctly rejected by the ecb template when it tries to
create the inner ecb(twofish-generic) as a simple cipher.

---8<---
Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505151503.d8a6cf10-lkp@intel.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/lrw.c b/crypto/lrw.c
index e7f0368f8c97..dd403b800513 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -322,7 +322,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -356,7 +356,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
