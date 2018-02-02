From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v3 2/5] crypto: caam: Fix endless loop when RNG is already
 initialized
Date: Fri, 2 Feb 2018 11:20:56 +0000
Message-ID: <78ad6a62-190c-e4fe-dd23-e1d058f9bbb2@nexus-software.ie>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
 <1517364040-27607-3-git-send-email-pure.logic@nexus-software.ie>
 <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Fabio Estevam <fabio.estevam@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas.auer@aisec.fraunhofer.de" <lukas.auer@aisec.fraunhofer.de>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/02/18 12:16, Horia Geantã wrote:
> If the loop cannot exit based on value of "ret" != -EAGAIN, then it means
> caam_probe() will eventually fail due to ret == -EAGAIN:
> 	if (ret) {
> 		dev_err(dev, "failed to instantiate RNG");
> 		goto caam_remove;
> 	}

For me it's an endless loop applying the first two

https://patchwork.ozlabs.org/patch/866460/
https://patchwork.ozlabs.org/patch/866462/

but not this one

https://patchwork.ozlabs.org/patch/865890/

> Please provide more details, so that the root cause is found and fixed.

np

---
bod
