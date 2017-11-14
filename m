From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [1/2] crypto/nx: Use percpu send window for NX requests
Date: Tue, 14 Nov 2017 22:12:03 +1100 (AEDT)
Message-ID: <3yblFv25bsz9sPr@ozlabs.org>
References: <1506321782.13257.4.camel@hbabu-laptop>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au, ddstreet@ieee.org, mikey@neuling.org,
        suka@us.ibm.com, npiggin@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:53785 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754080AbdKNLME (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 06:12:04 -0500
In-Reply-To: <1506321782.13257.4.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-09-25 at 06:43:02 UTC, Haren Myneni wrote:
> [PATCH 1/2] crypto/nx: Use percpu send window for NX requests
> 
> For P9 NX, the send window is opened for each crypto session and closed
> upon free. But VAS supports 64K windows per chip for all coprocessors
> including in user space support. So there is a possibility of not
> getting the window for kernel requests.
> 
> This patch reserves windows for each coprocessor type (NX842) and are
> available forever for kernel requests, Opens each window for each CPU
> on the corresponding chip during driver initialization. So then use the
> percpu txwin for NX requests depends on the CPU on which the process
> is executing.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/976dd6490b1b45727733a3ee1e25e1

cheers
