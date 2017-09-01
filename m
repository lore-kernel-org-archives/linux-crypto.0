From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [V4,1/7] crypto/nx: Rename nx842_powernv_function as icswx function
Date: Fri,  1 Sep 2017 23:30:00 +1000 (AEST)
Message-ID: <3xkKqF2jcvz9t3P@ozlabs.org>
References: <1504163489.4681.4.camel@hbabu-laptop>
Cc: mikey@neuling.org, linuxram@us.ibm.com, npiggin@gmail.com,
        suka@us.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, ddstreet@ieee.org
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:40059 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752212AbdIANaD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2017 09:30:03 -0400
In-Reply-To: <1504163489.4681.4.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2017-08-31 at 07:11:29 UTC, Haren Myneni wrote:
> Rename nx842_powernv_function to nx842_powernv_exec.
> nx842_powernv_exec points to nx842_exec_icswx and
> will be point to VAS exec function which will be added later
> for P9 NX support.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/c97f8169fb227cae5adeac56cafa98

cheers
