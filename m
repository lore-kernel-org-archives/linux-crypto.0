Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC42C04A68
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 14:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiGZOgY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239218AbiGZOf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 10:35:59 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [IPv6:2a01:e0c:1:1599::13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D1218375
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 07:35:49 -0700 (PDT)
Received: from [IPV6:2a01:e35:39f2:1220:a31f:dd28:d78d:59ef] (unknown [IPv6:2a01:e35:39f2:1220:a31f:dd28:d78d:59ef])
        by smtp4-g21.free.fr (Postfix) with ESMTPS id 7C8D319F752;
        Tue, 26 Jul 2022 16:35:40 +0200 (CEST)
Message-ID: <df5c0926-22f8-af79-4972-ff41488ef945@opteya.com>
Date:   Tue, 26 Jul 2022 16:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: arc4random - are you sure we want these?
Content-Language: en-US
To:     Florian Weimer <fweimer@redhat.com>,
        "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Michael@phoronix.com,
        linux-crypto@vger.kernel.org, jann@thejh.net
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
 <87v8rlqscj.fsf@oldenburg.str.redhat.com>
From:   Yann Droneaud <ydroneaud@opteya.com>
Organization: OPTEYA
In-Reply-To: <87v8rlqscj.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le 25/07/2022 à 14:39, Florian Weimer a écrit :
> * Jason A. Donenfeld via Libc-alpha:
>>> The performance numbers suggest that we benefit from buffering in user
>>> space.
>> The question is whether it's safe and advisable to buffer this way in
>> userspace. Does userspace have the right information now of when to
>> discard the buffer and get a new one? I suspect it does not.
> Not completely, no, but we can cover many cases.  I do not currently see
> a way around that if we want to promote arc4random_uniform(limit) as a
> replacement for random() % limit.

+1

That the reason I've reviewed the implementation positively: for me 
arc4random is not about generating secret keys but small integers.
I want to be able to divert developers from
     srand(time(NULL))
     identifier = rand() % 33
to
     identifier = arc4random_uniform(33)

Safe, fast, and reasonably secure.


Regards.


-- 
Yann Droneaud
OPTEYA


