Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9BECCA483
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jun 2022 07:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiF2HhR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiF2HhQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jun 2022 03:37:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65E1936173
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 00:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656488233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1h0smKgkaQYyMckjg1gEO+92UXCJgyf7f6YfzsCAFg4=;
        b=A9r6z16eLePDP7bGnj4DQvo7y3G6bSPDfVUon8h8UU1fWVxsHhqlS7X5ho2Kg8bsJ94eAB
        ZpiagtHmU1cR+Mbl+pQ9uTE8c3wDDfX5ZBou6CQVNZ5jJ68lAXx9uYydmYJ32oQ+BT7P8w
        R0bVtv950eOUgOiUhg0nh9TLSJUseeI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-Qvi7-SSNOFix4MNrE3e58Q-1; Wed, 29 Jun 2022 03:37:12 -0400
X-MC-Unique: Qvi7-SSNOFix4MNrE3e58Q-1
Received: by mail-wm1-f70.google.com with SMTP id m20-20020a05600c4f5400b003a03aad6bdfso6164544wmq.6
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 00:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1h0smKgkaQYyMckjg1gEO+92UXCJgyf7f6YfzsCAFg4=;
        b=Fk6Qv2kznBa5kpGcPqpzCKBPh0olbsAFGFqO4kRnxCZqUjjpN3+bga9b0ZJncheqHn
         X6ciLD1jH/wcr7sdJ8urIy4W+9xkbqlNSutc3dpT1zg1OehXagIlT9wz2ZaKY4KiYKcJ
         DpEW8DZVruLz3PtXzXnOzykblsvY83icHxGKvIXHsZ5+9CLz6ceKdbR8pbRaGCINhKOq
         u/7eLxRJcy0zQRtsXlLLyPq44pO1PCRvGjQZaOC5fzIWHhxYPktwO1TVwiECZkq46hfZ
         jJF93Mo9NNNafjF/bqU1kHY7Bv4CWBWiRZvk4BsqpsIQczWwCPgKBrjuyv6D9Y+p6l0A
         Z9gA==
X-Gm-Message-State: AJIora9Q2zYoS3WGYUnmyFw4ff7ZMMAJf/DKh0+ZtABKV8AwrQyHCPbS
        HHdxQmwuAE4n5nscqu4+l0PBUeWRzWQBMWDLeQv8xvf6CKKRJ/3DznBCidV+UlqbXleBG3o0Im6
        CvcJ+teRPMOJ83eI6U21fO+Kr
X-Received: by 2002:a05:6000:1448:b0:21b:b7db:c40b with SMTP id v8-20020a056000144800b0021bb7dbc40bmr1650281wrx.279.1656488231028;
        Wed, 29 Jun 2022 00:37:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfq7mqFRSJqFJPQOP6rs25Ch1nA7fBeueZwuaRaLaWENw0ay54yTOP4QHXmGLo1NEA4L9c5g==
X-Received: by 2002:a05:6000:1448:b0:21b:b7db:c40b with SMTP id v8-20020a056000144800b0021bb7dbc40bmr1650238wrx.279.1656488230741;
        Wed, 29 Jun 2022 00:37:10 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id j10-20020a5d448a000000b0021b8c99860asm15832366wrq.115.2022.06.29.00.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 00:37:10 -0700 (PDT)
Message-ID: <7654a74e-a410-a8a5-c228-d006dbbc200f@redhat.com>
Date:   Wed, 29 Jun 2022 09:37:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-i2c@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-rtc@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-staging@lists.linux.dev, kasan-dev@googlegroups.com,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-pm@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, linux-gpio@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-hwmon@vger.kernel.org,
        Support Opensource <support.opensource@diasemi.com>,
        netdev@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        linux-crypto@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        patches@opensource.cirrus.com, linux-integrity@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
 <60cc6796236f23c028a9ae76dbe00d1917df82a5.camel@codeconstruct.com.au>
 <20220629072304.qazmloqdi5h5kdre@pengutronix.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220629072304.qazmloqdi5h5kdre@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/29/22 09:23, Uwe Kleine-König wrote:
> Hello,
> 
> [I dropped nearly all individuals from the Cc: list because various
> bounces reported to be unhappy about the long (logical) line.]
>

Yes, it also bounced for me when I tried to reply earlier today.

> diff --git a/drivers/gpu/drm/solomon/ssd130x-i2c.c b/drivers/gpu/drm/solomon/ssd130x-i2c.c
> index 1e0fcec7be47..ddfa0bb5d9c9 100644
> --- a/drivers/gpu/drm/solomon/ssd130x-i2c.c
> +++ b/drivers/gpu/drm/solomon/ssd130x-i2c.c
> @@ -39,13 +39,11 @@ static int ssd130x_i2c_probe(struct i2c_client *client)
>  	return 0;
>  }
>  
> -static int ssd130x_i2c_remove(struct i2c_client *client)
> +static void ssd130x_i2c_remove(struct i2c_client *client)
>  {
>  	struct ssd130x_device *ssd130x = i2c_get_clientdata(client);
>  
>  	ssd130x_remove(ssd130x);
> -
> -	return 0;
>  }
>  
>  static void ssd130x_i2c_shutdown(struct i2c_client *client)

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com> 
-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

