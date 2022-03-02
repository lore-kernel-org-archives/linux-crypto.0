Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DFDC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 07:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbiCBHn0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbiCBHnZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 02:43:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9241612600
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 23:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646206959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r54KECS5Ta4+XfMPrM9TZqlD4g6ikpj26D7X7GFm2xk=;
        b=QMs8ba4d0AilIqnziBBUUTDmtQakhIK46ClD949Mvdto6I+vJR9LbkKT/LP1WjDIz8lA5T
        CMoCIDHFQzsppTGhfTaUup3MowobN69zqAzUuTgslnODl66D2sHO4dWq6uCKhYZSAkCPAG
        cs90gcr9rRIi1GdJgDlPUvm2q6Wtp+s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-i_eVaZGqOYO9pR8An31ZbQ-1; Wed, 02 Mar 2022 02:42:38 -0500
X-MC-Unique: i_eVaZGqOYO9pR8An31ZbQ-1
Received: by mail-wm1-f72.google.com with SMTP id m34-20020a05600c3b2200b0038115c73361so230350wms.5
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 23:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r54KECS5Ta4+XfMPrM9TZqlD4g6ikpj26D7X7GFm2xk=;
        b=pAIPdan8RHByrl5+aCbATuPblCTWlZLYg73Gd31O8/4FnSJxqlt6Y7ICbGQiqLgsiS
         sF2W/MQhf2eq1VyCw5bEdb+r90/7bnnXg17gdn5B/TQkKOMJvVwKdglfgsphv4X1ddy7
         F+gUjyhO1evV6Uf/WYTSaI3vVwZ2d+72mDRAyKa1WBB50LfgXCWRoc/aT0EyEv+/cJrv
         Vxc+nWZ3tUbM4mDxyAB7w/EKnczXn/PMX0B6hxMcGaXGWKpajVNp4jmReB7mCwG+dzlG
         QVwgaKt0Zi0Rl5CctUfGePsK1r/LECx91nn7aDAtZftAbFvkUazgN0oD92Gaa+wc4KVz
         S1Tg==
X-Gm-Message-State: AOAM533bMovtaSXMLxSqL/JkybqiPeLsFiu/kn8k3rn80Ib+ETBx/h9V
        XOp1PFfCf1XBF5yhjNIlRvymarHb1EXGrZhx0TexxKr7mqAKVThRBKSevr/kHCtWXsVjcvh4wij
        z8LYmTcLhEqV9X44U8QontTE4
X-Received: by 2002:a05:600c:4ed0:b0:37b:e983:287b with SMTP id g16-20020a05600c4ed000b0037be983287bmr19550326wmq.156.1646206957619;
        Tue, 01 Mar 2022 23:42:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrhIny0LTz+oAiVJdVBdcw7M1SyuYOvWiCd108UgZKej5mVsXb3i5PRUQLI/CVYzNAxiQ1tA==
X-Received: by 2002:a05:600c:4ed0:b0:37b:e983:287b with SMTP id g16-20020a05600c4ed000b0037be983287bmr19550301wmq.156.1646206957345;
        Tue, 01 Mar 2022 23:42:37 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c4f8f00b003842f011bc5sm1040455wmq.2.2022.03.01.23.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 23:42:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 02:42:33 -0500
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
Message-ID: <20220302024137-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 01, 2022 at 07:37:06PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Tue, Mar 1, 2022 at 6:17 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > Hmm okay, so it's a performance optimization... some batching then? Do
> > you really need to worry about every packet? Every 64 packets not
> > enough?  Packets are after all queued at NICs etc, and VM fork can
> > happen after they leave wireguard ...
> 
> Unfortunately, yes, this is an "every packet" sort of thing -- if the
> race is to be avoided in a meaningful way. It's really extra bad:
> ChaCha20 and AES-CTR work by xoring a secret stream of bytes with
> plaintext to produce a ciphertext. If you use that same secret stream
> and xor it with a second plaintext and transmit that too, an attacker
> can combine the two different ciphertexts to learn things about the
> original plaintext.

So what about the point about packets queued then? You don't fish
packets out of qdisc queues, do you?

> But, anyway, it seems like the race is here to stay given what we have
> _currently_ available with the virtual hardware. That's why I'm
> focused on trying to get something going that's the least bad with
> what we've currently got, which is racy by design. How vitally
> important is it to have something that doesn't race in the far future?
> I don't know, really. It seems plausible that that ACPI notifier
> triggers so early that nothing else really even has a chance, so the
> race concern is purely theoretical. But I haven't tried to measure
> that so I'm not sure.
> 
> Jason

