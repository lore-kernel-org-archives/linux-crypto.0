From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Fri, 10 Mar 2017 20:06:40 +0200
Message-ID: <20170310180640.dnacw53vqrqji2xo@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
 <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
 <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36708 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933100AbdCJSGv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2017 13:06:51 -0500
Content-Disposition: inline
In-Reply-To: <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 09, 2017 at 05:16:35AM -0600, Nathan Royce wrote:
> Gave it a try on 4.10.1, but still to no avail:

(...)

> Also for the sake of testing, I did not add any FLAGS for compilation this time.

Damn, I am fixing bugs around but not the one you are hitting. Can you
also check if exynos_defconfig (+XTS + any other needed setting sfor
you) also has this issue?

I want to reproduce it but my setup does not use cryptswap. Probably I
will have to set it up.

Best regards,
Krzysztof
