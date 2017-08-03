From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V3 2/6] crypto/nx: Create nx842_configure_crb function
Date: Thu, 03 Aug 2017 19:53:16 +1000
Message-ID: <87bmnxq8oj.fsf@concordia.ellerman.id.au>
References: <1500699459.23205.3.camel@hbabu-laptop> <20170803055850.GA11987@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, suka@us.ibm.com,
        ddstreet@ieee.org, linuxram@us.ibm.com, npiggin@gmail.com,
        hbabu@us.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47711 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751775AbdHCJxT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 05:53:19 -0400
In-Reply-To: <20170803055850.GA11987@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Fri, Jul 21, 2017 at 09:57:39PM -0700, Haren Myneni wrote:
>> 
>> Configure CRB is moved to nx842_configure_crb() so that it can
>> be used for icswx and VAS exec functions. VAS function will be
>> added later with P9 support.
>> 
>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>
> Your patch does not apply against cryptodev.  Please rebase.

It depends on another series that will go via my tree, so it might be
better if this series goes via my tree too?

cheers
