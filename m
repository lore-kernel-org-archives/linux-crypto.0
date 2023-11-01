Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E251C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 12:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbjKAME5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjKAME5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 08:04:57 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52237F7
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 05:04:51 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qy9xo-0001cN-9r; Wed, 01 Nov 2023 13:04:48 +0100
Message-ID: <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
Date:   Wed, 1 Nov 2023 13:04:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
Content-Language: en-US, de-DE
To:     Yureka <yuka@yuka.dev>
Cc:     linux-crypto@vger.kernel.org, regressions@lists.linux.dev,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Eric Biggers <ebiggers@kernel.org>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
 <20230929224327.GA11839@google.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20230929224327.GA11839@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1698840291;2c6ccb74;
X-HE-SMSGID: 1qy9xo-0001cN-9r
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

n 30.09.23 00:43, Eric Biggers wrote:
> On Fri, Sep 29, 2023 at 11:08:55PM +0200, Yureka wrote:
>>
>> I am running the NixOS distribution cross-compiled from x86_64 to a Marvell
>> Armada 388 armv7 SoC.
>>
>> I am not getting expected speeds when reading/writing on my encrypted hard
>> drive with 6.5.5, while it is fast on 5.4.257. Volume is formatted like this:
>> `cryptsetup luksFormat -c aes-cbc-essiv:sha256 /dev/sda`.
>>
>> Specifically, I tracked this down to the changes to crypto/essiv.c from
>> 7bcb2c99f8ed mentioned above. Reverting those changes on top of a 6.5.5 kernel
>> provides working (see applicable diff further below).
>>
>> I'm *guessing* that this is related to the mv-aes-cbc crypto driver (from the
>> marvell-cesa module) being registered as async (according to /proc/crypto),
>> and I *suspect* that async drivers are not being used anymore by essiv or
>> dm_crypt. Going by the commit description, which sounds more like a refactor,
>> this does not seem intentional.
> 
> This is actually from commit b8aa7dc5c753 ("crypto: drivers - set the flag
> CRYPTO_ALG_ALLOCATES_MEMORY"), which set CRYPTO_ALG_ALLOCATES_MEMORY in
> marvell-cesa.  7bcb2c99f8ed is just one of the prerequisite commits.
> 
> I understand that the dm-crypt developers did this as an intentional bug fix in
> order to prevent dm-crypt from using crypto drivers that are known to cause
> deadlocks due to allocating memory during requests.
> 
> If you are interested in still being able to use marvell-cesa with dm-crypt, I
> believe it would need to be fixed to meet the requirements for not needing
> CRYPTO_ALG_ALLOCATES_MEMORY.  I've Cc'ed the maintainers of that driver.
> 
> #regzbot introduced: b8aa7dc5c753

BTW: Eric, thx for this.

Boris, Arnaud, Srujana, and Mikulas, could you maybe comment on this? I
understand that this is not some everyday regression due to deadlock
risk, but it nevertheless would be good to get this resolved somehow to
stay in line with our "no regressions" rule.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke
