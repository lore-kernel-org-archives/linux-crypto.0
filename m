Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B850C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Feb 2022 17:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346269AbiBBRaq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 12:30:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234244AbiBBRap (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 12:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643823045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARK8JuI2/Z9yWWBIIvnvP+Vpd7t0FPVLNXUAPYXWbuU=;
        b=SYveQbbwAAMhBfGcRYGUc268VVB2tl1lI0jNdQWAlRha8fm/mbAibi9XPIRMRjos+ZO1g1
        HCba19r74IC2kxDt3guqVbkcjDpD7uJUp4UFae1ErEGe7jdMk3BiOHsMRWdaboS3FlhwGA
        1qxI/Fq9LjV0UFcG3OcOMzWXx143oZM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Lkd89KTQPQ62M2aTPVG-bQ-1; Wed, 02 Feb 2022 12:30:44 -0500
X-MC-Unique: Lkd89KTQPQ62M2aTPVG-bQ-1
Received: by mail-ot1-f72.google.com with SMTP id h5-20020a9d5545000000b0059ecbfae94eso34134oti.17
        for <linux-crypto@vger.kernel.org>; Wed, 02 Feb 2022 09:30:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARK8JuI2/Z9yWWBIIvnvP+Vpd7t0FPVLNXUAPYXWbuU=;
        b=UAPgg0WwEAMCppqQ6XSCLNpIjbCQObvhFKySs3Qq0v+5clMO46UoVumvrMPf2COidI
         5vUPcvHGEVZggmeefTaS3wFrmGkZUKLczGxpIkZ2hoBkRFeR8jKZ0zuFH10z+dNq0M6V
         ++ZF5MHXB+2uMi46VMtwCgG0rAhKhRi52G6bzG6eQ6xjPWn3jLykqDV32dCVFp4S+nqG
         FXU+PGnQdZ3nO6gWK4iiSx4fxfotkJk63T4dtdP8jkycqn6iM15e2zBWLWpj+ilon6Se
         VO55OSYiVHw++BTqtp8EQCpq8QJVAdpO43XDezBI3Jc0/7JouNAoAmvGmyRJRzUoOfx3
         5B4Q==
X-Gm-Message-State: AOAM533W97IckQ2HyMKX9vZ5hM6GZS5lD/UCtESjLh7D79JexuL0fjjG
        pu3/onBozXe1i3pnA3f8W9mAAb/Y2/idaSONEg8N/TlW4CIJz2u88ZIO8kZYna5Z6LuY5QCdXIm
        Cv7jEoKuQ3ocQzN43ea3+2XL6
X-Received: by 2002:a9d:226b:: with SMTP id o98mr17394669ota.125.1643823043029;
        Wed, 02 Feb 2022 09:30:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxa1ulr875j7x7Dy544lRgUzL/mvKbrd24FxjT+1UwW5AH4hYjxYo2X7ptav2DX65k3R2wHSA==
X-Received: by 2002:a9d:226b:: with SMTP id o98mr17394656ota.125.1643823042832;
        Wed, 02 Feb 2022 09:30:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 6sm19835290oig.29.2022.02.02.09.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 09:30:42 -0800 (PST)
Date:   Wed, 2 Feb 2022 10:30:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202103041.2b404d13.alex.williamson@redhat.com>
In-Reply-To: <a29ae3ea51344e18b9659424772a4b42@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20220202131448.GA2538420@nvidia.com>
        <a29ae3ea51344e18b9659424772a4b42@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Feb 2022 14:34:52 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> 
> > 
> >    I see pf_qm_state_pre_save() but didn't understand why it wanted to
> >    send the first 32 bytes in the PRECOPY mode? It is fine, but it
> >    will add some complexity to continue to do this.  
> 
> That was mainly to do a quick verification between src and dst compatibility
> before we start saving the state. I think probably we can delay that check
> for later.

In the v1 migration scheme, this was considered good practice.  It
shouldn't be limited to PRECOPY, as there's no requirement to use
PRECOPY, but the earlier in the migration process that we can trigger a
device or data stream compatibility fault, the better.  TBH, even in
the case where a device doesn't support live dirty tracking for a
PRECOPY phase, using it for compatibility testing continues to seem
like good practice.  Thanks,

Alex

