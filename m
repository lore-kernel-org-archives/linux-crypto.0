From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Wed, 8 Mar 2017 23:15:43 +0200
Message-ID: <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35804 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbdCHWZA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 17:25:00 -0500
Content-Disposition: inline
In-Reply-To: <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 08, 2017 at 07:45:42PM +0200, Krzysztof Kozlowski wrote:
> On Mon, Mar 06, 2017 at 03:29:48PM -0600, Nathan Royce wrote:
> > OK, I just tried 4.10.0 and the output is looking the same.
> > 
> > I can't say my setup is all that odd. The cryptographic use is only
> > with the swap partition found in my original email (seen in Herbert's
> > reply).
> 
> You have quite specific/customized config and compilation flags.
> I doubt that it causes the issue but at least the config is unusable on
> anything other then XU3/XU4.
> 
> Anyway I reproduced some of the issues with tcrypt on Odroid U3 on v4.10
> and v4.11-rc1, with regular exynos defconfig plus some more crypto
> algorithms:
> 1. Without my patch: the original warning.
> 2. With my patch:

I sent a fix. At least for spin lock recursion in tcrypt.

Could you give it a try?

Best regards,
Krzysztof
