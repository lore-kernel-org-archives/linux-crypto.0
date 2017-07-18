From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto hwrng consider quality value, remember
 user choice
Date: Tue, 18 Jul 2017 18:39:51 +0800
Message-ID: <20170718103951.GU6479@gondor.apana.org.au>
References: <1499758583-14626-1-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, prasannatsmkumar@gmail.com,
        schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33364 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbdGRKkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:40:18 -0400
Content-Disposition: inline
In-Reply-To: <1499758583-14626-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 11, 2017 at 09:36:21AM +0200, Harald Freudenberger wrote:
> The hwrng core implementation currently doesn't consider the
> quality field of the struct hwrng. So the first registered rng
> is the winner and further rng sources even with much better
> quality are ignored.
> 
> The behavior should be that always the best rng with the highest
> quality rate should be used as current rng source. Only if the
> user explicitly chooses a rng source (via writing a rng name
> to /sys/class/misc/hw_random/rng_current) the decision for the
> best quality should be suppressed.
> 
> This two patches make hwrng always hold a list of registered
> rng sources sorted decreasing by quality. On registration of a new
> hwrng source the list is updated and if the current rng source was
> not chosen by user and the new rng provides better quality set as
> new current rng source. Similar on unregistration of an rng, if it
> was the current used rng source the one with the next highest quality
> is used. If a rng source has been set via sysfs from userland as
> long as this one doesn't unregister it is kept as current rng
> regardless of registration of 'better' rng sources.
> 
> Patch 1 introduces the sorted list of registered rngs and the
> always use the best quality behavior.
> 
> Patch 2 makes hwrng remember that the user has selected an
> rng via echo to /sys/class/misc/hw_random/rng_current and
> adds a new sysfs attribute file 'rng_selected' to the rng core.
> 
> Harald Freudenberger (2):
>   crypto: hwrng use rng source with best quality
>   crypto: hwrng remember rng chosen by user

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
