Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97881A2D;
	Mon, 19 May 2025 05:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634290; cv=none; b=c837AIZ6rk+ILyAl3bGofDc/uNx/2PFSGdWsx5mbMfX7DfDcCyRjvq8Vb8YoYNyQz4LLv/SHw/7QaeW4Iq5PhG9IR+avQfKTViC9Y7EiMV9X6YQH9thEKUM0VnJto3aUhz/vr98jsaLU5/udCiAvbgBAlSytn4WmRXjDM6mldos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634290; c=relaxed/simple;
	bh=KFhosAFVYMcWYd1+oFgQon5+ArT4OVTpFWiDyovRQlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAaOIJ6BEbnPMhXZHEqdFzVHGzCGTIiJKAA3ir7xIdq0wuY/tAC2HSbe/+2aBnQB15zMd7mgPZdIv4VCnBQZzQZULvCbvNHkFYcmvrOT+57UFTDspcgXIbZ9sc5lN4Q9UgA51KOdpOCyYJEuuNmGUzrhPa5azPKx/xraWKUv/08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TZdxRaVx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TZdxRaVx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4KT6cUbz6JBlnZnp44KqbJaiklMh9glQrgRzRT1/6/k=; b=TZdxRaVxxJIW1AWRtqr8r1QtSA
	1UbOCaURz3hJaYmiocGv+acLjE02v7WE/EsEbCyenZEx38fzphm3WhBaMGX4SSz0zsg2f3WtEA3DB
	Atfm7eJC+ZvFAD2NLUeB7W5b9MbZb+ojxpXYqs7XGt2adYxroaR7gMVvkpeEy7oJMgMBIGyVhPi51
	uzmUnvPbVuYH/bupQwh6iFM3zi5HWxe29W5rGfOGCYS/sMI/ZtxyLw+F1YEegx0r1NM/1a2m34Neh
	Uw761audNi7eZDMLJziVY4Xcp9hOAPz9t0mq9lqJWATrxI4Icn4ETiFa2TmM2zkL51lw2GWzRWjdM
	v0EKxziA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtVj-00781L-25;
	Mon, 19 May 2025 13:58:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:58:03 +0800
Date: Mon, 19 May 2025 13:58:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: John Allen <john.allen@amd.com>
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	linux-kernel@vger.kernel.org, mario.limonciello@amd.com
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x17D8
Message-ID: <aCrIa1cgC8S73XGU@gondor.apana.org.au>
References: <20250512181705.2428-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512181705.2428-1-john.allen@amd.com>

On Mon, May 12, 2025 at 06:17:05PM +0000, John Allen wrote:
> Add a new CCP/PSP PCI device ID.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
