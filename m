From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v1 0/1] *** crypto: AF_ALG: add compression support
 ***
Date: Fri, 14 Apr 2017 16:32:40 +0800
Message-ID: <20170414083240.GA26625@gondor.apana.org.au>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, akamaluddin@cavium.com,
        pathreya@cavium.com, machalla@cavium.com
To: Abed Kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:46926 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751530AbdDNIdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 04:33:35 -0400
Content-Disposition: inline
In-Reply-To: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 14, 2017 at 12:04:53AM +0530, Abed Kamaluddin wrote:
> Hi Herbert,
> 
> This patch adds compression support to the AF_ALG interface exported by the 
> kernel crypto API. By extending AF_ALG, all compression algorithms of types 
> scomp and acomp, which the kernel crypto API allows access to, are now also
> accessible from userspace.
> 
> The new compression interface has been tested with both kernel software
> deflate(scomp) and HW accelerated ThunderX deflate(scomp) using the zpipe
> example application provided by zlib.

I think we should convert ipcomp over to the new interface first
in order to make sure that we don't need to change the interface
which would be hard to do once we export it to user-space.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
