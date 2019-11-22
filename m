Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E716BC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 16:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D0E20715
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 16:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVQgi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:36:38 -0500
Received: from ns.iliad.fr ([212.27.33.1]:45398 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVQgi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 11:36:38 -0500
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 2A23F20B9F;
        Fri, 22 Nov 2019 17:36:36 +0100 (CET)
Received: from [192.168.108.51] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 19DE81FF32;
        Fri, 22 Nov 2019 17:36:36 +0100 (CET)
Subject: Re: [PATCH] crypto: picoxcell: add missed tasklet_kill
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191115023116.7070-1-hslester96@gmail.com>
 <20191122085512.m75tjfa3valqfgyv@gondor.apana.org.au>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <218e9053-42c7-098e-ecda-e0306361cc23@free.fr>
Date:   Fri, 22 Nov 2019 17:36:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122085512.m75tjfa3valqfgyv@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Fri Nov 22 17:36:36 2019 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/11/2019 09:55, Herbert Xu wrote:

> On Fri, Nov 15, 2019 at 10:31:16AM +0800, Chuhong Yuan wrote:
>> This driver forgets to kill tasklet when probe fails and remove.
>> Add the calls to fix it.
>>
>> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> 
> Yes this driver does look buggy but I think your patch isn't
> enough.
> 
>> diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
>> index 3cbefb41b099..8d7c6bb2876e 100644
>> --- a/drivers/crypto/picoxcell_crypto.c
>> +++ b/drivers/crypto/picoxcell_crypto.c
>> @@ -1755,6 +1755,7 @@ static int spacc_probe(struct platform_device *pdev)
>>  	if (!ret)
>>  		return 0;
>>  
>> +	tasklet_kill(&engine->complete);
> 
> The tasklet is schedule by the IRQ handler so you should not kill
> it until the IRQ handler has been unregistered.
> 
> This driver is also buggy because it registers the IRQ handler
> before initialising the tasklet.  You must always be prepared for
> spurious IRQs.  IOW, as soon as you register the IRQ handler you
> must be prepared for it to be called.
> 
>> @@ -1771,6 +1772,7 @@ static int spacc_remove(struct platform_device *pdev)
>>  	struct spacc_alg *alg, *next;
>>  	struct spacc_engine *engine = platform_get_drvdata(pdev);
>>  
>> +	tasklet_kill(&engine->complete);
> 
> Ditto.
> 
> However, the IRQ handler is registered through devm which makes it
> hard to kill the tasklet after unregistering it.  We should probably
> convert it to a normal request_irq so we can control how it's
> unregistered.

Or inversely, registering the tasklet_kill() through devm, so that it
is called *after* the ISR unregistration.

Regards.
