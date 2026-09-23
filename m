Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E150038A725;
	Wed, 23 Sep 2026 05:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142344; cv=none; b=GyT5fqawKRNalOdrLsPBQiBCCVRuYMlHolZiQFUU+LruVVhs0kWbyF52UsagwfBpjiWjGOkoezH9nnv6SroK/BnXP4W8YG6/w+H7S3Ir0+B3l/Y4SnBg/jyXlFj06GH7lbQHt9l2Wf5d0UTOMUZFR6woc2HXz0at6YmDD9JvUFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142344; c=relaxed/simple;
	bh=pM9okg1mAfTcsOjVU0S3FtEU5LVCKah7staipiTn4vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dc9qwussQr1EqFXsKWMxRPuFB1LcU6YRUneo85jqz8G2AZm2MbMOu9w9i5/dtDNWCwO3Ye/6lrzdfDMA5g/82NCCxE3g1pgAasUfeZrq+TZj4KqSlJFO6KOe2+y9ahLpqkUZnEaXSh1o0O50RGT3vVBw9uXeiUchC6rXxdUHSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WfGG6sol; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WfGG6sol"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3XjZVCiagHx/6Y2uabzw7ERTMDgBSCPbpJOmgaLw8rc=; 
	b=WfGG6solAfSnndvgldn7M6P/gN3c+yxuhwwaWx9DJkX9auGa5PLRu0OlYAXPeWl7QB9lR41yQWK
	kmsYiicpjP9YZHHs0stEeuhiD0F328mq8FsqfwCnTvPomlbsbaDFFSHj51lC+UrXPv481X5OtTnzH
	M43fpYQqbDwsQduUqjtwotepIMW1taysCQ0tNPBRGYrAP/HFazGhn5kfKViNqd7rMekEwF3Bq/BEA
	EVxuzOZJPP6cQfDu4fvq5KHd+BXk/uvjnf9KMVGq5COdJo4Sv1OY/hjzRCFC2sRT0WsgLXxfwsg1t
	SOmCOam6ISG1Ctr4L0xeR12FxrQPVRxSSZcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FnU-0000000GumR-35x7;
	Wed, 23 Sep 2026 13:45:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:45:36 +1000
Date: Wed, 23 Sep 2026 15:45:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cesa: complete pending requests on device remove
Message-ID: <arNngHZELtCQqVF_@gondor.apana.org.au>
References: <20260916230526.284982-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916230526.284982-1-rosenp@gmail.com>

On Wed, Sep 16, 2026 at 04:05:26PM -0700, Rosen Penev wrote:
> mv_cesa_remove() unregisters the algorithms and frees the IRQs but never
> drains the engine queues. Each engine can still hold outstanding requests
> in three places: engine->req (currently in flight), engine->queue (queued
> but not started), and engine->complete_queue (processed but not yet
> reported). The latter two are only completed from the IRQ handler, which
> is torn down before they are flushed.
> 
> If the device is unbound via sysfs while requests are outstanding, those
> waiters never receive their completion callback and block indefinitely,
> leaking the request and its scatterlist buffers.
> 
> Drain all three queues in mv_cesa_remove() and complete each remaining
> request with -ENOENT before freeing the IRQ, so bound tasks are released.
> 
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/marvell/cesa/cesa.c | 46 ++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260916230526.284982-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
