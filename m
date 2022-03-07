Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F0FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 09:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiCGJGi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 04:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiCGJGi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 04:06:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF61B443FE
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 01:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646643943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KquYHpLzP9rbFE8aNYKIXPzbeoLEFNa1Q6VUPR36ZHo=;
        b=VeP3JhV/6ywY42CYsAfyDpVn+b4jxJMotyi8l4sNEEpt625qZaRN4ytqIjNouh1hEWEOZd
        Xjz99qoyiczPkYeEHBeNFYAdYAXBm+0djn9VeudOMCovA/se7WfPtPb9Caks6lF03WsMTI
        7V8RVZbmxQiOnLH1y8i9BzfJADAGFII=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-DVBT-u3MOUy07KhqdmSKoA-1; Mon, 07 Mar 2022 04:05:42 -0500
X-MC-Unique: DVBT-u3MOUy07KhqdmSKoA-1
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so6625881ejw.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 01:05:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KquYHpLzP9rbFE8aNYKIXPzbeoLEFNa1Q6VUPR36ZHo=;
        b=f8MA7Uv3IJ75g/xorycsiMxl/jH8Yg0iEyCj7khtJcc0YQ+GoI0GQWmlM0KbIionoo
         JxBSxk9ahXyKdmGE/ZB+4VfIS/Qs4sDYLTVS+xwef6B0cBSXK9vZGNTy1BCl/dZomeXb
         pziW/AyB2vVGG7WHhfv8g8+uQ5PVuAKGlwRCgOntey+W/LfkcBM8x+Nm3to5hDdiHibq
         BxxGeKST2RFE4Bfcz32axQAxrFW3rIYDozmsVNoFTdyl/H3VghiPa5VWYRLTxznnJYnB
         nk91R/F/FOIKcNbDh/G1sYF9OGeeC7tiuQA2/sICNdEQwf+4uzk8HHcnh1gFKeRI0Wx6
         5gww==
X-Gm-Message-State: AOAM530ZZuTBKVj5N87H30rOMy1j/R0L57yqbq2d7M2rPWwwWLv0xmk4
        zgqzyy4ZCc0T0Mv1QtKPwOGLzOoUNUwoNsyPBDlnnPVFWU1iE5qOsi66N1/57eMkFOr3BkgiNdk
        PZeQR+PY4+FsAqyBbWEph7Gnr
X-Received: by 2002:a50:fb93:0:b0:416:c4f:bd24 with SMTP id e19-20020a50fb93000000b004160c4fbd24mr10142937edq.225.1646643941307;
        Mon, 07 Mar 2022 01:05:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWeD5sAgrgZ1GTJMg5/qZSM+l+wtaHwT/4dN4mntileJu6VvueA9/As61UwE+i+QOYycmFEg==
X-Received: by 2002:a50:fb93:0:b0:416:c4f:bd24 with SMTP id e19-20020a50fb93000000b004160c4fbd24mr10142922edq.225.1646643941088;
        Mon, 07 Mar 2022 01:05:41 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id a25-20020a50ff19000000b0040f84cd806csm5875397edu.59.2022.03.07.01.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 01:05:40 -0800 (PST)
Date:   Mon, 7 Mar 2022 04:05:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com,
        cohuck@redhat.com
Subject: Re: [PATCH v3 0/4] Introduce akcipher service for virtio-crypto
Message-ID: <20220307040431-mutt-send-email-mst@kernel.org>
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
 <a9d1dfc1-080e-fba2-8fbb-28718b067e0d@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9d1dfc1-080e-fba2-8fbb-28718b067e0d@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 07, 2022 at 10:42:30AM +0800, zhenwei pi wrote:
> Hi, Michael & Lei
> 
> The full patchset has been reviewed by Gonglei, thanks to Gonglei.
> Should I modify the virtio crypto specification(use "__le32 akcipher_algo;"
> instead of "__le32 reserve;" only, see v1->v2 change), and start a new issue
> for a revoting procedure?

You can but not it probably will be deferred to 1.3. OK with you?

> Also cc Cornelia Huck.
> 
> On 3/2/22 11:39 AM, zhenwei pi wrote:
> > v2 -> v3:
> >    Rename virtio_crypto_algs.c to virtio_crypto_skcipher_algs.c, and
> >      minor changes of function name.
> >    Minor changes in virtio_crypto_akcipher_algs.c: no need to copy from
> >      buffer if opcode is verify.
> > 
> > v1 -> v2:
> >    Fix 1 compiling warning reported by kernel test robot <lkp@intel.com>
> >    Put "__le32 akcipher_algo;" instead of "__le32 reserve;" field of
> >      struct virtio_crypto_config directly without size change.
> >    Add padding in struct virtio_crypto_ecdsa_session_para to keep
> >      64-bit alignment.
> >    Remove irrelevant change by code format alignment.
> > 
> >    Also CC crypto gurus Herbert and linux-crypto@vger.kernel.org.
> > 
> >    Test with QEMU(patched by the v2 version), works fine.
> > 
> > v1:
> >    Introduce akcipher service, implement RSA algorithm, and a minor fix.
> > 
> > zhenwei pi (4):
> >    virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
> >    virtio-crypto: introduce akcipher service
> >    virtio-crypto: implement RSA algorithm
> >    virtio-crypto: rename skcipher algs
> > 
> >   drivers/crypto/virtio/Makefile                |   3 +-
> >   .../virtio/virtio_crypto_akcipher_algs.c      | 585 ++++++++++++++++++
> >   drivers/crypto/virtio/virtio_crypto_common.h  |   7 +-
> >   drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
> >   drivers/crypto/virtio/virtio_crypto_mgr.c     |  15 +-
> >   ...o_algs.c => virtio_crypto_skcipher_algs.c} |   4 +-
> >   include/uapi/linux/virtio_crypto.h            |  82 ++-
> >   7 files changed, 693 insertions(+), 9 deletions(-)
> >   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> >   rename drivers/crypto/virtio/{virtio_crypto_algs.c => virtio_crypto_skcipher_algs.c} (99%)
> > 
> 
> -- 
> zhenwei pi

