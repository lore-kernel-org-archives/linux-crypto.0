From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Thu, 18 Aug 2016 19:59:44 -0500
Message-ID: <20160819005944.GA1711@rob-hp-laptop>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, mark.rutland@arm.com,
        ralf@linux-mips.org, davem@davemloft.net, geert@linux-m68k.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        mchehab@kernel.org, linux@roeck-us.net,
        boris.brezillon@free-electrons.com, harvey.hunt@imgtec.com,
        alex.smith@imgtec.com, daniel.thompson@linaro.org,
        lee.jones@linaro.org, f.fainelli@gmail.com, kieran@ksquared.org.uk,
        krzk@kernel.org, joshua.henderson@microchip.com,
        yendapally.reddy@broadcom.com, narmstrong@baylibre.com,
        wangkefeng.wang@huawei.com, chunkeey@googlemail.com,
        noltari@gmail.com, linus.walleij@linaro.org, pankaj.dev@st.com,
        mathieu.poirier@linaro.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 17, 2016 at 09:05:51PM +0530, PrasannaKumar Muralidharan wrote:
> This patch adds support for hardware random number generator present in
> JZ4780 SoC.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  .../devicetree/bindings/rng/ingenic,jz4780-rng.txt |  12 +++

Acked-by: Rob Herring <robh@kernel.org>

>  MAINTAINERS                                        |   5 +
>  arch/mips/boot/dts/ingenic/jz4780.dtsi             |   7 +-
>  drivers/char/hw_random/Kconfig                     |  14 +++
>  drivers/char/hw_random/Makefile                    |   1 +
>  drivers/char/hw_random/jz4780-rng.c                | 105 +++++++++++++++++++++
>  6 files changed, 143 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/rng/ingenic,jz4780-rng.txt
>  create mode 100644 drivers/char/hw_random/jz4780-rng.c
