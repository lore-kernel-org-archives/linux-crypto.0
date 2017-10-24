From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: remove chip_num parameter from in-kernel API
Date: Wed, 25 Oct 2017 00:27:41 +0200
Message-ID: <20171024222741.lqvgpdaosjazpvfd@linux.intel.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <20171024185208.GD1806@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9230 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751576AbdJXW1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 18:27:47 -0400
Content-Disposition: inline
In-Reply-To: <20171024185208.GD1806@obsidianresearch.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 24, 2017 at 12:52:08PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2017 at 02:38:14PM +0200, Jarkko Sakkinen wrote:
> > The reasoning is simple and obvious. Since every call site passes the
> > value TPM_ANY_NUM (0xFFFF) the parameter does not have right to exist.
> > Refined the documentation of the corresponding functions.
> 
> I like this patch, but how about a slightly different take, make this
> change instead:
> 
> -struct tpm_chip *tpm_chip_find_get(int chip_num)
> +struct tpm_chip *tpm_chip_find_get(struct tpm_chip *chip);
> 
> Where chip == NULL means the default TPM.
> 
> And then at all call sites swap TPM_ANY_NUM to NULL and instead of
> flowing an 'int chip_num' to tpm_chip_find_get, flow the 'struct
> tpm_chip *' directly.
> 
> This gets us much closer to the desired API with about the same amount
> of churn as this patch has.
> 
> Jason

I can do that. I will rework this as a patch set that includes this
proposal. Gives us more clean position to continue. Thank you.

/Jarkko
