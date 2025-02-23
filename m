Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013D822612;
	Sun, 23 Feb 2025 02:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740279190; cv=none; b=a6OeV1Pi0jyws6oioWyDHmxpJDXK0cQcdMiTGqwKUF5T0WSH5mu/aPg0teqjOBmbSFkSKglqNhLcwpXuAtnyvnbIs4I+/a2GIy9hznQnGMz6VVHYnRgsRB2MOrVQ8XNivxz2cG+up4BOtPWA7tDsLozYkAIpHJYapPOGMflGOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740279190; c=relaxed/simple;
	bh=obMnHjuKzoUq/iZrkus0UZUPE91NLD1g1Z0/24mGcfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AY4ONKL/S1wDg5t8CLcVEyybkcLtYR/9UOq+Fhxcyck6H9FHgHF/OqqbN1It7eWVbpfN+PtUvr+zZYsf9VSk3dGTEBxw7f/BIJ2x3sPtcT5AsJEOu/Ejykzfb6CXvIgXNrjFUgbhQZTawdfcpnsSyx5idEUSDjMITJ8v64D4jIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Eu4l0o0p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Eu4l0o0p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WsIJTTYLHxjcB204NYnG7rDohCeWBbckZrZozEyvyPk=; b=Eu4l0o0pBFvhjtYPG2ZpXhUe53
	SGdEdleh3upbVMP49bq/03pc41Zw1b/8vHOfKR4sfsba0ZvwqltJ62Vgd1rgpdjv0JkJHMepJCbH5
	f1QFXZiQ2iiLZv4jFuLGbNWFcS/6egCAZ1c1gA1g2ze5Tq2MjO08D8l190KaIZhcCXj2DzQxU+SrS
	TGNSDqkhRXVHWywbqqdjVQiJEHklqzCoyQ/6lw6TU9/Y4jBc5Y75rcjEgxePWi9W4/mWvb//hkMLh
	WMH+jxHUHrSnQWiydiLyOO1A+L0ecpIjN46Gj+iVhBSEXmr5HYnW5NB7i7r8wNowEp8CKdwJHVO4z
	YsgvF6AQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tm26p-000xMg-16;
	Sun, 23 Feb 2025 10:52:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 10:52:47 +0800
Date: Sun, 23 Feb 2025 10:52:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Minchan Kim <minchan@kernel.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z7qNf4NerHrflmfV@gondor.apana.org.au>
References: <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
 <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>

On Sun, Feb 23, 2025 at 11:09:32AM +0900, Sergey Senozhatsky wrote:
>
> Right, for lzo/lzo-rle we need a safety page.

We should fix it because it's a security hole for anyone who calls
it through the Crypto API.

> It also seems that there is no common way of reporting dst_but overflow.
> Some algos return -ENOSPC immediately, some don't return anything at all,
> and deflate does it's own thing - there are these places where they see
> they are out of out space but they Z_OK it
> 
> if (s->pending != 0) {
> 	flush_pending(strm);
> 	if (strm->avail_out == 0) {
> 		/* Since avail_out is 0, deflate will be called again with
> 		 * more output space, but possibly with both pending and
> 		 * avail_in equal to zero. There won't be anything to do,
> 		 * but this is not an error situation so make sure we
> 		 * return OK instead of BUF_ERROR at next call of deflate:
> 		 */
> 		s->last_flush = -1;
> 		return Z_OK;
> 	}
> }

Z_OK is actually an error, see crypto/deflate.c:

	ret = zlib_deflate(stream, Z_FINISH);
	if (ret != Z_STREAM_END) {
		ret = -EINVAL;
		goto out;
	}

We could change this to ENOSPC for consistency.

If you do find anything that returns 0 through the Crypto API please
let me know.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
