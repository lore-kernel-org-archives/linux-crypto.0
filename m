From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2 0/2] hwrng: Add support for qcpm v2 hwrng
Date: Thu, 21 Jun 2018 10:17:15 -0500
Message-ID: <CAOZdJXUgYpLT=xMos4wKxMOTOZb8rV8is48YjGB8_9okZsuvhQ@mail.gmail.com>
References: <20180619095430.26358-1-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Vinod Koul <vkoul@kernel.org>
To: Vinod Koul <vinod.koul@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619095430.26358-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 19, 2018 at 4:54 AM, Vinod Koul <vinod.koul@linaro.org> wrote:
> This series adds support for newer version of hwrng as found in
> Qualcomm SoCs. To do that add new v2 compatible string and driver_data
> values for v2.

It's amazing you're sending this now, because I also have a PRNG
patchset that I'm sending out today that adds support for v2 chips on
an ACPI platform.

I'll send my patches as-is, and we'll just have to work to resolve the
merge conflicts.

I will probably need you to test my patches as my last day at Qualcomm
is the 26th.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
