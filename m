From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v5 3/6] crypto: Add Qcom prng driver
Date: Sat, 14 Jul 2018 12:16:37 +0200
Message-ID: <CACRpkdYk11wNMFFFqbVXgRtPCrvq25MOHDrG_dikCr31oUWyqA@mail.gmail.com>
References: <20180709061925.20276-1-vkoul@kernel.org> <20180709061925.20276-4-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>, jhugo@codeaurora.org
To: vkoul@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709061925.20276-4-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 9, 2018 at 8:20 AM Vinod Koul <vkoul@kernel.org> wrote:

> This ports the Qcom prng from older hw_random driver.
>
> No change of functionality and move from hw_random to crypto
> APIs is done.
>
> Signed-off-by: Vinod Koul <vkoul@kernel.org>

FWIW:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>


> +config CRYPTO_DEV_QCOM_RNG
> +       tristate "Qualcomm Randon Number Generator Driver"

Random speling error.

> +#include <linux/of_device.h>

Do you need this? It seems like a platform device fair and square.

Yours,
Linus Walleij
