Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA5A5695
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717132065; cv=none; b=fPOgsk2/rvjDh7DDmA8yZ7Jkb4ZYMIGpEhu1OE8JkHEktgd6zvnxcGZ+X75BFi89zatYBRE85VE1EueCW65/f5DhdjupbVxCRENMLG2R9C2aCZCaINKYkBMmyj3aHWD+DXbT6Mfq4DTNyaPviqdkpUVg98T20c2STY2hFtN2Ibg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717132065; c=relaxed/simple;
	bh=QU4+zmKkFq/D+7dXNJRL+WyJ6vqIzj4oQMoNX99GAz0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWAwR3O6IZHJvrGQaSXPcUICoSQSz7VirxXD+XYQTgWl2Sb2hUH946x/7vkXHPwQjKAsj+qF3PSuP0PQtm7KQ+41pn70IKdeccpuRcXhkK0XElGwMYGSrSkfnyfa8wUicGkwZ8U1ItjjV81mGAPvGmg6zCCWCY8nuyH+adQnNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCuUM-0044as-35;
	Fri, 31 May 2024 13:07:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 13:07:41 +0800
Date: Fri, 31 May 2024 13:07:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] crypto: acomp - Add interface to set parameters
Message-ID: <ZllbHYL8FYlrCRC_@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1716202860.git.herbert@gondor.apana.org.au>

On Mon, May 20, 2024 at 07:04:43PM +0800, Herbert Xu wrote:
> This patch series adds an interface to set compression algorithm
> parameters.  The third patch is only an example.  Each algorithm
> could come up with its own distinct set of parameters and format
> if necessary.
> 
> Herbert Xu (3):
>   crypto: scomp - Add setparam interface
>   crypto: acomp - Add setparam interface
>   crypto: acomp - Add comp_params helpers
> 
>  crypto/acompress.c                  |  70 +++++++++++++++++--
>  crypto/compress.h                   |   9 ++-
>  crypto/scompress.c                  | 103 +++++++++++++++++++++++++++-
>  include/crypto/acompress.h          |  41 ++++++++++-
>  include/crypto/internal/acompress.h |   3 +
>  include/crypto/internal/scompress.h |  37 ++++++++++
>  6 files changed, 252 insertions(+), 11 deletions(-)
> 
> -- 
> 2.39.2

So does this satsify your needs Sergey? I'm not going to apply this
if you won't be using it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
