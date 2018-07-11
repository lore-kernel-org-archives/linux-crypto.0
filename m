From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v5 6/6] crypto: qcom: Add ACPI support
Date: Wed, 11 Jul 2018 09:39:43 +0530
Message-ID: <20180711040943.GJ3219@vkoul-mobl>
References: <20180709061925.20276-1-vkoul@kernel.org>
 <20180709061925.20276-7-vkoul@kernel.org>
 <2a678412-26d4-769e-ff6f-ace5d53e70b5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Jeffrey Hugo <jhugo@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2a678412-26d4-769e-ff6f-ace5d53e70b5@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10-07-18, 11:27, Jeffrey Hugo wrote:
> On 7/9/2018 12:19 AM, Vinod Koul wrote:
> > From: Timur Tabi <timur@codeaurora.org>
> > 
> > Add support for probing on ACPI systems, with ACPI HID QCOM8160.
> > 
> > On ACPI systems, clocks are always enabled, the PRNG should
> > already be enabled, and the register region is read-only.
> > The driver only verifies that the hardware is already
> > enabled never tries to disable or configure it.
> > 
> > Signed-off-by: Timur Tabi <timur@codeaurora.org>
> > [port to crypto API]
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> 
> Tested-by: Jeffrey Hugo <jhugo@codeaurora.org>

Thanks Jeffrey.

-- 
~Vinod
