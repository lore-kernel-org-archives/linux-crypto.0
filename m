Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60434C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 18:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351068AbiCOS1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 14:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351064AbiCOS1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 14:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5E095A0A5
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 11:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647368789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XzGpzSPPvF6IztwMBCoGf9CULdIDvsRovEHMwfBSZBM=;
        b=cEJyWcoQzS21r5rH/cC3iS6ofmh/8meRcb7L5k5J8Q6v92HCfFl09Dh1OkjhKupr2EAzoW
        3nDPsAa2d7FGTYLbp48O903vkKS1OsujrJnhGeUzVuj9lJnBNg0UPtfFY70PskU9Z/4oaC
        Dg6Eb1XG/U9RcR5aet7qfHfrqodeXBQ=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-m-V8FG5KNBqXwlbu-VrSvA-1; Tue, 15 Mar 2022 14:26:28 -0400
X-MC-Unique: m-V8FG5KNBqXwlbu-VrSvA-1
Received: by mail-ot1-f71.google.com with SMTP id w7-20020a9d6387000000b005c97b45b0eeso1172678otk.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2022 11:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XzGpzSPPvF6IztwMBCoGf9CULdIDvsRovEHMwfBSZBM=;
        b=ECMBeE+/HRIwc6yERtAQfZapnO8ZNntRw4OnQahQyd2G+4YSd0WegkCG5ixYOglY8m
         743PGktKgU6pbX50zHkkXMcTV5VK6z3/lgwRX3CexwZa0V7mei+Ugqlpw2HDtKWYLzIl
         etdNBe4VnjvbDOGdU+2FS12ITxXySj/reLmWC2EQLCQHEAx5dhMCig5TV+gHjztTSujx
         P026qrlDqGZ4JDQvCssmyF/PpKoRTBMkxOP6Ydlh+zpjuZJv0AWHU7wAWhxAScZguNTQ
         L1jZNfP49TAZZFy0ET1tQW2xmyk4JGX2HyGuCGfavjMUYlcbnP9KiE7s1EhTUDBrp2jW
         Nbjg==
X-Gm-Message-State: AOAM531BLktazQHoWTsxloX8gqm/hMEVHpay9rz9sGiPf298xlopyrUv
        GudCLmS5xCelKkTb17UYZhr6p6yNXwDQmvNcebW6YNjn6jJ3iWy8QvMkWLkzid17a2h8if44o/y
        UbIomdh3qYRxhZrBfW1mJjZes
X-Received: by 2002:a05:6808:318:b0:2ec:b689:dceb with SMTP id i24-20020a056808031800b002ecb689dcebmr2257283oie.103.1647368787088;
        Tue, 15 Mar 2022 11:26:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl2HKKYQyELHU9U7fpC71zcgGaaZdRFZKPKQmxedgdSk7TVfmp5oz3+3myxBDN2yFrKXIHeA==
X-Received: by 2002:a05:6808:318:b0:2ec:b689:dceb with SMTP id i24-20020a056808031800b002ecb689dcebmr2257269oie.103.1647368786856;
        Tue, 15 Mar 2022 11:26:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 96-20020a9d0469000000b005c959dd643csm3717144otc.3.2022.03.15.11.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 11:26:26 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:26:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v9 0/9] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220315122625.4ec21622.alex.williamson@redhat.com>
In-Reply-To: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 8 Mar 2022 18:48:53 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi,
>=20
> This series attempts to add vfio live migration support for HiSilicon
> ACC VF devices based on the new v2 migration protocol definition and
> mlx5 v9 series discussed here[0].
>=20
> v8 --> v9
> =C2=A0- Added acks by Wangzhou/Longfang/Yekai
> =C2=A0- Added R-by tags by Jason.
> =C2=A0- Addressed comments=C2=A0by Alex on v8.
> =C2=A0- Fixed the pf_queue pointer assignment error in patch #8.
> =C2=A0- Addressed=C2=A0comments from Kevin,
>  =C2=A0 =C2=A0-Updated patch #5 commit log msg with a clarification that =
VF
> =C2=A0 =C2=A0 =C2=A0migration BAR assignment is fine if migration support=
 is not there.
>  =C2=A0 =C2=A0-Added QM description to patch #8 commit msg.
>=20
> This is sanity tested on a HiSilicon platform using the Qemu branch
> provided here[1].
>=20
> Please take a look and let me know your feedback.
>=20
> Thanks,
> Shameer
> [0] https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.co=
m/
> [1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
>=20
> v7 --> v8
> =C2=A0- Dropped PRE_COPY support and early=C2=A0compatibility checking ba=
sed on
>    the discussion here[1].
> =C2=A0- Addressed=C2=A0comments=C2=A0from John, Jason & Alex (Thanks!).
>=20
> v6 --> v7
> =C2=A0-Renamed MIG_PRECOPY ioctl name and struct name. Updated ioctl desc=
riptions
> =C2=A0 regarding ioctl validity (patch #7).
> - Adressed comments from Jason and Alex on PRE_COPY read() and ioctl() fns
>   (patch #9).
> - Moved only VF PCI ids to pci_ids.h(patch #3).
>=20
> v5 --> v6
>  -Report PRE_COPY support and use that for early compatibility check
>   between src and dst devices.
>  -For generic PRE_COPY support, included patch #7 from Jason(Thanks!).
>  -Addressed comments from Alex(Thanks!).
>  -Added the QM state register update to QM driver(patch #8) since that
>   is being used in migration driver to decide whether the device is
>   ready to save the state.
>=20
> RFCv4 --> v5
>   - Dropped RFC tag as v2 migration APIs are more stable now.
>   - Addressed review comments from Jason and Alex (Thanks!).
>=20
> v3 --> RFCv4
> -Based on migration v2 protocol and mlx5 v7 series.
> -Added RFC tag again as migration v2 protocol is still under discussion.
> -Added new patch #6 to retrieve the PF QM data.
> -PRE_COPY compatibility check is now done after the migration data
> =C2=A0transfer. This is not ideal and needs discussion.
>=20
> RFC v2 --> v3
> =C2=A0-Dropped RFC tag as the vfio_pci_core subsystem framework is now
> =C2=A0 part of 5.15-rc1.
> =C2=A0-Added override methods for vfio_device_ops read/write/mmap calls
> =C2=A0 to limit the access within the functional register space.
> =C2=A0-Patches 1 to 3 are code refactoring to move the common ACC QM
> =C2=A0 definitions and header around.
>=20
> RFCv1 --> RFCv2
>=20
> =C2=A0-Adds a new vendor-specific vfio_pci driver(hisi-acc-vfio-pci)
> =C2=A0 for HiSilicon ACC VF devices based on the new vfio-pci-core
> =C2=A0 framework proposal.
>=20
> =C2=A0-Since HiSilicon ACC VF device MMIO space contains both the
> =C2=A0 functional register space and migration control register space,
> =C2=A0 override the vfio_device_ops ioctl method to report only the
> =C2=A0 functional space to VMs.
>=20
> =C2=A0-For a successful migration, we still need access to VF dev
> =C2=A0 functional register space mainly to read the status registers.
> =C2=A0 But accessing these while the Guest vCPUs are running may leave
> =C2=A0 a security hole. To avoid any potential security issues, we
> =C2=A0 map/unmap the MMIO regions on a need basis and is safe to do so.
> =C2=A0 (Please see hisi_acc_vf_ioremap/unmap() fns in patch #4).
> =C2=A0
> =C2=A0-Dropped debugfs support for now.
> =C2=A0-Uses common QM functions for mailbox access(patch #3).
>=20
> Longfang Liu (3):
>   crypto: hisilicon/qm: Move few definitions to common header
>   crypto: hisilicon/qm: Set the VF QM state register
>   hisi_acc_vfio_pci: Add support for VFIO live migration
>=20
> Shameer Kolothum (6):
>   crypto: hisilicon/qm: Move the QM header to include/linux
>   hisi_acc_qm: Move VF PCI device IDs to common header
>   hisi_acc_vfio_pci: add new vfio_pci driver for HiSilicon ACC devices
>   hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
>   hisi_acc_vfio_pci: Add helper to retrieve the struct pci_driver
>   hisi_acc_vfio_pci: Use its own PCI reset_done error handler
>=20
>  MAINTAINERS                                   |    7 +
>  drivers/crypto/hisilicon/hpre/hpre.h          |    2 +-
>  drivers/crypto/hisilicon/hpre/hpre_main.c     |   19 +-
>  drivers/crypto/hisilicon/qm.c                 |   68 +-
>  drivers/crypto/hisilicon/sec2/sec.h           |    2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c      |   21 +-
>  drivers/crypto/hisilicon/sgl.c                |    2 +-
>  drivers/crypto/hisilicon/zip/zip.h            |    2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c       |   17 +-
>  drivers/vfio/pci/Kconfig                      |    2 +
>  drivers/vfio/pci/Makefile                     |    2 +
>  drivers/vfio/pci/hisilicon/Kconfig            |   15 +
>  drivers/vfio/pci/hisilicon/Makefile           |    4 +
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1326 +++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  116 ++
>  .../qm.h =3D> include/linux/hisi_acc_qm.h       |   49 +
>  include/linux/pci_ids.h                       |    3 +
>  17 files changed, 1591 insertions(+), 66 deletions(-)
>  create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
>  create mode 100644 drivers/vfio/pci/hisilicon/Makefile
>  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>  rename drivers/crypto/hisilicon/qm.h =3D> include/linux/hisi_acc_qm.h (8=
7%)
>=20

Applied to vfio next branch for v5.18 with reviews/acks from Kevin and
Bjorn.  Thanks,

Alex

