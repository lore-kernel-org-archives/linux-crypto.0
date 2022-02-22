Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400F6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 19:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiBVTaL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 14:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiBVTaK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 14:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EFFC17072
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 11:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645558183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/Jd5qPSi0YoZ3kqzdTLt1xOvKYnU22Qo00BT9erdYs=;
        b=cWUvuzIEBCRxeeVM6AfOwHjb9u8ay8CZawKb0WI4zLT+y0FksHRjgIinwaJaUgBVJYACSU
        q8b2tsQN93vogykVhE6Qx8Oh0wQ3vpRSxtDHg3Y4T2/RENNK257eLvYx3O0YFZ2lvNIPcl
        LBxXov9IYlWJ4S/yxrz8BVpn29obpQE=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-tQH3BfQKORahg2eOSewWcQ-1; Tue, 22 Feb 2022 14:29:42 -0500
X-MC-Unique: tQH3BfQKORahg2eOSewWcQ-1
Received: by mail-oo1-f70.google.com with SMTP id x130-20020a4a4188000000b0031b2e31acc7so8024923ooa.21
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 11:29:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=P/Jd5qPSi0YoZ3kqzdTLt1xOvKYnU22Qo00BT9erdYs=;
        b=Kf21CPK3NMJLNHzIVbpdoW5GQY1yrTDuzUnAHic8RY3CAu7aP23lhlClm1ENbIPzAI
         2/GI0h4QxwVkTweTWAkI2ntj0i+w5gjXXmJzO/ykViqLH30Xmn6xoD2KT8Qf6R1XsdcM
         U45WaJNZOcQNC/ozC7HTODVBDX8ggdp/EhjiyHJfe48jDEVQk9jkkisnf48Nc8qmIdM1
         YF1VKHv+Aff6xv+nqFvKZuohBmRhlHXxKDcb9NhFZ8Ywdt4bXPfhfQR//ddzcRnKnCtn
         FRTvQ8AIfwulxY6r2hOF9iVH50aagl1mGRvT3JNeMZCl7qr+2ag2aIDFxKTqcvVnNlpV
         iWOw==
X-Gm-Message-State: AOAM531OTv6TawmKy5891M+tx4gv0P65oZ5mBRQ/76YCECLCm6dV1EC0
        xTxKamznlNqKfvpQrOnFOLFa3V1ctoDWXEGej/vUnu3ieq9bpyRzU5221Moth8QeTaxTC8T5zcN
        31Msgf2cOyrxR1D9PmmGlMrh7
X-Received: by 2002:a05:6808:2228:b0:2cf:f102:b72b with SMTP id bd40-20020a056808222800b002cff102b72bmr2831430oib.286.1645558181762;
        Tue, 22 Feb 2022 11:29:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwh29+asBEtg/qsvLMW4an6L8Nd9/EVBQ/g0hcum7J+rAegjy9pBVpr3MCPenuuqCzVpTX6pA==
X-Received: by 2002:a05:6808:2228:b0:2cf:f102:b72b with SMTP id bd40-20020a056808222800b002cff102b72bmr2831418oib.286.1645558181540;
        Tue, 22 Feb 2022 11:29:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g34sm6632626ooi.48.2022.02.22.11.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 11:29:40 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:29:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220222122939.0394d152.alex.williamson@redhat.com>
In-Reply-To: <20220222004943.GF193956@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220222004943.GF193956@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Feb 2022 20:49:43 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 21, 2022 at 11:40:35AM +0000, Shameer Kolothum wrote:
> >=20
> > Hi,
> >=20
> > This series attempts to add vfio live migration support for
> > HiSilicon ACC VF devices based on the new v2 migration protocol
> > definition and mlx5 v8 series discussed here[0].
> >=20
> > RFCv4 --> v5
> >   - Dropped RFC tag as v2 migration APIs are more stable now.
> >   - Addressed review comments from Jason and Alex (Thanks!).
> >=20
> > This is sanity tested on a HiSilicon platform using the Qemu branch
> > provided here[1].
> >=20
> > Please take a look and let me know your feedback.
> >=20
> > Thanks,
> > Shameer
> > [0] https://lore.kernel.org/kvm/20220220095716.153757-1-yishaih@nvidia.=
com/
> > [1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
> >=20
> >=20
> > v3 --> RFCv4
> > -Based on migration v2 protocol and mlx5 v7 series.
> > -Added RFC tag again as migration v2 protocol is still under discussion.
> > -Added new patch #6 to retrieve the PF QM data.
> > -PRE_COPY compatibility check is now done after the migration data
> > =C2=A0transfer. This is not ideal and needs discussion. =20
>=20
> Alex, do you want to keep the PRE_COPY in just for acc for now? Or do
> you think this is not a good temporary use for it?
>=20
> We have some work toward doing the compatability more generally, but I
> think it will be a while before that is all settled.

In the original migration protocol I recall that we discussed that
using the pre-copy phase for compatibility testing, even without
additional device data, as a valid use case.  The migration driver of
course needs to account for the fact that userspace is not required to
perform a pre-copy, and therefore cannot rely on that exclusively for
compatibility testing, but failing a migration earlier due to detection
of an incompatibility is generally a good thing.

If the ACC driver wants to re-incorporate this behavior into a non-RFC
proposed series and we could align accepting them into the same kernel
release, that sounds ok to me.  Thanks,

Alex

