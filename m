Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2B112E5B;
	Wed, 21 May 2025 05:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747804011; cv=none; b=uw4BnfBfnd6PjeyWGgJcRnkInhrMcvRKYdRlIhxdxa74oJBLNmv6IT7PXmmtqPvS37QquFu45hlw6PmCSwxVsiVBm4U+XE2pYidRe3DakDnDGxmM7qQUty2DXFAYVQKWvCQE16QUK4yo9hV1tXs09s+NVDD0yAO8ZN2eVFN7p0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747804011; c=relaxed/simple;
	bh=Fye+R7aSAVFkLVJB4LRWCnkoEi6brZy46TD7AWNohgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uY/KXfjKCHgwyJld/psWfWv9pYsfAtODEwHwzSHZjCoRMbxo2yAcTs7glY6m30wuLzNbAxo1os7H2g8peFbGS3dxpsX+O/FzeFCGWrbDQXiNA7GK4GFk+/w1FFOi0i938FOKjQmtjIl6kgRyKesodi19ct+cMrQ7VfmhnXskSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Sy+2dtzf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Sy+2dtzf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WUCO060a2/IvAmEmgmEmyLHDKu9iFQRjj/u3vUBQG2Q=; b=Sy+2dtzf4/pcfepLyLVAb4lVTS
	65paAERZGJY5JNnqsweV54o3BG7vcpD8T9eLYSl1JPFCQla2F3hdBhASxFLzCmb+xYZAdxKkP1VH2
	yVnNd9O1hs0+rY7eHlwvsrUY6hWox0Cptukt8Qrg80mxFS3Lyz2afyRdy944CYDgDAE5b2eDAxaCD
	vdsLTeQKCurJl/S0AmeQULtsGexmc8vUb2Ll+GX1Z+XcPdQ5K7A7mw1wJz6B8qIZwzBJuaZL/xFma
	aS6F+iAWxfEVwtlwJxnEAa+wolO8+Sr/btxWghSnWCLaBTscew8WxVeU0d9jzf2uTGRvKnIStABFr
	3WzahrZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHbf9-007iP5-2W;
	Wed, 21 May 2025 13:06:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 13:06:43 +0800
Date: Wed, 21 May 2025 13:06:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
References: <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>

On Sun, May 18, 2025 at 03:58:58PM +0800, Herbert Xu wrote:
>
> Hah my debug patch was broken.  It didn't take into account the
> partial block when recalculating the hash with the fallback.
> 
> However, this seems to suggest that my hunch was incorrect.  The
> partial hash wasn't being corrupted and it's actually the final
> calculation that was wrong.
> 
> This could be good news.  Because if it is a hardware bug causing
> this, then the final calculation can be easily worked around by
> turning the final hash into a partial update.

Further investigation shows that it's not so simple.  While one
hash (md5) was definitely a final hash, the sha ones aren't.
Indeed the sha256 hash was definitely corrupted at the partial
stage and correctly identified by my printk.

So we'll have to look elsewhere for a solution.

One thing that may or may not be a coincidence is that all the
failed tests involve a partial block of data somewhere along
the line.  I might just be grasping at straws but perhaps the
partial block is the key?

Can you please try this patch to see if it makes a difference?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..7a50b31d94b3 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -532,6 +532,7 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
 		return ret;
 
 	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
+	wmb();
 
 	return mv_cesa_dma_add_data_transfer(chain,
 					     CESA_SA_DATA_SRAM_OFFSET,
