Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A7823E32B;
	Mon, 23 Jun 2025 11:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750677455; cv=none; b=h96OqlW/L10ZP+efTorkFIIihjKaq7zvXPAdzMG9PoDaYvOWonWfd48sA3NxPgM4Y4c8OXOiAlC2xCJaJLy3cBNj96kYJT8J6szK5AxNImPfSmcNxbrvFcV2lxfA7y1uddVsBRTN0KA5HeV39OvkHjBgdB2STDFV9ccivz0Jhj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750677455; c=relaxed/simple;
	bh=ufc3sxYuQVw75EfKq9TWDqId2MpamTjbLTFe1uynnKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt9qM3a9VHScAfq1T+lOx2DAOl4I0KlnyzJ9DPl2Cq4m/AeeoOHvnxvAZO1QiJMrsbTxNhYFmJYGYYTR0Kzy7hV/QPxvaPnbIn/zkDv+bq0QSH45luDlc6f6F0mSquSvZaD4vw1/Rr620Pj25Xxj5DL3kHv+VO2OH+6WuEOe3rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QVG7oDQV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QVG7oDQV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YL0iS2C1lAYFI6vC1Bkn7fzloy0KkjArmZh1Ah0LQ8w=; b=QVG7oDQVksA/CfJt7X6T10H1vy
	XacIGMrJx4LfN8oUm00IhOJ6app3KS0MD3lTWZsT6VayUwVGzLFW8pxTovT3iSpOfQ14ZbPrsDp5R
	2IieICpVet7wre/gR8GeqMrMKvsFVgsqFTTVRoX/37hjDJAT3hwRgMWpIfp/pEpDRKp4fTJ/VRTMV
	YYyuu87pVcHMuQvscRBPnwVy+UlEWUDH8naiS+acr3U4jO+hHKhi4MuJOzcOoj+znG+wtQY9Fvf6C
	RuOQrvm+QVJuRfUfqCQz2Qxh4Qd2HN+aASi7n0HZLj5OnCNt2oS/7ja+SZmihzbt/MzvPRjsIVlcL
	LQPeIj1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTevb-000HdS-02;
	Mon, 23 Jun 2025 19:17:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 19:17:27 +0800
Date: Mon, 23 Jun 2025 19:17:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	Neal Liu <neal_liu@aspeedtech.com>
Subject: [PATCH] crypto: aspeed - Fix hash fallback path typo
Message-ID: <aFk3xzko6sFEOWQO@gondor.apana.org.au>
References: <202506231830.us4hiwlZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202506231830.us4hiwlZ-lkp@intel.com>

On Mon, Jun 23, 2025 at 06:55:06PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   82a0302e7167d0b7c6cde56613db3748f8dd806d
> commit: 508712228696eaddc4efc706e6a8dd679654f339 [11/61] crypto: aspeed/hash - Add fallback
> config: arm-randconfig-r073-20250623 (https://download.01.org/0day-ci/archive/20250623/202506231830.us4hiwlZ-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of

Thanks for the report!

---8<---
Fix typo in the fallback code path.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506231830.us4hiwlZ-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index e54b7dd03be3..f8f37c9d5f3c 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -449,7 +449,7 @@ static noinline int aspeed_ahash_fallback(struct ahash_request *req)
 	if (rctx->flags & SHA_FLAGS_FINUP)
 		ret = ret ?: crypto_ahash_finup(fbreq);
 	else
-		ret = ret ?: crypto_ahash_update(fbreq);
+		ret = ret ?: crypto_ahash_update(fbreq) ?:
 			     crypto_ahash_export_core(fbreq, state) ?:
 			     aspeed_sham_import(req, state);
 	HASH_REQUEST_ZERO(fbreq);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
