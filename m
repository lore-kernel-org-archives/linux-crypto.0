Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F402C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 22:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiKVWgn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiKVWgl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 17:36:41 -0500
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C5BC900F
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 14:36:40 -0800 (PST)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id xbsaozAnSpJKlxbsaorx22; Tue, 22 Nov 2022 23:36:38 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 22 Nov 2022 23:36:38 +0100
X-ME-IP: 86.243.100.34
Message-ID: <a83e5419-c19f-764f-9860-08385d7dd757@wanadoo.fr>
Date:   Tue, 22 Nov 2022 23:36:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] crypto: amlogic - Save a few bytes of memory
Content-Language: fr, en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org
References: <c797dc5e9248498918916a6eeedaa25de2196e8c.1669154149.git.christophe.jaillet@wanadoo.fr>
 <CAFBinCAEwYaEvmGjen_LPO52BcyUFD2EKtzzzfZ1rMuVuihEqA@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <CAFBinCAEwYaEvmGjen_LPO52BcyUFD2EKtzzzfZ1rMuVuihEqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le 22/11/2022 à 23:02, Martin Blumenstingl a écrit :
> On Tue, Nov 22, 2022 at 10:57 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> There is no real point in allocating dedicated memory for the irqs array.
>> MAXFLOW is only 2, so it is easier to allocated the needed space
>> directly within the 'meson_dev' structure.
>>
>> This saves some memory allocation and avoids an indirection when using the
>> irqs array.
> ..and it even fixes a missing devm_kcalloc error check
> 
> Personally I prefer this approach over a patch that was sent earlier today: [0]
> Corentin, Christophe, what do you think?
> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://lore.kernel.org/linux-crypto/0df30bbf-3b7e-ed20-e316-41192bf3cc2b@linaro.org/T/#m6a45b44206c282f106d379b01d19027823c5d79b
> 

Unrelated, but I think that meson_irq_handler() needs a small ajustement 
to avoid printing a spurious message if readl() returns 0.

Maybe something like that?:


@@ -33,9 +33,10 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
  				writel_relaxed(0xF, mc->base + ((0x4 + flow) << 2));
  				mc->chanlist[flow].status = 1;
  				complete(&mc->chanlist[flow].complete);
-				return IRQ_HANDLED;
+			} else {
+				dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", 
__func__, irq, flow);
  			}
-			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", 
__func__, irq, flow);
+			return IRQ_HANDLED;
  		}
  	}


CJ
