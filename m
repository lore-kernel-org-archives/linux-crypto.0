Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794477330;
	b=0FvnUctdp26MRG+epWvw1cj3cEfUf0UH4NAaZs2Q0eY4U6pRMckO/IdjjVIPN9cTprd4
	 SiskV310VN7aIuUxyhfWH7kG6zaQz3TlhJ3qIgx4dxGbZA7uNTM0FtR95CsbkXSUVkONe
	 n1V1ob8Ouoryo26woPqkt7S40dRWoqHozmguO9zssbYNek43o0RyCmPAA5UfUjH9emcjV
	 zQjtMWSeB+RzdmriBW+1OKrRY5H+X9LJJu3YlQqn+NQD1Fr8bk8pzRI/UnmRnpekFkmjB
	 GG13xz5it4HE3Qb7rtpdDHZxJC9PhHBHRaPyttoGJsDByK0TNm0wVY4wF6JEEzhj+zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794477330;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HUrDJSU3D5wEJhjvbogQ1WvmN5gFPRnMgbMneELgIdA=;
	b=ld0Q4f0juW6iayksxcOb9czfPs8+bWdMeNX8aka3LusSpefMi5HPs9ZVX+ewNIxL25XB
	 jX0exA073U5DEWxb7bLceZi5LiByWkacOJJfk8MuikYIaYYbulWlGMW+MMS8yRwJrXWrd
	 4prMLqye6YrCrBVyF88IjsryGsiwTZyZXs2EN1qt0dkZDlpSRgErVu84b6lCH/NKKUKmt
	 57yTgsU7cPN6CBWFYd5WTpJus4LJ92axxgDoXD88EZeZwI8D2qao9qyyI2GmrbsOFZWzq
	 PLOcb0tpk5fbUp8vhgG3P1broY6auGVTG15zBcO6ZkRh8+WHv0IFqronJjwC+hrjtWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=k69eR+65;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44E8606A33A;
	Thu, 12 Nov 2026 09:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C44E8606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=k69eR+65
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HUrDJSU3D5wEJhjvbogQ1WvmN5gFPRnMgbMneELgIdA=; 
	b=k69eR+657rmTJHl+vZLoJcRgSMrGHE03Y8s6klV/5KZsNgxtdj54B1s7yakTe4ggEkdNJQWlg+J
	ksYmv15c6vBzPFNTTbwo0ZX2YEzaH1j+wz3m1Vjb9kwSEJ6mdhRHW/jYUrmuALs+V2NJtpsi4ZZ4o
	7zdvBFb7hVdixo2mrFriAp6xhzaO1DNuNES3samYSthDlcKmoFoZQvlgm2Jbr5bjuQUrWCinqFohZ
	Wr9U/dgWfg1WaKTBadv/xMWpHcoj7Fxp4ZHh0aHtvjDogTQiHFO0QzCcQ32GbsE1smievTMIEAwqp
	DMLZasM1TAeFOKMyzEFdNkLFaCSzLOsPtsnw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRWf-0000000EDe6-47NX;
	Thu, 12 Nov 2026 17:55:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 17:55:25 +0800
Date: Thu, 12 Nov 2026 17:55:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Li Ximo <lixicaicai@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Wang Haoran <haoranwangsec@gmail.com>
Subject: Re: [PATCH] crypto: keembay - fix list_first_entry() on empty
 dev_list in find_dev helpers
Message-ID: <avWNDZiIHuPkX8rH@gondor.apana.org.au>
References: <20261026115646.4137906-1-lixicaicai@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026115646.4137906-1-lixicaicai@gmail.com>

On Mon, Oct 26, 2026 at 07:56:46PM +0800, Li Ximo wrote:
> From: Wang Haoran <haoranwangsec@gmail.com>
> 
> list_first_entry() does not return NULL on an empty list; it returns a
> bogus pointer computed by container_of() from the list head. Both
> kmb_ocs_aes_find_dev() and kmb_ocs_ecc_find_dev() call list_first_entry()
> on their global dev_list without checking list_empty() first. The list
> becomes empty after the single OCS device is removed (kmb_ocs_aes_remove()
> / kmb_ocs_ecc_remove() do list_del()), while existing tfm instances may
> still invoke find_dev afterwards: for AES the device lookup is deferred
> until the first encrypt/decrypt operation (setkey only stores the key),
> and for ECC init_tfm of a new tfm can run after the device was unbound.
> In both cases the bogus pointer passes the callers' validity checks
> (the AES callers test for NULL, the ECC caller tests with IS_ERR(); a
> container_of() address inside a static struct satisfies neither) and is
> later dereferenced via ->engine or used for MMIO through ->base_reg,
> causing memory corruption or a kernel crash. This was found by code
> audit; we do not have Keem Bay hardware to reproduce it.
> 
> Fix both helpers to use list_first_entry_or_null(). The AES helper now
> returns NULL on an empty list, matching the existing NULL checks in its
> callers. The ECC helper converts NULL to ERR_PTR(-ENODEV), matching the
> existing IS_ERR() check in kmb_ecc_tctx_init().
> 
> Reported-by: Wang Haoran <haoranwangsec@gmail.com>
> Reported-by: Li Ximo <lixicaicai@gmail.com>
> Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
>  drivers/crypto/intel/keembay/keembay-ocs-ecc.c      | 7 +++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
