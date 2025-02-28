Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B86D1F3BB7
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 08:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740730401; cv=none; b=ujRCkpmITA1PZstInAlJbomnvBPxr+bzc5TbqZ4p7REBbddIKSw2BVLElnq5QkgfqSW/KgefKcdLD+uLTnSzoKQmVoGR+b9Usj/6+PgdhRHN55MhVBZNrFX9vc7HZClnZprCo94PyB9e1xR3MWj2DZhITtu3ph7FgU/Uk/oTZZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740730401; c=relaxed/simple;
	bh=he1Qodgc0ftkVGsAlTlGKPXEwxyRbmgGHQaLbNMp2OY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P58/g6XPWYkoinbAsw/bFKEaXigCvvWU+1RwHJW69EuxgcIrwLnHKccg4pWbcG5XfOwFNu4YJnO1K4pOnfvOX+mj+XZKTZ5iEoeBw+UG4/mJpPUEgs2xXoE4gDj0Oo1YCzxWJ/QjZUWyaxMbzE0C3ZDuBw7Fi4Dg9Ymu8wSViEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rm92Syh7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rm92Syh7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WhLoH34A/flsVGOIlPLZ59ie9UdXcSnOeKV2LDW9aUw=; b=rm92Syh7FyZHE+LKh+u8uRYVAx
	fCGNRNRqBoFskaC5kKSEfv2bdehKFqTgpgTgRMJfcjz44xB/GzMsU6rYkpdzQfN3HB3ueNA8jf6uh
	OqXQ7fRfjotEbQDPYpmsdmKsHph+UB+5mIpbkdZodALPHT+H3beqn4AC8WB+Ch48BJsGxjiU7p+Uv
	Jy01fBBLu5kKYxOfE1Qjo31MMyFUXzPjm01CnL7CEGThI8fEc8pEicKwRIw6LJ/EMIMkRoprnBaMh
	9430KxbywNQNyxIEtJtAXP81YUKVmdSJzez/CnPCbJFujSPRl3S+h+gWcCSeIm7KtM4zDdPkTB1V1
	QXDICdDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnvUa-002VcO-2J;
	Fri, 28 Feb 2025 16:13:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2025 16:13:08 +0800
Date: Fri, 28 Feb 2025 16:13:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8DcmK4eECXp3aws@google.com>

On Thu, Feb 27, 2025 at 09:43:52PM +0000, Yosry Ahmed wrote:
>
> If we cannot pass in highmem addresses then the problem is not solved.
> Thanks for pointing this out.

Oh I didn't realise this even existed.

It's much better to handle this in the Crypto API where the copy
and be done only when it's needed for DMA.

I'll respin this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
