Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F9A1487F6;
	Tue, 23 Sep 2025 11:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758627084; cv=none; b=ECB7b44X1IHt1MS2/WsFCIGoGsuQBN2hCxhyNW68js/c2lro0MrJYTr5PlIOwEsx25V0Bei1qT9Xo8pb+t7ISgM66iguyuJVzkBnfe7pReAjvE1tgkVa6a6A1dVVme9DCojNMg2YQjP7gqvkai9kAhFlkjAcfCxV7kklMpI8LKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758627084; c=relaxed/simple;
	bh=mCNJOTazPvqVqMaQhV2tfeF0FvD+Mm2uF3eK7Ojqa8g=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=rFYIjsiUZJ1Rldlckpg4bjQMYwtU8V8hiShieF9F8is4sRNyO6/kK3G6r5EV+HE6CTFJrXqsSD58KqCiNEtNkYHKGdxXtbxyXzt1YegsyM9oeHY2h6gCFM0nfAPgJCX27SckKiFgUCSsEafUsNhgwCeHrVAAsfQqRUCyw8tzrlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=oLGph3EV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EtS0BnnY; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="oLGph3EV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EtS0BnnY"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 1DE111D002A0;
	Tue, 23 Sep 2025 07:31:20 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 23 Sep 2025 07:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1758627079; x=1758713479; bh=XJAa74at5W3WFDosbUaDEhWc/w9NW9zUkT4
	q5gGIozM=; b=oLGph3EVDopwXaQ09M4M9BXRIuQIKjVhpPdU/HLILXtSSkUbFCg
	wUAMPDaNSl39d7FvqEnNKCuXWufYI28oASpbl2ogkwEuvwyXlzDxIDVj7PYwZ3Va
	2RZGvH0jx6gOElp6/8qASdcNVV8LrNKTsViE0r4j0JpZ8so1Y5JpBs/Qrg+r8Ywk
	x/8u1oczJJI90rcOdD2QI320N0Qpbl1UjeMboaPae8cJq9kzgqvYXEOw3+3R18nz
	CGrt2Cg8sRMO2eT+qtSd9tmhquhzjxGDLVg/z/+3hzEUIg17yrH1KtWTnQ19dPI6
	B6ZuLZTgE9B8xgmFKaOUDRReLKdFsSbBy8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758627079; x=
	1758713479; bh=XJAa74at5W3WFDosbUaDEhWc/w9NW9zUkT4q5gGIozM=; b=E
	tS0BnnY4ZK6gJryMtpHSIWbXNQkGiz7APxIyXS+3or6PBCbS6j+rQI2lsA36BLXt
	8KfBKnvBrCVt7mpF+3BLmP1PbaNMLhWQk9/8wKq/SjF0ucuKR4JQ0MSp5UR0faIY
	mYgmLMk5K+xqcrwH6TR9khHKYLkdy2KB2RVmOTx1FqqJIpYPse2mpr6sTOIp8Ela
	f/A+bN/ckqmEedt81PJJqQdzR2pKZbsKYcuphRYX3fHn9cvrsCmWJ66nzKUS9/u5
	xUX13mg8W/KvzRYuOn0Ma0ROe252h9kbPrgGH99zHtLD3oQksqbnPxKsHftxiv7W
	Q7lXzCYcW4+gaoSkVzc8w==
X-ME-Sender: <xms:B4XSaC9omsIVkUWqV0QFUVMIhZIeaK62bY7a7NGc51k_Q70wpWe68A>
    <xme:B4XSaLLwb6vvFVWpZGONLlJ2rREwkBrt8xuLC0AK_EUOInLBPqvHw2GNZ2-pgp2aM
    7U1OEIfhMAN-mWEiNwe9CYLxJRIreuUESNQTKANVIi-PBVcbw>
X-ME-Received: <xmr:B4XSaIfX7rS_gvUhKwqrGjR4eRl8lErg9iLSwxxLIoVgNNg5Leu1HI1zMkiRPP9kjsK_oV1CjV4YEfk8jWZp-ANPW06Wu5mKLseO1L-Piurd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthhqredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    eljedtfeegueekieetudevheduveefffevudetgfetudfhgedvgfdtieeguedujeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgsse
    hofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehtghhrrghfsehsuhhughdrtghhpdhrtghpthhtohephhgvrh
    gsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehmvghn
    ghhlohhnghekrdguohhnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:B4XSaK_dPsgsd7ji6EdrvdL5jlOS0Jl7WF8eA_tKp5CROFM1mDn2bg>
    <xmx:B4XSaFq8c2x7K1AxAxAei67LRqANszDZLhfdYqezkajn1w-Td3jH1Q>
    <xmx:B4XSaPCEgOWCWvv5Xuwvr6d28YW_FZm5xTGjO3SSYMeVxiQBfVrGJQ>
    <xmx:B4XSaHw-Ntt0dkzUazLA8bmH7WpvfMz3wR0xhmPkoWF5xzeauomeBw>
    <xmx:B4XSaJM1XAAV3ofZ9PsAt8d4BQIGeQJQCcyMI83r5Ogs4Eaqscm4zRgo>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:31:17 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Menglong Dong" <menglong8.dong@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, tgraf@suug.ch,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
In-reply-to:
 <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>
References: <20250923060614.539789-1-dongml2@chinatelecom.cn>,
 <aNI_-QHAzwrED-iX@gondor.apana.org.au>,
 <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>
Date: Tue, 23 Sep 2025 21:31:13 +1000
Message-id: <175862707333.1696783.11988392990379659217@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Tue, 23 Sep 2025, Menglong Dong wrote:
> On Tue, Sep 23, 2025 at 2:36=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> >
> > Menglong Dong <menglong8.dong@gmail.com> wrote:
> > > In the fast path, the value of "p" in __rht_ptr() should be valid.
> > > Therefore, wrap it with a "likely". The performance increasing is tiny,
> > > but it's still worth to do it.
> > >
> > > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > > ---
> > > include/linux/rhashtable.h | 5 +++--
> > > 1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > It's not obvious that rht_ptr would be non-NULL.  It depends on the
> > work load.  For example, if you're doing a lookup where most keys
> > are non-existent then it would most likely be NULL.
>=20
> Yeah, I see. In my case, the usage of the rhashtable will be:
> add -> lookup, and rht_ptr is alway non-NULL. You are right,
> it can be NULL in other situations, and it's not a good idea to
> use likely() here ;)

Have you measured a performance increase?  How tiny is it?

It might conceivably make sense to have a rhashtable_lookup_likely() and
rhashtable_lookup_unlikely(), but concrete evidence of the benefit would
be needed.

Thanks,
NeilBrown
