From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 4/6 v2] crypto:s5p-sss: Kconfig: Let Exynos SoCs select
 SSS driver
Date: Thu, 9 Jan 2014 14:59:26 +0530
Message-ID: <CAK9yfHyya0LwYp0f2ZrBbb9M51FVxnBkZuHqrD1ju9yDBffmqg@mail.gmail.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
	<1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, vzapolskiy@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35710 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaAIJ31 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jan 2014 04:29:27 -0500
Received: by mail-oa0-f47.google.com with SMTP id i7so3130914oag.34
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jan 2014 01:29:27 -0800 (PST)
In-Reply-To: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Naveen,

On 9 January 2014 10:29, Naveen Krishna Chatradhi <ch.naveen@samsung.com> wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch modifies Kconfig such that ARCH_EXYNOS SoCs
> which includes (Exynos4210, Exynos5250 and Exynos5420)
> can also select Samsung SSS(Security SubSystem) driver.

What about Exynos4x12 and 5440 as they too come under ARCH_EXYNOS?

-- 
With warm regards,
Sachin
