Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AD2C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Apr 2022 06:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbiD2G3y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Apr 2022 02:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiD2G3x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Apr 2022 02:29:53 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B168A541A0
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 23:26:35 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23T6QCZF004314;
        Fri, 29 Apr 2022 15:26:12 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Fri, 29 Apr 2022 15:26:12 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23T6QBj2004307
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 29 Apr 2022 15:26:12 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5de198b9-7488-13e4-bf22-6c58c1c8b401@I-love.SAKURA.ne.jp>
Date:   Fri, 29 Apr 2022 15:26:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] crypto: atmel - Avoid flush_scheduled_work() usage
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org
References: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
 <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/04/29 14:30, Herbert Xu wrote:
> On Wed, Apr 20, 2022 at 10:27:11AM +0900, Tetsuo Handa wrote:
>>
>> +module_init(atmel_i2c_init);
>> +module_exit(atmel_i2c_exit);
> 
> What if everything is built-in? Shouldn't this be moved to a place
> earlier than module_init?

Since drivers/crypto/Makefile has lines in

obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o

order (which will be used as link order for built-in.o), module_init()
is processed in this order. Also, module_exit() is no-op if built-in.
Therefore, I think there is no need to explicitly boost the priority
of atmel_i2c_init().

