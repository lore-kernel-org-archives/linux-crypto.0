From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 2/9 v5] crypto:s5p-sss: Add device tree support
Date: Thu, 06 Feb 2014 15:36:56 +0100
Message-ID: <52F39E08.7010906@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1390987259-18581-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, devicetree@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59086 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBFOhC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 09:37:02 -0500
In-reply-to: <1390987259-18581-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Naveen,

On 29.01.2014 10:20, Naveen Krishna Chatradhi wrote:
> This patch adds device tree support to the s5p-sss.c crypto driver.
>
> Also, Documentation under devicetree/bindings added.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v4:
> Modified Documentation to give clock names and example for interrupts
>
> Changes since v3:
> None
>   .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++++++++++++++++++
>   drivers/crypto/s5p-sss.c                           |    8 +++++++
>   2 files changed, 32 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
>
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> new file mode 100644
> index 0000000..d193084
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -0,0 +1,24 @@
> +Samsung SoC SSS (Security SubSystem) module
> +
> +The SSS module in S5PV210 SoC supports the following:
> +-- Feeder (FeedCtrl)
> +-- Advanced Encryption Standard (AES)
> +-- Data Encryption Standard (DES)/3DES
> +-- Public Key Accelerator (PKA)
> +-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
> +-- PRNG: Pseudo Random Number Generator
> +
> +Required properties:
> +
> +- compatible : Should contain entries for this and backward compatible
> +  SSS versions:
> +  - "samsung,s5pv210-secss" for S5PV210 SoC.
> +- reg : Offset and length of the register set for the module
> +- interrupts : the interrupt-specifier for the SSS module.
> +		Two interrupts "feed control and hash" in case of S5PV210
> +	   Eg : interrupts = <0 feed-control 0> <0 hash 0>;

Please rewrite the description of interrupts property sa follows:

- interrupts : interrupt specifiers of SSS module interrupts, should
   contain two entries:
     - first : feed control interrupt,
     - second : hash interrupt.

Then in later patch adding support for Exynos, it shoudl be rewritten to:

- interrupts : interrupt specifiers of SSS module interrupts, should
   contain following entries:
     - first : feed control interrupt (required for all variants),
     - second : hash interrupt (required only for samsung,s5pv210-secss).

Best regards,
Tomasz
