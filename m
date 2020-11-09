Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FE2C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 19:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD602065D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 19:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgKITbG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 14:31:06 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40755 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbgKITbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 14:31:06 -0500
Received: from [192.168.0.2] (ip5f5af1fc.dynamic.kabel-deutschland.de [95.90.241.252])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D6F902064713E;
        Mon,  9 Nov 2020 20:31:02 +0100 (CET)
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: jitterentropy: `jent_mod_init()` takes 17 ms
Message-ID: <02fa159f-4f94-cfb7-1f88-bed91c6542a1@molgen.mpg.de>
Date:   Mon, 9 Nov 2020 20:31:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dear Linux folks,


By mistake I built `XFRM_ESP` into the Linux kernel, resulting in

     CONFIG_CRYPTO_SEQIV=y
     CONFIG_CRYPTO_ECHAINIV=y

and also the Jitterentropy RNG to be built in.

     CRYPTO_JITTERENTROPY=y

So, on the Asus F2A85-M PRO starting Linux 4.10-rc3 with 
`initcall_debug`, the init method is run unconditionally, and it takes 
17.5 ms, which is over ten percent of the overall 900 ms the Linux 
kernel needs until loading the init process.

     [    0.300544] calling  jent_mod_init+0x0/0x2c @ 1
     [    0.318438] initcall jent_mod_init+0x0/0x2c returned 0 after 
17471 usecs

Looking at the output of systemd-bootchart, it looks like, that this 
indeed delayed the boot a little, as the other init methods seem to be 
ordered after it.

I am now building it as a module, but am wondering if the time can be 
reduced to below ten milliseconds.


Kind regards,

Paul
