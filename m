From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: change hwrng device default permissions to 0444
Date: Wed, 12 Jul 2017 18:13:56 +0800
Message-ID: <20170712101356.GA21862@gondor.apana.org.au>
References: <1499078279-19135-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Christian.Rund@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43396 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbdGLKOa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 06:14:30 -0400
Content-Disposition: inline
In-Reply-To: <1499078279-19135-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 03, 2017 at 12:37:59PM +0200, Harald Freudenberger wrote:
> Currently /dev/hwrng uses default device node permissions
> which is 0600. So by default the device node is not accessible
> by an ordinary user. Some distros do rewrite the device node
> permissions via udev rule, others don't. This patch provides
> 0444 as the new mode value and so makes the device node
> accessible for all users without the need to have udev rules
> rewriting the access rights.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>

Hmm, one usage scenario for /dev/hwrng is to feed rngd which then
feeds into /dev/random.  In that case it may not be desirable to
allow arbitrary access to hwrgn since it may cause the rate of
entropy going into /dev/random to go down.

In any case, as you noted userspace can change this anyway so I
don't see why we need to make this policy change in the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
