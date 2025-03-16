Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C2EC0
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742100372; cv=none; b=rviY6g1rb8t7KVCKv+97KshSRcxGoQGrg4VVdm4PjNsW/kM16P1vKyJnaHuZpYxPob2EhH0/AI5zql8OPNELZwHhbwkYV6w5ryx0xon+ujwlk+9hb6uArxhkpmbBdWN9paRMxCQUhY/+UfO5pNu3STafifEWD25vZu4V0G5rubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742100372; c=relaxed/simple;
	bh=0jievc55IXNe4sF4vbO+7qx3KjJ5ZbOXrvSLXfofb4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ab8fIzvCUOoqA0j2Dzac67X/vAFzxmpRbL136CBCQYaThwDLbPe9WjzrwPmb2zLhJ9Tnzf/J3Zac2JGpFs34pbtyr0apaWcU3B1o88kvMiQaRlAqZec3AIM0c1UDVdQGYeRtBaGtlvWQDWZQhkYmGs7htrUmmSXYMfdo988dfaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lO4WSJKz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lO4WSJKz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ORR9F29R6VdJMrQWVHATYJLtgX8Kht6evDiG1RD6RwQ=; b=lO4WSJKzHB9PymtYoo+8as9A70
	6Yts5c76YyyyVzLMW+4X1YybOxsmw8TXPlfII79WR4cIJw3LyDxRoLJIrz+/BGEvrcAxzM84ExaZ2
	Kb0AwOyCp4RuZt1Gqbsc/3Ri7Z8CABeP7I7/xLwAD6ehBBPtJkNHB4gBJYspbNy0+Sc9rf38wHnEq
	RAgblQRVqMnTu8Mknd3RHHRP/i2i2h0oc7kMo7ANlQCL2DC2TFolej73I5nQ4pWo6zI1Pu9l++iNF
	og9re+1DJu8o3tZbi3A+P3aEEtUT2jqNdGLGShHN3JPsJZk43ROCDgTkGdh18z0UBoI5dMgCQqmJY
	6WSZS4wg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttft0-006z3L-0R;
	Sun, 16 Mar 2025 12:46:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 12:46:06 +0800
Date: Sun, 16 Mar 2025 12:46:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 3/8] crypto: acomp - Move stream management into scomp
 layer
Message-ID: <Z9ZXjvjDMouBAKV5@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <25f96a0e0e642e9d1c6014b12b00fd21b9f9c785.1741488107.git.herbert@gondor.apana.org.au>
 <20250316043631.GC117195@sol.localdomain>
 <Z9ZWyGpILLHTQzhf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ZWyGpILLHTQzhf@gondor.apana.org.au>

On Sun, Mar 16, 2025 at 12:42:48PM +0800, Herbert Xu wrote:
> On Sat, Mar 15, 2025 at 09:36:31PM -0700, Eric Biggers wrote:
> >
> > But of course there is also no guarantee that users want it to be per-"tfm"
> > either, let alone have a full set of per-CPU buffers.  FWIW, this series makes
> > the kernel use an extra 40 MB of memory on my system if I enable
> > CONFIG_UBIFS_FS, which seems problematic.
> 
> The memory is allocated on first use, or am I missing something?

Oh yes ubifs is unconditionally allocating a compressor, that should
be fixed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
