Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FEDC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 02:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FCB564F69
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 02:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhBCC7T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 21:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhBCC7K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 21:59:10 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1A5C061794
        for <linux-crypto@vger.kernel.org>; Tue,  2 Feb 2021 18:57:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id f63so15691408pfa.13
        for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2021 18:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Mj181Ap2D9DsZYkVX1SWxRRocq6IiJOQXL4LIKSE2qI=;
        b=rETZciL1SObWCgT8Ed/M0tNvxsDYXKO4c18UMLpvyMUQDP1rSu4J8VjV5ryEND1HPx
         vDrWFqrONhkDU5f07DsXZ1bfXhWt06iBr+6amRveofmiVZ9HuHSSfapdk5hDwEm01a9W
         OqqBvDPsmgGiRY7KIG9cgmp+FdAtE8Mr2ed6DnVPTYT0HGsUgU2IjZgStTjJtjU7NWPe
         MxrEJOPvOL5iwJ/Pxi1iE20OnjZpR0fYiroCRucUTaoiWgzgizxkht/5C30osBEkIIBi
         kmvHyUhnYiEiBrVwOkI7c8Z/4M2HfSoNS+y9dzWdrL9O9LRf8LeE22yaGuNP5SkkyWRS
         gf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Mj181Ap2D9DsZYkVX1SWxRRocq6IiJOQXL4LIKSE2qI=;
        b=lIdAqzOEWxsjXeFX63YA276unexfJUVp9gHseUBAGgqjnB4Kd52ydFsWhO6IZQtH0s
         7lIPUGZKa8K+k3Bhan8mWmQ7evlitty6XnmNkB3S/L1zFLDKQboT6+vk7VP5cpZP+ceK
         COji7qDiGydI0A/MGS3MAbHJyjPOdS0ia/S7JxIsQICmO/nP+f63/e/ArQpoknAat/SF
         f2EYuqfVrXhPs50F9K6b1u8W5mkf0fQwqk5xShEcRWw8MF28JhYHTmaM0vskEsfCPn0i
         3H1RxgmYiJEE5gPJ4MkBcyfQDNwRTw0oEWTWIRFuAevjluZFwKYhFbbOnwGUNO6BWiVA
         5SeA==
X-Gm-Message-State: AOAM531vBYWJxokZ8SS897XSfLQQdHbCS0ijmIzwCl+SoL8Q+ijpYjSk
        xPj7Vkre8Z4Q9AaJQDPZLhzHzQ==
X-Google-Smtp-Source: ABdhPJxZEQKKmg2ggzDFHqz1rxir2RepMaJA7H59H/b7qyCRgyRAV8n1fv2eYttRmcFa+R2jJeiZEg==
X-Received: by 2002:a63:fa0b:: with SMTP id y11mr1280696pgh.35.1612321068363;
        Tue, 02 Feb 2021 18:57:48 -0800 (PST)
Received: from localhost ([122.172.59.240])
        by smtp.gmail.com with ESMTPSA id z11sm323556pfk.97.2021.02.02.18.57.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Feb 2021 18:57:47 -0800 (PST)
Date:   Wed, 3 Feb 2021 08:27:43 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Russell King <linux+pull@armlinux.org.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tushar Khandelwal <Tushar.Khandelwal@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        linux-fbdev@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Linus Walleij <linus.walleij@linaro.org>,
        alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
        Jaroslav Kysela <perex@perex.cz>,
        Eric Anholt <eric@anholt.net>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig.org@pengutronix.de>, linux-i2c@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-rtc@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Takashi Iwai <tiwai@suse.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mike Leach <mike.leach@linaro.org>,
        linux-watchdog@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        coresight@lists.linaro.org, Vladimir Zapolskiy <vz@mleia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-arm-kernel@lists.infradead.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Leo Yan <leo.yan@linaro.org>, dmaengine@vger.kernel.org
Subject: Re: [PATCH] mailbox: arm_mhuv2: make remove callback return void
Message-ID: <20210203025743.uffbfdjsubsjbfrc@vireshk-i7>
References: <20210126165835.687514-1-u.kleine-koenig@pengutronix.de>
 <20210202135350.36nj3dmcoq3t7gcf@pengutronix.de>
 <20210202194308.jm66vblqjwr5wo6v@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202194308.jm66vblqjwr5wo6v@pengutronix.de>
User-Agent: NeoMutt/20180716-391-311a52
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02-02-21, 20:43, Uwe Kleine-König wrote:
> My build tests failed to catch that amba driver that would have needed
> adaption in commit 3fd269e74f2f ("amba: Make the remove callback return
> void"). Change the remove function to make the driver build again.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 3fd269e74f2f ("amba: Make the remove callback return void")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I guess I missed that driver during rebase as it was only introduced in
> the last merge window. Sorry for that.
> 
> I'm unsure what is the right thing to do now. Should I redo the pull
> request (with this patch squashed into 3fd269e74f2f)? Or do we just
> apply this patch on top?
> 
> FTR, the test robot report is at https://lore.kernel.org/r/202102030343.D9j1wukx-lkp@intel.com
> 
> Best regards
> Uwe
> 
>  drivers/mailbox/arm_mhuv2.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
> index 67fb10885bb4..6cf1991a5c9c 100644
> --- a/drivers/mailbox/arm_mhuv2.c
> +++ b/drivers/mailbox/arm_mhuv2.c
> @@ -1095,14 +1095,12 @@ static int mhuv2_probe(struct amba_device *adev, const struct amba_id *id)
>  	return ret;
>  }
>  
> -static int mhuv2_remove(struct amba_device *adev)
> +static void mhuv2_remove(struct amba_device *adev)
>  {
>  	struct mhuv2 *mhu = amba_get_drvdata(adev);
>  
>  	if (mhu->frame == SENDER_FRAME)
>  		writel_relaxed(0x0, &mhu->send->access_request);
> -
> -	return 0;
>  }
>  
>  static struct amba_id mhuv2_ids[] = {

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
