Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964525;
	b=vI+NP84c88ZSEw8xJAD2w2g84TdLrJTBTeptjkWUFTQae2J40JiMoVnMTas/GYMjTZLA
	 sn1cPTRu3wjLyNabVRLrVv9nvI9SwUEVK7QnZeYJjFUf/BNLGNC1XhDOfK01/bUidhskA
	 pNoK+lfPbdi28O0ycQ+8gFFKfDmat3x/ifSDoGrvkSQn9mfxqa+h/TPIC9OdGLyIPMboL
	 CFPyRnjfpIw6tZRmp62nNkLCYojUawhd8qlkmMPR8oWTrsvRu6Yu2hz+HI4FSRRsnAwHH
	 Up7Xmntki1VqRannniO49Z92LqyLP99W8JC3uhedaKhmDYYmEbACJVijXWL4+WB8Q6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964525;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BuNBH4jmFiUk7+w+snfcUCMKY1kL1nNRBUsOEP5hsew=;
	b=2fF5FepdTunVLdtW02wcuvm924hZnU8L4RkvF56DXX6/Ksj8FfKxfgvV0yb3wFUWwQRp
	 NpPTjO3sh+LISE0MAlkUL+vKrPkcZUbZLBJWCHEqEpcyypLG+taqFsQOlZFZW/ghg/c0t
	 H6CREwwwcI2LbtN2rgtTssVm07CZz69/XlmUOfdVuQc+lNU/SsjeTwjCx6sPVdGFiKBbh
	 T9gt8ZXeA/QLKiavTrW+4lN030hK8pCKp7qaVfa9veBjmsmxtDu6QS4jJfzedvnVsnSV/
	 jijBKBGfBnxLJ+a7+T0PGd0rtPVYqXSW+LgKTE4Q+gwklSrzDAfSqUgPbiYtcrt+nXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=g3Wijq6g;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DD0606D82E;
	Fri,  6 Nov 2026 11:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7DD0606D82E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=g3Wijq6g
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BuNBH4jmFiUk7+w+snfcUCMKY1kL1nNRBUsOEP5hsew=; 
	b=g3Wijq6guUk77Yu6eWCZ1Lv+e2GLTGm3ezuTJp65DByQ6a6MEwOjsVrEGRn9TrjTsIRwb32mo0D
	0IyrPN7Q7Egs30L2Rsr1P9YAif+CL+9+CSjs877iGO+nw0y50hAURN6qxN1o1RHDDB30ougaLCr74
	hTf+hg4gv5OIUnjuBkEpfBbUc1lK0T9K+SYza+d6y4k5yL8mi9CO6R722wIW3MCJGo4rW6wmwW7Ks
	6Zz/1KBAS7h92GEc4+OxLbT9Py9wjC85lUsB5dky4t5Wh91x/IgAgmQJ62N2vueZLnMyLZOnkBs/C
	AUR7bpR0wFaAThpJggQ2yIbj4+2En0mqAV/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI7c-0000000Br6l-48wB;
	Fri, 06 Nov 2026 19:28:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:28:40 +0800
Date: Fri, 6 Nov 2026 19:28:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Snider <ssnider5@outlook.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/lzo: check output space before writing the RLE header
Message-ID: <au256Pjm3sJ5T22S@gondor.apana.org.au>
References: <20261016170857.44908-1-ssnider5@outlook.com>
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
In-Reply-To: <20261016170857.44908-1-ssnider5@outlook.com>

On Fri, Oct 16, 2026 at 05:09:03PM +0000, Sean Snider wrote:
> The safe LZO-RLE compressor writes its two-byte version header before
> checking the available output space. With an output capacity of zero or
> one, these stores exceed the supplied limit. Advancing op past op_end
> also makes the unsigned HAVE_OP() comparison accept later writes.
> 
> Check for the two header bytes before emitting them. Use the existing
> output_overrun path, leaving the output length unchanged on this error.
> Ordinary LZO does not emit this header. Valid output is unchanged.
> 
> Bounded userspace tests of the kernel codec under ASan/UBSan reproduced
> the boundary violation and passed after the correction. Successful
> full-capacity streams remained byte-identical, and the existing Crypto
> LZO and LZO-RLE compression vectors passed.
> 
> Fixes: cc47f07234f7 ("crypto: lzo - Fix compression buffer overrun")
> Assisted-by: LLM
> Signed-off-by: Sean Snider <ssnider5@outlook.com>
> ---
>  lib/lzo/lzo1x_compress.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
