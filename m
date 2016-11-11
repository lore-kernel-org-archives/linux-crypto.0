From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] crypto: arm64/sha2: integrate OpenSSL implementations of
 SHA256/SHA512
Date: Fri, 11 Nov 2016 19:56:07 +0000
Message-ID: <20161111195607.GB4457@arm.com>
References: <1478872273-16382-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, catalin.marinas@arm.com,
        appro@openssl.org, victor.chong@linaro.org,
        daniel.thompson@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52118 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934375AbcKKT4R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 14:56:17 -0500
Content-Disposition: inline
In-Reply-To: <1478872273-16382-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 11, 2016 at 09:51:13PM +0800, Ard Biesheuvel wrote:
> This integrates both the accelerated scalar and the NEON implementations
> of SHA-224/256 as well as SHA-384/512 from the OpenSSL project.
> 
> Relative performance compared to the respective generic C versions:
> 
>                  |  SHA256-scalar  | SHA256-NEON* |  SHA512  |
>      ------------+-----------------+--------------+----------+
>      Cortex-A53  |      1.63x      |     1.63x    |   2.34x  |
>      Cortex-A57  |      1.43x      |     1.59x    |   1.95x  |
>      Cortex-A73  |      1.26x      |     1.56x    |     ?    |
> 
> The core crypto code was authored by Andy Polyakov of the OpenSSL
> project, in collaboration with whom the upstream code was adapted so
> that this module can be built from the same version of sha512-armv8.pl.
> 
> The version in this patch was taken from OpenSSL commit
> 
>    866e505e0d66 sha/asm/sha512-armv8.pl: add NEON version of SHA256.
> 
> * The core SHA algorithm is fundamentally sequential, but there is a
>   secondary transformation involved, called the schedule update, which
>   can be performed independently. The NEON version of SHA-224/SHA-256
>   only implements this part of the algorithm using NEON instructions,
>   the sequential part is always done using scalar instructions.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> 
> This supersedes the SHA-256-NEON-only patch I sent out about 6 weeks ago.
> 
> Will, Catalin: note that this pulls in a .pl script, and adds a build rule
> locally in arch/arm64/crypto to generate .S files on the fly from Perl
> scripts. I will leave it to you to decide whether you are ok with this as
> is, or whether you prefer .S_shipped files, in which case the Perl script
> is only included as a reference (this is how we did it for arch/arm in the
> past, but given that it adds about 3000 lines of generated code to the patch,
> I think we may want to simply keep it as below)

I think we should include the shipped files too. 3000 lines isn't that much
in the grand scheme of things, and there will be people who complain about
the unconditional perl dependency.

Will
