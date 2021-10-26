Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32C0C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 16:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835FA60EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Oct 2021 16:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhJZQfq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbhJZQfq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 12:35:46 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D26C061745
        for <linux-crypto@vger.kernel.org>; Tue, 26 Oct 2021 09:33:22 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w193so1780702oie.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Oct 2021 09:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ySNcsY363QZ/RnA+nfcsQe2l83WfUSCdvNlRS/XmUgg=;
        b=PQWQEljOW4lIcSSvGAtoMotPfW+8QbP2ps5WGGRksDyer20E55wKBhV9u0CaYVQgc7
         DJmm6U3chCyqAjJX1fNhK4aYBPtg0CFFHBwxBPu7AIWCvcB6VFPLa98j7E+lB7jhBUM+
         PTVebw+XdxonIawOUkraPoLeQJqQbIjOHabOn+Ge+BmHR96soMA0lEOwDqzKVpcp4mW1
         WuO5rKO4kgvfc+Ec9/K5Co1NlezsCW99VaqTx5dtxge6bETg/wAiJbjC7XRIeikxT3F1
         1YgrQKA8/enODlgsYnx87ZjqKCHaNEntc8lXQ7Q1uDz9L8EoJEtkMf5QlGuftEfv0EEM
         UEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ySNcsY363QZ/RnA+nfcsQe2l83WfUSCdvNlRS/XmUgg=;
        b=QuVayXiq0Ln+VFnM50KEeH42O6Qpk/ZPO7SR8WewSkpjDDdzr6Bh8wvbUBnwAVRJue
         bVrUeshRv1Lil3KyaW88tCnxZ2T6m+0ZYD4LuMtpe5j6ubCqrrVhE7DUw7oGGP0t9Jav
         m1gGwFYSm4HwKsk3qwExoziUXexei1RVy7a/HGzKwJlQK+gXfCJWh4FjHDoEqcRvGcoy
         OK64HAhoe4gD4yO9+WYxQvr7Y3nWQBIaaLp6Y515MxegYh1+Lh19SPJN3MXRbE5JzMjp
         klv0AE5gduu5DanGJk4IQOX3AOmsyJ6vYT9hRGNHvtDhnQQMdHtwHdgncUlNM8kqt7q+
         1QOg==
X-Gm-Message-State: AOAM531pxCSwMaJE+VyhJ/Ga+7ov5YlynbOMFHpePpGvghdodl6yV6GL
        OCqdjD+f5udq6FU6jgHwqGC9+41/AzA=
X-Google-Smtp-Source: ABdhPJwxBHpTQO/c3EtEt+dJbl4txHkzX8db3JyGbi7IldHKfgCgKyFBl1HANhFRJM/p0D2OSmBntQ==
X-Received: by 2002:aca:3e09:: with SMTP id l9mr29711370oia.131.1635266001340;
        Tue, 26 Oct 2021 09:33:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w17sm4737635otm.50.2021.10.26.09.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 09:33:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 09:33:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211026163319.GA2785420@roeck-us.net>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917002619.GA6407@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Sep 17, 2021 at 08:26:19AM +0800, Herbert Xu wrote:
> When complex algorithms that depend on other algorithms are built
> into the kernel, the order of registration must be done such that
> the underlying algorithms are ready before the ones on top are
> registered.  As otherwise they would fail during the self-test
> which is required during registration.
> 
> In the past we have used subsystem initialisation ordering to
> guarantee this.  The number of such precedence levels are limited
> and they may cause ripple effects in other subsystems.
> 
> This patch solves this problem by delaying all self-tests during
> boot-up for built-in algorithms.  They will be tested either when
> something else in the kernel requests for them, or when we have
> finished registering all built-in algorithms, whichever comes
> earlier.
> 
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

I can not explain it, but this patch causes a crash with one of my boot
tests (riscv32 with riscv32 virt machine and e1000 network adapter):

[    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)
[    9.968578] Unable to handle kernel paging request at virtual address 9e000000
[    9.969207] Oops [#1]
[    9.969325] Modules linked in:
[    9.969619] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc6-next-20211025 #1
[    9.969983] Hardware name: riscv-virtio,qemu (DT)
[    9.970262] epc : e1000_io_write+0x10/0x1c
[    9.970487]  ra : e1000_reset_hw+0xfa/0x312
[    9.970639] epc : c07b3a44 ra : c07b5e4a sp : c258dcf0
[    9.970792]  gp : c1d6cfa0 tp : c25b0040 t0 : c1f05b3c
[    9.970941]  t1 : 04d6d7d4 t2 : 00001fff s0 : c258dd00
[    9.971091]  s1 : c36a9990 a0 : c36a9990 a1 : 9e000000
[    9.971240]  a2 : 00000000 a3 : 04000000 a4 : 00000002
[    9.971389]  a5 : 9e000000 a6 : 00000000 a7 : 00006000
[    9.971539]  s2 : c101b3ec s3 : c23aceb0 s4 : 04140240
[    9.971692]  s5 : 00000000 s6 : c14a3550 s7 : c1d72000
[    9.971872]  s8 : 00000000 s9 : c36a9000 s10: 00000000
[    9.972037]  s11: 00000000 t3 : cb75ee6c t4 : 0000000c
[    9.972200]  t5 : 000021cb t6 : c1f017a0
[    9.972336] status: 00000120 badaddr: 9e000000 cause: 0000000f
[    9.972570] [<c07b3a44>] e1000_io_write+0x10/0x1c
[    9.973382] ---[ end trace 49388ec34793549e ]---
[    9.973873] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Bisect log is attached. Reverting this patch fixes the problem. The problem
is always seen with this patch applied, and is never seen with this patch
reverted.

Any idea what might be going on, and how to debug the problem ?

Thanks,
Guenter

---
# bad: [2376e5fe91bcad74b997d2cc0535abff79ec73c5] Add linux-next specific files for 20211026
# good: [3906fe9bb7f1a2c8667ae54e967dc8690824f4ea] Linux 5.15-rc7
git bisect start 'HEAD' 'v5.15-rc7'
# bad: [18298270669947b661fe47bf7ec755a6d254c464] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git bisect bad 18298270669947b661fe47bf7ec755a6d254c464
# good: [7294cee5cd18f89b0070ac8b0cd872cc663896de] Merge branch 'i3c/next' of git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux.git
git bisect good 7294cee5cd18f89b0070ac8b0cd872cc663896de
# good: [a7021af707a3637c963ce41802b650db6793eb8a] usb: smsc: use eth_hw_addr_set()
git bisect good a7021af707a3637c963ce41802b650db6793eb8a
# good: [5c511d28b9596fda6c550b0f0c3b163f6dac7e54] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
git bisect good 5c511d28b9596fda6c550b0f0c3b163f6dac7e54
# good: [0969becb5f7661fb0db1a5d6b60f3d7f046ff6a7] s390/qeth: improve trace entries for MAC address (un)registration
git bisect good 0969becb5f7661fb0db1a5d6b60f3d7f046ff6a7
# good: [57edc4d2baac9210564ffe8ea333aabacdce650c] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
git bisect good 57edc4d2baac9210564ffe8ea333aabacdce650c
# good: [a84f7cc76f5d33450e9fc6e681df1e1bf716773e] Merge branch 'nand/next' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
git bisect good a84f7cc76f5d33450e9fc6e681df1e1bf716773e
# bad: [38aa192a05f22f9778f9420e630f0322525ef12e] crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
git bisect bad 38aa192a05f22f9778f9420e630f0322525ef12e
# good: [ba79a32acfde1ffdaefc05b02420c4124b60dbd3] crypto: qat - replace deprecated MSI API
git bisect good ba79a32acfde1ffdaefc05b02420c4124b60dbd3
# good: [81f53028dfbc79844f727a7c13d337ba827a471c] crypto: drbg - Fix unused value warning in drbg_healthcheck_sanity()
git bisect good 81f53028dfbc79844f727a7c13d337ba827a471c
# good: [ca605f97dae4bf070b7c584aec23c1c922e4d823] crypto: qat - power up 4xxx device
git bisect good ca605f97dae4bf070b7c584aec23c1c922e4d823
# bad: [adad556efcdd42a1d9e060cbe5f6161cccf1fa28] crypto: api - Fix built-in testing dependency failures
git bisect bad adad556efcdd42a1d9e060cbe5f6161cccf1fa28
# good: [7c5329697ed4e0e1bf9a4e4fc9f0053f2f58935d] crypto: marvell/cesa - drop unneeded MODULE_ALIAS
git bisect good 7c5329697ed4e0e1bf9a4e4fc9f0053f2f58935d
# first bad commit: [adad556efcdd42a1d9e060cbe5f6161cccf1fa28] crypto: api - Fix built-in testing dependency failures
