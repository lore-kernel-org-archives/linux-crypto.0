Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876E51369AE;
	Wed, 25 Dec 2024 11:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735124624; cv=none; b=UpuVHnVhbdsr/LT/q1/EK89d6gUVaEKDzzgs1bes3y8TI2fSW3IQvKzxH3mM20EAAJ1u0+wBxVm3tIkWxPWfAsQEWK7njBkBILFxeWOb69/+ry9PcalgGcyfaaNoepQ0J0gjLs5hi8aUCsN49UFI17ahgZb78VDGEjXAdUATgSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735124624; c=relaxed/simple;
	bh=853pagY2PGpAQ1msH3XYmIabrBEt1FAJOnCoZY97Bfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEr3Wkm8sE0zvZspaJk+mA2BBDfB6NTsYAdcSauHANLl7hOY/THdlVe3yPc9UmMuT4iaW65iKuNiIbauBVb2lDhPxwHVr36P9J+z2HwYsxIXxxsavyTEhMLpcMUedG9a+9EB2WD3iwNxxmjPl1I+/0WvH/U0m4Rf3lpngqbH5Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 12E9C300002A6;
	Wed, 25 Dec 2024 12:03:38 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 00C2335A1C8; Wed, 25 Dec 2024 12:03:37 +0100 (CET)
Date: Wed, 25 Dec 2024 12:03:37 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kurt Borja <kuurtb@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] Double energy consumption on idle
Message-ID: <Z2vmiUyIcvE8vV0b@wunner.de>
References: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>

On Tue, Dec 24, 2024 at 07:42:49PM -0500, Kurt Borja wrote:
> When I first booted into v6.13 I noticed my laptop got instantly hotter
> and battery started draining fast. Today I bisected the kernel an ran
> powerstat [1]. It comes down to
> 
> Upstream commit: 6b34562f0cfe ("crypto: akcipher - Drop sign/verify operations")
[...]
> Graphics:
>   Device-1: Intel TigerLake-H GT1 [UHD Graphics] driver: i915 v: kernel
>   Device-2: NVIDIA GA104M [GeForce RTX 3070 Mobile / Max-Q] driver: nvidia
>     v: 565.77

I note that you're using the out-of-tree nvidia driver on v6.12.

The driver may be using the portions of the akcipher API that were
removed by the commit you bisected to.  E.g. this source file calls
crypto_akcipher_verify():

https://github.com/NVIDIA/open-gpu-kernel-modules/blob/main/kernel-open/nvidia/libspdm_ecc.c

Are you seeing build or load errors for the nvidia module?

If the module is not loaded, no voltage / frequency scaling happens,
which would indeed result in the dGPU consuming an awful lot of power.

Thanks,

Lukas
