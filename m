Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168699;
	b=Z2Vx3usvz/7xw1zd8DhRcYmDK9C4OQLcHyuCgr2t7VCjIBz+X98M1N/nb+QbCHuqIvFo
	 Hkr9VVlYeICHFXR/jH4AZd6rsLpj5uKLXIIgDzZ5UhRz4r74tciqJTPRGck9QrxPy46hK
	 0Gj2h9qrxEDh4g3MZLA7UTaYP7nzE0MGXs9rmftzspbNQ0BEJlNl13F67MmXnzOHgp467
	 4QVl53wUpceeAHseSWuCW2XrRBgwJ4+WqzjodNqKbvQeIxezSkLdwo/1zhjQ7YG8G9hKY
	 JsTJxNsS//93q4a43/3xFCb5g+Gp3Vj/6nDny9K8x4Gs3JqqPQ8Exjy/dt25vebjqAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168699;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=uY8yz1qOoWb7maxNqQmHGS2DiNSUmLuGnnvbTyfBc4U=;
	b=HyjQFZuL+HE1V2F0grFLRxfZWHwhvvGQeDCjRloSs1n+CfeysSRD5yjx7ZU3Em1WlRqc
	 uVnbwctKFhZwLV7Dun6xJuo9yFWRm68bRzATTltzDlAgRMYTkLMy8LLEdb1G65g3oh6ma
	 G1OjKtAhO88sovtNgodQE/vsRU8ynCmyvpqVUFYkFxPW3/xerzzxV19jqYZkeRfhMSKsN
	 JSMXymnh0Oa8vGZO/+dDptQ0B6m/Yt0OQA2phvQVn4JU3sKCuyUI687Y0gec52F6DFWME
	 i9+iHCr+NdjP9djO4tflgWlkICwzLX8mEgdLTwhkrB3dnFWKSlH0qRDTcQBW7n2LyFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dLA6REuD;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA1B606A325
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 09:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDA1B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dLA6REuD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uY8yz1qOoWb7maxNqQmHGS2DiNSUmLuGnnvbTyfBc4U=; 
	b=dLA6REuDqD1CZJLP8PhzMk79uwjpFBIeXRwT6QlThpohXF/55mBIjv3rqOa63TG0S90b2B1msuR
	W2DJS/UHbHD+KSx2LfWLzqZcr6Ezl5qYZRGIPOG89DiP9bVtZkhUSf/qzYHpo6PwgVu8dCm9hmFY9
	DMHMDdFUK4HPSvBcaIUQfFsMzm4XARaDbb6caPpHZBCBkZEX9+hqS7L00h88Z3T2yE4eGUBJZJyGh
	XyGOFyKuYpi+qXEy2V64VO+35CZnEGH6iKUAoXw4V7K78J1I7eK3HCEjjwzWBJyKhnj+Pf4AS2ePc
	xtJfXqeLdks2w/pOZkC2XU5eZHrno+hxDrpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULNm-0000000HYrP-2GMt;
	Fri, 20 Nov 2026 17:58:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:58:14 +0800
Date: Fri, 20 Nov 2026 17:58:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH RESEND] crypto: qat - clear fw_loader pointer on
 adf_ae_init() failure
Message-ID: <awAZtk4gqEFBi2CP@gondor.apana.org.au>
References: <20261113145508.1556307-1-ahsan.atta@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113145508.1556307-1-ahsan.atta@intel.com>

On Fri, Nov 13, 2026 at 02:55:08PM +0000, Ahsan Atta wrote:
> adf_ae_init() stores the newly allocated loader data in
> accel_dev->fw_loader before calling qat_hal_init(), as the latter
> publishes the HAL handle through that pointer. If either
> qat_hal_init() or adf_ae_reset() fails, the error paths free the
> allocation but leave accel_dev->fw_loader pointing at freed memory,
> so the device is left holding a dangling pointer.
> 
> No code path dereferences that stale pointer today. This is therefore
> a robustness improvement with no observable failure behind it, hence
> no Fixes tag.
> 
> Clear accel_dev->fw_loader when the allocation is released, and fold
> the duplicated error handling into a cascading goto chain. Report the
> error returned by the callee rather than a generic -EFAULT;
> adf_dev_init() still maps any failure to -EFAULT, so this is a
> readability improvement and not a functional change.
> 
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  .../intel/qat/qat_common/adf_accel_engine.c   | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
