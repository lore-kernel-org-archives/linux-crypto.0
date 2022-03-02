Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EE5C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 16:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiCBQXj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 11:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiCBQXi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 11:23:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A179E3CFDE
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 08:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646238174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=319HSMClYmc73i4+9cM7jkH73o3HvmVRZnh4aruHeG8=;
        b=fwvJ7WjsQ4evanuIWxXxzhDI5kKmNuE/7HkJfGM2gAUPlgPTLr0LZj4XFuqlmQgRx6s8GK
        WW4Cg5o7sgDgJq7vySwnLd2vti8XAH50Nj+dxVqS1qtSw/j+jDEkm2WTkidGnubD2assti
        JAs/RnCA6JyTZv7XqU8RV1aziu2ptRo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-NQOWNU9OPd6dzXuq_K9sgw-1; Wed, 02 Mar 2022 11:22:53 -0500
X-MC-Unique: NQOWNU9OPd6dzXuq_K9sgw-1
Received: by mail-wm1-f70.google.com with SMTP id d8-20020a05600c34c800b0037e3cd6225eso693929wmq.6
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 08:22:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=319HSMClYmc73i4+9cM7jkH73o3HvmVRZnh4aruHeG8=;
        b=aV/Fl3yMk8hrUeW5s+CL6yrxMMZnZrneJH/ZRPTQHJeiUlfoH9hPB6jhsRlnUlgNaG
         Wd5o3z1AYx/ZTYyNol/0qG+pjSfGmb/a9EuRutpbE1lBgTrSquDm9zOAcNlmEfNQUhUj
         2W5Gg9jnAcoCzaKE1T1nPWal3PsxviOs70rj7614M8mooZUn/V7to5gfd4mr2mNyVNLs
         PCTZzqTP597lfMKPbpiXn5/+40tCpJc3gmkL1BgI4rgzzwy3Q8irfiWstKb4D59RPss+
         i7kcAYjYvwsiwa8SQhefMn5woayALQW4SqsOg/aGKqW9a4lOVgkagqF9/+MO+HO7WnQX
         zbQw==
X-Gm-Message-State: AOAM531mCUQcqCuhpsA3Lusk298nxfZ5ilfAw4hm6amYx0FKuVj7DXB+
        b8W2cY3IthzceElT02q2doTlP9QGcGdRarHOhb5qi+gc0+H36eT+WzGLosue9OKQ3PifRE+hN77
        NEvprhJUDZoWfuUqdRkoCCEA2
X-Received: by 2002:a05:600c:378b:b0:381:67e7:e20c with SMTP id o11-20020a05600c378b00b0038167e7e20cmr479492wmr.32.1646238171013;
        Wed, 02 Mar 2022 08:22:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzS+hgEnn1ZApPqccdMegoD/Y1rBIvh8rKEfDBm0b4Su6FFtEq0p31uoeFi3LW+QoZEiPhhcg==
X-Received: by 2002:a05:600c:378b:b0:381:67e7:e20c with SMTP id o11-20020a05600c378b00b0038167e7e20cmr479479wmr.32.1646238170768;
        Wed, 02 Mar 2022 08:22:50 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d49ce000000b001f036a29f42sm2040814wrs.116.2022.03.02.08.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:22:50 -0800 (PST)
Date:   Wed, 2 Mar 2022 11:22:46 -0500
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
Message-ID: <20220302111737-mutt-send-email-mst@kernel.org>
References: <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
 <20220302092149-mutt-send-email-mst@kernel.org>
 <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
 <20220302101602-mutt-send-email-mst@kernel.org>
 <Yh+PET49oHNpxn+H@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+PET49oHNpxn+H@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 02, 2022 at 04:36:49PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Wed, Mar 02, 2022 at 10:20:25AM -0500, Michael S. Tsirkin wrote:
> > So writing some code:
> > 
> > 1:
> > 	put plaintext in a buffer
> > 	put a key in a buffer
> > 	put the nonce for that encryption in a buffer
> > 
> > 	if vm gen id != stored vm gen id
> > 		stored vm gen id = vm gen id
> > 		goto 1
> > 
> > I think this is race free, but I don't see why does it matter whether we
> > read gen id atomically or not.
> 
> Because that 16 byte read of vmgenid is not atomic. Let's say you read
> the first 8 bytes, and then the VM is forked.

But at this point when VM was forked plaintext key and nonce are all in
buffer, and you previously indicated a fork at this point is harmless.
You wrote "If it changes _after_ that point of check ... it doesn't
matter:"

> In the forked VM, the next
> 8 bytes are the same as last time, but the first 8 bytes, which you
> already read, have changed. In that case, your != becomes a ==, and the
> test fails.

Yes I'm aware what an atomic read is. If the read is not atomic
a part of value can change ;)

-- 
MST

