Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4B4A2E12;
	Tue, 19 May 2026 10:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185707; cv=none; b=pLQY82txIXkPnc8v/31Ilq5b4LzrqZm2gSOCiyacTPnRwCltjwpytDDQKvH3LTPD2aui2/dgdkAq5hfWqP1YlRRA59dGss1wdTo78cGfpnYVoIKi/vDkj3yqbUUlf1vBPl0p0/Dvdcuye9TOehDLG9J80bjmCqUkjHEKN2x9EE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185707; c=relaxed/simple;
	bh=goFEvZBrkmTBesaOxXB3sXrpp/sgJ5tMhrCL8M/yQU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwMfrLrgu3cEvceG4ihrPw/sSy/75MU9QI9ukqfzuy6yi8D3Mp6vkbZiRAM7RbbDjbEpYnsuGVy8dGr6FA67PE1huYAPxiBycv9n43ft7+/UESLe+eiOuq6Clq251qqB75emNrwyNGjN6utGc5ySXMBaYi2RUlSDjex5yl/zZKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 36072C23;
	Tue, 19 May 2026 12:14:53 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 149CE603430D; Tue, 19 May 2026 12:14:53 +0200 (CEST)
Date: Tue, 19 May 2026 12:14:53 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - remove empty sig_alg exit callback
Message-ID: <agw4HU-BrSJjKomP@wunner.de>
References: <20260519083630.147673-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519083630.147673-3-thorsten.blum@linux.dev>

On Tue, May 19, 2026 at 10:36:32AM +0200, Thorsten Blum wrote:
> ecrdsa_exit_tfm() is empty, and sig_alg .exit is optional. The
> corresponding .init callback is not set either, so there is nothing to
> release in .exit.
> 
> Remove the empty function and leave .exit unset.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Lukas Wunner <lukas@wunner.de>
