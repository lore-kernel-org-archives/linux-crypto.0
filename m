Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0282D8391;
	Sat, 31 Jan 2026 02:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827726; cv=none; b=ZLk5WbdaVmfKJkL4qt3YegcRJw8P6+6QQhK2ng3kip6qoj3UL3ba0mge6XrUqsQHcshGJbkwJWbvZUz7YVc6YZA7BaTBtKMebxSHpGWaS7UzrrZhiC0h5P2NcPmT/JxyWe0/diR6Nyp4LFG09HDoBYmi/FS2kgnYgFWj9eFT2CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827726; c=relaxed/simple;
	bh=eqRfFrSF3twsT2P/vmqxBiww2a+dpE5b0x0vURQ2kEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4Ihxsjia76M7aOaBPuNWwvnRBkYOmxrpa9nYSXEh0p1yg/GHHQLaaal/vI6z0CZd2htpbxcWaERjnHm0c/aDSU7o1QLhhqIG/lKq4DFAxpnP1YU95lfAd7YR3F2+IljvQWFuy3+Rp9Nk2Igy2jKOvDUDVWnRBwwW/sM2nV5KmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Kg6B7wFm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Kg6B7wFm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DcR7qHARxwiPKYODcuVg7nYzyVOtu546pX/yRM+hS1Y=; 
	b=Kg6B7wFmSuIAb/wsEBnodG22PsO2hcNbZxYYXljAq4QC0Pt24JEeJ2xp96q37UfzQeStzIad1HL
	yYkR94+OzYBoF16UC4SGMj934Db5goDQ2PuQd19hbeY727y5VgiASRMWelshVyymjyclaIPh1P5vc
	j3d022IMPoMTzgqQZBb4liyjDCa3wUo2Mf+E3Rto7AoTyQ/RbZpugfQPSmSXMpq71fi0UFY0+/5T3
	MyyRuikDdh64DgUjKi9qGhFALsvrq5OZSQrDeTHOJd+RoMz78evHMf72RBFbVR2ZbC1/k3EUy3hid
	N6QMOLUBDRCgCcJ/uPSRwVdLceUOWiVetjng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm12I-003Rrb-1F;
	Sat, 31 Jan 2026 10:48:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:48:34 +0800
Date: Sat, 31 Jan 2026 10:48:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ella Ma <alansnape3058@gmail.com>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@inria.fr,
	Markus.Elfring@web.de, Tom Lendacky <thomas.lendacky@gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Fix a crash due to incorrect cleanup
 usage of kfree
Message-ID: <aX1tgpqjtIby9tav@gondor.apana.org.au>
References: <20260108152906.56497-1-alansnape3058@gmail.com>
 <20260109151724.58799-1-alansnape3058@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151724.58799-1-alansnape3058@gmail.com>

On Fri, Jan 09, 2026 at 04:17:24PM +0100, Ella Ma wrote:
> Annotating a local pointer variable, which will be assigned with the
> kmalloc-family functions, with the `__cleanup(kfree)` attribute will
> make the address of the local variable, rather than the address returned
> by kmalloc, passed to kfree directly and lead to a crash due to invalid
> deallocation of stack address. According to other places in the repo,
> the correct usage should be `__free(kfree)`. The code coincidentally
> compiled because the parameter type `void *` of kfree is compatible with
> the desired type `struct { ... } **`.
> 
> Fixes: a71475582ada ("crypto: ccp - reduce stack usage in ccp_run_aes_gcm_cmd")
> Signed-off-by: Ella Ma <alansnape3058@gmail.com>
> Acked-by: Tom Lendacky <thomas.lendacky@gmail.com>
> ---
> 
> Changes in v2:
> - Update the subject prefix as suggested by Markus
> 
> 
> I don't have the machine to actually test the changed place. So I tried
> locally with a simple test module. The crash happens right when the
> module is being loaded.
> 
> ```C
> #include <linux/init.h>
> #include <linux/module.h>
> MODULE_LICENSE("GPL");
> static int __init custom_init(void) {
>   printk(KERN_INFO "Crash reproduce for drivers/crypto/ccp/ccp-ops.c");
>   int *p __cleanup(kfree) = kzalloc(sizeof(int), GFP_KERNEL);
>   *p = 42;
>   return 0;
> }
> static void __exit custom_exit(void) {}
> module_init(custom_init);
> module_exit(custom_exit);
> ```
> 
> BESIDES, scripts/checkpatch.pl reports a coding style issue originally
> existing in the code, `sizeof *wa`, I fixed this together in this patch.
> 
>  drivers/crypto/ccp/ccp-ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
