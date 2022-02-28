Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A140C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 21:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiB1VVW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiB1VVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 16:21:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01949EFFAA
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 13:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646083240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6wu1+m7/y8nI6BZGp4jNazhv0Rsh6xTe2mPvqYxCIw=;
        b=FwFs7TKJ6fuql8ALMi5WZ+/x75VA9yoqZbFK788HlzQTLO7Z6SK8EceCurm1bKIlnOJEUo
        TXcfEUVOSbonP59OtnPI7hYM8g/97Ee3JbfRHaJWm/2sKmbJKBdDE7Pe3GvBpdPV9TQ4WC
        9jZB30uMNE/ZJgQIe/7rfzTuqxFtjhI=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-bJp2rqpZPbeMBRd2A6jZpA-1; Mon, 28 Feb 2022 16:20:38 -0500
X-MC-Unique: bJp2rqpZPbeMBRd2A6jZpA-1
Received: by mail-oo1-f70.google.com with SMTP id x130-20020a4a4188000000b0031b2e31acc7so9267332ooa.21
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 13:20:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6wu1+m7/y8nI6BZGp4jNazhv0Rsh6xTe2mPvqYxCIw=;
        b=IQv7YthPyxQwQWAQqO9be3sdUXvt45YOMxqRaQKtDFrb/lS2tnkHyvTloGFp+SljnM
         ymVlnOb97/eC6FjCUVMrjzufCLfFDleiyUCtd0nJQLS0vDzp/cki7nhc8Cs2Ylu6VEi9
         YWpHx1z+b1F8px7n7pbEAJYqHA/dNthFhSxgDMWDA93IO9kdohN6O/A+UPtG1LYeXcbj
         c54AG5R+0B+moo/fzHO8rwD5x3K66JBa5M7Uy0KhDrlWVlRsemPwNXX0DeZX7Dha0DSW
         tS1mcZrzimU4mlJorh2R3YBeX7Pa66SpUd9N74b9sfTye4sqE/Mayj9bwYuYgTVS3M7V
         E3gg==
X-Gm-Message-State: AOAM532iYUYuuNad8OQ8VVOwyzLA6wGdLYVii6gvNd09lxBwKJ/+bUTF
        qv1R4T3/789xiPBJxNkvksIqA08ftFYbR+k2nGWM0E17b/l/Z33rU9rlHgVI81Xef2wzVmC/3ir
        Xj5i52Z9LSSFHY+wCWdxQbVns
X-Received: by 2002:a05:6871:79b:b0:d3:4039:7e7c with SMTP id o27-20020a056871079b00b000d340397e7cmr9367038oap.121.1646083237864;
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHK6xVIr8qQr3M46nx2bUSEdvIL0NZBwiWDciAqFz2Oi4tFkHyMFlLCQIvyTFhjzN3Y8aPjg==
X-Received: by 2002:a05:6871:79b:b0:d3:4039:7e7c with SMTP id o27-20020a056871079b00b000d340397e7cmr9367028oap.121.1646083237618;
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v5-20020a544d05000000b002d7652b3c52sm4722517oix.25.2022.02.28.13.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 13:20:37 -0800 (PST)
Date:   Mon, 28 Feb 2022 14:20:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228142034.024e7be6.alex.williamson@redhat.com>
In-Reply-To: <20220228202919.GP219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 28 Feb 2022 16:29:19 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 01:16:14PM -0700, Alex Williamson wrote:
> > On Mon, 28 Feb 2022 14:05:20 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:
> > >   
> > > > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > > > +                                      unsigned int cmd, unsigned long arg)
> > > > +{
> > > > +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > > > +       loff_t *pos = &filp->f_pos;
> > > > +       struct vfio_device_mig_precopy precopy;
> > > > +       unsigned long minsz;
> > > > +
> > > > +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> > > > +               return -EINVAL;    
> > > 
> > > ENOTTY
> > >   
> > > > +
> > > > +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > > > +
> > > > +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > > > +               return -EFAULT;
> > > > +       if (precopy.argsz < minsz)
> > > > +               return -EINVAL;
> > > > +
> > > > +       mutex_lock(&migf->lock);
> > > > +       if (*pos > migf->total_length) {
> > > > +               mutex_unlock(&migf->lock);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       precopy.dirty_bytes = 0;
> > > > +       precopy.initial_bytes = migf->total_length - *pos;
> > > > +       mutex_unlock(&migf->lock);
> > > > +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> > > > +}    
> > > 
> > > Yes
> > > 
> > > And I noticed this didn't include the ENOMSG handling, read() should
> > > return ENOMSG when it reaches EOS for the pre-copy:
> > > 
> > > + * During pre-copy the migration data FD has a temporary "end of stream" that is
> > > + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> > > + * may indicate that the device is idle and not currently dirtying any internal
> > > + * state. When read() is done on this temporary end of stream the kernel driver
> > > + * should return ENOMSG from read(). Userspace can wait for more data (which may
> > > + * never come) by using poll.  
> > 
> > I'm confused by your previous reply that the use of curr_state should
> > be eliminated, isn't this ioctl only valid while the device is in the
> > PRE_COPY or PRE_COPY_P2P states?  Otherwise the STOP_COPY state would
> > have some expectation to be able to use this ioctl for devices
> > supporting PRE_COPY.    
> 
> I think it is fine to keep working on stop copy, though the
> implementation here isn't quite right for that..
> 
> if (migf->total_length > QM_MATCH_SIZE)
>    precopy.dirty_bytes = migf->total_length - QM_MATCH_SIZE - *pos;
> else
>    precopy.dity_bytes = 0;
> 
> if (*pos < QM_MATCH_SIZE)
>     precopy.initial_bytes = QM_MATCH_SIZE - *pos;
> else
>     precopy.initial_Bytes = 0;
> 
> Unless you think we should block it.

What's the meaning of initial_bytes and dirty_bytes while in STOP_COPY?
It seems like these become meaningless and if so, why shouldn't the
ioctl simply return -EINVAL if the device state doesn't match the
window where it's useful?

> > I'd like to see the uapi clarify exactly what states allow this
> > ioctl and define the behavior of the ioctl when transitioning out of
> > those states with an open data_fd, ie. is it defined to return an
> > -errno once in STOP_COPY?  Thanks,  
> 
> The ioctl is on the data_fd, so it should follow all the normal rules
> of the data_fd just like read() - ie all ioctls/read/write fails when
> teh state is moved outside one where the data_fd is valid.
> 
> That looks like another issue with the above, it doesn't chck
> migf->disabled.
> 
> Should we add another sentence about this?

Right, of course the ioctl goes away when the data_fd is invalid, the
question is more that we've created this PRE_COPY_* specific ioctl and
what does it mean to call it when not in a device state where the
data_fd is still valid but this ioctl is really not.  We should
specify how the driver is intended to respond to this ioctl in
STOP_COPY.  Thanks,

Alex

