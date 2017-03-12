From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Sun, 12 Mar 2017 21:13:22 +0200
Message-ID: <20170312191322.bbux5nrkqf5klznq@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
 <20170310180640.dnacw53vqrqji2xo@kozik-lap>
 <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35664 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934658AbdCLTN2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Mar 2017 15:13:28 -0400
Content-Disposition: inline
In-Reply-To: <CALaQ_hqomXaZs0z-S3YX6d-hS_giqgBqBSvumwsMm=BzrgZz7Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 10, 2017 at 03:44:45PM -0600, Nathan Royce wrote:
> Sure, I went ahead and rebuilt it just using the bare exynos_defconfig
> and adding XTS and ECB and no other changes.
> 
> No flags were used. No patches were used other than the 2 you
> provided. Just the barest of bears, the barest of bones, the barest of
> deserts, the barest of hairless cats.
>

Okay, I reproduced it. Beside enabling crypto tests, ECB and XTS, the
important step is to disable the "ARM Accelerated Cryptographic
Algorithms" so S5P-SSS will be used with XTS. The xts(ecb-aes-s5p))
itself passes TCRYPT tests but oopses on cryptswap.

Best regards,
Krzysztof
