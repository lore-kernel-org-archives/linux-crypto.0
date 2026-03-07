Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AE8355F5A;
	Sat,  7 Mar 2026 05:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861051; cv=none; b=umuH8SYG4W67GwMJNASMmCDE1xvf1BkJdgOcf+oy2PG/2GiEPnZ1EhFjMO2D7f5nquXhGv6ns1Rp1Jv4cA6lYjIa7VN1RzTxCoaKbMWrFRwjl7PdPRoWfgY1LqhSvlQRcTHEbeyhsNS8Tj7gVXvxXk1W7MrH32IpjAKBaMmoOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861051; c=relaxed/simple;
	bh=RVVnKtbXOFSwyK7wKbW42rOuYypJ/78S0lBwCh6kSB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vt2U9bsnNV6yF1U5I7vb+JM25yTxVXLYiPlEvnru2th/fz/2fRiUPj7enIFnNOAAB2RWYIl4+B81ef3P12tmtbJKxbL4PAZN6eBDuXSGrCN/iOvbLrwYR9FIy8O7r6ziALyj/Ghord+Di5LOHwDTwzJ3yuxO3eyPTEh290ibpko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gEOtoIvz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gEOtoIvz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TZtYTKdHqFobo9IEwiD6UTjJ7mG6N0xczjmjrh5PM/o=; 
	b=gEOtoIvzl0PHIx4ehnYpeSytPCruDIvSir2FYbwvAE5U2oBqXHffoKGtV8JhM3iDB2eW9F3InmI
	uRWOT7bKVM0AmkaTJh0C5th5Hoadx82m6cAcroIb/5TGw18QGsN2uDD9ooAN97XV9/IL02a4gtRFd
	GWbNPYTMDf85DyAgPT+eHqKeHb9nB4dDj2ZpcX5nH/1r1DV3OCDobiGOcLVTA/i/e84BrxkiLwsIT
	okJbYDyVvS+urDlI330QoTw3J53vtA0zNfF3THZHJGLKKuX5aWl7fxiurMzR7h0n80WKOvLT/p0sK
	cB8rBhyLI+r2w8MS/v8M6LTZKdCXfbxcdOHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vyk8s-00CJRR-09;
	Sat, 07 Mar 2026 13:23:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:23:58 +0900
Date: Sat, 7 Mar 2026 14:23:58 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/3] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
Message-ID: <aau2bg4gdM0VPcEo@gondor.apana.org.au>
References: <20260226125441.3559664-1-t-pratham@ti.com>
 <20260226125441.3559664-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226125441.3559664-3-t-pratham@ti.com>

On Thu, Feb 26, 2026 at 06:24:40PM +0530, T Pratham wrote:
>
> +	src = dthe_aead_prep_src(req->src, req->assoclen, cryptlen,
> +				 src_assoc_padbuf, src_crypt_padbuf);
> +	if (IS_ERR(src)) {
> +		ret = PTR_ERR(src);
> +		goto aead_prep_src_err;
> +	}
> +
> +	if (req->assoclen % AES_BLOCK_SIZE)
> +		assoclen += AES_BLOCK_SIZE - (req->assoclen % AES_BLOCK_SIZE);
> +	if (cryptlen % AES_BLOCK_SIZE)
> +		cryptlen += AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
> +
> +	src_nents = sg_nents_for_len(src, assoclen + cryptlen);
> +
> +	if (cryptlen != 0) {
> +		dst = dthe_aead_prep_dst(req->dst, req->assoclen, unpadded_cryptlen,
> +					 dst_crypt_padbuf);
> +		if (IS_ERR(dst)) {
> +			ret = PTR_ERR(dst);
> +			goto aead_prep_dst_err;
> +		}
> +
> +		dst_nents = sg_nents_for_len(dst, cryptlen);
> +	}
> +	/* Prep finished */

How does this handle the case where req->src == req->dst?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
