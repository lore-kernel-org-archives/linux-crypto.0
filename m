From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 06/61] crypto: simplify getting .drvdata
Date: Fri, 20 Apr 2018 08:07:43 +0200
Message-ID: <CAJKOXPcpOHF6a_XtvKD-PUw_CRsXXrb-fHSm+HOug9YX=zj68w@mail.gmail.com>
References: <20180419140641.27926-1-wsa+renesas@sang-engineering.com> <20180419140641.27926-7-wsa+renesas@sang-engineering.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>,
        Jamie Iles <jamie@jamieiles.com>, linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180419140641.27926-7-wsa+renesas@sang-engineering.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 19, 2018 at 4:05 PM, Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> We should get drvdata from struct device directly. Going via
> platform_device is an unneeded step back and forth.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>
> Build tested only. buildbot is happy. Please apply individually.
>
>  drivers/crypto/exynos-rng.c       | 6 ++----
>  drivers/crypto/picoxcell_crypto.c | 6 ++----
>  2 files changed, 4 insertions(+), 8 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
