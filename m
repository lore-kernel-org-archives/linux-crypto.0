From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v2 0/2] hwrng: Add support for qcpm v2 hwrng
Date: Fri, 22 Jun 2018 09:57:47 +0530
Message-ID: <20180622042747.GH27187@vkoul-mobl>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <CAOZdJXUgYpLT=xMos4wKxMOTOZb8rV8is48YjGB8_9okZsuvhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>
To: Timur Tabi <timur@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOZdJXUgYpLT=xMos4wKxMOTOZb8rV8is48YjGB8_9okZsuvhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 21-06-18, 10:17, Timur Tabi wrote:
> On Tue, Jun 19, 2018 at 4:54 AM, Vinod Koul <vinod.koul@linaro.org> wrote:
> > This series adds support for newer version of hwrng as found in
> > Qualcomm SoCs. To do that add new v2 compatible string and driver_data
> > values for v2.
> 
> It's amazing you're sending this now, because I also have a PRNG
> patchset that I'm sending out today that adds support for v2 chips on
> an ACPI platform.
> 
> I'll send my patches as-is, and we'll just have to work to resolve the
> merge conflicts.

I have checked the series.

I am not sure I follow that this is v2 and you read CONFIG register.
Apart from that other changes look mostly okay with few nitpicks :)

But there is a bigger concern raised by Herbert on this not being a true
RNG and thus should be moved to crypto/

I have the changes ready for that, I will test them later today and
share with you, ACPI addition should be easy on that driver

> I will probably need you to test my patches as my last day at Qualcomm
> is the 26th.

Sad to hear that and good luck in your new adventure

-- 
~Vinod
