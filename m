From: Tobias Rauter <tobiasrauter@gmail.com>
Subject: Re: [PATCH 1/4] crypto: dcp: Remove redundant platform_set_drvdata()
Date: Tue, 04 Jun 2013 21:21:08 +0200
Message-ID: <51AE3E24.6000907@gmail.com>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39599 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FDTVM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jun 2013 15:21:12 -0400
Received: by mail-ea0-f182.google.com with SMTP id r16so516402ead.13
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jun 2013 12:21:11 -0700 (PDT)
In-Reply-To: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29.05.2013 13:39, Sachin Kamat wrote:
> Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
> driver is bound) removes the need to set driver data field to
> NULL.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Tobias Rauter <tobias.rauter@gmail.com>
> ---
> This series compile tested against linux-next (20130529).

Hi!

Thank you for the corrections.

I tested this series on Freescale's evalboard with v3.10-rc4.

regards,
tr
