From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Fri, 22 Apr 2016 09:09:51 -0400
Message-ID: <CACXcFmmyA2qkpB+BM4wmJGek=1KB0tB88WxQXDjxwm4_h=k6Xg@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
	<20160422025155.GA6690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35921 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbcDVNJw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Apr 2016 09:09:52 -0400
In-Reply-To: <20160422025155.GA6690@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 21, 2016 at 10:51 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> I still have a massive problem with the claims that the "Jitter" RNG
> provides any amount of entropy.  Just because you and I might not be
> able to analyze it doesn't mean that somebody else couldn't.  After
> all, DUAL-EC DRNG was very complicated and hard to analyze.  So would
> be something like
>
>    AES(NSA_KEY, COUNTER++)
>
> Very hard to analyze indeed.  Shall we run statistical tests?  They'll
> pass with flying colors.
>
> Secure?  Not so much.
>
>                                         - Ted

Jitter, havege and my maxwell(8) all claim to get entropy from
variations in timing of simple calculations, and the docs for
all three give arguments that there really is some entropy
there.

Some of those arguments are quite strong. Mine are in
the PDF at:
https://github.com/sandy-harris/maxwell

I find any of those plausible as an external RNG feeding
random(4), though a hardware RNG or Turbid is preferable.
