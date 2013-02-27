From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
Date: Wed, 27 Feb 2013 11:47:30 +0100
Message-ID: <10560881.xkCvi82rco@wuerfel>
References: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com> <1361961711-4603-3-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	kernel@pengutronix.de, gcembed@gmail.com, shawn.guo@linaro.org,
	swarren@nvidia.com
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1361961711-4603-3-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 27 February 2013 11:41:50 Javier Martin wrote:
> SAHARA2 HW module is included in the i.MX27 SoC from
> Freescale. It is capable of performing cipher algorithms
> such as AES, 3DES..., hashing and RNG too.
> 
> This driver provides support for AES-CBC and AES-ECB
> by now.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Looks good,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
