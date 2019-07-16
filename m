Return-Path: <SRS0=wawN=VN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB555C76195
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 18:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC14220880
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 18:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HaFxzYUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfGPS2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jul 2019 14:28:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39483 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388345AbfGPS2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jul 2019 14:28:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so5527273pfn.6
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jul 2019 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:from:to:subject:cc:user-agent:date;
        bh=zvGcK+VeZ8cxUQUUb/Ziua1dyjBrgzj1NF9vZ94FkTY=;
        b=HaFxzYUquBICo8Qa2dhDAMayVb4+B8XnoZq6FveM6TFEZ4xttZwMrCmGGANC/QGVlw
         u+Q8JPimlFkaChFUdUbnRKD6m1PJup0MyZsBkdRyVka7yI9ODuShs0+cBre686lEzvVj
         jGQyqpkhbiFKGwnAmGCcyqaMlrf7d6Hd+QgwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:from:to:subject:cc
         :user-agent:date;
        bh=zvGcK+VeZ8cxUQUUb/Ziua1dyjBrgzj1NF9vZ94FkTY=;
        b=Ct57xP7HJIIYdbCWKZziY4LgRR9uMGrggRFfcAMO417mpMorrfLPQZzvT7vH938cFp
         S38l5iZyGutwkVIX1is6rELVv5HSHtWX1FylM/TSSwdaaCJlp5dND74woh8ZjxBFdVTm
         BHGiwRb8AolW1lSpDsNa/yyw8kXtaWLh2lXHStSAVH2UpNNz9d45WWzlVsY1mHAfuhmV
         d/SrfEowFDav5Zb35ZvOeNRB+jN81LAwwY7UYxHj1/QxNpVRh0/qYnA0aKXmaJUJxCHA
         4DKcX+Hm+oksBHvrm1PW7Cc2YXAHYt53lTZCi3MyVVxXhuwHXxGODgzR82j/cCW1Jklq
         QgSg==
X-Gm-Message-State: APjAAAVolp+see5tXJFAUoVuujXp1VRNMx7vGSv5PW66Pf5eAF2sT67S
        55sUQTBQ33ru1MCC7AfvevwjSA==
X-Google-Smtp-Source: APXvYqz4qZBoRB6OmcdQOJn/RkfEoww9MxRhFBGtRytBBWzy2H7BHROzWqtrB66vhSitRPsWPlDCmg==
X-Received: by 2002:a63:5550:: with SMTP id f16mr17160524pgm.426.1563301733618;
        Tue, 16 Jul 2019 11:28:53 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id x8sm18949101pfa.46.2019.07.16.11.28.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 11:28:52 -0700 (PDT)
Message-ID: <5d2e1764.1c69fb81.448bb.65c0@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190624142654.zprcpz42hivuyrjq@gondor.apana.org.au>
References: <20190613180931.65445-1-swboyd@chromium.org> <20190613180931.65445-2-swboyd@chromium.org> <20190613232613.GH22901@ziepe.ca> <5d03e394.1c69fb81.f028c.bffb@mx.google.com> <20190617225134.GA30762@ziepe.ca> <5d0c2cd6.1c69fb81.e66af.32bf@mx.google.com> <20190624142654.zprcpz42hivuyrjq@gondor.apana.org.au>
From:   Stephen Boyd <swboyd@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] tpm: block messages while suspended
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrey Pronin <apronin@chromium.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, devicetree@vger.kernel.org,
        Duncan Laurie <dlaurie@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
User-Agent: alot/0.8.1
Date:   Tue, 16 Jul 2019 11:28:51 -0700
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Herbert Xu (2019-06-24 07:26:54)
> On Thu, Jun 20, 2019 at 06:03:17PM -0700, Stephen Boyd wrote:
> >
> > What do you think of the attached patch? I haven't tested it, but it
> > would make sure that the kthread is frozen so that the hardware can be
> > resumed before the kthread is thawed and tries to go touch the hardware.
>=20
> Looks good to me.
>=20

Thanks for checking. I haven't been able to reproduce the problem yet to
confirm this is actually fixing anything, even after tweaking the sysctl
values for khwrng to try and force the thread to run continuously.

From reading the bug report that caused this 'is_suspended' code to be
added to the driver I'm fairly convinced this is the right solution. To
give some more background, it looks like we use s2idle suspend (i.e.
all CPUs are idle across suspend) and then we have the kthread running
to ask the hardware for some more random numbers. The i2c transaction
fails when asking the hwrng for data, and we see these messages printed
on the resume path:

	i2c_designware i2c_designware.2: i2c_dw_handle_tx_abort: lost arbitration
	tpm tpm0: i2c transfer failed (attempt 3/3): -11
	tpm0: tpm_transmit: tpm_send: error -11
	hwrng: no data available

Userspace tasks are thawed after this failure so it looks like something
in the kernel kicks khwrng to grab more data before the i2c bus can be
resumed.

