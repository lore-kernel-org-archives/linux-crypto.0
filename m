From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH v2] drivers/crypto/nx: saves chaining value from
 co-processor
Date: Thu, 8 Aug 2013 17:49:22 +1000
Message-ID: <20130808074922.GA22688@concordia>
References: <1375917350.16050.14.camel@what-is-leg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, mhcerri@linux.vnet.ibm.com,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:38163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3HHHtZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 03:49:25 -0400
Content-Disposition: inline
In-Reply-To: <1375917350.16050.14.camel@what-is-leg>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Fin,

I don't know anything about crypto so I can only critique you on your
patch submission technique :)  ...

On Wed, Aug 07, 2013 at 06:15:50PM -0500, Fionnuala Gunter wrote:
> This patch fixes a bug that is triggered when cts(cbc(aes)) is used with
> nx-crypto driver on input larger than 32 bytes.
> 
> The chaining value from co-processor was not being saved. This value is
> needed because it is used as the IV by cts(cbc(aes)).
> 
> Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> ---
> v2. changed signed-off-by to reviewed-by and added more details to
> description
> 
> This bug appeared in the original submission (v3.5)

Ideally this should identify the commit, so:

  This bug was introduced in the original submission (v3.5), commit
  856d673 "powerpc/crypto: AES-CBC mode routines for nx encryption".

Including the subject of the commit is handy in case the patch has been
backported somewhere, in which case the commit sha will be different.

It should definitely be part of the commit message, not below the "---".

And Ben might disagree but I think with a clear cut bug fix like this it
should include the CC to stable, so:

    Cc: stable@vger.kernel.org # 3.5+

cheers
