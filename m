Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC52C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 03:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiCCDso (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 22:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCCDsn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 22:48:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4527A136EE7
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 19:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646279277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYfgs3N+rvRxYqeQvpIVkVHYmOj1DCx1FHLabmoSbPc=;
        b=KvJpShr88ONMsBnjnrPVjC9Q1KDptCaYzL7oiDLrZ9mGdNS+f0CN4idyJf/QT0hBolyTSM
        9QW64+T16BzHGOMwx1NpMrZ/blfMl5EBBEDHUQNBl83b85DXgbonBTJQEHnbATlpln0M9v
        twY6zCE8HLAYHunnvpWHxkxk+BBVpQQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-9wKs7CfwOoe6fMENsljH7Q-1; Wed, 02 Mar 2022 22:47:56 -0500
X-MC-Unique: 9wKs7CfwOoe6fMENsljH7Q-1
Received: by mail-ot1-f70.google.com with SMTP id q2-20020a9d5782000000b005ad0c39a8b5so2675442oth.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 19:47:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pYfgs3N+rvRxYqeQvpIVkVHYmOj1DCx1FHLabmoSbPc=;
        b=8PnPt7PcG8WyUXHJujwKxjfnvKruHe9pFeXjGrLkNUH1wJTQvc3XOMxiqun6cpV9In
         44ADGNEQYD/gktfOvz3ZJcIj3J185JfDS+iWWwFN2I4FB6q4nFnzYVAE8yQqninAj5l/
         qv5B2Uo2BIs/69PJbpoDCmCLdE8HScB+W8wJAboq+UFk2X+4z0XrAw1kQFmR/491ZCi/
         in5L7NW6KSQPW0vrZ7heWx42C4G0QE6nwBk1VWIyBUreASoTOocROF76sBJ6QaDhEejC
         kvCZmCqtMseeqemyn8E9/1JPLUYBjy5DqUivUnqaEeuEYOamLmHOHcExmXlLMlAFHAd4
         OUvA==
X-Gm-Message-State: AOAM5326r85ixuL91491LlFaMFLXiyeLuFxs4Q7ozuDkeFls7AWn/Noc
        YWRetxr4M8kPg3PvfNTzAUzJV4syFxa/dy1erSviqGx66k3IipnZoROrihVVE3w7f4W50B8gJLA
        JOutz/m+rqgEYG0fxDJ6I+d60
X-Received: by 2002:a05:6870:c987:b0:d7:3d45:6692 with SMTP id hi7-20020a056870c98700b000d73d456692mr2568152oab.34.1646279275357;
        Wed, 02 Mar 2022 19:47:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqAqFU9eF4TGFq+ynpN8QYYtYZBW2wrihjy9F9oNP48aBIzOrqLfKZTtd7KLpmq/YSUxV4OA==
X-Received: by 2002:a05:6870:c987:b0:d7:3d45:6692 with SMTP id hi7-20020a056870c98700b000d73d456692mr2568136oab.34.1646279275125;
        Wed, 02 Mar 2022 19:47:55 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x3-20020a056808144300b002d4dedfc1ebsm451545oiv.20.2022.03.02.19.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 19:47:54 -0800 (PST)
Date:   Wed, 2 Mar 2022 20:47:52 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol
 with PRE_COPY
Message-ID: <20220302204752.71ea8b32.alex.williamson@redhat.com>
In-Reply-To: <20220303000528.GW219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
        <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
        <20220302133159.3c803f56.alex.williamson@redhat.com>
        <20220303000528.GW219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Mar 2022 20:05:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:
> > > + * initial_bytes reflects the estimated remaining size of any initial mandatory
> > > + * precopy data transfer. When initial_bytes returns as zero then the initial
> > > + * phase of the precopy data is completed. Generally initial_bytes should start
> > > + * out as approximately the entire device state.  
> > 
> > What is "mandatory" intended to mean here?  The user isn't required to
> > collect any data from the device in the PRE_COPY states.  
> 
> If the data is split into initial,dirty,trailer then mandatory means
> that first chunk.

But there's no requirement to read anything in PRE_COPY, so initial
becomes indistinguishable from trailer and dirty doesn't exist.

> > "The vfio_precopy_info data structure returned by this ioctl provides
> >  estimates of data available from the device during the PRE_COPY states.
> >  This estimate is split into two categories, initial_bytes and
> >  dirty_bytes.
> > 
> >  The initial_bytes field indicates the amount of static data available
> >  from the device.  This field should have a non-zero initial value and
> >  decrease as migration data is read from the device.  
> 
> static isn't great either, how about just say 'minimum data available'

'initial precopy data-set'?

> >  Userspace may use the combination of these fields to estimate the
> >  potential data size available during the PRE_COPY phases, as well as
> >  trends relative to the rate the device is dirtying it's internal
> >  state, but these fields are not required to have any bearing relative
> >  to the data size available during the STOP_COPY phase."  
> 
> That last is too strong. I would just drop starting at but.
> 
> The message to communicate is the device should allow dirty_bytes to
> reach 0 during the PRE_COPY phases if everything is is idle. Which
> tells alot about how to calculate it.
> 
> It is all better otherwise
> 
> > > + * Drivers should attempt to return estimates so that initial_bytes +
> > > + * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
> > > + * will require to be streamed.  
> >
> > I think previous discussions have proven this false, we expect trailing
> > data that is only available in STOP_COPY, we cannot bound the size of
> > that data, and dirty_bytes is not intended to expose data that cannot
> > be retrieved during the PRE_COPY phases.  Thanks,  
> 
> It was written assuming the stop_copy trailer is small.

We have no basis to make that assertion.  We've agreed that precopy can
be used for nothing more than a compatibility test, so we could have a
vGPU with a massive framebuffer and no ability to provide dirty
tracking implement precopy only to include the entire framebuffer in
the trailing STOP_COPY data set.  Per my understanding and the fact
that we cannot enforce any heuristics regarding the size of the tailer
relative to the pre-copy data set, I think the above strongly phrased
sentence is necessary to understand the limitations of what this ioctl
is meant to convey.  Thanks,

Alex

