From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Tue, 03 Jul 2018 15:28:04 +0200
Message-ID: <2990655.vKmMgW600W@tauon.chronox.de>
References: <20180703060434.19293-1-vkoul@kernel.org> <20180703060434.19293-4-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Vinod Koul <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703060434.19293-4-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 3. Juli 2018, 08:04:31 CEST schrieb Vinod Koul:

Hi Vinod,

> +static int qcom_rng_read(struct qcom_rng *rng, void *data, size_t max)
> +{
> +	size_t currsize = 0;
> +	u32 *retdata = data;

How can you be sure that this cast is appropriate? I.e. how is it guaranteed 
that data is 4-byte aligned?

Also, the data variable in qcom_rng_generate is a u8 -- shouldn't this type be 
used instead of a void?


Ciao
Stephan
