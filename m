Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AAA18871E;
	Fri, 15 Nov 2024 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731672836; cv=none; b=kABxaFyjFIhMIzYiJvz1zNmyK0ifEg/X04osD2EVh8d1UbZfGQXBw6bsdGo5jzzLDCK3lYIUHwRRClW8YsGAeyZoLXGUn1AMq+OK4yDtCXp9agukJi2SqyQ4avw9bYSTMt0BMaF1MFtbH1Z4ZF9ZDKWg+jm0MKzlhzYNvnuLGSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731672836; c=relaxed/simple;
	bh=qptVrqqlhvn1vcwfNp8sTVK43NOb1qPSDYjPijvL59k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWgBQMRzwfsSuL2+c6ey3MUa62NV1AdC9jAZlO8Yf+PAG/vDvSFhO0Qrz5Vkjlu4JoeKYnxUb1m4Qk9jl3hFy1e2GcFVcBz9hnQvua3l4iJPLy743AhRUNxtUVarVefeJdB1JMlOorNxZd3xOM6MdHA3zCCtBQP9z5qnnAaRLK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=a4xQiTM7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="a4xQiTM7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SZ1PgYZ+Qllsei6vV6laWrGH4wj4wXrOVb/+TQgP5X4=; b=a4xQiTM7d20pv4PqmXvVNjkfQa
	pCzHCwdKE/N1zb5kLt8FifZpsdvIGnnnvrnVpGOh7LcFkVUasIq0Q4AD1gU93f2UNnK+Ub//doQOq
	OtAUyPxHtIgHlefi8KQmCQh1cchGPNap/4v+hnH9XbnSRVo8AknoeHrGblOMDn1RpS0gEz8hb2l0n
	sPysljDZP/nL1ScxQG9qxjwiNqqBSBFx2y1GN5mQfdt+jmBkssODej7JU/4g0/z8ebtSYhPhCYn15
	e6dgFowP+OJ1H4J6i8Ss/6KYxRHly6RfHnaEsccZ7Z91uCHWhu8uHvC2AoUQ4KpkDWKB/TtuC3IUm
	j3rHfW8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBvCk-00H2A3-24;
	Fri, 15 Nov 2024 20:13:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 20:13:38 +0800
Date: Fri, 15 Nov 2024 20:13:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: George Cherian <gcherian@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	George Cherian <george.cherian@cavium.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium - Fix an error handling path in
 cpt_ucode_load_fw()
Message-ID: <Zzc68q7Atu6TH4b0@gondor.apana.org.au>
References: <774a441420a14d4425c4b6f6d7ae0a06c795f61d.1731086525.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <774a441420a14d4425c4b6f6d7ae0a06c795f61d.1731086525.git.christophe.jaillet@wanadoo.fr>

On Fri, Nov 08, 2024 at 06:22:27PM +0100, Christophe JAILLET wrote:
> If do_cpt_init() fails, a previous dma_alloc_coherent() call needs to be
> undone.
> 
> Add the needed dma_free_coherent() before returning.
> 
> Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.
> 
> I guess that dmam_alloc_coherent() could also be used to fix the leak.
> This would simplify cpt_unload_microcode(), IIUC.
> ---
>  drivers/crypto/cavium/cpt/cptpf_main.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
