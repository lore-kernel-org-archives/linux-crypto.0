Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45934C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 12:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiF3MoZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiF3MoY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 08:44:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990391CFF7
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 05:44:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so2918892pjs.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x27N2SyNP7mUeyY/FVkhEqHf5rW1kdAaQZZt0mTkbRU=;
        b=SYWRHVENxHl0eY44BCScFHwbxGoCNIOOkzBMDJaB0KGPFJ/xUdvhEyoSIZtJViApIE
         oFhkUui2klUFnHdDevSH4HP7CLE1A9OVv3IvVGsK6ktgJgRFC2mTyuVlePxreuN0kowk
         juik47hUGGpVzX28Pyz/6GKZZb9s20Ulv/+qfEy8eCUCXBw7F9dBQoXyP3Z4EVj61+B7
         OW3LeLHmFslB2RHbX6Kj9U8rztNLXCf1dQpXpx0dzbBHRtOA1XMxw+r7oqb+aSsVoR4d
         sLI47nlZRleCh4yRnZH97rJtDf4WhxhFRLR6ereQN9KbWaeKuYQELAkhkZDJ227/1P0L
         VTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x27N2SyNP7mUeyY/FVkhEqHf5rW1kdAaQZZt0mTkbRU=;
        b=TUKhahuwzFKwBsLjDPykAjOFGEc/3Yl6m0HuwozPMaD7DlGYuleAH/NC/G/qlOZDFP
         +n5UFmMxJSYMOMu7duIhKQxs1c1gboyUJiTd06H6uXf0YwdTFbBUHqEm7/S1YBIGMJjT
         WLhBkuDlZLMtZKFaVma62WhuoC/epbDd5ObifRTZsHa3FuKBOkOUk34pYaE915BmEupg
         vqFeWyyFPQ45EHmlELzetu7el7D6AGuhg/nBbT+4JO7e7K8jI19IW/QmLEnhZclcI1V6
         SO3VvgiPKj3s2I8iit42UIW3YdOngwe1HfKU2zFf4vkt4FCVx7K5KCPSgDGKIyMhw5Yu
         Fk7g==
X-Gm-Message-State: AJIora+HPWnlKKN894iBu2bUv5y6rkMpXuZJ9RnP/fhxxyyHCHm+zd6E
        DkqYYa0/DmB7G2Ux57NhC7acJg==
X-Google-Smtp-Source: AGRyM1vfMWl3U0X4qQ+cNACaQ5A0XlkloXmiJbHe0Lx49I7uYjHnrW4yhg14x1dwRrcoSFBHGBGLng==
X-Received: by 2002:a17:90b:3851:b0:1ed:d98:fe35 with SMTP id nl17-20020a17090b385100b001ed0d98fe35mr12255304pjb.35.1656593063188;
        Thu, 30 Jun 2022 05:44:23 -0700 (PDT)
Received: from [10.76.43.148] ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id jj22-20020a170903049600b001674d61c1c6sm13225370plb.272.2022.06.30.05.44.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 05:44:22 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re:  [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <Yr1nybJ9eSNgU24i@gondor.apana.org.au>
Date:   Thu, 30 Jun 2022 20:44:18 +0800
Cc:     Lei He <helei.sig11@bytedance.com>, davem@davemloft.net,
        dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=22Daniel_P_=2E_Berrang=C3=A9=22?= <berrange@redhat.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <274D6476-E37F-4110-BAA5-5B5CE0B63BE9@bytedance.com>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
 <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
 <Yr1TuPM8yvJUoV9r@gondor.apana.org.au>
 <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
 <Yr1nybJ9eSNgU24i@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Jun 30, 2022, at 5:07 PM, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:

>=20
> On Thu, Jun 30, 2022 at 04:30:39PM +0800, Lei He wrote:
>>=20
>> I have explained above why we need a driver that supports ECDSA, and =
this patch
>> enables virtio-crypto to support ECDSA. I think this is a good time =
to support ECDSA
>> in the kernel crypto framework, and there will be more drivers =
supporting ECDSA in the=20
>> future.
>> Looking forward to your opinion :-).
>=20
> Until there are drivers in the kernel it's pointless to implement
> this.
>=20

I guess you mean that if there are no drivers in the linux kernel source =
tree that supports the=20
ECDSA, then there is no way under linux to offload ECDSA to other =
devices, so even if the
virtio-crypto can get the akcipher request, it can=E2=80=99t do better, =
right? I have some different opinions
 on this:
1. There does exist hardware for offloading ECDSA calculations, for =
example, IBM PCIe
Cryptographic Coprocessor, Intel QAT, etc, and those chips are already =
on the market now.
Of course, they also provided corresponding drivers to access these =
devices, but for some reason,
these drivers have not been submitted to the kernel source tree now.
2. With this patch, when we use QEMU to create a virtual machine, people =
can directly access the=20
virtio-crypto device without caring about where these akcipher requests =
are executed, and no need
to update drivers(and other stuff) for guest kernel when the  =
co-processor is updated.=20
3.  I will communicate with the Intel QAT team about their plans to =
provide ECDSA support and ECDH=20
support.


