Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316A933F9;
	Sat, 30 Nov 2024 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732956113; cv=none; b=rU60Pkhqs2uId36JZRSkpdCf7KZ2RLRd8P81RmDvb86TCqKhk4Oceb8d/RAsS0rdMqofib/7Pw6G10O3CCRC7dKtvEpLceKl+LXQYZIq0xFqtyJcC+DYuisRY/46xo7MqvvShfyHBo9Pc9ByXSSriMuqdSTV4LQhndCiiKqA9lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732956113; c=relaxed/simple;
	bh=H/RRBgof+JVgKE1pD2H+QLRerc5x6zW9W0KYdR6sqGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBx2zU9u89t8uOImDCnSPW6/b9vZlVow5cNJT/sIpgVT0httA3K9xCNDJhQj7IXMy7B661dBiE5/tgyvFBD5ph2MihY6/OCz4+ExvNpCRY/h+MwOWRFAz94R5/YJnX+xp/8YyCKFqh5Inz+X0gVhWOzfoV6bSfdPlYmH48Gdm18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id DEC8E3000A0CB;
	Sat, 30 Nov 2024 09:41:40 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id B7ED420A5F; Sat, 30 Nov 2024 09:41:40 +0100 (CET)
Date: Sat, 30 Nov 2024 09:41:40 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Zorro Lang <zlang@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] crypto: rsassa-pkcs1 - Copy source data for SG list
Message-ID: <Z0rPxCGdD7r8HFKb@wunner.de>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Z0mPDA31r_LEYzNq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0mPDA31r_LEYzNq@gondor.apana.org.au>

On Fri, Nov 29, 2024 at 05:53:16PM +0800, Herbert Xu wrote:
> As virtual addresses in general may not be suitable for DMA, always
> perform a copy before using them in an SG list.

Just a heads-up, this won't work for use cases when the src buffer
isn't accessible by the kernel.  E.g. if the virtual address pointed to
by src is in TEE restricted memory which was mapped into virtual address
space by dma_buf_vmap():

https://lore.kernel.org/all/20241128150927.1377981-1-jens.wiklander@linaro.org/

Thanks,

Lukas
