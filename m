Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E67C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Feb 2022 10:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiBYKlG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Feb 2022 05:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbiBYKlE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Feb 2022 05:41:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4E3D1ACA14
        for <linux-crypto@vger.kernel.org>; Fri, 25 Feb 2022 02:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645785629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRwx65i57jRl4bCHTSkVyWCFjWZQA8Tr5rcxePhpjvg=;
        b=QotQqYph9ANHhruxRZ2w42A20WDDp0bJX2AC4ceK7oez6jGZk2idbNKdWUd1QwQOZk6qlZ
        Pu+GBgb5PuGcEF0vqo7AB4f8O0o8xOFfnRRA4IvPMG50k/yYniiWuJ4ghBiMGCHClEHI0Q
        /Ckl5FcuqNirEY+xthziSlKIySrkBfw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-49blmB3qN0WBBvziVLYusA-1; Fri, 25 Feb 2022 05:40:28 -0500
X-MC-Unique: 49blmB3qN0WBBvziVLYusA-1
Received: by mail-wr1-f72.google.com with SMTP id j27-20020adfb31b000000b001ea8356972bso753267wrd.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Feb 2022 02:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lRwx65i57jRl4bCHTSkVyWCFjWZQA8Tr5rcxePhpjvg=;
        b=sg2YZ81g0DoKEjmEUJR2TaZnEygf/J2TluM+6l90PcNcNGHUUExfQs4csn9fQ/8v5A
         S1+7B9zCE7RCxOTN/Z3wIr1vgOmLNAlsxQJQU7C8NBQ58UvaCBCFP252Tk4dezw3xK9e
         6ckGV5zZhfN5EFrD3aziBIZa3mX3dX3dk9BZGqBSsRXAE1T4UnsK5M5lMdQaIAMp/3Uj
         5EiSQ5safg2L7DqJkOBtXZg2MT3JmsL2cyWlQOY9mT4HFta2kyahYVr75L4GT3WtlPv0
         9d3+4NEt0uqpppCYxoO7os5uthvgeCAEd8C2d3i3vuSaXwc0jRZvKq3DK5WJOniSbLn4
         DZEw==
X-Gm-Message-State: AOAM531HJan+kYPM8pAJkXWe2xJpQ/aVZkvAVudIy493J+r09MCBF2sL
        /N9oB5GjbyWSAeyer5YkICMmVT6VoOKdsyGUNFz0uHjR5WbaespbPVkkVv53b6GybpX7YMHBpuI
        i73PktZ8VnGVo5FGNAteC6hn6
X-Received: by 2002:a5d:5584:0:b0:1ed:e423:18f4 with SMTP id i4-20020a5d5584000000b001ede42318f4mr5268155wrv.509.1645785627490;
        Fri, 25 Feb 2022 02:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+suvh52UL+yxQwZMYSZGg0of8oD756hKzab+wp95qXtMVPTn7Je7xnvr6hZRVfR9ly8TmQg==
X-Received: by 2002:a5d:5584:0:b0:1ed:e423:18f4 with SMTP id i4-20020a5d5584000000b001ede42318f4mr5268127wrv.509.1645785627288;
        Fri, 25 Feb 2022 02:40:27 -0800 (PST)
Received: from redhat.com ([2.55.145.157])
        by smtp.gmail.com with ESMTPSA id p30-20020a1c545e000000b003811f9102c0sm3167339wmi.32.2022.02.25.02.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:40:26 -0800 (PST)
Date:   Fri, 25 Feb 2022 05:40:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>, linux-s390@vger.kernel.org,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>, graf@amazon.com,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Igor Mammedov <imammedo@redhat.com>, ehabkost@redhat.com,
        ben@skyportsystems.com, "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
Message-ID: <20220225053937-mutt-send-email-mst@kernel.org>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <CAHmME9ogH_mx724n_deFfva7-xPCmma1-=2Mv0JdnZ-fC4JCjg@mail.gmail.com>
 <2653b6c7-a851-7a48-f1f8-3bde742a0c9f@redhat.com>
 <YhdkD4S7Erzl98So@redhat.com>
 <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9qRrLHwOjD+_xkGC7-BMVdzO95=DzhCo8KvDNa0JXVybA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 24, 2022 at 11:57:34AM +0100, Jason A. Donenfeld wrote:
> On Thu, Feb 24, 2022 at 11:56 AM Daniel P. Berrangé <berrange@redhat.com> wrote:
> > IIRC this part of the QEMU doc was making an implicit assumption
> > about the way QEMU is to be used by mgmt apps doing snapshots.
> >
> > Instead of using the 'loadvm' command on the existing running QEMU
> > process, the doc seems to tacitly expect the management app will
> > throwaway the existing QEMU process and spawn a brand new QEMU
> > process to load the snapshot into, thus getting the new GUID on
> > the QEMU command line.
> 
> Right, exactly. The "there are no known use cases" bit I think just
> forgot about one very common use case that perhaps just wasn't in use
> by the original author. So I'm pretty sure this remains a QEMU bug.
> 
> Jason

Quite possibly yes.

-- 
MST

