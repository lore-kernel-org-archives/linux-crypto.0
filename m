Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D242F28;
	Fri, 27 Dec 2024 01:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735263221; cv=none; b=KcS4YwBYg3QHF6aV4UNX08wziivycjn9gbiDJMDXHL/HGF2dE1o0kKlQMQZ7yCS6rqoKhR5OuMIPMH9UB5AnfP4t3mfTWhDe67h+nhOW4aacX+cItCURCWqbUYXWs8NppmBLgZE5MtdXgr63BPLyWkF6BkcfpMXUxGV8e2Y/agk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735263221; c=relaxed/simple;
	bh=qQzNt9lHjfDoIjG3VdrEnvUiAtegVgmWYVzSVYrCP3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwNEjEp1LmFGeXWHCoB+4g45XFRRyLrRrmijfZmqB6HV9Nekt0IAUOp9gAak8f0RFx5znXYGjS8N/nS7VZ3/16r86kUtPBaITA+9kEi3FoBC5inKpp0AHKHIA9pNlHLOWzsvRHScJpZ/ZyNoj7BYOXMZ9IXgQm6eA250Ch+/bMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KHBjl66/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KHBjl66/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SPVvYMJ5WrIjqd++EJK7abiYxtZ/IZV1lIqq5I/zjGM=; b=KHBjl66/HN0thBEkNxHsfEr6Rv
	puROf2KJlDRx4gODhQcGOn1XtkuwY4AS7CYRJ/F5rf4AfCq//QHBCVuRm84jkliVzibTXZVnoGjAk
	d7BpX1gioHkd4HYXmPPwwBUuZMxamlX9yn1ZLz0x2fTACLuFeykjZAsH/sUFarc34bl59L0IiQRde
	IPkzwTrFFIKSTxZw1yQVpyXLabe5Tf+RQKaJJ73dr6WaWB5erKS8kp2BlqcL0XTuio4LXIbm0JNUj
	XYl4lGPd1BEwwvn1BIHv01A63kGkWpoLXsO1d/UdHHmo0pxUAQibQ2WuvBKSbqAA0oR5vVlH+yrW+
	ll9qeV1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tQz1Q-003FWI-10;
	Fri, 27 Dec 2024 09:33:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Dec 2024 09:33:33 +0800
Date: Fri, 27 Dec 2024 09:33:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atharva Tiwari <evepolonium@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: vmac - Handle unaligned input in vmac_update
Message-ID: <Z24D7cvRovlFKISX@gondor.apana.org.au>
References: <20241226170049.1526-1-evepolonium@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226170049.1526-1-evepolonium@gmail.com>

On Thu, Dec 26, 2024 at 10:30:49PM +0530, Atharva Tiwari wrote:
> The `vmac_update` function previously assumed that `p` was aligned,
> which could lead to misaligned memory accesses when processing blocks.
> This patch resolves the issue by, 
> introducing a temporary buffer to ensure alignment.
> 
> Changes include:
> - Allocating a temporary buffer (`__le64 *data`) to store aligned blocks.
> - Using `get_unaligned_le64` to safely read data into the temporary buffer.
> - Iteratively processing blocks with the `vhash_blocks` function.
> - Properly freeing the allocated temporary buffer after processing.
> 
> Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
> ---
>  crypto/vmac.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/vmac.c b/crypto/vmac.c
> index 2ea384645ecf..513fbd5bc581 100644
> --- a/crypto/vmac.c
> +++ b/crypto/vmac.c
> @@ -518,9 +518,19 @@ static int vmac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
>  
>  	if (len >= VMAC_NHBYTES) {
>  		n = round_down(len, VMAC_NHBYTES);
> -		/* TODO: 'p' may be misaligned here */
> -		vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
> -		p += n;
> +		const u8 *end = p + n;
> +		const uint16_t num_blocks = VMAC_NHBYTES/sizeof(__le64);
> +		__le64 *data = kmalloc(num_blocks * sizeof(__le64), GFP_KERNEL);
> +
> +		while (p < end) {
> +			for (unsigned short i = 0; i < num_blocks; i++) {
> +				data[i] = get_unaligned_le64(p + i * sizeof(__le64));
> +			}

This is not what I meant by using get_unaligned_le64.  I meant
replacing the actual 64-bit accesses within vhash_blocks with
get_unaligned_le64.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
