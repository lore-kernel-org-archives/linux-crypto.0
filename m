Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E03C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 14:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiGZOdm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 10:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbiGZOdl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 10:33:41 -0400
X-Greylist: delayed 369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Jul 2022 07:33:37 PDT
Received: from ouvsmtp1.octopuce.fr (ouvsmtp1.octopuce.fr [194.36.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A4E2DAA7
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 07:33:37 -0700 (PDT)
Received: from panel.vitry.ouvaton.coop (unknown [194.36.166.20])
        by ouvsmtp1.octopuce.fr (Postfix) with ESMTPS id 69556AC4;
        Tue, 26 Jul 2022 16:27:26 +0200 (CEST)
Received: from [192.168.0.20] (unknown [83.159.33.34])
        by panel.vitry.ouvaton.coop (Postfix) with ESMTPSA id B1A7B5E26E6;
        Tue, 26 Jul 2022 16:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ouvaton.org;
        s=default; t=1658845646;
        bh=o1k02q53oLSoCGEaLKDATnd3ifXWQARljwdQoJencko=; l=1119;
        h=Subject:To:From;
        b=vAC0OGTyEJ9ckqmM0XJHgk2uadAwxS0mdpjrzhL9CC+hrWE8r8fDzY7rhgefJFFAE
         GAPywuIjCrgaUMQJY9RBYyHExTdD2VWcRRscEHqdihxLxxvK4W3UjEVbQP6X8SjJCU
         B8PZtIV2T7lRkNpmgbwwkfdoM1VmKqHeWuqL8zGo=
Message-ID: <f586ebee-df86-4bed-9dca-34471737029d@ouvaton.org>
Date:   Tue, 26 Jul 2022 16:27:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Overwrittting AT_RANDOM after use (was Re: arc4random - are you sure
 we want these?)
Content-Language: fr-FR
To:     Florian Weimer <fweimer@redhat.com>,
        "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yann Droneaud <ydroneaud@opteya.com>, Michael@phoronix.com,
        linux-crypto@vger.kernel.org, jann@thejh.net, dalias@libc.org
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
 <87v8rlqscj.fsf@oldenburg.str.redhat.com>
From:   Yann Droneaud <ydroneaud@ouvaton.org>
In-Reply-To: <87v8rlqscj.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le 25/07/2022 à 14:39, Florian Weimer a écrit :

> * Jason A. Donenfeld via Libc-alpha:

>>   (After all, I didn't see any wild-n-crazy fallback
>> to AT_RANDOM like what systemd does with random-util.c:
>> https://github.com/systemd/systemd/blob/main/src/basic/random-util.c )
> I had some patches with AT_RANDOM fallback, including overwriting
> AT_RANDOM with output from the seeded PRNG.  It's certainly messy.  I
> probably didn't bother to post these patches given how bizarre the whole
> thing was.


It's not that bizarre as I have some patches too: I tried to harden the 
way stack_chk_guard and pointer_chk_guard were computed.
Those values are currently generated from slices of AT_RANDOM by the loader.


But I've seen in the wild program reusing AT_RANDOM, thus possibily 
leaking stack_chk_guard and pointer_chk_guard values.


Having a proper (CS)PRNG in the loader, initialized from AT_RANDOM, that 
overwrites AT_RANDOM (with fresh entropy if possible) after 
initialization, would improve programs abusing AT_RANDOM purpose.


Regards.


-- 

Yann Droneaud

OPTEYA


