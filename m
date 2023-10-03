Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A526E75450
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 11:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbjJCLfm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjJCLfl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 07:35:41 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6CD9B
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 04:35:38 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qndgZ-0003Sc-5N; Tue, 03 Oct 2023 13:35:31 +0200
Message-ID: <436a7e20-082f-4aa9-bfbd-703d149d5463@leemhuis.info>
Date:   Tue, 3 Oct 2023 13:35:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Content-Language: en-US, de-DE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230905232757.36459-1-wahrenst@gmx.net>
 <ZQQ1tgDEGGXwfu/4@gondor.apana.org.au>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <ZQQ1tgDEGGXwfu/4@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1696332938;a96aed73;
X-HE-SMSGID: 1qndgZ-0003Sc-5N
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15.09.23 12:45, Herbert Xu wrote:
> On Wed, Sep 06, 2023 at 01:27:57AM +0200, Stefan Wahren wrote:
>> The last RCU stall fix caused a massive throughput regression of the
>> hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
>> and usleep_range doesn't allow scheduling. So try to restore the
>> best possible throughput by introducing hwrng_yield which interruptable
>> sleeps for one jiffy.
>>
>> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
>>
>> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
>>
>> cpu_relax              ~138025 Bytes / sec
>> hwrng_msleep(1000)         ~13 Bytes / sec
>> hwrng_yield              ~2510 Bytes / sec
>>
>> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
>> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> ---
>>
>> Changes in V2:
>> - introduce hwrng_yield and use it
>>
>>  drivers/char/hw_random/bcm2835-rng.c | 2 +-
>>  drivers/char/hw_random/core.c        | 6 ++++++
>>  include/linux/hw_random.h            | 1 +
>>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> Patch applied.  Thanks.

Hi Herbert, I there a strong reason why you merged this to what from
here looks like the branch that targets the next merge window? The patch
fixes a regression introduced during the last 12 months and thus
normally should not wait for the next merge window. For details see
"Expectations and best practices for fixing regressions" in
Documentation/process/handling-regressions.rst; or if you want to hear
it from Linus directly, check these out:
https://lore.kernel.org/all/CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgD98pmSK3ZyHk_d9kZ2bhgN6DuNZMAJaV0WTtbkf=RDw@mail.gmail.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
