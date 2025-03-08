Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924EE1917F1;
	Sat,  8 Mar 2025 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741422569; cv=none; b=Wy0eSDzhHw6itN75gJ+A8SjoAmOOsP4pw4l+TFID4IcVzyuGOyp1XdyuRWv8oJDg4uzU4UoplSauMMzxuSgOcqRqaPbN3IYYhFch5THsrTGPo2rQ5HHHpT+j2nNdNhf+KMg8c2ka9dORt1EByr3aQ1cm9CTTLn+ahPNfyQBZdOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741422569; c=relaxed/simple;
	bh=t0yY0IjEbjaO1mmMzMKXuBT3DoZDpnj0KqomOTUvq68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDyaOlGrzswvTl10JV0MmY2RqCn+gmgjbd5pz7zv5hgpLQMhEP/oXwiV0myDSiAlKbFOLFFvGBsyooNaMLMRGbZR5dv7yfGtRnnvPhh5QPzKhdo2uPbD90km/rND5GiDv2GDnPQh5lbLMOIB++TGE+ORhFuAMwCK2bhGK26zfN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SnTumCrU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SnTumCrU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Mn6w6D8XYBVvqamIeBgEnd7UGNMq9+b/v1SanxRW2uw=; b=SnTumCrUulXU4IIHR1/qjPpN8U
	9uCBKuWa9Jr7gobBwPWvmKQ1qcnoO1Dw3GsSXqcN8WyemkDhhRyVBt7Pz5PS4P1LC+nuek/ITqUop
	vb3xR22vnGrBH5NAihyggQ5BSWaSvJ06nsAJQ5HYmeIu8u3Rp3LotpXXMFZihxeEXgfm92YeBhtCs
	P2iv2PEmCoz+43DiR10VTKO0LQpgY5kAhc0NUJUU2egdDRrbovSYfhoAHccr0t7TgeKHQ7Kt308IJ
	LwSP18mTc+Bh6mxVXQZ4bgOL/mx5b0lwvYVaVglewgGUU5fScG7v+7oIBxNHVKhJkoO/lfa5oZZjI
	J1xtqTqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqpYY-004odn-1B;
	Sat, 08 Mar 2025 16:29:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 16:29:14 +0800
Date: Sat, 8 Mar 2025 16:29:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sven Schwermer <sven@svenschwermer.de>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, shawnguo@kernel.org,
	s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
	imx@lists.linux.dev, david@sigma-star.at, richard@nod.at,
	david.oberhollenzer@sigma-star.at
Subject: Re: [PATCH 1/1] crypto: mxs-dcp: Only set OTP_KEY bit for OTP key
Message-ID: <Z8v_2giA92wOo-2n@gondor.apana.org.au>
References: <20250224074230.539809-1-sven@svenschwermer.de>
 <20250224074230.539809-2-sven@svenschwermer.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224074230.539809-2-sven@svenschwermer.de>

On Mon, Feb 24, 2025 at 08:42:25AM +0100, Sven Schwermer wrote:
> While MXS_DCP_CONTROL0_OTP_KEY is set, the CRYPTO_KEY (DCP_PAES_KEY_OTP)
> is used even if the UNIQUE_KEY (DCP_PAES_KEY_UNIQUE) is selected. This
> is not clearly documented, but this implementation is consistent with
> NXP's downstream kernel fork and optee_os.
> 
> Signed-off-by: Sven Schwermer <sven@svenschwermer.de>
> ---
>  drivers/crypto/mxs-dcp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
