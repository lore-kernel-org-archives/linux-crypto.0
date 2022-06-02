Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B468C43334
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jun 2022 13:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiFBNWR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jun 2022 09:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiFBNWP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jun 2022 09:22:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FA9A3389A
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jun 2022 06:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654176132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QvH8RS4rnLfJom7q/alXiLEY8S5yec28Yu1pEYYV4RY=;
        b=CekT148rBk/R2oaSGKeLDcY1cLQBhj/sMdZAsJalq2OsoU8hpdULRwlr2Cf6k1yC27l5K8
        H5ELIoU/Hj/Bv/klzkGf3k393Or+02vDpmQoyhjcWlgWZFl27TU1NuTx64dYkz0SDIMzPE
        aVeI/kW0YWzwpQIL3AbLRkQcItxVDf0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-FHjKxhxQPyma4ZUHJuwCew-1; Thu, 02 Jun 2022 09:22:10 -0400
X-MC-Unique: FHjKxhxQPyma4ZUHJuwCew-1
Received: by mail-ej1-f69.google.com with SMTP id gr1-20020a170906e2c100b006fefea3ec0aso2465809ejb.14
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jun 2022 06:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvH8RS4rnLfJom7q/alXiLEY8S5yec28Yu1pEYYV4RY=;
        b=cU2fiG0wTSrMuR/cM7B9i8Rzfay3jTLjpq4hqoRPmp+rU0udEn9rSWItZKNF0jeIx3
         +oD0d6s04sHf8MtNYNRCDioJDRz5I4E+MaE+Mf37dewSS8WQ7Ms2Zh8VA5G8pWwfSIww
         Ae4r15LrSrndNM0TymtJcWGY85n5NA/yFH53zaUjzpYc74ZqV7A7axldnoyAce8MHHgb
         mHEgtOy1HSA9OuMZuTtKpoSbT7bGb2UBr3SWyORtnC//shtp+8Y1jmCGa9t01j5DlMQW
         q/JQWspvgVm0BmCkr7GJP7IhEfl4hgroOVnieZ/vrn2C7eRkVntDsaTyFkdPt6lpeHYQ
         IDrw==
X-Gm-Message-State: AOAM532GhmVMHTUNVdt//FC0Bqn5khKwk4NWwRJE2VahFqzRv5ZnQ7xW
        b/DzC8zvXoo2OdeFc4EokKqstzxi4fd1s77MAR2hAeLEVDmZDQWd5roTLaWHp130wPFR6t4Sg6H
        0Qnrej6eB49q+lrEgCVFRceoGruBXfA2m2ZC3THGX
X-Received: by 2002:a17:906:5251:b0:6fe:98cb:d1 with SMTP id y17-20020a170906525100b006fe98cb00d1mr4327590ejm.156.1654176129237;
        Thu, 02 Jun 2022 06:22:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYkJ4L8OfL8znCidowu+wDia85zZ9qno5SnfjKdx2WbghVaJeuQkCkHR/uUN5DMJIgFs4ixocbCxap1/1MTnU=
X-Received: by 2002:a17:906:5251:b0:6fe:98cb:d1 with SMTP id
 y17-20020a170906525100b006fe98cb00d1mr4327517ejm.156.1654176128336; Thu, 02
 Jun 2022 06:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Thu, 2 Jun 2022 15:21:57 +0200
Message-ID: <CAMusb+TA6wRHtkz=wXohH9-184fK_v=X3v=eYxr7BSWuVimOmQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: qat - enable configuration for 4xxx
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Giovanni, all,

I've read through the patchset and it looks good to me. I would have made
the following two minor (really minor) changes.

Add a missing "in" to the patch message:

@@ [PATCH 1/4] crypto: qat - expose device state through sysfs for 4xxx
-allow the change of states even if the device is the down state.
+allow the change of states even if the device is in the down state.

Probably add an indication that cfg_services has been really changed to
the sysfs-driver-qat doc for clarity:

@@ [PATCH 4/4] crypto: qat - expose device config through sysfs for 4xxx
diff --git a/Documentation/ABI/testing/sysfs-driver-qat
b/Documentation/ABI/testing/sysfs-driver-qat
 +                       # echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
 +                       # echo up > /sys/bus/pci/devices/<BDF>/qat/state
++                       # cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
++                       dc

Anyway, please feel free to use:

Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

On Tue, May 17, 2022 at 4:10 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> qat_4xxx devices can be configured to allow either crypto or compression
> operations. By default, devices are configured statically according
> to following rule:
>   - odd numbered devices assigned to compression services
>   - even numbered devices assigned to crypto services
>
> This set exposes two attributes in sysfs that allow to report and change
> the state and the configuration of a QAT 4xxx device.
> The first, /sys/bus/pci/devices/<BDF>/qat/state, allows to bring a
> device down in order to change the configuration, and bring it up again.
> The second, /sys/bus/pci/devices/<BDF>/qat/cfg_services, allows to
> inspect the current configuration of a device (i.e. crypto or
> compression) and change it.
>
> Giovanni Cabiddu (4):
>   crypto: qat - expose device state through sysfs for 4xxx
>   crypto: qat - change behaviour of adf_cfg_add_key_value_param()
>   crypto: qat - relocate and rename adf_sriov_prepare_restart()
>   crypto: qat - expose device config through sysfs for 4xxx
>
>  Documentation/ABI/testing/sysfs-driver-qat    |  58 ++++++
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   1 +
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   1 +
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         |   6 +-
>  drivers/crypto/qat/qat_common/Makefile        |   1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |   1 +
>  drivers/crypto/qat/qat_common/adf_cfg.c       |  41 +++-
>  .../crypto/qat/qat_common/adf_common_drv.h    |   3 +
>  drivers/crypto/qat/qat_common/adf_init.c      |  26 +++
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  28 +--
>  drivers/crypto/qat/qat_common/adf_sysfs.c     | 191 ++++++++++++++++++
>  11 files changed, 328 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-qat
>  create mode 100644 drivers/crypto/qat/qat_common/adf_sysfs.c
>
> --
> 2.36.1
>

