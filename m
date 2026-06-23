Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F36D3644A4;
	Tue, 23 Jun 2026 09:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782206779; cv=none; b=avtLKFp7rj1v3J0PR57vBc8FstUR+fwHGVkNM+uwnZlf/yQapzJVxYoAlpo3d/TE4bScRAQ4b51HSCcfSgatfMQXTtrrmKuBmRUzN+nJlVPFJ/Wtc1CyH0SDj4ksKvsYB8pTFmvqycCvrYhhQb99tIxTSwZqsEIgpd3IEqjU2Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782206779; c=relaxed/simple;
	bh=3G+s78ZGaE4w/7G+m2+1z/grM1j3s1Or94a6zPTLhgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6wmKyUCzr9m+QKiYNcXOc+tU+6lyLuJZscK5W4GnX444d3/1eAaKupzeA8T5xOrwPRjwzYoAB9xBmFnw/whbPc2jlSrqGWbQePe+Dh46hZc4QeGlfTFDcnEqQKADMubc90l1v0ZixvagM038pA381dhL4j/dmxm/0I8kjB6NXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id AB164367;
	Tue, 23 Jun 2026 11:26:05 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A3B1A602090D; Tue, 23 Jun 2026 11:26:05 +0200 (CEST)
Date: Tue, 23 Jun 2026 11:26:05 +0200
From: Lukas Wunner <lukas@wunner.de>
To: azraelxuemo <eilaimemedsnaimel@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dhowells@redhat.com, Ignat Korchagin <ignat@linux.win>,
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: fix OOB read in KEYCTL_PKEY_DECRYPT on
 zero-length message
Message-ID: <ajpRLY4unsqxS46e@wunner.de>
References: <20260622025002.798934-1-xuemo@xuemo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622025002.798934-1-xuemo@xuemo.com>

[cc += Ignat, Jarkko, keyrings; start of thread is here:
https://lore.kernel.org/r/20260622025002.798934-1-xuemo@xuemo.com
]

On Mon, Jun 22, 2026 at 02:50:02AM +0000, azraelxuemo wrote:
> When ret is replaced with maxsize, the caller keyctl_pkey_e_d_s()
> does copy_to_user(_out, out, ret) with ret = key_size (e.g. 256
> for RSA-2048) on a buffer allocated with kmalloc(params.out_len),
> which can be as small as 1 byte.  This reads key_size - out_len
> bytes beyond the allocation.

It would probably make sense to tighten security in keyctl_pkey_e_d_s()
by using kzalloc() instead of kmalloc() and by capping the amount of
data copied with min(ret, params.out_len).

> Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
> Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>

Please add:

Cc: stable@vger.kernel.org # v6.5+

You don't need to cc that address when submitting the patch,
but including the tag in the commit message helps stable
maintainers identify patches that need backporting.

> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -358,7 +358,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  		BUG();
>  	}
>  
> -	if (!issig && ret == 0)
> +	/* Decrypt may legitimately return 0 (zero-length message); only
> +	 * replace ret with maxsize for encrypt, which returns 0 on success.
> +	 */
> +	if (!issig && ret == 0 && params->op == kernel_pkey_encrypt)
>  		ret = crypto_akcipher_maxsize(tfm);

Given that out of 3 operations (encrypt, decrypt, sign),
2 already return the size, I think a better approach would be
to let crypto_akcipher_sync_encrypt() return crypto_akcipher_maxsize()
on success, i.e.:

	return crypto_akcipher_sync_prep(&data) ?:
	       crypto_akcipher_sync_post(&data,
-					 crypto_akcipher_encrypt(data.req));
+					 crypto_akcipher_encrypt(data.req)) ?:
+	       crypto_akcipher_maxsize(tfm);

and then remove the if-clause in software_key_eds_op() altogether
which overwrites ret with the maxsize.

Do you agree?

Your patch wasn't cc'ed to all maintainers of this file.
Please double-check that you've checked out Linus' current
master when running scripts/get_maintainer.pl.

Thanks,

Lukas
