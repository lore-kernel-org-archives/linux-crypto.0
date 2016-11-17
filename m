From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] powerpc: crypto/vmx: various build fixes
Date: Thu, 17 Nov 2016 11:51:56 +1100
Message-ID: <87inrnx70z.fsf@concordia.ellerman.id.au>
References: <20161116151146.15720-1-naveen.n.rao@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:40941 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbcKQAwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 19:52:01 -0500
In-Reply-To: <20161116151146.15720-1-naveen.n.rao@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:

> First up, clean up the generated .S files properly on a 'make clean'.
> Secondly, force re-generation of these files when building for different
> endian-ness than what was built previously. Finally, generate the new
> files in the build tree, rather than the source tree.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
> Michael,
> I've added your SOB here though you didn't explicitly include it in your
> previous mail. I hope that's fine from your end.

Yeah that's fine, thanks.

Crypto patches usually have a subject like:

crypto: vmx - Various build fixes


But maybe Herbert can fix it up for you when he applies this.

cheers
