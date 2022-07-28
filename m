Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC7DC04A68
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jul 2022 00:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiG1Aah (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jul 2022 20:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiG1Aag (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jul 2022 20:30:36 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3FD54C9A
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 17:30:35 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26S0UCCS031326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 20:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658968215; bh=1wi5L4K34t9LcQgNbR3NZ2jp2nBfmS+5NosxquH20QM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=IchE0OxmTpZDwvNSku9evK5bGiveQ4BU0aCb8xo9FZm12vvLpum7EDXm8jksZKt4S
         w6QzdTlPjc7GOjI8FaqPge5qzz6hjybTeldtm0XGvid7ziugiCCtRCKVXX8Vs8lohP
         Buuzyvkc5crz7cRspZtQdXVZNFSYF3yr+LQ3eMsGK4cOBqDmhubpphPhiSknZNkvFC
         KMHMtrkraDZmeSZzoazTwcGBKqMKxXl0ZE9LL7e6ptbnzPSj88RyEEFt2hKt61arRo
         XacWTThshjFwzl6wZiCp49bLZcI/+DBtBYuFgUq/E3i3HLniCvomJQaqhjgrgH1z5c
         g6TZOZyavtibQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CBC0315C3AE2; Wed, 27 Jul 2022 20:30:12 -0400 (EDT)
Date:   Wed, 27 Jul 2022 20:30:12 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Rich Felker <dalias@libc.org>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Michael@phoronix.com, linux-crypto@vger.kernel.org, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
Message-ID: <YuHYlIXR0wsjyjIY@mit.edu>
References: <878rohp2ll.fsf@oldenburg.str.redhat.com>
 <20220725174430.GI7074@brightrain.aerifal.cx>
 <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
 <20220725184929.GJ7074@brightrain.aerifal.cx>
 <YuCa1lDqoxdnZut/@mit.edu>
 <a5b6307d-6811-61b6-c13d-febaa6ad1e48@linaro.org>
 <YuEwR0bJhOvRtmFe@mit.edu>
 <87v8rid8ju.fsf@oldenburg.str.redhat.com>
 <YuGc3O88Zxb5HkxY@mit.edu>
 <20220727215949.GM7074@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727215949.GM7074@brightrain.aerifal.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 27, 2022 at 05:59:49PM -0400, Rich Felker wrote:
> The only place I've heard of a viable "soft requirement" for real
> entropy is for salting the hash function used in hash table maps to
> harden them against DoS via intentional collisions. This is a small
> but arguably legitimate usage domain.

OK, so this is an issue that both Perl and Python have had to deal
with, as described here: https://lwn.net/Articles/474912/

Is that fair description of the use case which you are describing?
Because if it is, in the worst case, we only need a single random
value for every http request made to the server.  Would you agree with
that?

I think you'll find that even the original getrandom(2) system call or
fetching a random value from /dev/urandom was plenty fast enough for
this particular use case.  If you're on some slow, ancient CPU, the
webserver isn't going to be able to handle that many queries per
second.  And if you're on a fast CPU, the original /dev/urandom and/or
getrandom(2) system call would be plenty fast enough.

This is why both Jason and I have been trying to push people to
clearly articular a specific use case and the attendant performance
requirement, so we can test the hypothesis regarding how critical it
is to have an userspace cryptographically secure RNG, with all of the
attendant opportunities for security vulnerabilities in the face of VM
snapshots, or VM's getting duplicated with a pre-spun execution image,
etc., etc.

Cheers,

					- Ted
