From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 7/8 v4] crypto:s5p-sss: validate iv before memcpy
Date: Fri, 24 Jan 2014 16:52:55 +0100
Message-ID: <52E28C57.4060106@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50805 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaAXPxM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jan 2014 10:53:12 -0500
In-reply-to: <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15.01.2014 10:17, Naveen Krishna Chatradhi wrote:
> This patch adds code to validate "iv" buffer before trying to
> memcpy the contents
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v3:
> None
>
>   drivers/crypto/s5p-sss.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
