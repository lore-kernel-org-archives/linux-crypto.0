From: Stephan Mueller <smueller@chronox.de>
Subject: Re: HWRNGs without quality attribute - are they used or not?
Date: Tue, 05 Sep 2017 16:37:39 +0200
Message-ID: <14077929.VbZM9Hdhi7@tauon.chronox.de>
References: <trinity-15517d84-3eec-425d-8519-7fa540b50125-1504619642848@3c-app-gmx-bs67>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Peter Huewe <PeterHuewe@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34632 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbdIEOhm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2017 10:37:42 -0400
In-Reply-To: <trinity-15517d84-3eec-425d-8519-7fa540b50125-1504619642848@3c-app-gmx-bs67>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 5. September 2017, 15:54:02 CEST schrieb Peter Huewe:

Hi Peter,

> Hi,
> 
> while reading through the analysis of the Linux RNG by the BSI [1][2],
> I was suprised by the lack of reflecting on the usage of HWRNGs except
> RDRAND/RDSEED.

Sure, the study is about assessing entropy. How can one assess entropy when no 
access to noise sources is possible?
> 
> In the paper it was mentioned that if the quality attribute of a regular
> hwrng is not set (or specified via the module parameter default_quality for
> all hwrng) the HWRNG is not used at all. Only very few set this attribute
> explictly, and the default is 0,
> so even if we enable these HWRNGs in the kernel config, they are not used?

Yes, see drivers/char/hw_random/core.c:

       if (current_quality == 0 && hwrng_fill)
                kthread_stop(hwrng_fill);
       if (current_quality > 0 && !hwrng_fill)
                start_khwrngd();
> 
> I read through the hw_random code and came to the same conclusion - but is
> this correct and desired?

If the quality is marked as 0, it is considered to provide no entropy. Thus, 
it will not change the blocking behavior of /dev/random.

As the in-kernel path in core.c with add_hwgenerator_randomness shall 
eliminate the need for rngd for those hardware RNGs, the current approach 
makes sense.

Though, the current implementation cannnot be used to simply mix the 
input_pool with a hardware RNG that is assumed to provide no entropy.
> 
> Specifically since you can set the 'default value' only for every hwrng but
> not overwrite the quality for a specific device. e.g. the quite good tpm
> hwrng of my ifx tpm would not be used and
> if I set the default_quality to something other than 0, other devices would
> be used, which I would not want to.
> 
> Is this understanding correct?
> 
> 
> Thanks,
> Peter
> (tpm maintainer)
> 
> 
> 
> [1] https://www.bsi.bund.de/DE/Publikationen/Studien/LinuxRNG/index_htm.html
> [2]
> https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/Studien/L
> inuxRNG/LinuxRNG_EN.pdf?__blob=publicationFile&v=5



Ciao
Stephan
