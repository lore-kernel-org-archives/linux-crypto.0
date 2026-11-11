Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395554;
	b=tJZHM4TcL5MDTHOW8lG6Sx+EWkjEbMYiolzVgtGfCwGDK1BOKgaLR9kYAcyuq7Gl9EZb
	 kzl9zV7UK0gGEIa2x+ICxmVO2IJ1DrQMOpCPdsSlwjuYEGwX3kNfIuS+/GipG/AToqm4y
	 JnkWrMxDf7zLKdOO6ibt3t4pzLbnMXILxfWTnhYUT/6/v6xzCPMXL851rTiCHkU8RyBpa
	 dZfceVtAceEyZ4bpQPcT1GCQ0i/Y3QwnVodK9XNhlNFBHsWz+gFeRLNr9S4cwxzXMD0e7
	 i6DZC9l/AR6jisYDww0M6jJEe8EKBWFKoAInD+lkLtg8J/iwXX2F2T6NhX12QgJbAzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395554;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=M7i7qeV9UiDvx6/zhRopZZexL1OUHkXEsmKT4YMKLAA=;
	b=TWoP7QH7wAa4fbgCxQkQ4TDFkJN5KgYEYPcidM43+93YLvc+XFoPFlQ4gPa5wn34d7Vc
	 mvZyRKGGyiV+R9q104Cl4g2huNbT2pE5ggqA1PSCtv47/rUxun/MJW0j4rgrAIrvIo1Nm
	 DYnNgbpr4HjvoH7EilpsuBUR0zqCITepc5GpkQagJQZFgE1/LJrq33Qz0zIB1uGpqI0NX
	 juVJAL+KlFyH6lHXJWhRZGaq5GKXWJ7Y0AdMT6XPeGrlyp/sM7OirLIoabCs7HD+0Sw5l
	 2mlrIZE39RwQZpc0BsOb6sjliubBK5ejO6b7dWbu4ou8ePvN/udpAANkSkqn/duBhfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bgQrcmHp;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F63606A31C;
	Wed, 11 Nov 2026 11:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3F63606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bgQrcmHp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=M7i7qeV9UiDvx6/zhRopZZexL1OUHkXEsmKT4YMKLAA=; 
	b=bgQrcmHpxO0L6OeF4AkdJV1Lhdt6AsVN5XB3qO6PdaBYwdVOmz0i+Y/O4iob7RQhObqkGWLZRWx
	onBORGIkeUIa6vOLisJB2mkIIKvnF7L9MnNhdH8QWdnCGNKs/kfuFo/AcOivPvFQN97+LLmN/Inaj
	2NUmQmJJu9biCkO+XFcLU+Htxx1NbLsV+BQf5Ck1M+Zs7bjgl7hbn8o0zWxYq7Dxp5NFHkvprZJ/v
	QdlKH3Fgaegfi34AGMnpZn8zUQtj0t0qb1VU8wGi02neLY5gOwVssPp4VPh8yKMALujvlVqv9lash
	1R3XQIyl9Notz83Vw1599nUlmBbJHuidfNVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6Fb-0000000DmSI-1cF5;
	Wed, 11 Nov 2026 19:12:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:12:23 +0800
Date: Wed, 11 Nov 2026 19:12:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rusty Russell <rusty@rustcorp.com.au>, Amos Kong <akong@redhat.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed
 restore
Message-ID: <avRNl36r1eiO7Ofu@gondor.apana.org.au>
References: <20261016103640.4989-2-blum@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016103640.4989-2-blum@kernel.org>

On Fri, Oct 16, 2026 at 12:36:40PM +0200, Thorsten Blum wrote:
> remove_common() frees the driver data during freeze, but does not clear
> vdev->priv, which points to freed memory. If probe_common() then fails
> during restore, a later remove or freeze can dereference the dangling
> pointer.
> 
> Clear vdev->priv on the probe_common() error cleanup path and before
> freeing the driver data in remove_common(). Also reset the device and
> return early from remove_common() if vdev->priv is already NULL for a
> safe teardown after a failed restore.
> 
> Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/virtio-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
