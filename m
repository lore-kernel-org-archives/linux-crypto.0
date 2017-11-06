From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered after
 suspend/resume
Date: Mon, 6 Nov 2017 15:09:28 +0800
Message-ID: <20171106070928.GF14274@gondor.apana.org.au>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org
To: Jim Quigley <Jim.Quigley@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51758 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdKFHJ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 02:09:59 -0500
Content-Disposition: inline
In-Reply-To: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 03, 2017 at 09:57:21AM +0000, Jim Quigley wrote:
> The patch for
> 
> commit: 5c06273401f2eb7b290cadbae18ee00f8f65e893
> Author: Amit Shah <amit.shah@redhat.com>
> Date:   Sun Jul 27 07:34:01 2014 +0930
> 
>     virtio: rng: delay hwrng_register() till driver is ready
> 
> moved the call to hwrng_register() out of the probe routine into the scan
> routine. We need to call hwrng_register() after a suspend/restore cycle
> to re-register the device, but the scan function is not invoked for the
> restore. Add the call to hwrng_register() to virtio_restore().
> 
> Reviewed-by: Liam Merwick <Liam.Merwick@oracle.com>
> Signed-off-by: Jim Quigley <Jim.Quigley@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
