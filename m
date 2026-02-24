Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [144.76.133.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAE3A1A36;
	Tue, 24 Feb 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945457; cv=none; b=OG7OhtR0gTbaZyx9BYv7UHF+jvV1mk6O19ZVUd8JucwGFmO6PuCT/0RufIyPuB6GkqchhYpnTKtJEAfQaaJcMhZO0NgyQA9nxNQuppX2BluVUtrnFAAsCpD7lWsjsSJAKBJQzu/CJmmrxicPOkmmH7IdW2thCdx32WP9kAxeuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945457; c=relaxed/simple;
	bh=ZlHYu0to0O09fjgtM4Y47Pd7vHh6vx2FNVF1O+ZGypw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6dEyKcw+UyVSIW4R5o4ARnQIHuF+BuIbgyyORtu5NCZe1cCsJuDL43WaL+HOv/hmMv56m1Y0bHm8v8Ny8GAD/g9FX3K9KPK/KIqNVxaWziIH6WrFgnZHgqIxlj/wcXo1ZEoatZd3pgNdUpvFSYEGzX1Ul4RDyG6y4CueHSEi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=144.76.133.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 93C55202D8FB;
	Tue, 24 Feb 2026 16:04:11 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 607B82CD0A; Tue, 24 Feb 2026 16:04:11 +0100 (CET)
Date: Tue, 24 Feb 2026 16:04:11 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aZ296wd7fLE6X3-U@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>

On Tue, Feb 24, 2026 at 02:17:22PM +0000, Kepplinger-Novakovic Martin wrote:
> I run imx6ul with FSL_CAAM* enabled and simply add ca.pem 
> ( openssl req -x509 -newkey rsa:4096 -keyout ca_key.pem -out ca.pem \
> -nodes -days 365 -set_serial 01 -subj /CN=ginzinger.com )
> to CONFIG_SYSTEM_TRUSTED_KEYS in order to use it to verify a squashfs
> rootfs via dm-verity (but forget that for a moment, the failure is early
> during boot, rsa verify()).

The issue might be easier to debug if you could come up with a
simpler reproducer.  E.g. you could use keyctl(1) to add a key to
a keyring in the kernel and subsequently have the kernel verify
a signature with it.

> This works until v6.6 and fails after ("crypto: ahash - optimize
> performance when wrapping shash")
> but too much has happened that I could revert one and I might be wrong
> with that commit even.

It would be good if you could bisect to exactly pinpoint the offending
commit.

> I run v6.18 now where this works when I *disable* FSL_CAAM* completely
> and use the rsa-generic code.
> Also it works, when I generate from elliptic curve key.
> 
> Only the CAAM+RSA case is failing in a weird way:
[...]
> but why? Because after the CAAM completion callback returning to the
> caller, out_buf (that was set to the key-part inside of the request
> earlier) still holds *old* data,
> and NOT the "encyption block" with 00 01 ff ff.... 
> 
> out_buf1 is (I assume valid because never changing) input data "out_buf"
> inside of "child_req".

"git grep out_buf1" finds nothing in a v6.19 source tree, so I'm not sure
what you're referring to?

> Directly when caam jr dequeue() returns with the user-callback, I see 64 bytes (all?)
> old data. SOMEHOW the cryto-wait needs 100ms or longer (no idea why) and after THAT,
> out_buf has only the first 16 bytes old data (out_buf2 in the logs):

I assume the caam device writes to memory via DMA.  Perhaps the CPU isn't
aware that the memory has been changed and is using data in its cache?
That could be caused by an incorrect dma_map_*() call in caampkc.c.

> There has been quite some changes, most notably ("crypto: ahash - optimize
> performance when wrapping shash")
> or ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") which squashes
> differnt changes into one commit...

Being the author of the latter, your initial report scared me that
I might have broken something.  However I looked through the code
and nothing stuck out.

Thanks,

Lukas
