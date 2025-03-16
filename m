Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CD027702
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742100295; cv=none; b=Hw5DjcOW/v0ORccGf4Wtnf68m1co5QXssNTQC+NSTvz17zQSru4EyvRtPZrJp1LzLgabLbq7vozlaT0g+sOtCQFhydPxGdhfyCDZh3Wr/44ta4DsEGbFXrU2n+1UKZnkg4u7Z9e5jxgyqkDDdjDILCSp2MHJFx6bU+xT6C2zDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742100295; c=relaxed/simple;
	bh=dXSRXAJLqRjwsRgrgoBHPfQfV1UaefHAcBYLxLQ3Vl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFaAg7FXPJVrG3YwkxRR0N0UVJWQPp4YZoeeBImdSPh1oNiMIt72x+wMsc+KLMdbdmX1Vqr2uTFk/wFK0be9FLVXO6actb4pLOdB+gSVh/n/cerWhvrM7EWQlZjFVIJP9Ax+uLN9UrlD/7uCXgthUi00NI4Ng470y/oVqu8OH9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dLzcAPAm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dLzcAPAm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=byhxYkr4VzW/xizG1Mej48+a8D11dGdfCyRAJP/5K3U=; b=dLzcAPAmO8VvlMEzWFoSeIbFEq
	PdT25JtvcgVj/XjzfH9ByYTJvIYTgoDDm0N23+0aCXmpGR5KhLPDl+VacWYBXjCeMbzIc6Zq5Iebz
	PoBC8f1X6NGvFWrO6TYYVwP8BLlZb5BQJFXPA9YqNE47ARx+Cyo+oUJWhlYgA21PJ6n8n2gSpt0zR
	Xt5xrPvRV0S8qUlPZP75FiIg9Nkkh/ymC0dX65biVB2s6vLSbRL1GyChhdYIhxR8Ahl5EArpTWxI7
	GRvJ0sJx6tTxG4O+r9r1xHobweJp4RWSdVvAIZGCLJX84wbe+4kucSy+p1PDnLrNmqFy/Djyey5Eg
	C/6M3vNA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttfrl-006yzy-1U;
	Sun, 16 Mar 2025 12:44:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 12:44:49 +0800
Date: Sun, 16 Mar 2025 12:44:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 3/8] crypto: acomp - Move stream management into scomp
 layer
Message-ID: <Z9ZXQdCaKYoU6FU-@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>
 <20250316043631.GC117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316043631.GC117195@sol.localdomain>

On Sat, Mar 15, 2025 at 09:36:31PM -0700, Eric Biggers wrote:
> 
> Well, except the workspace (which you seem to be calling a "stream" for some
> reason) size depends heavily on the compression parameters, such as the maximum
> input length and compression level.  Zstd for example wants 1303288 (comp) +
> 95944 (decomp) with the parameters the crypto API is currently setting, but only
> 89848 + 95944 if it's properly configured with estimated_src_size=4096 which is
> what most of the users actually want.  So making this a per-algorithm property
> is insufficiently flexible.

We don't support parameters yet but yes this is something that will
have to be addressed when we add parameter support.  Per-tfm for
non-standard parameters is probably the best bet in this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
