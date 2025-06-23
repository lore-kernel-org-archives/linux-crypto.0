Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395522FF59
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670488; cv=none; b=G2L9L+K5DVeTUGeI0l8M8L3uzgCNnsDszc0Jj0hHP4avvrKZaiaT6Sfj7bns8Lts7tCiNjnO+FxlfdDfezXCEppUH2mNV8YbiUUxvvURNF50yEdc0h1ukc4cDTFfLrpE++zEosQB2e+YE0mQly0OrUsKdraHhzibf0ssPbiZ7lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670488; c=relaxed/simple;
	bh=A22vFMh50fEOLDgRwZYjTQlQPDhIBRDIRrVQ8efkupg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNNWA+/kPn/OaejbBNhESa+r9SK6mFIK6NHfl2vBojWRgn1qdtQmm7Eb/uWZ2PxjYa53/1X7iluRxixMvTa/aw1Rs9bd0/DhkzPOmWajdBDpf/oMDC2FP2f4WoKBWlWJkaSt93x3r2FyAYBeGwhWbqbxzSvPeoKFEvhXz8JZMu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nGGIzlkN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nGGIzlkN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pmdTAGjNh1+lxEVvy459tRks02jgR0uhJ+P3mWdLcvc=; b=nGGIzlkNMV1CTn+uINQrS5ypwd
	GZ1bsGMNQ8PBNYbc4Pfdgc7U0ChIvD//yOlulJ777vbvnnG5GIK9AlWYQRy3RV6aBrl6B0Mq3nhO+
	2uQyaWFnVUe4CR9XGnIJ9qJKhCtPe+WKvrACzrCkTdV+0gsePQD+Gd9GeBWAXkkOs7r/ZSH6rkTF5
	IRYU7xHMZuTDrADXIXSeJLeNj0xy9cq94AogVKBUzj3HqtNzwaCYZyDcNBqIpWMmlCNSQ2vrqBkCy
	3WCbHxcmGdbinTIz/NFiSVVYhLXFPdcGPSJ6SQrFIBC7RKdRJRPx9P6FKDj679wf0p7EMyXqp1NY3
	fIoFkqJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd7F-000FaT-1q;
	Mon, 23 Jun 2025 17:21:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:21:21 +0800
Date: Mon, 23 Jun 2025 17:21:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [PATCH v7] crypto: zstd - convert to acomp
Message-ID: <aFkckZjBA4ItSh6f@gondor.apana.org.au>
References: <20250616031944.761509-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616031944.761509-1-suman.kumar.chakraborty@intel.com>

On Mon, Jun 16, 2025 at 04:19:44AM +0100, Suman Kumar Chakraborty wrote:
> Convert the implementation to a native acomp interface using zstd
> streaming APIs, eliminating the need for buffer linearization.
> 
> This includes:
>    - Removal of the scomp interface in favor of acomp
>    - Refactoring of stream allocation, initialization, and handling for
>      both compression and decompression using Zstandard streaming APIs
>    - Replacement of crypto_register_scomp() with crypto_register_acomp()
>      for module registration
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v6->v7:
>    - Used __aligned(8) instead of  __attribute__((aligned(8)))
>    - Used mapped address from the walk object instead of sg_virt in
>      zstd_compress_one() and zstd_decompress_one()
> 
> v5->v6:
>    - On x86 (i386), u64 _align only guarantees 4-byte alignment,
>      which causes the test to fail. To ensure consistent 8-byte alignment
>      across all architectures, explicitly specify the alignment using the
>      __aligned(8) attribute.
> 
> v4->v5
>    - Swapping the order of acomp_walk_done_src/dst during
>      decompression for a single flat buffer.
> 
> v3->v4:
>    - Added acomp_walk_done_src/dst calls after completing
>      compression/decompression for a single flat buffer
>    
> v2->v3:
>    - Updated the logic to verify the existence of a single flat
>      buffer using the acomp walk API.
> 
> v1->v2:
>    - Made the wksp address to be 8 byte aligned.
>    - Added logic to use Zstd non streaming APIs for single flat buffer.
> 
>  crypto/zstd.c | 386 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 249 insertions(+), 137 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
