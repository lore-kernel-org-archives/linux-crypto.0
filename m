From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/17] crypto: talitos - Add support for SEC1
Date: Fri, 6 Mar 2015 11:28:31 +1100
Message-ID: <20150306002831.GA30947@gondor.apana.org.au>
References: <20150305164605.E65D81A241C@localhost.localdomain>
 <20150305182101.6db66e228f519476f0751c13@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47735 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbCFA3L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:29:11 -0500
Content-Disposition: inline
In-Reply-To: <20150305182101.6db66e228f519476f0751c13@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 05, 2015 at 06:21:01PM -0600, Kim Phillips wrote:
> On Thu, 5 Mar 2015 17:46:05 +0100
> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> 
> > [15/17] crypto: talitos - Implementation of SEC1
> 
> ...
> 
> > [16/17] crypto: talitos - SEC1 bugs on 0 data hash
> > [17/17] crypto: talitos - Update DT bindings with SEC1
> 
> This patchseries doesn't apply, at least on top of Herbert's
> cryptodev-2.6 tree, as of today:
> 
> Applying: crypto: talitos - Implementation of SEC1
> error: patch failed: drivers/crypto/talitos.c:655
> error: drivers/crypto/talitos.c: patch does not apply

Also the patches are coming in a random order.  Please send them
one at a time to ensure proper ordering.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
