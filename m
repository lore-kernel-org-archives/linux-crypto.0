Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D3A264FB0;
	Mon, 28 Apr 2025 11:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841267; cv=none; b=PTW8fpCa+TPZH3lOgR4OL3J45GCFwl13fMEIUm6HtTC/QfmSpt+986sYbmdbxmK3ShRPCJNgmucTXdGSm9ekA40tncTznPXGTUVXWKFlv4bkbQkgPLMP2fVP1Sp3/xKiy3Hon47Q9+GaeRklsZvlnL9Mih2JrvOgg8LkSqKbkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841267; c=relaxed/simple;
	bh=2gW/3ZhGsbWDX4ULKMFedeuPuNECOa1UrqfTitYosNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYWnL0LNHegEuOmLFH/hm5ta0VUApS4X7bp+Lb2uLybI+iorb91BqKrY9df1CyBTvK4464fX7NGkxFKprv1Y+PgPXKDWnwCfsMU3Dw+btbDBFRaxjLmKAE6o3khOZ6X73PfmG5BFC/rzUkYsORj31Ho5+uZlH4WVxTmX+VgNQ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rkHY96nA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rkHY96nA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HFZGTAyifmag2K0gSNBO6GGxUDjj97u9ZKLwccoI3jg=; b=rkHY96nA59bIK2vNpVgqNjL0AP
	eoWja533yfLBMc1cgVnzrYzpVjbC8RWd43BZZoAmPwoJhr+X1R0UuhZS6H/WDNVple6b6otwjwlsd
	uaiy3NLOIjy7gO22ywz0j78uyHzh0p4Gk0RCPV2/6Q0zP/pLtiStvSb0XtYuuGD1tQ0nk3l4v04PI
	aZAgSLBVOTjQnHV4nZOuNXyC8gUueOmm+P1m6hfOe3cEOxnDfSndEJ0u+iF4eTrpoNjD9eDuvQnOf
	SyEF0D6EHrEx0TUN4KdgHoKXVEzvdLiyG8hJl7nk1mCbrTAxuDDvxgU0kjMhl5/NGEwB3QxN7ibKD
	47WA9aaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9N3n-001bKJ-25;
	Mon, 28 Apr 2025 19:54:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 19:54:07 +0800
Date: Mon, 28 Apr 2025 19:54:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Simplify multiple return statements
Message-ID: <aA9sX2NppsF5wyKL@gondor.apana.org.au>
References: <20250426222621.2104-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426222621.2104-2-thorsten.blum@linux.dev>

On Sun, Apr 27, 2025 at 12:26:19AM +0200, Thorsten Blum wrote:
> Simplify multiple return statements by directly returning the boolean
> expressions.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  .../marvell/octeontx2/otx2_cpt_common.h       | 34 ++++++-------------
>  1 file changed, 10 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
