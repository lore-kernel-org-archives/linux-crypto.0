Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70465C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 09:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B66920780
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 09:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgKJJhG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 04:37:06 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60451 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727991AbgKJJhG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 04:37:06 -0500
Received: from [192.168.0.2] (ip5f5af431.dynamic.kabel-deutschland.de [95.90.244.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 20E712064712F;
        Tue, 10 Nov 2020 10:37:03 +0100 (CET)
Subject: Re: jitterentropy: `jent_mod_init()` takes 17 ms
To:     Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <02fa159f-4f94-cfb7-1f88-bed91c6542a1@molgen.mpg.de>
 <4825077.WBkqHH8m98@tauon.chronox.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <a422b262-3923-0d29-1a11-3498724a98ad@molgen.mpg.de>
Date:   Tue, 10 Nov 2020 10:37:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <4825077.WBkqHH8m98@tauon.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dear Stephan,


Thank you for the quick reply.

Am 10.11.20 um 10:25 schrieb Stephan Mueller:
> Am Montag, 9. November 2020, 20:31:02 CET schrieb Paul Menzel:

>> By mistake I built `XFRM_ESP` into the Linux kernel, resulting in
>>
>>       CONFIG_CRYPTO_SEQIV=y
>>       CONFIG_CRYPTO_ECHAINIV=y
>>
>> and also the Jitterentropy RNG to be built in.
>>
>>       CRYPTO_JITTERENTROPY=y
>>
>> So, on the Asus F2A85-M PRO starting Linux 4.10-rc3 with
>> `initcall_debug`, the init method is run unconditionally, and it takes
>> 17.5 ms, which is over ten percent of the overall 900 ms the Linux
> 
> Hm, 17.5 / 900 = 2%, or am I missing something?

Indeed, that is embarrassing. My bad.

>> kernel needs until loading the init process.
>>
>>       [    0.300544] calling  jent_mod_init+0x0/0x2c @ 1
>>       [    0.318438] initcall jent_mod_init+0x0/0x2c returned 0 after 17471 usecs
>>
>> Looking at the output of systemd-bootchart, it looks like, that this
>> indeed delayed the boot a little, as the other init methods seem to be
>> ordered after it.
>>
>> I am now building it as a module, but am wondering if the time can be
>> reduced to below ten milliseconds.
> 
> What you see is the test whether the Jitter RNG has a proper noise source. The
> function jent_entropy_init() is the cause of the operation. It performs 1024
> times a test to validate the appropriateness of the noise source. You can
> adjust that with the TESTLOOPCOUNT in this function. But I am not sure
> adjusting is a wise course of action.

Out of curiosity, why 1024 and not, for example, 128 or 2048? Is there 
some statistics behind it?


Kind regards,

Paul
