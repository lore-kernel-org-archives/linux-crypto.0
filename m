Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D301124EA90;
	Sun, 27 Apr 2025 09:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745058; cv=none; b=KFU8I+HB4AsKToXsdMbl0/P8vt+ljIXh9jEq59Sm1UzHU87Hc1s5hf7qCg/2/sU0D/HcBVxLfTEHRGv6XeIi3RIYiQ8hKrgqV2rv46/i3UVjhZaO57AEt4250JOM5rk3rChOkfbANqXX3ujPxEksCAxcyqHO5ygYY9HwmbtJvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745058; c=relaxed/simple;
	bh=C/B9zvlUukkqWLCi/Mt+JSdJvR1LQZhE0nDum+0XmpU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ciWrPOWPA0x5h8K6CiwCCrCtEBduCDn0oU6hmvgge3drYBJKzyzcPboHAmwtIJmV2+o7EF1Qx/g5MA2bciwCoU5Fux2z68sECmjG4/tuTMRuEQn+Ifkcf/uxVf8FbzA3mCO4sGqQ9F4ykmCLwGvv4uZXxW/Uhb4T9BPJ/n4MdiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tBkQSwdW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tBkQSwdW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2ICBWG1q18eKbndo/iLBsuuc9jxO0kDKHXQDDK0Bw3A=; b=tBkQSwdWN6MFVIuHRuXKqpsj9x
	teGGVmC82MU3F9Lwu3j9RuuGtkc668I+xehtM06sp8qIFnYEUBW8bPM4MiLrNH7qIkjsAKwfgSVWK
	OZnnTxK3sTa1Mq7efFkBss64fcU86Q0tmOqlgjcY+Ey8VEUMZtmmXYGBGZewd1JBbBMMOn2RHuNZm
	bkLwSnbBu3xHyvvJFMgZJSYI5R8K0HckTPMZSi7/i/9POLSmfoDg9nZqUOJuqf03W9RgtEO4GfV4K
	z5srWxp17Z+tj1XsULSnvry/zwAsweqZjEalI6+DFW6GtU11ZPKT9tmXqS/lJzJhSWwuSYEBidk4I
	sfV8NMFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8y2D-001MqL-31;
	Sun, 27 Apr 2025 17:10:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 17:10:49 +0800
Date: Sun, 27 Apr 2025 17:10:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com, pavitrakumarm@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v1 4/6] Add SPAcc ahash support
Message-ID: <aA30mVmjAahKb1P-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423101518.1360552-5-pavitrakumarm@vayavyalabs.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Pavitrakumar M <pavitrakumarm@vayavyalabs.com> wrote:
>
> +static void spacc_digest_cb(void *spacc, void *tfm)
> +{
> +       int dig_sz;
> +       int err = -1;
> +       struct ahash_cb_data *cb = tfm;
> +       struct spacc_device *device = (struct spacc_device *)spacc;
> +
> +       dig_sz = crypto_ahash_digestsize(crypto_ahash_reqtfm(cb->req));
> +
> +       if (cb->ctx->single_shot)
> +               memcpy(cb->req->result, cb->ctx->digest_buf, dig_sz);
> +       else
> +               memcpy(cb->tctx->digest_ctx_buf, cb->ctx->digest_buf, dig_sz);
> +
> +       err = cb->spacc->job[cb->new_handle].job_err;
> +
> +       dma_pool_free(spacc_hash_pool, cb->ctx->digest_buf,
> +                     cb->ctx->digest_dma);
> +       spacc_free_mems(cb->ctx, cb->tctx, cb->req);
> +       spacc_close(cb->spacc, cb->new_handle);
> +
> +       if (cb->req->base.complete)
> +               ahash_request_complete(cb->req, err);

This can only execute in softirq context, or you must disable BH.

> +       if (atomic_read(&device->wait_counter) > 0) {
> +               struct spacc_completion *cur_pos, *next_pos;
> +
> +               /* wake up waitQ to obtain a context */
> +               atomic_dec(&device->wait_counter);
> +               if (atomic_read(&device->wait_counter) > 0) {
> +                       mutex_lock(&device->spacc_waitq_mutex);
> +                       list_for_each_entry_safe(cur_pos, next_pos,
> +                                                &device->spacc_wait_list,
> +                                                list) {
> +                               if (cur_pos && cur_pos->wait_done == 1) {
> +                                       cur_pos->wait_done = 0;
> +                                       complete(&cur_pos->spacc_wait_complete);
> +                                       list_del(&cur_pos->list);
> +                                       break;
> +                               }
> +                       }
> +                       mutex_unlock(&device->spacc_waitq_mutex);

While mutex_lock obviously cannot be taken with softirqs disabled.
So what context is this function called in?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
