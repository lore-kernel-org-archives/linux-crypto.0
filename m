Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394637;
	b=Lr7WLzvIUVRUH7APGMpw/BxtVPxkZ+0n7nVRNo6/OHesJ89JlItLm/0NdNGW0ulgjERS
	 EE/Jqz4Xnk9Xh5JBE/cJj0NeRLGHiQmSPaaP6DZk2VbZj903Wh6ksPPB+oc/sLayzv2nv
	 iwLfr5zkJQQ6Ps7o2qdLlWyH+W/j1lgvDthAiKlONK9eKheqFCPFIozx9oEnlVzJcUUnG
	 QHyLkBgwHpCyCYba3o/WP29IXHIPKb1E2pZQfu6uV+wZWvanCojhJlnagrWzmJW3qXS21
	 pvEptqnKyj22uhXl7tPjAg0B2IqhmQxMrdH+NRi8EHHYHNUi/Jy+5O9hVitoSOn9SlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394637;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/tEoO9wlGMqIvf0h432Z06K7uloWrBYOEEtmATNYZx0=;
	b=bmVCs6lqm0gZx19JY9CSRQn6xg+G2wnv/b343PjaPo/vQwUts5BViYDzzwz/fZUk67R3
	 366dBX8ZhZ5zd3jUBK6KEnaIbyxv4gGlw55gNVHXY7JptARDRCr+xe6OkOj5u7x4/Oyas
	 ikUtGsIrNWBY4VHWATT7qPISTifJIf6j+FsohYfHLlQScTFk3lHy71Fn74/oorN4cvg4g
	 lqcK31D3kvKKj9QwTiMrJikCToj2sBpiO/8+KS6A/6d4hoTjJPyVPwo4t94qa8x/zAhSR
	 VNAXNPOLjBntD2UK1jvg58AfXP2UP+x4fBF//qdq04CkuH/wBqHyFZ3eKjHrXIB0eTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=D4tzSEUp;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BF606A884;
	Wed, 11 Nov 2026 10:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 100BF606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=D4tzSEUp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/tEoO9wlGMqIvf0h432Z06K7uloWrBYOEEtmATNYZx0=; 
	b=D4tzSEUphplymiaxdK4+frJVAUo73FzvoD6f9B/WMt73OuAQaQgFyYc7qWrP9tZzaHCjsnQsoh2
	iGzXUgW3lO1I5RsK47JmGdKmyeGBCpUXI0A+d1c1mKtr22xCXrnqbPKhq6wXvjZWQi2YPwx8VRThO
	D1OnzN89hYRe55A4/BQ8NAjw+4FYgpoWv0cJAbhm/AeMzJEXcgQREN5VZsvuysYz5oM1jRwNBggDj
	XyMtCgzgUd0H48nhUAqETsGTeEHECuD9J0yFbu2at08Q49EItjsDXCDdaag80ohfrCL4WyboY+IJ8
	I29Zif+gDV00+u2jSFkEvzsQHAymoD1kRuZw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR60t-0000000Dm9I-3hdQ;
	Wed, 11 Nov 2026 18:57:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 18:57:11 +0800
Date: Wed, 11 Nov 2026 18:57:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
	ashish.kalra@amd.com, thomas.lendacky@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
	aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
	shansinha@google.com
Subject: Re: [Patch v5 7/7] crypto: ccp - Implement SNP Download Firmware EX
Message-ID: <avRKB59olTJmKQun@gondor.apana.org.au>
References: <cover.1792599491.git.prsampat@amd.com>
 <fe86fe10f9def87a2b463a6d4b44e266dd9497dc.1792599491.git.prsampat@amd.com>
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
In-Reply-To: <fe86fe10f9def87a2b463a6d4b44e266dd9497dc.1792599491.git.prsampat@amd.com>

On Wed, Oct 21, 2026 at 05:05:03PM +0000, Pratik R. Sampat wrote:
> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
> command.
> 
> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
> it is WORKING then legacy guests are running and the update is refused
> as busy. If it is INIT, shut it down, release the buffers the firmware
> owns across that shutdown, run the update, and bring the platform back
> up afterwards. SNP is never taken down, so SNP guests are unaffected.
> 
> To test run the following with your sbin file in FW:
> 
> echo 1 > /sys/class/firmware/sev/loading
> cat <firmware.sbin> > /sys/class/firmware/sev/data
> echo 0 > /sys/class/firmware/sev/loading
> 
> The COMMIT bit is left clear, so the image is only loaded provisionally
> and the admin decides when to make it permanent with ioctl(/dev/sev,
> SNP_COMMIT). To roll back, do not commit and upload the previous image
> the same way.
> 
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v4..v5:
> * Report original firmware error on rollback failure - Tycho, Shantanu
> ---
>  drivers/crypto/ccp/sev-dev.c | 297 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |   2 +
>  include/linux/psp-sev.h      |  19 +++
>  3 files changed, 317 insertions(+), 1 deletion(-)

Sashiko has a comment on this patch:

https://sashiko.dev/#/patchset/cover.1792599491.git.prsampat%40amd.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
