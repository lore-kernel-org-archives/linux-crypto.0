From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Add RNG support to AF_ALG (v2)
Date: Fri, 21 Jan 2011 17:00:05 +1100
Message-ID: <20110121060005.GA9768@gondor.apana.org.au>
References: <1292260317-2684-1-git-send-email-nhorman@tuxdriver.com> <1292275514-2488-1-git-send-email-nhorman@tuxdriver.com> <20110120233440.GA2451@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51194 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AUGAK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jan 2011 01:00:10 -0500
Content-Disposition: inline
In-Reply-To: <20110120233440.GA2451@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 20, 2011 at 06:34:40PM -0500, Neil Horman wrote:
>
> Herbert, Sorry to bug you about this, but are you still planning on pulling this
> now that Linus has the infrastructure scheduled for 2.6.38?

I think it's best if we leave this out for now, unless we can
come up with some way of merging this with the hardware RNG
interface so that we are not duplicating an existing user interface.

Could we perhaps merge this with the HWRNG interface somehow?
Or maybe we should just expose ansi_cprng (I presume you only
need that) through the hwrng interface?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
