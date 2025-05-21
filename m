Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5DC2376F4;
	Wed, 21 May 2025 09:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747819019; cv=none; b=HZMUVPN/wRuzwnx46d19TwQVfkoOUGU4WPBI4XqNnW0nI1i9Tr1yA5kAPdjwjrcqwq0nVt/+XuICPXuaQLk8Gp9kBar1YZImmteB/7+r1ymMl59u10jKOPA8tgA3Cei/oFchCzWeU6873yMjVAdhCtFh3pZDQviRWlQDNv379JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747819019; c=relaxed/simple;
	bh=EOYxf7rwGWIxwQKIXZUZH9u+8ExhAtv5kLTSo4XFdhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0TzkpBhAaEj4VOliMQFpUT7zvs74XH0iuYgNnweYPZU4srBQk/oR9874RDe3ZyGuK+9BQtHQ3037OwAelUWzWkao2FIlNFRQZ5ZR/BhEKqtbHtRd+RPlzGL2A/2UkVSavfiLnARgcK1klhuAZTx2eTelGEgelBRScKJR798Bk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O+USdRL2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O+USdRL2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uoJqCLXWE5jO/v/8BjuFoyBj5zpl+Y/YmxOaV/Prcn0=; b=O+USdRL2X6np4UEcAL+BrsXnPL
	9XmnWEzuTYVkrbh005HjdbJYPILiwp/nIKEQ3TytLuQebr/ZXFqbM48rUwKaHVrPbmdrKcYEipBg1
	uWDQYkSLSWxtafPM//N30/ByssD2mzAL1aCnNNAtplUlnqlNns3vQGceZgQH0n/94vVvCjf88tOmE
	CrtKQBH/qWx+Yqxbf+YnYtMW4M9SDVwgqb1bzgi6VBadEiGJ9Nj54f+pS8rISqMVIyXyLXtcPntN0
	p+uUuhleoqmOetVEvEj3rrg9dINEPVhWS1EsqFqHMGQNZd3+994+jivte0QYCI2sNQ0TbW6ZhFguB
	eJEf5ECg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHfZC-007lLq-2K;
	Wed, 21 May 2025 17:16:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 17:16:50 +0800
Date: Wed, 21 May 2025 17:16:50 +0800
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
Message-ID: <aC2aAvX07Aaho08d@gondor.apana.org.au>
References: <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC1fY6IP-8MzVIbx@gondor.apana.org.au>

On Wed, May 21, 2025 at 01:06:43PM +0800, Herbert Xu wrote:
>
> Can you please try this patch to see if it makes a difference?

Actually, please try this one instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..8a9ea83372c9 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -15,6 +15,7 @@
 #include <crypto/sha2.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-map-ops.h>
 
 #include "cesa.h"
 
@@ -532,6 +533,7 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
 		return ret;
 
 	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
+	arch_sync_dma_for_device(ahashdreq->cache_dma, creq->cache_ptr, DMA_TO_DEVICE);
 
 	return mv_cesa_dma_add_data_transfer(chain,
 					     CESA_SA_DATA_SRAM_OFFSET,
