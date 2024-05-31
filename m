Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C6B139563;
	Fri, 31 May 2024 10:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717150865; cv=none; b=GD/6D3n3Bh2wqsgX4otBqODz1V+NjWSKh4FYSNSZWv0M999xq1qHto0P+ZWeEbitFQerRcO533/EyDds+mp/LS82deSQAZHW+SWjVNlhv+gNZel7WezJjX0ULOPwGfyXagmyUB3lzLda/Ngp1Yz9BdDDhnjKr98bQeebdEog6WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717150865; c=relaxed/simple;
	bh=bXIPqiUhKZS885E6lJgHjJKlC+DBa4ZEfw4jOQNSvsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=McdR1gZxwAZOfC72M8UyzHdzpMgPZRNTKixgkcwHwBdukMMbqyfKlXB6K23Z/JSUIm5Oj6hwBybJ2r6yx3WURA2usKYWu3G+sQAzX1YE8OmCzV/+jBQnQRoGJCHPZyJrjUC1h/8CB1sqpBJwkDMAHPfDYjCwyOG1e1ArDHjrvW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCzNQ-004AiX-2n;
	Fri, 31 May 2024 18:20:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 18:20:50 +0800
Date: Fri, 31 May 2024 18:20:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Danny Tsen <dtsen@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, leitao@debian.org, nayna@linux.ibm.com,
	appro@cryptogams.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
	ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH v2 0/3] crypto: X25519 supports for ppc64le
Message-ID: <Zlmkgisql2NxPcXi@gondor.apana.org.au>
References: <20240516151957.2215-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516151957.2215-1-dtsen@linux.ibm.com>

On Thu, May 16, 2024 at 11:19:54AM -0400, Danny Tsen wrote:
> This patch series provide X25519 support for ppc64le with a new module
> curve25519-ppc64le.
> 
> The implementation is based on CRYPTOGAMs perl output from x25519-ppc64.pl.
> (see https://github.com/dot-asm/cryptogams/)
> Modified and added 4 supporting functions.
> 
> This patch has passed the selftest by running modprobe
> curve25519-ppc64le.
> 
> Danny Tsen (3):
>   X25519 low-level primitives for ppc64le.
>   X25519 core functions for ppc64le
>   Update Kconfig and Makefile for ppc64le x25519.
> 
>  arch/powerpc/crypto/Kconfig                   |  11 +
>  arch/powerpc/crypto/Makefile                  |   2 +
>  arch/powerpc/crypto/curve25519-ppc64le-core.c | 299 ++++++++
>  arch/powerpc/crypto/curve25519-ppc64le_asm.S  | 671 ++++++++++++++++++
>  4 files changed, 983 insertions(+)
>  create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
>  create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S
> 
> -- 
> 2.31.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
