Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5860F1D86E7;
	Fri, 13 Sep 2024 10:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223524; cv=none; b=pfc0yZMybbkw7glzb6bG9kLTIeP2ekrk+oZ01N3wvWgVUm1zIqsNq4MtCpptpgsYZORhCp2YbgM49rgKRGP6taI9Cym25+XgZ9G3f072fiIfqlrOz0qmNg2FQ1yNMCI8mlCH1XvTWNByg9yvoEd3kcolWMdnsFkRlAXEsN5BC58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223524; c=relaxed/simple;
	bh=7ivd+WdK+aq4MBObNeNCEIVPW0kKaRjKQTPOhGgbDVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gre9kt5Cbq5ese2h98H3KMbPqqnM6S/jHrunPUrdBA2QXczh3Yv+15c0hv2lDN1Lh2iv208/6SWX+y7oeDnngSyzoK6H7JlFXehjJ+OrdI1wA+Eo8oXHulvd+Yw3/ZqJKJNeO48nnNVcoNlc7jXZ4ealu0+AyuvwVmf0W2jC4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pXGgtSFn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pXGgtSFn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=quFk3WgZg9+egnOYr8N0RhUmwCf0tv4Den6aqX8Uawg=; b=pXGgtSFn5uzbCKq113TpYMrD+A
	7ReZAKi7UKQor27EN/eBGVdZzhbxhbEsZiFAEDsr6lvqUORQDqgmlD+AsLG5UXLf4YO3u0ijwC1pF
	1+JSpoWG2rV18m3HKFf30cUpfPEFBHtdfgJIcZbF2iwCoxrUiEcd7KuouzhsBnDckqEagTT0N3XnQ
	9wbQvXYvx4ZIejJcFMQ8WIdcDQSddsH4ZY8Kw5bebZUTISkuysDHkMks0j+JtPk6/5jvRQpN474ms
	iRkaYZhX3RwMvPx+3POz6rYrqV/1Wh9wFZBkY00qvxMMW7QDjtVEZxXyYyhLND50HHR3+R9xfdjWw
	GcqOP2Uw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sp3Qr-002DwH-04;
	Fri, 13 Sep 2024 18:31:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2024 18:31:54 +0800
Date: Fri, 13 Sep 2024 18:31:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Yufan <chenyufan@vivo.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com
Subject: Re: [PATCH v1] crypto: camm/qi - Use ERR_CAST() to return
 error-valued pointer
Message-ID: <ZuQUmpO1v07tXDuE@gondor.apana.org.au>
References: <20240906104327.72221-1-chenyufan@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906104327.72221-1-chenyufan@vivo.com>

On Fri, Sep 06, 2024 at 06:43:24PM +0800, Chen Yufan wrote:
> Instead of directly casting and returning (void *) pointer, use ERR_CAST
> to explicitly return an error-valued pointer. This makes the error handling
> more explicit and improves code clarity.
> 
> Signed-off-by: Chen Yufan <chenyufan@vivo.com>
> ---
>  drivers/crypto/caam/caamalg_qi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
