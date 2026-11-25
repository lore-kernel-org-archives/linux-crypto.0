Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795596055;
	b=H0pRA3EIAuiyPEOPlbvS/G5pbGFU/bt18e4MeV0aB5ZmatiUunWEzWMeU82fLicelqe3
	 VES0fozyAJzf/spyLlCiErGBTSbGNI4+lUZDUBLpqIwsXfOdNDeBdhokbysKlvUPH5GDG
	 ce4P2XqAKk6kYm/Cg9qCMDCuwL+9mDMQTZWivPSDKV/AW2/cSrhMRUSLT4lpZW32s8EfP
	 O28nfk9n8rH1WMl/h+7bqfj/qPxf/Tc7XfFO+W+/Bfg08Wfn/hCv3XEgmia2EZGzWHzVM
	 QodcVX4APC8wm1uQ6mGU81665yaO2lHRKsnFuPnk/rCp3vzSM8703tJZaZfnm/xUdoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596055;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=dYsFcUK8+jsj7NvG+f903DGBWyTaFCEj4VNhYRMj1Ts=;
	b=q66YJZ3bjpJqn9lI/qgmesto8+86jagTJScJKjvUUl8/JmAeYWLromovcB2eGkhdO6kc
	 IlI9xIuWF1dtWfq6K0SYsftx9kEbHzVWYHkK6w9n1yNbkVlo5XBHjBVfTc4Ae1snKuSrT
	 b1NYLGXX7uPj9/2pMDBqWHDI3MUa968neDVEJZbVBh8uATWup6xAeIBa5TqhPGbT3HtQZ
	 gcAbfsjEcMwFqNt7DBVCPLOg10o/V4AfG7OWmyVosJxn2y1/ysDxVFAsk8vi5CVzopVX/
	 AGhZIF4ksEleDDvHhiKCVPsY3V+V2Y5cJjIynxsjP3auFRSnNPCUMPYQlKqyFT3Hwag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oVTZiYBC;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A460606A69C;
	Wed, 25 Nov 2026 08:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A460606A69C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oVTZiYBC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dYsFcUK8+jsj7NvG+f903DGBWyTaFCEj4VNhYRMj1Ts=; 
	b=oVTZiYBCgZc8JC08TT5kespwNby2k9ZUVlXQ4WERhVgTj2JpXDjezNg282p+5J9l2Eld9dCZjCT
	5pm3gqOdof2K/Pys0suDySqz82z4xFaEvuO0WjCH+Kr2318xipOh77qkGnA4efDUURjQv0bzV7mOm
	AKXNdiJfbf8eQnJaAvI96WY0vCrELboFkqEqTn4crF2aQVaY1l1JeUMcTVviXMjs9womPqajC02ZA
	YG9ZTzqKz4DGhiW5vpLVobmBy3HkmDkqOMl84B3XzabkFVSXO4whbtOV/1ahLu7WVIwJBGXVP9hC8
	JBjWuOvsec/lLSTp7WxYqqyrkXaHId2I/fcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xW8YR-00000001lAN-2nk4;
	Wed, 25 Nov 2026 16:40:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Nov 2026 16:40:39 +0800
Date: Wed, 25 Nov 2026 16:40:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awafBxDtUoIQW9iR@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au>
 <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
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
In-Reply-To: <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>

On Mon, Nov 23, 2026 at 01:56:19PM -0800, Kanchana P. Sridhar wrote:
>
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index df9e42f519c3..f0ff821b3560 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
> *req, int err)
>         acomp_reqchain_virt(req);
>         acomp_restore_req(req);
> 
> -       if (req->unit_size)
> +       if (req->unit_size && !acomp_request_dst_isvirt(req))
>                 req->dst->length = unlikely(err) ? err : req->dlen;

I think this should return -EINVAL in the sense that using a
virtual address with unit_size cannot be supported as it makes
no sense at the API level.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
