Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FD6C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 14:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbiCBOrH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiCBOrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 09:47:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1C90C793F
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 06:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646232383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w205eOqOdxeAZdCILUJdCHi/CnhyFtZESdwZqehxcdc=;
        b=GZYZDlyesE/pp8ODtAnWwaaMpSkl4SvEc6dt0M86vxmzS1/uc47uZlz4cbmfgdl3u9lwNh
        x+P1Ha9uRcrDyYOVF3mtB1owRJLN1rofnHhn6iiJvwDmyld8JuZMUrIGYXEcPzzs6bPyI0
        FA+GTAJrcZ/nryT2VGbhRpqlZbeUuCQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-aMxjvS8PP76g6cHbKiuhHw-1; Wed, 02 Mar 2022 09:46:21 -0500
X-MC-Unique: aMxjvS8PP76g6cHbKiuhHw-1
Received: by mail-wm1-f72.google.com with SMTP id a26-20020a7bc1da000000b003857205ec7cso441893wmj.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 06:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w205eOqOdxeAZdCILUJdCHi/CnhyFtZESdwZqehxcdc=;
        b=bIqFpfgXbMXtc1b9xS808yJCLFxNOOwnXP30kHMHG1uRNuRffgaCGNLPVfp86bJKLJ
         aPik8CzOunMDWAYqsMDxTh7gU3fnK5jql3boAOoM5uRM/caAa5fqN1fGt4AmnNjwOBgj
         ivWAPgbCjDjHLxeWC5B4NsX7/oI1Ep9bs5OADJ7K64ZG7bNqUCLBk0lZ7FMd1S8lLRwg
         IRd56oejfPey7M8G8TUoseYtSTVEsfkkUc9bVboYE1Es4W9VYmIS58/ehdbQ6pmjwiIe
         K1mr0WgnqsDlL2UMK7EDJo+29eAsw9dhy3yNTx0EI4xzX/XgK9o8fjdKLu/O3q2cE+rr
         aPgQ==
X-Gm-Message-State: AOAM530e1wgZO3MieEddIEmJj1LDcJovfEdeM/Kxl/X++XI6Edw0f5w9
        ouxlGkuFrvUH4AuaKmbVjTyOJyEjUuvRlZmTOwPWbsihmkoJGyE8JuPMlEQHCGZixBF7brQQ+5S
        iyRkzCtyHIF7LXslbk+l8WWtq
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr20390156wrn.301.1646232380698;
        Wed, 02 Mar 2022 06:46:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJza4Ib8iRQhbK5h23mGl00nx8utPjoauWdru+z6xmj8vBVgS9w4ICFHCPrxOEOgLj/22uh95g==
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr20390128wrn.301.1646232380470;
        Wed, 02 Mar 2022 06:46:20 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id z16-20020a7bc7d0000000b00381004c643asm5677773wmk.30.2022.03.02.06.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:46:19 -0800 (PST)
Date:   Wed, 2 Mar 2022 09:46:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220302092149-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh93UZMQSYCe2LQ7@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 02, 2022 at 02:55:29PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Wed, Mar 02, 2022 at 07:58:33AM -0500, Michael S. Tsirkin wrote:
> > > There's also the atomicity aspect, which I think makes your benchmark
> > > not quite accurate. Those 16 bytes could change between the first and
> > > second word (or between the Nth and N+1th word for N<=3 on 32-bit).
> > > What if in that case the word you read second doesn't change, but the
> > > word you read first did? So then you find yourself having to do a
> > > hi-lo-hi dance.
> > > And then consider the 32-bit case, where that's even
> > > more annoying. This is just one of those things that comes up when you
> > > compare the semantics of a "large unique ID" and "word-sized counter",
> > > as general topics. (My suggestion is that vmgenid provide both.)
> > 
> > I don't see how this matters for any applications at all. Feel free to
> > present a case that would be race free with a word but not a 16
> > byte value, I could not imagine one. It's human to err of course.
> 
> Word-size reads happen all at once on systems that Linux supports,
> whereas this is not the case for 16 bytes (with a few niche exceptions
> like cmpxchg16b and such). If you read the counter atomically, you can
> check to see whether it's changed just after encrypting but before
> transmitting and not transmit if it has changed, and voila, no race.
> With 16 bytes, synchronization of that read is pretty tricky (though
> maybe not all together impossible), because, as I mentioned, the first
> word might have changed by the time you read a matching second word. I'm
> sure you're familiar with the use of seqlocks in the kernel for solving
> a somewhat related problem.
> 
> Jason

I just don't see how "value changed while it was read" is so different
from "value changed one clock after it was read".  Since we don't detect
the latter I don't see why we should worry about the former.  What I
don't have here is how would a code reading the value look.  It might
help to write some pseudo code to show that, but I'd say it makes more
sense to just code the read up even just so the overhead of the current
interface can be roughtly measured.

-- 
MST

