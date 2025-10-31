Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8F283FDD;
	Fri, 31 Oct 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761903989; cv=none; b=k2gO+zvuHbgqfOyIoHTpdqJD3LNiUBT7ZNuvja5Wg5QuqLdWNtzj0y4nPrWbNP9OKbQUv58lO/ZBRzn5fKMhSKdDRm5zj/BYc1XIHWaoMAcIIpjY2+mu9c2b2vgYrxn4UfVjVDEzgygOJ5DCH+qLk5dOibBakEImgJkEunoBdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761903989; c=relaxed/simple;
	bh=MCEVVTR+IDNll82YXpubf/nlMfQ+KMZBMAj8dhvv5Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/DzGXgIorxMmmwv/leeQw9RUVYu3OGra6JPhKJctG0AzqimXxaC6JyuZaT8sTiB5wkxOC8x7Vp+0Dt7EB+ZYM5SFSCknUMwi/zBrY/nAmHlRBCTtKYF0b3pZlQesdawkOD5wJYNvOzYSml2BDWg0qfK0buvdZtMjX+rtyMzBmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hWhP5c6p; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hWhP5c6p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=B1PKOuO0OsC5V4PgCIPFKkYiextAr0fyxviZCbND01Y=; 
	b=hWhP5c6p7g5zheiRb5trI0oLXlW8YDKKQbF1cZAAcMkjzKSSUO4WB1xlKP0T7mL3Zm8sRc+9g1d
	ZNsEOYbPJbo5XcTHRQ4L6u/fVpoDrBlpVy3s2LlbiOO7GYQ27YupjIdFB8FDOlxbyTxflgJNw2Mb9
	Ol5T3rR3YhHeEb5oSvya3CYhaFeLwsQrevdiBT2YSG2M9OHe8oAfFRnNemvBJiVTYqpHTz1yiL1Ey
	oWlvnKM2g3l2/SFA5/zSBZxTPv325Djj3+XJxS1lbybKVnoRjDvw48PJaUb9w1+ueVZnLGX3RaY2J
	QLP+cCmHdjkgIArRTR8R6y6+aTUDMuFrZMDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vEli8-00H1ef-0E;
	Fri, 31 Oct 2025 17:46:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:46:20 +0800
Date: Fri, 31 Oct 2025 17:46:20 +0800
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
Subject: Re: [PATCH] crypto: aead - Add support for on-stack AEAD req
 allocation
Message-ID: <aQSFbEdedID5f5B8@gondor.apana.org.au>
References: <20251022171902.724369-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022171902.724369-2-t-pratham@ti.com>

On Wed, Oct 22, 2025 at 10:48:42PM +0530, T Pratham wrote:
> This patch introduces infrastructure for allocating req objects on the
> stack for AEADs. The additions mirror the existing sync skcipher APIs.
> This can be used in cases where simple sync AEAD operations are being
> done. So allocating the request on stack avoides possible out-of-memory
> errors.
> 
> The struct crypto_sync_aead is a wrapper around crypto_aead and should
> be used in its place when sync only requests will be done on the stack.
> Correspondingly, the request should be allocated with
> SYNC_AEAD_REQUEST_ON_STACK().
> 
> Similar to sync_skcipher APIs, the new sync_aead APIs are wrappers
> around the regular aead APIs to facilitate sync only operations. The
> following crypto APIs are added:
>  - struct crypto_sync_aead
>  - crypto_alloc_sync_aead()
>  - crypto_free_sync_aead()
>  - crypto_aync_aead_tfm()
>  - crypto_sync_aead_setkey()
>  - crypto_sync_aead_setauthsize()
>  - crypto_sync_aead_authsize()
>  - crypto_sync_aead_maxauthsize()
>  - crypto_sync_aead_ivsize()
>  - crypto_sync_aead_blocksize()
>  - crypto_sync_aead_get_flags()
>  - crypto_sync_aead_set_flags()
>  - crypto_sync_aead_clear_flags()
>  - crypto_sync_aead_reqtfm()
>  - aead_request_set_sync_tfm()
>  - SYNC_AEAD_REQUEST_ON_STACK()
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  crypto/aead.c         | 19 ++++++++++
>  include/crypto/aead.h | 87 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
