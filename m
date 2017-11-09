From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: remove unused pointer cc_base
Date: Thu, 9 Nov 2017 11:21:50 +0200
Message-ID: <CAOtvUMeJABR=mp-5_aO2wq3FoFAiKzftSpor7r_J6382XGpGcA@mail.gmail.com>
References: <20171109081305.3659-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:53161 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdKIJVv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 04:21:51 -0500
Received: by mail-ot0-f195.google.com with SMTP id 18so4721755oty.9
        for <linux-crypto@vger.kernel.org>; Thu, 09 Nov 2017 01:21:51 -0800 (PST)
In-Reply-To: <20171109081305.3659-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Colin,

Thank you very much for your patch.

On Thu, Nov 9, 2017 at 10:13 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Pointer cc_base is being assigned but is never read, hence it is
> redundant and can be removed. Cleans up clang warning:
>
> drivers/staging/ccree/ssi_driver.c:235:2: warning: Value stored to
> 'cc_base' is never read
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/ccree/ssi_driver.c | 3 ---
>  1 file changed, 3 deletions(-)

Your patch is perfectly fine but I just happened to send a patch
series that includes
this fix but also deals with  other occurrences of the same now
no-longer needed cc_base
variable just a second ago before checking my email...

Sorry about that and thanks again.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
