Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37273F9CC;
	Sat,  5 Oct 2024 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106214; cv=none; b=c7KKBWjL05YKajhXgkI8g6aI/PYs82ksoCUb5wSQd4ZNX1gdSAbA+w/u17I46A/0MQOU0QJjhyhZ8S6LL39nUXZzRBceybodzQKQv0y2SAcZxbhifqnXOGgyPhdW6hGaSXQf63JJtMIGm/CiGr896LAoBG30qMa2oC82yaw+z9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106214; c=relaxed/simple;
	bh=iMLvLpJSZj8POdkM9kL78IoIXYLyMWTnpDjK0BArSTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0pjI0xQD0JFOic5YwDJutMS2QD86/9/+JOW/3HjxlHoaVeKsA+sUeHtmqT+ZR9bayRf1JZpUBePRJHtIIdq9sr1d5E+mXRRHe4drz0+tBcNhgj7ike86s55QqCkgxRHnW4sL8GS8xeOY/2qJR9KvzD7VVLuSDR6nEnrcYzsgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=apjMNx4f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="apjMNx4f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=22G6hUsHewmhwV2ekiJ9Lvm0h+XG3V2n6wsZ7AJFomI=; b=apjMNx4fJVxc0ahgE/I8Ov6x1J
	OdixjTPWdFkp+GF2sBDaOA35LW+LCwOiw80aWeUa1s4Ts9BrxoudZ5Kl/2HQrioo0WIARFuj2yIRS
	ZpxlXLP0TwKMIDs8a3QBlt3gNnEBOZl2Z0Vj+WuhGTQ93n/RDK0y9cu5Jq/kNGXk2qFw6CaHkqWBD
	ekhZALJG6ssGxevISNNGMLH37TFMyTGgiCkXznhlyWgYhi6GYrSMiYlLnJ1FjEUrbxaMRg7PMimEq
	xZwl1JSUXSKd+cisMNDQaJE1s7GDP6Ybe5v0auL8fTHpce3/Nzy7ixTo5JLPyRTgE18I3K4t0m2fT
	SfeVJguA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxCr-0071Tj-28;
	Sat, 05 Oct 2024 13:30:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:30:07 +0800
Date: Sat, 5 Oct 2024 13:30:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tomas Paukrt <tomaspaukrt@email.cz>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: mxs-dcp: Fix AES-CBC with hardware-bound keys
Message-ID: <ZwDO3zqppqOZeSLg@gondor.apana.org.au>
References: <1Wx.Zci3.5c7{vqn25ku.1cv07F@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1Wx.Zci3.5c7{vqn25ku.1cv07F@seznam.cz>

On Fri, Sep 13, 2024 at 11:11:43AM +0200, Tomas Paukrt wrote:
> Fix passing an initialization vector in the payload field which
> is necessary for AES in CBC mode even with hardware-bound keys.
> 
> Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys")
> Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
> ---
>  drivers/crypto/mxs-dcp.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
