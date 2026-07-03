Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D610D3B1EFB;
	Fri,  3 Jul 2026 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071022; cv=none; b=uTIsSfybHHnsbmlMxwh9MI6eI2huVzK7xYnUTfN23T77tLyGkswJdEEZiByUcp9k51E2JrdpHvQhnW/Rrq9lIvi4k66CL1Wj4l91ktKprhtOcmaQajpPK268hN0ygwq03TlVrsxxUb1mmwJgzXOjTp8IibOo/iiA4DpgowIsUcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071022; c=relaxed/simple;
	bh=S1IoBIHZUdKDEguos6xItwJ+mP/O3bM5hh2hub7XSw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lph6ZvHn/848CX9qvMgP7T0qfzD7WjNN4wPKQT7bkioNYLPCieaqvoJwsDxbuDX2oE5W1Khkv3Mn3EVbYRQlZ1zTCDCF9cXt3U4vlXVLEMmb0qbZEvzuZdOW2NcomXCtkx0k7H5RPkzF5JSNTMUOWZKftfVDxAW9YA7aMF9y3II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KwiUzH5b; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KwiUzH5b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bMqWeaK7hx8ilXvf9UXlHNx3exT0cjWw/skeWOS9d0I=; 
	b=KwiUzH5b6Oj1wAV1vl2plhMHZA4GCujKD/16me5uZ9q2exGptX/3H9+bzJkAZ4Wy4owULNH4B7q
	HoeO4/4D8mc3L5vRXThM0O5+YdtZr6lQZ9+AqYi+3YeAHbDydgavoRTuNwqMzfic9Tf0luKQq1UFY
	Y7iOqyXfpG1fST5qliKT5VHgbUUZLm2CDV5ftVUU3XhfZB66S18KAuA5YZfrI+Dr08oQolUO1XgZR
	kpjt5Xe0ZF5532WO1R4oLFHvuKv9jdQAaWpRQvyOwwweHukUOre941o+WyQBeRFfIIa8z5Jf+NPF1
	Gthi0CBQxrnrTqPdN9uDJc3rJqnkrOC7olVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfaDv-0000000AKHj-0T0E;
	Fri, 03 Jul 2026 17:30:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 17:30:15 +0800
Date: Fri, 3 Jul 2026 17:30:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] Fix multiple issues in chcr driver:
Message-ID: <akeBJx_1I1yiRva0@gondor.apana.org.au>
References: <20260622151910.49402-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622151910.49402-1-vulab@iscas.ac.cn>

On Mon, Jun 22, 2026 at 11:19:10PM +0800, Wentao Liang wrote:
> 1. In chcr_ahash_final() and chcr_ahash_digest(), chcr_send_wr()
>    return value is not checked. If it fails, DMA buffers are not
>    unmapped, causing leaks.
> 
> 2. In chcr_aead_op(), the inflight counter is not decremented when
>    assoclen validation fails.
> 
> Fix by:
> - Adding error handling for chcr_send_wr() with goto unmap
> - Adding chcr_dec_wrcount() on the assoclen error path
> 
> Fix the following functions with missing decrement on error paths:
> - chcr_aes_encrypt()
> - chcr_aes_decrypt()
> - chcr_aead_op()
> 
> For chcr_aes_encrypt() and chcr_aes_decrypt(), use a common error
> label to decrement the counter. For chcr_aead_op(), use the existing
> chcr_dec_wrcount() helper on the invalid assoclen error path.
> 
> Cc: stable@vger.kernel.org
> Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
> Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
> Fixes: 324429d74127 ("chcr: Support for Chelsio's Crypto Hardware")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

Please take a look at

https://sashiko.dev/#/patchset/20260622151910.49402-1-vulab%40iscas.ac.cn

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
