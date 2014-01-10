From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 8/8 v3] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Fri, 10 Jan 2014 17:04:52 +0100
Message-ID: <52D01A24.10603@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
> This patch set adds use of clk_prepare/clk_unprepare as
> required by generic clock framework.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> New change to fix a WARN_ON during the bootup
>
>   drivers/crypto/s5p-sss.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
