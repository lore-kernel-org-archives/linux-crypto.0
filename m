Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738D1E8322;
	Mon, 19 May 2025 06:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634597; cv=none; b=uasZK205AUTElHAeocukcgoo5wh3GYjgDc8CahBtTfMicNuL4Z6juvF97CpvLwu28zhi5WL00fvH2z6iM7b3wpMZrwJnC56XbXgo/nFTth5pXJ3yBvySCBTWKdLlUddtwI71MLE0w4FxPSFHLD+SwD9pG1GwLWjh3w1MRLQeukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634597; c=relaxed/simple;
	bh=n6ap2dKQAydfs/goOk+8zHnvL30aIShC3Gg6qGu8J2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6wf0UgdTqVEZ4vl5uPMKvJkAzgo5La+7dt4PRrvhHBEF7/vRS6QT7eVixEqoQfh3ecvaFR1ls+7xUjpaSiDhk3zuXUKm53ng9OYpA8j5+Ms3XikOd/8TiCKMa1w8xOob5W7HfHlso62hml92VCcl3pOMokFdrGz1jXXAnIi8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=llx4rKCc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="llx4rKCc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JysD6bXkXcUxDOraTgzy8CQh664lFTcTfZ1A5hSTWxQ=; b=llx4rKCcOaHC0KBZKzMw9i6cz7
	dnoUK2G6yo/cBuZz9iQdMwFCcDDzF5lCy+5MWHnKVk0tLVbcKbDXTBJpZYro9B6hJjSKjOpezBJVl
	wq4g7Wtw5Z9itWlo1avYM1FloiFsDqwH00w0x2BzfF9/CKWJ7iQOcUMxaSza7PUGoNnmG40Ru95/l
	ysHSnrhQp/HJIQdnxczU84wFWIZ9JfAdKhyANqjHH9bqawezTnByq6W7uAJb9eXtiO/ywvTrM94Xa
	Xj6M++OZDXj2CvBu+RpvCb//IasvipqqkpwIGmuH0jBlZdD1WBY3yYsO9JMCsvz9XOw8cFHRO/n/L
	LBKYgmQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtaY-0078AZ-1N;
	Mon, 19 May 2025 14:03:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:03:02 +0800
Date: Mon, 19 May 2025 14:03:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ce - move fallback ahash_request to the
 end of the struct
Message-ID: <aCrJlrZqwhtMUN_w@gondor.apana.org.au>
References: <20250516120656.3610623-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516120656.3610623-1-ovidiu.panait.oss@gmail.com>

On Fri, May 16, 2025 at 03:06:56PM +0300, Ovidiu Panait wrote:
> 'struct ahash_request' has a flexible array at the end, so it must be the
> last member in a struct, to avoid overwriting other struct members.
> 
> Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
> struct.
> 
> Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
