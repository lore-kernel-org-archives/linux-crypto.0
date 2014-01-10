From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 1/8 v3] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Fri, 10 Jan 2014 16:15:02 +0100
Message-ID: <52D00E76.8060001@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
 <1389354102-31709-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	"David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389354102-31709-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 10.01.2014 12:41, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch uses the platform_get_irq() instead of the
> platform_get_irq_byname(). Making feeder control interrupt
> as resource "0" and hash interrupt as "1".
>
> reasons for this change.
> 1. Cannot find any Arch which is currently using this driver
> 2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
> 3. Patches adding support for DT and H/W version are in pipeline
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
