Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A3BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 15:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243434AbiCBPVR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiCBPVR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 10:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF18DC6259
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 07:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646234433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o+/uKNtMSqxxtp2IKJVl4PtqKh8tUPajkwApvE96v0s=;
        b=iZvlekyAFl5nhUjkv+onEJRQIPyP7cB+kIaFJrHbDQ7pATZiAYE/Tq0qBzlMzuHFHLOmpt
        zdYbNAkNwWffzIUXc6FizFwUuQ3JkC2BEfyNqKWaIKMbuIQkucj75fyBYJ3SbWkm/kJU2a
        6FDxgfebhtt2Dd8xIt8C7EZO8WD/ewA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-bZwfpALWOMKD7jP3OyutTA-1; Wed, 02 Mar 2022 10:20:31 -0500
X-MC-Unique: bZwfpALWOMKD7jP3OyutTA-1
Received: by mail-wm1-f72.google.com with SMTP id v67-20020a1cac46000000b00383e71bb26fso522630wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 07:20:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o+/uKNtMSqxxtp2IKJVl4PtqKh8tUPajkwApvE96v0s=;
        b=2+k57HdoamaY3bLsVCVe2SzyMsZXnhTFpfg9AWPMAmzZsTLwTFFd3FFWLHLaynS/Bp
         F1jWjStI3No8Ngulyd+dF3zXKVKnwItiyv5QLAWrcxtNfHE13xOYKo5FXmiplcFO33hP
         IgX7qCvfuaA4YZ4Kxo9KSxUoyrnO5GNeAgtXIRZ45isGuJuwYWMAmT4+q2huGbjPgB2Q
         fdUfMtxZXncHiRRhXkzlEoLle3ktEF6OEOY3Lk/zaU2K1Mqsh3EDjifqRd9Oc/cdzFxJ
         u9HjuoFK/g3Tl1JwUoZwjXwHn4kMZNjiry1z4vd69qhJr6wRH2WZ19SHD/SmcXCuYz2R
         l8RQ==
X-Gm-Message-State: AOAM5317x27Up3TiQVuZSLOYVYiRrN9G61UCYhS8/hDMRYE89T3hsZnX
        duYrDZQeVFqxsXrPruOiuwdbwBKJdKo+smjemfum+b+6tlA3Kpzx7PnytLZ8keohwMK0pRDRRET
        GGgx2wqRzaeb4zW12ttUrGq4L
X-Received: by 2002:a05:6000:114d:b0:1ee:f251:52c6 with SMTP id d13-20020a056000114d00b001eef25152c6mr22351325wrx.618.1646234430717;
        Wed, 02 Mar 2022 07:20:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaRd2QDCauXRg0Cy1iugecAP23hz+39Lwf58iM9a92otz79fxfMO534ZE5Hi2k0kqltL5FeA==
X-Received: by 2002:a05:6000:114d:b0:1ee:f251:52c6 with SMTP id d13-20020a056000114d00b001eef25152c6mr22351286wrx.618.1646234430410;
        Wed, 02 Mar 2022 07:20:30 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id m18-20020a5d56d2000000b001edc00dbeeasm16452690wrw.69.2022.03.02.07.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 07:20:29 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:20:25 -0500
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
Message-ID: <20220302101602-mutt-send-email-mst@kernel.org>
References: <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
 <20220302092149-mutt-send-email-mst@kernel.org>
 <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 02, 2022 at 04:14:56PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Wed, Mar 2, 2022 at 3:46 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > I just don't see how "value changed while it was read" is so different
> > from "value changed one clock after it was read".  Since we don't detect
> > the latter I don't see why we should worry about the former.
> 
> The "barrier" is at the point where the plaintext has been chosen AND
> the nonce for a given keypair has been selected. So, if you have
> plaintext in a buffer, and a key in a buffer, and the nonce for that
> encryption in a buffer, and then after those are all selected, you
> check to see if the vmgenid has changed since the birth of that key,
> then you're all set. If it changes _after_ that point of check (your
> "one clock after"), it doesn't matter: you'll just be
> double-transmitting the same ciphertext, which is something that flaky
> wifi sometimes does _anyway_ (and attackers can do intentionally), so
> network protocols already are resilient to replay. This is the same
> case you asked about earlier, and then answered yourself, when you
> were wondering about reaching down into qdiscs.
> 
> Jason

So writing some code:

1:
	put plaintext in a buffer
	put a key in a buffer
	put the nonce for that encryption in a buffer

	if vm gen id != stored vm gen id
		stored vm gen id = vm gen id
		goto 1

I think this is race free, but I don't see why does it matter whether we
read gen id atomically or not.

-- 
MST

