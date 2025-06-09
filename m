Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4F26E17A
	for <linux-crypto@vger.kernel.org>; Mon,  9 Jun 2025 04:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444794; cv=none; b=cjRlhMJYyh163gelUXC7HmcozXHSjE4ouQetkk6dcakuIS6Y0GuVjSqf0Qzm/9ZftEdn8TCyRXUtSiyaPi/ix9fDvVLLPGq+sieuHh6IDdhrwT815JWJ1X9QqcGl7mBbgd6KNqC4SYUiXhk9WMkbm+IXP8Dj2vGEEA8NGxjeF1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444794; c=relaxed/simple;
	bh=WERKOsvf4XzQX5g+F1qJ/6Z2v69kJQYyajEmKqZvvNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boa9lpmxdPSiuWaR2WAPdsizeisN18P38rOcBaG4QSmFOLknuw0ZayjDmfT5kKUuFllkUZNaMCsjgzuruyRMSFTgxrvGxKcqvw1daxYj56JDja931R3AU9fyDuPSC7xoS7esWAjUshq1QrTp8w3uRVm9b/+MVHxexdcn9Ky0F9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OzKwavf5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OzKwavf5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AOtVxphg4n/ibYwLF+8lXDVsTdzzSnwNRh8d8Sl3NLA=; b=OzKwavf5shxn9SAjjh5HHd6wYq
	4+kEa7j1HYwsKQjJjmE/hhTlxn2T0+1zpSfGZWjwLJXBu5bwQkoBPaPGyU+kQmbZvCHnr/zDdpTnb
	3+9C1Q6VzxW6VxlhD43zhvT1zZrIMyb5Pqc2vgIYxwRc2thVGJWq4gnd94tAVn/4MvX+wBaW1LEmo
	xbawOco0tQ3nbFcbU14V6VEXp4iBq8IJ5NjEc3Vw4gG5wtB8ZApBgaxrFrwhVtGsN5nwMZsJQdH6s
	NSJXEtnw88AAMPVWa4lG8cj4flA/cTo2nFDSnN+gZJvH8L7bmsRh4yaFmI+8NGwfrk9U3v19tK360
	vlVSAK4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uOU7q-00BiVO-2Q;
	Mon, 09 Jun 2025 12:28:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Jun 2025 12:28:46 +0800
Date: Mon, 9 Jun 2025 12:28:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: zhihang.shao.iscas@gmail.com
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	paul.walmsley@sifive.com, ou@eecs.berkeley.edu, alex@ghiti.fr,
	appro@cryptogams.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v2] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <aEZi_pADmu263g43@gondor.apana.org.au>
References: <20250608133118.162935-1-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250608133118.162935-1-zhihang.shao.iscas@gmail.com>

On Sun, Jun 08, 2025 at 09:31:18PM +0800, zhihang.shao.iscas@gmail.com wrote:
>
> +static int __init riscv_poly1305_mod_init(void)
> +{
> +	return 0;
> +}
> +subsys_initcall(riscv_poly1305_mod_init);
> +
> +static void __exit riscv_poly1305_mod_exit(void)
> +{
> +}
> +module_exit(riscv_poly1305_mod_exit);

Please remove these functions.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
