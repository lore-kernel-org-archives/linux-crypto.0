Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542816;
	b=WBOV2c9Z1NyiotXjtZIko+jIP516giDco1uz5CzAsV3b76rHpy5dbTZ6XlaFc/uPUv/3
	 aLWJpWCAIcDL2H5zH7OzLVSQ655qgwfeeoH4SoGFdgREglwHhgCjTZd0/nUu8H6sRqwUw
	 BDhs+1HNIZR6oRq6lsopX67oOSR0J1vYKfNgaf6l1Sp6V1GrrGP2yj4/mzu84RD5tzQL7
	 cr+4vT1SET/87zhyHZALUy5iKK7Wqs5bGlBa9gmC7TmeUmNS9EK2sXFTQLleEsANvez+s
	 vUHPj35LMQ9VAiebuT4b834UXWTZO3FOP/sg86S24sJ4cDKY8z97VgM7fPYNEkKMsEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542816;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UM8r3RrjmSLVAs4cg3MYCKzmXpYfatwbT/NH7sSmYbU=;
	b=BEsWWKHOcRHIh0N+ULzCXm8kVbOP77E218kWf857OjiclYms0gajEUJ3kzUlb10Ts8NR
	 i0yo25LjiHWB7pNQ6TkiekDs+Q2tYVkytXhV2bK6BW7Biv3v4PRwzOG58W7kqfntbPOXy
	 d/yljVJlEvtNPPZg9TseQjBXJbWPQxif80Dc3+12q4kZxFTWqiYoQtAcFI41XgSMxWTRE
	 vDQdYdqdedzcpdMaMa4BQw/+UZTEmSBzzskyCb3flbid4/3QwFXE23z5L4RpOW9M8taHU
	 z94+UFljAEMJ/dwSdfwe7ov3Df/vQyWpP+w3i7YCUjX3ZU85Y6t6Abbw8Z3SBFza1Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Yp/Wz8Ey";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3DC8D606A31E;
	Tue, 24 Nov 2026 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yp/Wz8Ey
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DED4F1F000C0;
	Tue, 24 Nov 2026 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795542815;
	bh=UM8r3RrjmSLVAs4cg3MYCKzmXpYfatwbT/NH7sSmYbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yp/Wz8EyDw8mQFUJN21YmJp0d4VR0WIlM/zUKeSQBzLGvT/8eRoB7ajr84lpPyPkD
	 lhVgbcJcn85m5CBNpxglcvakFE2ix61YYZas43+Ym0BgZnHirlL5PwBTx9+1rTZWku
	 15vAC0P8pJjEYGCe+m7jyaQI6mhIzvF1nbdi7qf/NC4gT7CUbVZnMeL2XXJl0HYcAc
	 0dDOtTxQAleWaApUMILPJj3d07N4WxUf2heyerujXCmKJE+aROeCXlfKvd0ROsCwZO
	 QU0S1HXxEhhrrPEt9C23stWUd3fVpG+H6Z4LDVB4wmXfvx1xCEaGoN0R+iD1ST0pS3
	 7CMheNuHIJHgQ==
Date: Tue, 24 Nov 2026 19:53:31 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Florian Bauckholt <florian.bauckholt@cispa.de>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <awXPG9RspYmccps2@kernel.org>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
 <av7x53CigERu-cf2@kernel.org>
 <5d833d4c-bf8b-4ffb-a214-126de4403d4e@cispa.de>
 <awXK5NCHf82v7yaj@kernel.org>
 <awXOfwPQUxO2L1M2@kernel.org>
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
In-Reply-To: <awXOfwPQUxO2L1M2@kernel.org>

On Tue, Nov 24, 2026 at 07:50:59PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 07:35:37PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 04:54:15PM +0100, Florian Bauckholt wrote:
> > > On 11/19/26 13:56, Jarkko Sakkinen wrote:
> > > > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > Hi,
> > > 
> > > I saw that for-next-keys now has 94cd21592349 ("KEYS: Fix asym key
> > > overflow in keyctl_pkey_verify()") with the same (trivial) patch.
> > > I'm not sure how this goes, but if you'd like to add some context, a
> > > link to this thread and these tags can probably be moved over:
> > > 
> > > https://lore.kernel.org/all/20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de/
> > > 
> > >   Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> > >   Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
> > >   Tested-by: Guicai Ma <maguicai@kylinos.cn>
> > >   Tested-by: Rodolfo Giometti <giometti@enneenne.com>
> > > 
> > > Thanks,
> > > Florian
> > 
> > OK, so I pulled that by mistake as I was picking patch for keys 
> > 1/2; not asymmetric keys.
> > 
> > I'll drop it.
> 
> I'm confused. The patch set had fixes for to separate subsystems
> so I picked the one that I should.
> 
> I assume it will be picked by someone. If not send a new patch.

I don't have your patch in my for-next-keys branch so perhaps
it is unsynced.

I guess I call this done from my side.

Br, Jarkko
