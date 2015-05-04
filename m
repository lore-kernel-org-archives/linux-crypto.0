From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v4 2/6] random: Async and sync API for accessing kernel_pool
Date: Mon, 4 May 2015 06:22:04 -0400
Message-ID: <CACXcFmm=axx6Pkwm1e-_U4CJYv9DT3f-j3MggH0KJTuQ7Ygm5w@mail.gmail.com>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de>
	<1551132.jNO2hp8j9J@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36983 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbEDKWF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 06:22:05 -0400
In-Reply-To: <1551132.jNO2hp8j9J@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 3, 2015 at 11:33 AM, Stephan Mueller <smueller@chronox.de> wrote:

> The kernel_pool is intended to be the in-kernel equivalent to the
> blocking_pool, i.e. requests for random data may be blocked if
> insufficient entropy is present.

I cannot see any reason this would be useful, let alone necessary.

Of course /dev/random should block and it seems to me there is a good
argument for making both /dev/urandom and get_random_bytes() block
until there is emough entropy to seed them well. For everything else,
though, a properly seeded PRNG seems adequate so there is no reason to
block.
