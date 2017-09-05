From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: HWRNGs without quality attribute - are they used or not?
Date: Tue, 05 Sep 2017 21:54:01 +0530
Message-ID: <D1368E98-6796-4D3C-A565-B601D93B4786@gmail.com>
References: <trinity-15517d84-3eec-425d-8519-7fa540b50125-1504619642848@3c-app-gmx-bs67>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Peter Huewe <PeterHuewe@gmx.de>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32776 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdIEQYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2017 12:24:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id m1so1895969pfk.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Sep 2017 09:24:10 -0700 (PDT)
In-Reply-To: <trinity-15517d84-3eec-425d-8519-7fa540b50125-1504619642848@3c-app-gmx-bs67>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Hi Peter,

On 5 September 2017 7:24:02 PM IST, Peter Huewe <PeterHuewe@gmx=2Ede> wrot=
e:
>Hi,
>
>while reading through the analysis of the Linux RNG by the BSI [1][2],
>I was suprised by the lack of reflecting on the usage of HWRNGs except
>RDRAND/RDSEED=2E
>
>In the paper it was mentioned that if the quality attribute of a
>regular hwrng is not set
>(or specified via the module parameter default_quality for all hwrng)
>the HWRNG is not used at all=2E
>Only very few set this attribute explictly, and the default is 0,
>so even if we enable these HWRNGs in the kernel config, they are not
>used?
>
>I read through the hw_random code and came to the same conclusion - but
>is this correct and desired?

If the quality of RNG source is not set or set to 0 then hwrng does not us=
e the data to seed /dev/random=2E

>Specifically since you can set the 'default value' only for every hwrng
>but not overwrite the quality for a specific device=2E
>e=2Eg=2E the quite good tpm hwrng of my ifx tpm would not be used and=20
>if I set the default_quality to something other than 0, other devices
>would be used, which I would not want to=2E

Device with high quality will be used by default=2E But user space can tel=
l hwrng to use a particular device even if it is not the best RNG source=2E=
 But it won't be used for seeing /dev/random even in this case=2E

Every instance of hw_random structure represents a RNG device=2E If you ca=
n use different instance for every TPM chip then setting different quality =
value is possible=2E

I have an untested patch that allocates different hw_random structure inst=
ance for every TPM chip and registers with hwrng on tpm_chip_register=2E I =
made the change for fixing some other issue but did not get time to test it=
=2E If that patch will be helpful I can find it out and post the patch as R=
FC tomorrow=2E

>
>Is this understanding correct?
>
>
>Thanks,
>Peter
>(tpm maintainer)
>
>
>
>[1]
>https://www=2Ebsi=2Ebund=2Ede/DE/Publikationen/Studien/LinuxRNG/index_htm=
=2Ehtml
>[2]
>https://www=2Ebsi=2Ebund=2Ede/SharedDocs/Downloads/DE/BSI/Publikationen/S=
tudien/LinuxRNG/LinuxRNG_EN=2Epdf?__blob=3DpublicationFile&v=3D5

Regards,
PrasannaKumar
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
