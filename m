From: dj@deadhat.com
Subject: Re: [Cryptography] Randomness for crypto, github repositories
Date: Wed, 21 Oct 2015 17:06:19 -0000
Message-ID: <ce4305849b5abc370afd5336d2328a73.squirrel@www.deadhat.com>
References: <CACXcFmkg_YMdxr59rHxqskSj1__6-ooakyCWxe8rXsjyOu+6Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: rng@lists.bitrot.info, linux-crypto@vger.kernel.org,
	"Cryptography" <cryptography@metzdowd.com>
To: "Sandy Harris" <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from static-50-126-79-253.hlbo.or.frontiernet.net ([50.126.79.253]:49785
	"EHLO deadhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbJURNq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 13:13:46 -0400
In-Reply-To: <CACXcFmkg_YMdxr59rHxqskSj1__6-ooakyCWxe8rXsjyOu+6Mg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've only looked at it briefly, but I have a question.. Are you trying to
use the GCM Galois multiply as an entropy extractor?

I don't know of any proof that it is a good extractor for any class of
entropic data. That doesn't mean there isn't one, but I've not heard of
one.

> I've just created github repositories for two projects:
>
> https://github.com/sandy-harris/random.test
>
> Test program for things I want to add to the Linux random(4) driver. I
> am proposing a fairly radical rewrite. This gives an executable test
> program for my new code, not a driver.
>
> https://github.com/sandy-harris/maxwell
>
> A demon to feed random(4) with entropy derived from the timer.
> Intended mainly for use on limited systems which may lack other good
> sources.
