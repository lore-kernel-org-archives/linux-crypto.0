Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BDBC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 17:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiCNRrP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiCNRrO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Mar 2022 13:47:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E826BCB4
        for <linux-crypto@vger.kernel.org>; Mon, 14 Mar 2022 10:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647279963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEJG0IObRkUr69r2f7J23FXjPgRCTJSeRdoCwh8LUrA=;
        b=FjY3WnLXJFEGZDsR8GU0MH+aJTMb8Tq2Lj2HHQRn+Pg8zKBFJccv7hQBEZMtCT5huAtUOV
        cdMvdK/DXjUfXd/MH8vDS0SRYezuxElCpkG02S6N4zTZofIyKUQzEPbdqQsZRy06L7v7+t
        LZVe3T23HOOzC9STZ2KyQ43zAM2+uhA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-1WpEAWPqNWe-CsWkEgfVcw-1; Mon, 14 Mar 2022 13:46:02 -0400
X-MC-Unique: 1WpEAWPqNWe-CsWkEgfVcw-1
Received: by mail-il1-f199.google.com with SMTP id a2-20020a056e020e0200b002c6344a01c9so9727807ilk.13
        for <linux-crypto@vger.kernel.org>; Mon, 14 Mar 2022 10:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEJG0IObRkUr69r2f7J23FXjPgRCTJSeRdoCwh8LUrA=;
        b=mrIUaljO+nKBa6mOVtkXDQAwwmGuNjhB/1ZbxQybQw1XLDt6rXvvNx7MqocwpjgoO2
         G3nOEK+JMnWKP++58uL/usghcQRU1sTgmAvQXj0WeXEwFOVsxXFScna+JkgWNhbN/XeD
         4GMyOS80fkmRyXJbJRasHzvfA0GYJmo5tO5Zd2sArlIcK+KpnS5ldbWh/ovlu8akzR5+
         bYZ2g8B0InfM4w349E6WZerlUMWVOQzCy0KXG1+rAhxJFl/98EORwOfzZps9bV229Mfb
         Rgdbb0oQXad020uXae5DXCOrcFB0TSwwe3NFeMkyI6iC9CRCee5lQgzpfMCS3818Gxbs
         j0bw==
X-Gm-Message-State: AOAM533T9c8ce1auh/rfWy8wpBMgYsrGxhq53cEX6u1clnh+SC3iDjA7
        LGMjoRm56dDMM+c5hpXbChW8F33XpjFvd+2piTRO7kZX8z7QNQzqucMh3BVr/UFjgyTAzuHaWlb
        4E8Y259OvA8VYrjffLrenvvdN
X-Received: by 2002:a05:6602:3c5:b0:613:8644:591c with SMTP id g5-20020a05660203c500b006138644591cmr20675140iov.161.1647279961388;
        Mon, 14 Mar 2022 10:46:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZJJA4WojvmGdmtZ74f1wNxVgekXaAUaGHvuviIsQF6/0w1VCSMfKnNrXxBYkfIXxrO2Rn+w==
X-Received: by 2002:a05:6602:3c5:b0:613:8644:591c with SMTP id g5-20020a05660203c500b006138644591cmr20675084iov.161.1647279960174;
        Mon, 14 Mar 2022 10:46:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b2-20020a923402000000b002c25b16552fsm9227068ila.14.2022.03.14.10.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:45:59 -0700 (PDT)
Date:   Mon, 14 Mar 2022 11:45:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220314114558.2cdd57fc.alex.williamson@redhat.com>
In-Reply-To: <df217839a41b47dc94ef201dfe379e4e@huawei.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
        <df217839a41b47dc94ef201dfe379e4e@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 14 Mar 2022 17:26:59 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi Alex,
>=20
> > -----Original Message-----
> > From: Shameerali Kolothum Thodi
> > Sent: 08 March 2022 18:49
> > To: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com; jgg@nvidia.c=
om;
> > cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com;
> > kevin.tian@intel.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> > <wangzhou1@hisilicon.com>
> > Subject: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
> >=20
> > Hi,
> >=20
> > This series attempts to add vfio live migration support for HiSilicon
> > ACC VF devices based on the new v2 migration protocol definition and
> > mlx5 v9 series discussed here[0].
> >=20
> > v8 --> v9
> > =C2=A0- Added acks by Wangzhou/Longfang/Yekai
> > =C2=A0- Added R-by tags by Jason.
> > =C2=A0- Addressed comments=C2=A0by Alex on v8.
> > =C2=A0- Fixed the pf_queue pointer assignment error in patch #8.
> > =C2=A0- Addressed=C2=A0comments from Kevin,
> >  =C2=A0 =C2=A0-Updated patch #5 commit log msg with a clarification tha=
t VF
> > =C2=A0 =C2=A0 =C2=A0migration BAR assignment is fine if migration suppo=
rt is not there.
> >  =C2=A0 =C2=A0-Added QM description to patch #8 commit msg. =20
>=20
> Hope there is nothing pending for this series now to make it to next.
> I know ack from Bjorn is still pending for patch #3, and I have
> sent a ping last week and also CCd him on that patch.
>=20
> Please let me know if there is anything I missed.=20

Hi Shameer,

Nothing still pending from my end, as soon as we can get an ack on
patch #3 and barring issues in the interim, I'll merge it.  Thanks,

Alex

