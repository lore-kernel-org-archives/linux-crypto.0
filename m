From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH 2/6] clk: imx: vf610: Add CRC clock
Date: Thu, 30 Aug 2018 14:42:55 -0700
Message-ID: <153566537518.129321.12109490238775167072@swboyd.mtv.corp.google.com>
References: <20180830171539.20008-1-krzk@kernel.org>
 <20180830171539.20008-3-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
To: "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Turquette <mturquette@baylibre.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Stefan Agner <stefan@agner.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830171539.20008-3-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Krzysztof Kozlowski (2018-08-30 10:15:35)
> Add the clock for CRC block allowing it to be enabled by HW CRC driver.
> =

> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
