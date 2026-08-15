Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E016312814;
	Sat, 15 Aug 2026 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757292; cv=none; b=fNfhZwyPPnH/UO75Y4/O8m5HhWXQSsmhbSRd6QPZEarlp0a1DSF7SfGzZGPRfjuKTFZPTpydYgfxITp9WA8AgQMjOG0fcqaoTiZ+2BoIcF1r0YtJ9qBMkiYbv6XPK2g2DQkQY67ysBtzSBqCPACV2Y0+AcJGTEwFc4yjQNVKuyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757292; c=relaxed/simple;
	bh=i8psI6C/EWkgE1agJYuu20V7N7q/GhFtr6v4aZRaPQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnK94UitKT5VhpfMNssiECTrhJgN0HzvArMMWtrk+o+kYEiQ+B3LcYyD8Fw+ZMKZZ14TQcI+QAgxyj6LNAB0gb2MBKrghHwMQz6h6Q/8Ikq6eZs9H3WfwYTyLDfHbVDFDbb3+PArfUDBtoU2veNOAalzFbnROJ8vtBlS/FKlNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MobjhtXl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MobjhtXl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=r1PYX+dy12H+xNJtrAohlzrViOsVWCnSOZLN4/ka9oE=; 
	b=MobjhtXlCrYQeBwJp/hpWdl5+QAgHNU/OjrV7USnDD+M9YKRlQG5Cw3cftDmwdHwOEQh8R1FX9Y
	5Y2pFk+8Rr6yqCj45WlGYPHyNKBPzZ6PXh3RGjUB9afQBV11/t81gtw+pYJm0JgfoyKTiLVhUU+3F
	Qn4MzjNyMuA6T62Cmndf86Hrun2VqWTA14o7UwtcJwpKRxaH1rhQkUo28KuqH1JLS6ah5E/fwV9OK
	F18POw0J3VK/fnpRjyM4wv7moAVZ3WNOh/CSTIkM0k36pNXmouGQM5znEDLckfcLbSozlJ9KGFLfo
	UZ0vLBhMrvcx7HRmGyYSbgkhLFBZKeu18vlg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3Br-000000054yE-2pUw;
	Sat, 15 Aug 2026 09:28:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:28:03 +1000
Date: Sat, 15 Aug 2026 11:28:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] crypto: iaa - Fixes for multi entry SG lists
Message-ID: <an_AozAC9YzCZzIp@gondor.apana.org.au>
References: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>

On Wed, Aug 05, 2026 at 02:19:21PM -0700, Vinicius Costa Gomes wrote:
> Since commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs
> from zsmalloc"), iaa_crypto started seeing some failures with
> multi-entry scatter lists.
> 
> For that we introduce software fallback, in patch 2/5, to iaa-crypto
> when SG lists have more than one entry, for both input and output.
> Patch 4/5 adds a bounce buffer so small/simple requests can be
> linearized and sent to the hardware. This recovers most of the
> performance.
> 
> Patch 1/5 updates the default resources reserved to iaa-crypto so more
> engines are associated to the iaa_crypto group, resulting in better
> utilization by default. Patch 3/5 fixes so software request "bytes"
> are not counted as hardware "bytes". As the idxd changes only affect
> iaa_crypto, sending them here makes more sense. Patch 5/5 fixes a
> pre-existing issue pointed out by sashiko, that could cause data
> corruption when a hardware error is reported.
> 
> A potential use-after-free issue when a descriptor submission times
> out, pointed out by Sashiko, still remains and will be handled on a
> future series.
> 
> It should be noted that as the software and hardware implementations
> have different expectations for the window size, something like patch
> [1] or the future 'set_params()' API are needed to verify that patch
> 2/5 works without patch 4/5.
> 
> [1] https://lore.kernel.org/linux-crypto/20260326100433.57324-1-giovanni.cabiddu@intel.com/
> 
> Cheers,
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> Changes in v2:
> - Added patch 5/5, for a pre-existing issue, that touches the same
>   code paths as this series (Sashiko);
> - I took an old version of Giovanni's patch 4/5, new version is
>   simpler to read; because of changes did not take Dave Jiang's
>   Reviewed-by;
> - Added the missing Signed-off-by tags (Dave Jiang);
> - Link to v1: https://patch.msgid.link/20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com
> 
> ---
> Giovanni Cabiddu (4):
>       dmaengine: idxd: assign all engines to group 0 in IAA defaults
>       crypto: iaa - fall back to software for multi-entry scatterlists
>       crypto: iaa - avoid counting fallback decompression bytes
>       crypto: iaa - use bounce buffer for multi-sg decompress input
> 
> Vinicius Costa Gomes (1):
>       crypto: iaa - unmap dst before software fallback on decompress
> 
>  drivers/crypto/intel/iaa/iaa_crypto_main.c  | 270 +++++++++++++++++++---------
>  drivers/crypto/intel/iaa/iaa_crypto_stats.c |   9 +
>  drivers/crypto/intel/iaa/iaa_crypto_stats.h |   2 +
>  drivers/dma/idxd/defaults.c                 |  12 +-
>  4 files changed, 201 insertions(+), 92 deletions(-)
> ---
> base-commit: 947d62c094367ef6064907d570b47612cd579df6
> change-id: 20260713-iaa-crypto-fixes-zswap-ff5baae311d1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
