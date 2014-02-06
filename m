From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 3/9 v5] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Thu, 06 Feb 2014 15:39:44 +0100
Message-ID: <52F39EB0.4050702@samsung.com>
References: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
 <1390987294-18628-1-git-send-email-ch.naveen@samsung.com>
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
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaBFOju (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 09:39:50 -0500
In-reply-to: <1390987294-18628-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Naveen,

On 29.01.2014 10:21, Naveen Krishna Chatradhi wrote:
> This patch adds new compatible and variant struct to support the SSS
> module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
> for which
> 1. AES register are at an offset of 0x200 and
> 2. hash interrupt is not available
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v4:
> Fix rebase error because of the patch 2/9
>
>   .../devicetree/bindings/crypto/samsung-sss.txt     |   21 +++-
>   drivers/crypto/s5p-sss.c                           |  107 +++++++++++++++-----
>   2 files changed, 103 insertions(+), 25 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
