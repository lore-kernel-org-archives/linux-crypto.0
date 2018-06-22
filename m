From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v2 0/2] hwrng: Add support for qcpm v2 hwrng
Date: Fri, 22 Jun 2018 10:20:01 +0530
Message-ID: <20180622045001.GK27187@vkoul-mobl>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <CAOZdJXUgYpLT=xMos4wKxMOTOZb8rV8is48YjGB8_9okZsuvhQ@mail.gmail.com>
 <20180622042747.GH27187@vkoul-mobl>
 <0383ce35-caea-dc0f-21fd-2f44e44ca8ce@codeaurora.org>
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
In-Reply-To: <0383ce35-caea-dc0f-21fd-2f44e44ca8ce@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 21-06-18, 23:30, Timur Tabi wrote:

> > But there is a bigger concern raised by Herbert on this not being a true
> > RNG and thus should be moved to crypto/
> 
> I've asked some of the crypto experts in Q to answer that question.

That will be very helpful, I have not got any info on this. Although
specs mention PRNG everywhere..

> > I have the changes ready for that, I will test them later today and
> > share with you, ACPI addition should be easy on that driver
> 
> Ok.  Feel free to just merge my ACPI changes into yours.  Technically, it's
> only a couple lines that are really ACPI-specific.

Sure I will add/port you patch on top.

-- 
~Vinod
