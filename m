Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00936C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 20:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiB1URB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiB1URA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 15:17:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAE12522FF
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 12:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646079378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1qwirYd+erEvHJ95lOtyR0Vo6sDtD7Al1rwYNacQIM=;
        b=afuzBMKSE50cOh4PzglSTcvyPL0Tdvt/UFGXTgjMODkbzDxLUEvEa7VK2VkRfr45bHu1y/
        ZjEIOXDNV550fI1RUTvZURIDoR+3iSsblSFESJIxLyw7i47UYCFQAA8VWQrpEP1IRF7EYn
        RLeLDkW2rm5hUy1EDsPqyIDO9mSku0M=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-5GOND1t8MFC4E9INGOZRWA-1; Mon, 28 Feb 2022 15:16:17 -0500
X-MC-Unique: 5GOND1t8MFC4E9INGOZRWA-1
Received: by mail-oo1-f72.google.com with SMTP id r18-20020a056820039200b0031d6f9170eeso2921285ooj.6
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 12:16:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1qwirYd+erEvHJ95lOtyR0Vo6sDtD7Al1rwYNacQIM=;
        b=qG+0QBaOTW9PRCUYvFP8b2UQBsK00+g4SEtcyeGzOrmdi9e3uwXISextnb8oVKHTif
         RDquH7c4mNMIdLGaYgGIY9vKagezCwzn9HSK+Yn878ySvRrRrOyq5BJYBAfOug87avZ/
         y/4cp67sOlj8djbgxcH+x0P9KAm85WUTPgqeZssAXW0HixvmZtLQHGOpC0HE24ev5lCs
         YEA2S1vP6tuJ/MZWWqZdySllYFIA/grpoOHMQvVN+I8b8HB5A/uUEREfVN9uOpWoym4b
         0Qm5rG0auQx9Hz1gtkL02y6RUA9MsL1Ozy138h5KD+vXk5M5OBI3U+fop/SMZT1kRgck
         mtDQ==
X-Gm-Message-State: AOAM533wrYPGpuC8wz1Q6V1X73Caf3vnfCmOY8UuNHUOXGLyFXlrWbGF
        KQf38ealpMwhpwFbUUMh4kzPLW/25U+SzqZMBidZ2zMUruG4u65nF2jxZMVMoQBUOEnGwTDtgM+
        2C4Zc/NWVLBGLuil60bzFItBf
X-Received: by 2002:a05:6808:2022:b0:2d4:752b:dfb5 with SMTP id q34-20020a056808202200b002d4752bdfb5mr10313219oiw.174.1646079376573;
        Mon, 28 Feb 2022 12:16:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwATX/TctczNS/gHsk9mEtkZD5TmnQxZgG63VALy5wIcqHFt0Pz7L2VnwImfYiFNYQ8F3+yVw==
X-Received: by 2002:a05:6808:2022:b0:2d4:752b:dfb5 with SMTP id q34-20020a056808202200b002d4752bdfb5mr10313198oiw.174.1646079376357;
        Mon, 28 Feb 2022 12:16:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a12-20020a056870d60c00b000d6d215bf88sm4908975oaq.37.2022.02.28.12.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:16:15 -0800 (PST)
Date:   Mon, 28 Feb 2022 13:16:14 -0700
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
Message-ID: <20220228131614.27ad37dc.alex.williamson@redhat.com>
In-Reply-To: <20220228180520.GO219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 28 Feb 2022 14:05:20 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:
> 
> > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > +                                      unsigned int cmd, unsigned long arg)
> > +{
> > +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > +       loff_t *pos = &filp->f_pos;
> > +       struct vfio_device_mig_precopy precopy;
> > +       unsigned long minsz;
> > +
> > +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> > +               return -EINVAL;  
> 
> ENOTTY
> 
> > +
> > +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > +
> > +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > +               return -EFAULT;
> > +       if (precopy.argsz < minsz)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&migf->lock);
> > +       if (*pos > migf->total_length) {
> > +               mutex_unlock(&migf->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       precopy.dirty_bytes = 0;
> > +       precopy.initial_bytes = migf->total_length - *pos;
> > +       mutex_unlock(&migf->lock);
> > +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> > +}  
> 
> Yes
> 
> And I noticed this didn't include the ENOMSG handling, read() should
> return ENOMSG when it reaches EOS for the pre-copy:
> 
> + * During pre-copy the migration data FD has a temporary "end of stream" that is
> + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> + * may indicate that the device is idle and not currently dirtying any internal
> + * state. When read() is done on this temporary end of stream the kernel driver
> + * should return ENOMSG from read(). Userspace can wait for more data (which may
> + * never come) by using poll.

I'm confused by your previous reply that the use of curr_state should
be eliminated, isn't this ioctl only valid while the device is in the
PRE_COPY or PRE_COPY_P2P states?  Otherwise the STOP_COPY state would
have some expectation to be able to use this ioctl for devices
supporting PRE_COPY.  I'd like to see the uapi clarify exactly what
states allow this ioctl and define the behavior of the ioctl when
transitioning out of those states with an open data_fd, ie. is it
defined to return an -errno once in STOP_COPY?  Thanks,

Alex

