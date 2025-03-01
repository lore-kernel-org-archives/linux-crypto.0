Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A01D5258
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 06:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740811023; cv=none; b=NMe2MNU2jHbQ+Wxap+kdch+lTCk2ofPBIPYMBFaCid8tKMdGbmPPP5gBp/FCkA0EYLHmTMHec9EO7qXgafUN5SF8YTWR80yAM5Ke+kQeP8cu0RRRV13ShqsDiCCeJtDhoMBJD4NeL9ngzZ5vJ/OhYaO9uNH7NoMzsNf9LXL/p9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740811023; c=relaxed/simple;
	bh=uqg1O29GNZcOC9+rtaV5L4g7JvR69c6ieeqtUqMN9ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts43b01FWAuzab8+wSL4cMEmZu7gnNw85B3+LOf8CGlk6yQVUAmRJ/i4sRM7E3NtHD41RdI70Oav8n5t+BY3O4C5IJHagRgbcovRXTGPmyy+mwsmLaTOQ6TSZPAHjPKCIFOCSKRokkJBBUl4qVOCVpIzoywI8X0zA4K/RuNJcUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Yv4zlEw3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Yv4zlEw3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=S4bx2Z1yms0ZFfWUbn4bypEMiaaAt/OjXQd+TmsxwKs=; b=Yv4zlEw3p+0nHyfgHbg6tDWgQl
	/uFwUc2uP0x/NdVQl2Ryg5QHt2SXYtDsT9iUMvJIDaoxwKDWlam7WFvb1moACpSi3j5O+2YuYBDYX
	ZqqUI7bvx18qWhRnOkTvC6QMbsBmRmnxB6IFpaND0HgZmfnWfuvEUK7qcqxx+WLMKqZPN+DZIjltB
	TCAIPLXqnQNwH5CnDsX6WJohd9aQouOIeAcncQnC75iHTU6utkvX23Xdoij6930o06WJRCAN+tNg3
	uiWcgBplDz34unedwBhNud8cUUNtOl/gTJpXUAtJ3I+VYAfihkz0zgaLTF0Lldf0RpoEZu3hUBt4n
	cYmF1VQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toGSw-002mAi-0P;
	Sat, 01 Mar 2025 14:36:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Mar 2025 14:36:50 +0800
Date: Sat, 1 Mar 2025 14:36:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8Hcur3T82_FiONj@google.com>

On Fri, Feb 28, 2025 at 03:56:42PM +0000, Yosry Ahmed wrote:
> 
> Why is the acomp_ctx->is_sleepable check no longer needed?

Because the Crypto API knows which driver uses DMA so there is
no need to check that here.  All the API needs is for you to tell
it whether the memory can undergo DMA.

> Also, the zpool_can_sleep_mapped() cases will go away soon-ish, so I was
> kinda hoping that the !virt_addr_valid() case goes away too and is
> handled internally in the crypto library. Right now the problem is that
> virt_to_page() is used to get the underlying page, which doesn't work
> for kmap addresses.

Actually this check looks buggy.  The issue is that there is no
way in general to tell whether a given pointer can be used for
DMA or not.  You have to go to the source (e.g., is it SLAB,
vmalloc, or something else) to make that determination.

So there is no simple check that the Crypto API can do to determine
this.  We have to rely on you to tell us whether it's OK to do DMA.
Otherwise the assumption must be that it is not safe to do DMA and
a copy is always required.

Now of course this is all irrelevant if you use software crypto
that does not involve DMA.  So regardless of whether you can do
DMA or not, if you're going through the software path it will just
use that memory as is without any extra copies.

The difference only comes into play if your request is routed to
hardware offload.

In fact it looks like this check and fallback path is wrong to
begin with.  It's perfectly OK to do DMA to high memory, assuming
that the device can handle it.  And if not the device would need
to take care of it anyway since an SG list can always live in
highmem.

I thought this was a lot more complicated and you had some weird
arbtirary pointer from an unknown source.  But if it's just highmem
I can get rid of the memcpy for you right now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
