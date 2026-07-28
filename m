Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DC2DEA93;
	Tue, 28 Jul 2026 06:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785219801; cv=none; b=Tfx6mtSoWM1AWrOl7D2Ddx2X99rMljgAM2NmR7rrQIlFawVu/FfoN0L0VXIQeTXnfohDGnUMSp/T14ycH2yA7CUH9oyT3I4tlv5AEkPYXfiehFPYaNEBD/FdE3818fpaQy7BxwUzekm7r8cepXvihHk0C/1Nsf4yj2jFV7ZGn8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785219801; c=relaxed/simple;
	bh=94kZn2PVaqwj2G3W5OV+Hw7rCz4HwOqlfxsEOs1LBRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOEYkRlhLILidyM6m4p7OQr0gPO9ppX0xB3WBfTbecuALEaWexPwcxMdcSBo8LheeGLkbfR9dnUbQIWey9JXPSXFu9yFlAqXbjScavY+ynmb4djNQbJQKb16422mo6E3mgS1TUvciFCMCXZapCyDkE4FC/o4y9wNHfz9obEVpcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 1E90C10DD9;
	Tue, 28 Jul 2026 08:23:10 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0DD2060B03EB; Tue, 28 Jul 2026 08:23:10 +0200 (CEST)
Date: Tue, 28 Jul 2026 08:23:10 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Changwei Zou <changwei.zou@canonical.com>,
	Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>,
	Martin Kepplinger-Novakovic <martink@posteo.de>
Cc: herbert@gondor.apana.org.au, ignat@linux.win, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: rsassa-pkcs1: align DMA buffer to
 ARCH_DMA_MINALIGN
Message-ID: <amhKzluBxvB81v0r@wunner.de>
References: <20260727224300.150132-1-changwei.zou@canonical.com>
 <amhJWs2AdPgFzw8t@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amhJWs2AdPgFzw8t@wunner.de>

On Tue, Jul 28, 2026 at 08:16:58AM +0200, Lukas Wunner wrote:
> Reported-by: Martin Kepplinger-Novaković <Martin.Kepplinger-Novakovic@ginzinger.com>
> Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com

Sorry, I was using a utf-8 character but the mail user agent pretended
iso-8859-1 encoding, so this should have been:

Reported-by: Martin Kepplinger-Novaković <Martin.Kepplinger-Novakovic@ginzinger.com>
Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com
