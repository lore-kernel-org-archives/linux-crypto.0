From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] crypto: ccm - move cbcmac input off the stack
Date: Mon, 27 Feb 2017 17:04:59 +0100
Message-ID: <1488211499.28431.20.camel@sipsolutions.net>
References: <1488209456-7653-1-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20170227_163113_108444_5C8419E8)
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38356 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751039AbdB0QyV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 11:54:21 -0500
In-Reply-To: <1488209456-7653-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20170227_163113_108444_5C8419E8)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-02-27 at 15:30 +0000, Ard Biesheuvel wrote:
> Commit f15f05b0a5de ("crypto: ccm - switch to separate cbcmac
> driver")
> refactored the CCM driver to allow separate implementations of the
> underlying MAC to be provided by a platform. However, in doing so, it
> moved some data from the linear region to the stack, which violates
> the
> SG constraints when the stack is virtually mapped.
> 
> So move idata/odata back to the request ctx struct, of which we can
> reasonably expect that it has been allocated using kmalloc() et al.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac
> driver")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Tested-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for the quick fix!

johannes
