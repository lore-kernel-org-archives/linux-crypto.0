Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C189647142D;
	Wed, 23 Sep 2026 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153912; cv=none; b=E7DJCmCK/V5gwQ464h5QTW6ztRdgHD8HsX2Xux/yCrT+uhcmVe9OGwBDfsn26JvEHPqe8NDSiRXAEOpN7W+a0tWZPoLaRPdNVNYKJHVhBAmMpEFjc3exDpYnzeSRk4TmVY6kc1nf4PBnZ2pk4j7BOR2IxJD7sbfBDg0SQtPoP0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153912; c=relaxed/simple;
	bh=DZXAMtz14RD4YlRWCD9aayQjWBeaaoBzL09sl1ItEcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/CwzK8RmL8NHuoIYIJ0526CcnciEZ/3iatbFRdPygkkKqSUPQiBjIBuhILxz9P5O7VcMiXNMT9rYREdKpatJ8AdxVAmWJkZwpr7wmQNQdOb0TSN3dCdKUqyvQnTriVsQ2W6rNH5sfIu5uEh3S2wIOj4bUIdRMsK0CgI04tTCko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O5E6JUOF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O5E6JUOF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NU6POpuloHK8+EHJzg6WQzn8u8iYgMfP3aKWhXmnDQU=; 
	b=O5E6JUOFFgBzZECvKltBowxiPhwkgoIZKuqGUiEB1C52NjvwOOffoyWZb7HoK7XkuH61PS4cxBN
	X5F/SwZ5xn04iKpwG/GIt2uUEB8CXcVfM4alaHyC3Vh/AHMPHpM8xWd/xEAhKPRC+MRWwtELF1a45
	VhQcTQitcQ8flTDDxeuJhxBt8nBad3lNwZOCgREv+jKSnb7P3K5bKTZxg1b+r7nyCJ2zZ0YdHOsIx
	Jf6ZHrJRNDwmOgFr5mVVRcyRHH8SGarVLLEZsvJoHq+fuKsYL4PnQb6Kc5nNpdk2aE24oyefwSEAf
	gqzGIfZZMU3UhSZDMS5RzliQN/W8YqFNIFfQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Io6-0000000GyPw-2Ben;
	Wed, 23 Sep 2026 16:58:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:58:26 +1000
Date: Wed, 23 Sep 2026 18:58:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiale Yao <yaojiale02@163.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: kill v5 IRQ tasklet during teardown
Message-ID: <arOUsmw2dweuSVzq@gondor.apana.org.au>
References: <20260920173417.2126346-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920173417.2126346-1-yaojiale02@163.com>

On Mon, Sep 21, 2026 at 01:34:17AM +0800, Jiale Yao wrote:
> On PCI devices using MSI-X, ccp5_irq_handler() schedules irq_tasklet.
> The teardown paths release the IRQ but do not drain a tasklet that was
> already queued, so it can access ccp after the device-managed allocation
> has been released.
> 
> Kill the tasklet after releasing the IRQ in both the initialization
> error path and ccp5_destroy().
> 
> Fixes: 6263b51eb319 ("crypto: ccp - Change ISR handler method for a v5 CCP")
> 
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/crypto/ccp/ccp-dev-v5.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
