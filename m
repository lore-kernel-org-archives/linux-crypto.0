Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394823;
	b=XccbVtp6xJzJodmR6N/pYFYD08qbhYTA7X9t5Os0cGIM1Iaa+/3noVxqqQYxb+/h58+k
	 geZ3wGUtAiIvkp1eZEgXOE/VrH0mypYUycrXxJsCTJVJGgs2D1WRoc5tzUYe94wsMz3mR
	 xHwsZJ2Ax5AgJWio2+/radDmU5PPDDUyreT2CyFS+m9cntAvgiW0Hs7Iay01Fxvg4945t
	 T1MPIoZF49rnA9D9dF4eH9xtaQKD0/PPi0AcqvBfVuZ/x21XhYPUG3pXdSLDO2hKvS/ui
	 u37cPBQfugZHQ0q5qXhyyybW0W087leZqOW8p8dhWBI0I7Yp7J1zdSZKqJx8u8kEpRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394823;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=OYfWv7t3fNfV5mHgH3rQFUU5ZnGse0SEirQFnt+sNZA=;
	b=qZR0YCXEB88CLQI15H3l4ChQB8FMZOeWSJsRCDJgXFimek8v0pYtr4OeZeugfBoPDbwU
	 +isXL4J1vzbo3eD1rT2wJATjcW7w0MKPNrILr4fuug3XDJFrtAGjit2mxa2s/0TFaLHaM
	 ic0qgjkYPGn7DoQWriCQssGJcVeytZ635yeIGuD4ueb/22Dm4TibyVw1PmF4BXOmxf/bX
	 Z9jWBKD0KtDr3xXagGelAYVRuQZusxGbTyZhu4d/Z/VNf0SksLGhJIdLd2T4KJYW2XR/r
	 lYDML4lYF/6Mm/y96vW8MdwnesESJ+rWTySKx61dihggZhAP0X1TdTcARYjaDaKXI5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cO9XoWLf;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F58606A31C;
	Wed, 11 Nov 2026 11:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7F58606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cO9XoWLf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OYfWv7t3fNfV5mHgH3rQFUU5ZnGse0SEirQFnt+sNZA=; 
	b=cO9XoWLfjDEAo8WYLWNOoEiRtgAE4GB5whJjASVlg2jl9XmeIcKVqZ99wCK8SeuajrdKFGY4a7J
	l83YVFNtjopeZ2QhhCElQjui5HmK7/eCClUGF1gPmKhJKIJC1X1bAZVfcThNl6pKzSZkQukc1EV9o
	8WghVTs7Cz0q6uDE8dH4X8nowKLY/jGAa/79QC9okwhA3v2LoLY3OoCd1yO5wFPukyTfmBXifjFQ0
	y98Qrpd6yL2V7nAwtyOOaGtrXWX864+psHHS+KEFHDw+b3pJOAv183r+H151YNRbiE/jjviiT9yHh
	+KlpasAfqR++rkd81godh9nh0zIBozgEs/iw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR63k-0000000DmCq-0pos;
	Wed, 11 Nov 2026 19:00:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:00:08 +0800
Date: Wed, 11 Nov 2026 19:00:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Birk Skyum <birk.skyum@pm.me>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v11 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Message-ID: <avRKuPGD6QdRXrat@gondor.apana.org.au>
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <kh74or65txfcprntqqljabnszooj5ppuwizj35flv2r245zbvo@nfue4wdblicr>
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
In-Reply-To: <kh74or65txfcprntqqljabnszooj5ppuwizj35flv2r245zbvo@nfue4wdblicr>

On Mon, Nov 02, 2026 at 10:58:12AM +0100, Bartosz Golaszewski wrote:
> On Thu, Oct 22, 2026 at 10:57:58AM +0200, Bartosz Golaszewski wrote:
> > This is the follow-up to the three smaller series fixing crypto
> > self-tests in the QCE driver. It makes the crypto algorithms opt-in via
> > a module parameter and removes the BROKEN label so that the driver is
> > built by default.
> > 
> > The dependencies are:
> > - https://lore.kernel.org/all/20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com/
> > - https://lore.kernel.org/all/20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com/
> > - https://lore.kernel.org/all/20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com/
> > 
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > ---
> 
> Hi Herbert!
> 
> Gentle ping, can these three series + this one now get queued for v7.4?
> The three dependencies have no more sashiko comments. The ones for this
> one are minor about missing module params docs so can probably be
> ignored or I can send a follow up.

Did you miss the Sashiko comments about missing documentation?
Please address them first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
