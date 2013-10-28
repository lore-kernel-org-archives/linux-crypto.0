From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Mon, 28 Oct 2013 14:06:23 -0200
Message-ID: <20131028160623.GD15440@khazad-dum.debian.net>
References: <2579337.FPgJGgHYdz@tauon>
 <2049321.gMV6JUDze7@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33327 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab3J1QG0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Oct 2013 12:06:26 -0400
Content-Disposition: inline
In-Reply-To: <2049321.gMV6JUDze7@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 28 Oct 2013, Stephan Mueller wrote:
> If it is accepted that the CPU Jitter RNG delivers entropy, the latter 
> update may now allow us to get rid of storing the seed file during 
> shutdown and restoring it during the next boot sequence.

That's a 4096-bit safety net (uncredited entropy) which at least Debian
shall not remove.

I think Debian also dumps some low-entropy-per-bit crap into /dev/random
during boot (again, not credited), such as the boot kernel logs.  We could
increase the density of that entropy a lot using gzip -0 or something like
that... is an uncredited low-entropy-per-bit dump into the pool detrimental
to its quality?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
