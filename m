Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88343DF015;
	Fri, 17 Jul 2026 08:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275628; cv=none; b=NS2RaNIVQlegB6W7Mmzqt6M31t7eR0iz42SJ9oUodbHkdN59X4tg3XywsKa4cQGC64WH072BBGsjnkjRNwclrP4uGNXlugunaZpVArJBZ7mODzVVNOltaRJ1j9JWexDwQSIgtV+9AVKn7UTibhkErTrUzg+1QBeZjuoyhGVC7bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275628; c=relaxed/simple;
	bh=aHro7RIMkpPdaVdLeEekyTkyoqwG0u7WKkWzhrDkFP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcLIAp8PTsptjC9V889T8TgtZx3+uLuttA/82zFJA6aXG6Pd2JPp+vlKesRu0NtMNO0/bvo9qrfd3lT+kpS0ZD+BEajKP/G+daDhof4bGAfxAfmlLidLPVimHx65PYTVXsbAEFvIgKKG+EF3EPwdPXHRD3bwhTJt1dzbnKtbhO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=opitYOk0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="opitYOk0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZNhat9jnunpLkqXkCTFPlJlcB44kvt7vQT1NyFyBr3o=; 
	b=opitYOk0ZMiBkJ0CPl9CtUvc1R/+UCjPQFedrBGI/lWbMSJ+LiW45/XJ28vvIrZvWeCXtAysQ+Y
	nv5RyGi0WClUlUL8UWfaMnOtL0g8TYsP5E7gLcdZ/lYf9ANT7mZE/YViamS+yqXg3XfgI7s4kP4V2
	JwfN/0TlColXURN3xAcHT/Si9ZH3L5AJRorlEXmmh+tDjIsDeLkMYeeCDNQ685QPyVy3kEMtNjaDs
	5KelprhkU6n6iMefRRYDX/re/zR9Iu/yasvy7Ett2+I5+7+IfSrQwBMGzYWU4MNGzKEG2/HGGobfE
	OcJ5CzjvY4BmWsTtQya/Jy5vzeAhtKKMMwOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdaq-0000000ENuJ-2zjN;
	Fri, 17 Jul 2026 16:06:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:06:48 +1000
Date: Fri, 17 Jul 2026 18:06:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: cesa: switch to non-devm IRQ to free it earlier
Message-ID: <alnimCxfVcHqhHNE@gondor.apana.org.au>
References: <20260713031532.2458000-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713031532.2458000-1-rosenp@gmail.com>

On Sun, Jul 12, 2026 at 08:15:32PM -0700, Rosen Penev wrote:
> Switch the IRQ request from devm_request_threaded_irq() to
> request_threaded_irq() so the IRQ is released explicitly, allowing it to
> be freed earlier in the cleanup path rather than deferred to device
> teardown.
> 
> Add the matching free_irq() and irq_set_affinity_hint(NULL) calls in both
> the probe error path and the remove function to release the IRQ and clear
> the affinity hint set during probe.
> 
> Fixes: f63601fd616ab ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: fixed Fixes tag and reworded commit
>  drivers/crypto/marvell/cesa/cesa.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

This makes the code more complicated.  You need to explain why this
is desirable and the explanation needs to go into the patch description.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
