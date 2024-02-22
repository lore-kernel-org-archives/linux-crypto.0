Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995D112B7E;
	Thu, 22 Feb 2024 06:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708582093; cv=none; b=XnMcusc5Dk1SH4+Ew2gYuLZ0FsI1GhRG+yf18YNFN5N2hsApNwzEuSmuzghql8ZPTr4JpBt/vS8Vakq7iX/Grghp9lOTDaR/3+mQTGk1b657BiVUrGYx+JQIWW/Uxuz1XTUWzvC5lZ+BMYswqg8/ZnF76Nl5Den6N/RqyFieq2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708582093; c=relaxed/simple;
	bh=nHOLKgb6+VtGFQ81POiVMuBjnYJAOQNZZi1g7nE1IdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUDi2URoVHVC+UPuJcWGHT+dARw2w1w75wQ77V7rO954Zlo3CkpnhKtcSGtNzTjmZGPvOl8fngKftQ+y6B21NkkEijbhmfEjGA4AQpSsGpzPcZYcQ3Qw6oxl+5dR8lI7v2hB1tsIJbOB/6kg32d3yH26dBuK1jlmCeJ+LSJ+RQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rd2FQ-00GOPA-IT; Thu, 22 Feb 2024 14:07:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Feb 2024 14:08:11 +0800
Date: Thu, 22 Feb 2024 14:08:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: arm64/neonbs - fix out-of-bounds access on short
 input
Message-ID: <Zdbky1otr93e9a46@gondor.apana.org.au>
References: <20240217161151.3987164-2-ardb+git@google.com>
 <CAMj1kXH+k4Z_iowxp+t=yU4tQFwLYjQxAQ92bga-xeZxE734BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH+k4Z_iowxp+t=yU4tQFwLYjQxAQ92bga-xeZxE734BA@mail.gmail.com>

On Thu, Feb 22, 2024 at 12:37:45AM +0100, Ard Biesheuvel wrote:
> On Sat, 17 Feb 2024 at 17:12, Ard Biesheuvel <ardb+git@google.com> wrote:
> >
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > The bit-sliced implementation of AES-CTR operates on blocks of 128
> > bytes, and will fall back to the plain NEON version for tail blocks or
> > inputs that are shorter than 128 bytes to begin with.
> >
> > It will call straight into the plain NEON asm helper, which performs all
> > memory accesses in granules of 16 bytes (the size of a NEON register).
> > For this reason, the associated plain NEON glue code will copy inputs
> > shorter than 16 bytes into a temporary buffer, given that this is a rare
> > occurrence and it is not worth the effort to work around this in the asm
> > code.
> >
> > The fallback from the bit-sliced NEON version fails to take this into
> > account, potentially resulting in out-of-bounds accesses. So clone the
> > same workaround, and use a temp buffer for short in/outputs.
> >
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> > Tested-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Ping?

It's in my queue.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
