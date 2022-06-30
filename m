Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BAEC43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 12:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiF3Mux (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 08:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiF3Muw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 08:50:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A69F41627
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 05:50:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l6so16928480plg.11
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 05:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RK+G25fRPRPuusa2Wp+61X8unSoS0wCoyUNLtgJJpQE=;
        b=VsSdRI5XMSNH2T5TYJ30Hc3JSsunFVjLBL7fFMH5JmbzQoxLpxzC+xBDswgMPiimyU
         mjumrTUo6tWw75yrSp81fg0Ueh8cLED65TDUv3pghTtrUPI8HLcjrfSGK+zH+6qJQEvX
         HyT7zXWjtKudGHPrcPOY5zWNyqI4ohkQkdS2VzkkM/qtRSawL1igKmY/VIpGfzrVq3ys
         zgEkIzw+Xy5WcYB4Ro0Mh4LfKcZ0N85ObRwY19whW694vgOwGkCezHj+NIUsJ79TfWnU
         xXdRF4ZbwFfUO523WaxnNcuFTpIavrghsG0WJQlukipSeJBdoB2TxS7cZpQYySPx9pZz
         m2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RK+G25fRPRPuusa2Wp+61X8unSoS0wCoyUNLtgJJpQE=;
        b=R24yfEvhJWnRpodfSuFlN2vptgpwB14Dc0lDR1Rl+rEw10Qwn8A70dpvCjabS/dqUS
         Z46Ib/1xjc5pUsXCpvsJahalmyhn85yYMXDSTYKFaJdt0rUj/RBk0Kbik7Mn1M2H65+a
         8yRFs7uzJtNGWSnO+pDDPY+7mRK9W4ukzvT8v92Sk+1oSoECp0+lpLg8thKFNNMWQqa9
         IdND35gA5UfQCCyNEnXZRRvoDJ1pzGIsx2XBy0hR0abJbCYP3reQUPTbKDe69pOkI/sB
         i58dbB2B4VDmf/6nt/k3ZJa5ye1tE6FH96Nw1isv3v3k/xrIMFWOE5mYoNg1MfpWAIs6
         ZAvQ==
X-Gm-Message-State: AJIora809oRfZEqeVLxk2vnyloK6zXDzl9pbFAdgbsrv7nC+kiCtcBeP
        FRQtAye9OPM4m1gsthIdeGqL2Q==
X-Google-Smtp-Source: AGRyM1uug5cokmBQ6ntP8fqdB9SjvD/1mmSz4Nt71Y72WFS1Sn0sKcZvteVY63AsxnzrQD78+vOkiQ==
X-Received: by 2002:a17:90a:fd17:b0:1ec:92c0:575 with SMTP id cv23-20020a17090afd1700b001ec92c00575mr12159550pjb.55.1656593451134;
        Thu, 30 Jun 2022 05:50:51 -0700 (PDT)
Received: from [10.76.43.148] ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902bcca00b0015e8d4eb26csm13377905pls.182.2022.06.30.05.50.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 05:50:50 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <274D6476-E37F-4110-BAA5-5B5CE0B63BE9@bytedance.com>
Date:   Thu, 30 Jun 2022 20:50:43 +0800
Cc:     Lei He <helei.sig11@bytedance.com>, davem@davemloft.net,
        dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=22Daniel_P_=2E_Berrang=C3=A9=22?= <berrange@redhat.com>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F114A3E-2854-486F-AEFE-B04CFF3C3C52@bytedance.com>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
 <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
 <Yr1TuPM8yvJUoV9r@gondor.apana.org.au>
 <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
 <Yr1nybJ9eSNgU24i@gondor.apana.org.au>
 <274D6476-E37F-4110-BAA5-5B5CE0B63BE9@bytedance.com>
To:     Xin Zeng <xin.zeng@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Jun 30, 2022, at 8:44 PM, Lei He <helei.sig11@bytedance.com> wrote:
>=20
> On Jun 30, 2022, at 5:07 PM, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>=20
>>=20
>> On Thu, Jun 30, 2022 at 04:30:39PM +0800, Lei He wrote:
>>>=20
>>> I have explained above why we need a driver that supports ECDSA, and =
this patch
>>> enables virtio-crypto to support ECDSA. I think this is a good time =
to support ECDSA
>>> in the kernel crypto framework, and there will be more drivers =
supporting ECDSA in the=20
>>> future.
>>> Looking forward to your opinion :-).
>>=20
>> Until there are drivers in the kernel it's pointless to implement
>> this.
>>=20
>=20
> I guess you mean that if there are no drivers in the linux kernel =
source tree that supports the=20
> ECDSA, then there is no way under linux to offload ECDSA to other =
devices, so even if the
> virtio-crypto can get the akcipher request, it can=E2=80=99t do =
better, right? I have some different opinions
> on this:
> 1. There does exist hardware for offloading ECDSA calculations, for =
example, IBM PCIe
> Cryptographic Coprocessor, Intel QAT, etc, and those chips are already =
on the market now.
> Of course, they also provided corresponding drivers to access these =
devices, but for some reason,
> these drivers have not been submitted to the kernel source tree now.
> 2. With this patch, when we use QEMU to create a virtual machine, =
people can directly access the=20
> virtio-crypto device without caring about where these akcipher =
requests are executed, and no need
> to update drivers(and other stuff) for guest kernel when the  =
co-processor is updated.=20
> 3.  I will communicate with the Intel QAT team about their plans to =
provide ECDSA support and ECDH=20
> support.

Hi, xin:
	I would like to ask if you have any plans to support ECDSA in =
LKC for QAT driver, and if so how is
it going?=
