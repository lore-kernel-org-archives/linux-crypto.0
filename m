From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [V2, 2/2] crypto: vmx - Convert to CPU feature based module autoloading
Date: Fri, 22 Jul 2016 15:50:42 +1000 (AEST)
Message-ID: <3rwfrf67mVz9t0j@ozlabs.org>
References: <1468901033-28996-3-git-send-email-alastair@au1.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	paulus@samba.org, linux-crypto@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>,
	linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: Alastair D'Silva <alastair@au1.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:53992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbcGVFuo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 01:50:44 -0400
In-Reply-To: <1468901033-28996-3-git-send-email-alastair@au1.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-19-07 at 04:03:53 UTC, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> This patch utilises the GENERIC_CPU_AUTOPROBE infrastructure
> to automatically load the vmx_crypto module if the CPU supports
> it.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/ccf5c442a1b82bf74105d72416

cheers
