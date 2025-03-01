Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810701C07D9
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740812641; cv=none; b=OGlGNPPUuDyvlI9GKsMvTHfSA4kGvMKReRFgWPo/np6bVhVZjmmGU4DRfQK1FEEGK7Km2hHqdQh5JH0rKBohw08N4FchZLS//i7mM0MtQcHZ0oanyg24DJmvU6AKe5Vr7H+cUke8nQm1psZO87EawxeggqxbM6EupjUSqtsJwVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740812641; c=relaxed/simple;
	bh=Hlb9AP0/fnSDGEAO8LnE1Xv3kElrTOMDTGi2QsNhl5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCl1deaQOX2crT7cs0EcM7PXfSQHnj2PRYok7oj4o3AgyhuKeBISkSFwba3XKfreQTeJUMtIE/7smZ+5Ykl9GcEj5NebFPMq2eqFoK6AbjMtx5JqDYjuvFYIQqbna8795ipwNVMRGtuVFxDBJlkg/JtRq8GC5xIw1tajVw1zaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=q8hA7oPL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="q8hA7oPL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/wZMqZ2Ju9nv88CrsTXF+I4+HMBtyCzE6QMvTsRE1Ao=; b=q8hA7oPLlauPwKQL5mD0rFaWH9
	kroWWQ9yCZ+M1Y/VKeW3LB418ZLIo5wDeRwjb1j9s2hOYvhHOMZq1IM5hP23oeSPZ/RxwIAouUjl6
	eh86LRzTkgQAjSaBmpU4yAkd/rm89iJ33Sd33oojyI0IjHU11QkuUu1lTCElWVqV7mW19//JdH+Qe
	Ml8vLXQyT4d9KalJvWgOS0FokOFgMP07q0kLCIltrJWgXQzIUACcmTlKXsLJ9ywXzdj7btSxxO2pV
	QQdIa15ZSgow91z1JRDYCC99y9ddWTXDJhq+4JWCS1yKn08NOo0hpgt/QGcEYQhf5pmtaY8uWhE/l
	0QsbPj7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toGt2-002mQP-2o;
	Sat, 01 Mar 2025 15:03:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Mar 2025 15:03:48 +0800
Date: Sat, 1 Mar 2025 15:03:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8KrAk9Y52RDox2U@gondor.apana.org.au>

On Sat, Mar 01, 2025 at 02:36:50PM +0800, Herbert Xu wrote:
>
> I thought this was a lot more complicated and you had some weird
> arbtirary pointer from an unknown source.  But if it's just highmem
> I can get rid of the memcpy for you right now.

So it appears that your highmem usage is coming from zsmalloc.  In
that case you don't want virtual addresses at all, you want an SG
list.

In fact you've already gone through a totally unnecessary copy
in _zs_map_object.  Had it simply given us a 2-entry SG list,
the Crypto API can process the data directly with no copies at
all.

The whole point of SG lists is to deal with memory fragmentation.
When your object is too big to fit in a single page, you need an
SG list to describe it.  Forcing virtual addresses just leads to
an unnecessary copy.

Chers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
