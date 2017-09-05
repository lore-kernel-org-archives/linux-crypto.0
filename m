From: "Peter Huewe" <PeterHuewe@gmx.de>
Subject: HWRNGs without quality attribute - are they used or not?
Date: Tue, 5 Sep 2017 15:54:02 +0200
Message-ID: <trinity-15517d84-3eec-425d-8519-7fa540b50125-1504619642848@3c-app-gmx-bs67>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org, "Matt Mackall" <mpm@selenic.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53136 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751160AbdIENyN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2017 09:54:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

while reading through the analysis of the Linux RNG by the BSI [1][2],
I was suprised by the lack of reflecting on the usage of HWRNGs except RDRAND/RDSEED.

In the paper it was mentioned that if the quality attribute of a regular hwrng is not set
(or specified via the module parameter default_quality for all hwrng) the HWRNG is not used at all.
Only very few set this attribute explictly, and the default is 0,
so even if we enable these HWRNGs in the kernel config, they are not used?

I read through the hw_random code and came to the same conclusion - but is this correct and desired?

Specifically since you can set the 'default value' only for every hwrng but not overwrite the quality for a specific device.
e.g. the quite good tpm hwrng of my ifx tpm would not be used and 
if I set the default_quality to something other than 0, other devices would be used, which I would not want to.

Is this understanding correct?


Thanks,
Peter
(tpm maintainer)



[1] https://www.bsi.bund.de/DE/Publikationen/Studien/LinuxRNG/index_htm.html
[2] https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/Studien/LinuxRNG/LinuxRNG_EN.pdf?__blob=publicationFile&v=5
