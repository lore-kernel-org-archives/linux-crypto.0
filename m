From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v3 6/6] crypto: qcom: Add ACPI support
Date: Wed, 4 Jul 2018 09:43:10 +0530
Message-ID: <20180704041310.GV22377@vkoul-mobl>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-7-vkoul@kernel.org>
 <28000d33-5321-76af-7985-94a564a75336@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Jeffrey Hugo <jhugo@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28000d33-5321-76af-7985-94a564a75336@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03-07-18, 11:08, Jeffrey Hugo wrote:
> On 7/3/2018 12:04 AM, Vinod Koul wrote:

> > +#if IS_ENABLED(CONFIG_ACPI)
> > +static const struct acpi_device_id qcom_rng_acpi_match[] = {
> > +	{
> > +		.id = "QCOM8160",
> > +	},
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, msm_rng_acpi_match);
> 
> qcom_rng_acpi_match?
> Looks like a copy/paste issue.  This causes a build failure for me.
> I'm trying to see if it works otherwise...

Ah sorry about that, I though I had fixed it, looks like I missed to
fold the fix.

Did it work for you?

-- 
~Vinod
