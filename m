Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A351C3524D
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 09:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CDB2217BA
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 09:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Nn9PL41l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDJIR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 04:08:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39883 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBDJIQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 04:08:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so21922578wrt.6
        for <linux-crypto@vger.kernel.org>; Tue, 04 Feb 2020 01:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iGV1DqhrFLHj8QdalXfDtR6wbs+cGOMB35ltqgmN0Ag=;
        b=Nn9PL41l50lwNMTCjinnOCp6VUeltIV5L0mfCuY0dSdrMHt6xqEvcZaxfRqU7w4PCq
         lsYwWxk3hYLI4EI34hyVjK2kgAo3bRrdxR9F8MRWLazDdtR9nBADsVv19rq85g4k22/e
         h5c94UTIFkt4txci8w+X66lnG/OIj1IeOe1LMos2KG7blHYWL9Iyzk2BKs9l0Xj5SeFm
         uia7ShgCWaxWoIeSnfdRBOPNfwYZ2q3Em+Z7XS3n3ovyVOtjpWRtuzzwtD1EP3KLHovC
         LTUQsL1BELtoBbc9Jgpri5PWJMud53IvJjPuw+izV8ydzOtYb16iGr+bM7wdLVuAY+/c
         QT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iGV1DqhrFLHj8QdalXfDtR6wbs+cGOMB35ltqgmN0Ag=;
        b=f3SNuhTNtj2eqZCjKnTL35WJ4ez3+1uF6VdOb3Wqrm7jboFT4Dbvq46s9NF++X2+nY
         0lmbsf90jbbG4e3J0bUiq6qOuuuBfIdz9lQWKUsYONpfgQiq94rVvRocXelISmDlsVJ1
         ONRYBKy87alc89NwWdBUUyyhW8ieORhnZEHXLVwzFqkuMIuD5E77tWo7ahcpoaJXp6/L
         XXcxdYnb4S0dflm75GNgVUrLsY0zNA5ruIHID1xTIFbKsP3MSRk/G9WgY8gIKxBq3G9q
         q7MtOuLGs5AmpawDbrmY4U0ympOW2bgpjUxgZWUkff70EN1vqZ4zxNRtgN3q0rLngaDt
         mvtA==
X-Gm-Message-State: APjAAAU5uVY6PLqCn4xIN1Sq8vgQGc6HLdc4VnhPNUQNaozz4MrcS0LF
        0xvbVHIs9AR804zFgF+g96HUpQ==
X-Google-Smtp-Source: APXvYqxLl4f0Q+pyBcc8esetrhdNVcLBQGIBq/qcl042V4LKAHzTAsJYrQ4o153xub5vUSaXu0nvqA==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr20668462wrm.24.1580807294261;
        Tue, 04 Feb 2020 01:08:14 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id f8sm13221241wru.12.2020.02.04.01.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 01:08:13 -0800 (PST)
Date:   Tue, 4 Feb 2020 10:08:11 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Gonglei <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [CRASH] crypto: virtio: crash when modprobing tcrypt on 5.5-rc7
 / next-20200122
Message-ID: <20200204090811.GA26734@Red>
References: <20200123101000.GB24255@Red>
 <20200123065150-mutt-send-email-mst@kernel.org>
 <20200203205324.GA26330@Red>
 <CAKv+Gu8zPK2R_3UbGJq=+g=exknY0g2cprKBgBUTMKAPXL=pOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8zPK2R_3UbGJq=+g=exknY0g2cprKBgBUTMKAPXL=pOA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 03, 2020 at 11:01:57PM +0000, Ard Biesheuvel wrote:
> On Mon, 3 Feb 2020 at 20:53, LABBE Corentin <clabbe@baylibre.com> wrote:
> >
> > On Thu, Jan 23, 2020 at 06:52:29AM -0500, Michael S. Tsirkin wrote:
> > > On Thu, Jan 23, 2020 at 11:10:00AM +0100, LABBE Corentin wrote:
> > > > Hello
> > > >
> > > > When modprobing tcrypt on qemu 4.1.0 I get a kernel panic on 5.5-rc7 and next-20200122
> > > > qemu is started by:
> > > > /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net nic,model=e1000,macaddr=52:54:00:12:34:58 -net tap -m 512 -monitor none -object cryptodev-backend-builtin,id=cryptodev0 -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 -append 'console=ttyS0 root=/dev/ram0 ip=dhcp' -kernel /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/kernel/bzImage -initrd /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/ramdisk/rootfs.cpio.gz -drive format=qcow2,file=/var/lib/lava/dispatcher/tmp/41332/apply-overlay-guest-icy4k1ol/lava-guest.qcow2,media=disk,if=ide,id=lavatest
> > > >
> > > > [  112.771925] general protection fault: 0000 [#1] SMP PTI
> > > > [  112.772686] CPU: 0 PID: 126 Comm: virtio0-engine Not tainted 5.5.0-rc7+ #1
> > > > [  112.773576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
> 
> Interesting. So your QEMU was cross-built on an ARMv7 machine?? Or
> just the guest firmware?

This qemu is built and run on x86 (gentoo).
The firmware is not built (pre-built version).

> 
> 
> > > > [  112.775319] RIP: 0010:sg_next+0x0/0x20
> > > > [  112.775821] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
> > > > [  112.778330] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
> > > > [  112.779071] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
> > > > [  112.780081] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
> > > > [  112.781081] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
> > > > [  112.782079] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
> > > > [  112.783079] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
> > > > [  112.784077] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
> > > > [  112.785202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [  112.786030] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0
> > > > [  112.787034] Call Trace:
> > > > [  112.787393]  virtqueue_add_sgs+0x4c/0x90
> > > > [  112.787998]  virtio_crypto_skcipher_crypt_req+0x310/0x3e0
> > > > [  112.788817]  crypto_pump_work+0x10c/0x240
> > > > [  112.789420]  ? __kthread_init_worker+0x50/0x50
> > > > [  112.790082]  kthread_worker_fn+0x89/0x180
> > > > [  112.790690]  kthread+0x10e/0x130
> > > > [  112.791182]  ? kthread_park+0x80/0x80
> > > > [  112.791736]  ret_from_fork+0x35/0x40
> > > > [  112.792282] Modules linked in: cts lzo salsa20_generic camellia_x86_64 camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate sha512_ssse3 sha512_generic cfb ofb serpent_sse2_x86_64 serpent_generic lrw twofish_x86_64_3way twofish_x86_64 crypto_simd cryptd glue_helper twofish_generic twofish_common blowfish_x86_64 blowfish_generic blowfish_common md4 tcrypt(+)
> > > > [  112.797652] ---[ end trace 4a8142d4a08c2518 ]---
> > > > [  112.798320] RIP: 0010:sg_next+0x0/0x20
> > > > [  112.798865] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
> > > > [  112.801452] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
> > > > [  112.802189] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
> > > > [  112.803190] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
> > > > [  112.804192] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
> > > > [  112.805201] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
> > > > [  112.806195] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
> > > > [  112.807222] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
> > > > [  112.808352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [  112.809169] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0
> > > >
> > > > I have tested also 5.4.14
> > > > and I got random freeze with:
> > > > qemu-system-x86_64: virtio: zero sized buffers are not allowed
> > > >
> > > > Regards
> > >
> > > did any of previous versions work for you?
> > > Any chance of a bisect?
> > >
> >
> > Hello
> >
> > Bisecting lead to 500e6807ce93b1fdc7d5b827c5cc167cc35630db ("crypto: virtio - implement missing support for output IVs")
> > Qemu 4.2.0 also fail like this but not 1:3.1+dfsg-8+deb10u2
> >
> 
> That commit adds scatterwalk_map_and_copy() calls in two places, and
> the only way I see that could cause corruption here is when
> req->cryptlen < AES_BLOCK_SIZE.
> 
> Could you please try whether returning an error early in
> __virtio_crypto_skcipher_do_req() if req->cryptlen < AES_BLOCK_SIZE
> fixes the issue?

I did the following:
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -360,6 +360,9 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
        int sg_total;
        uint8_t *iv;
 
+       if (req->cryptlen < AES_BLOCK_SIZE)
+               return -EINVAL;
+
        src_nents = sg_nents_for_len(req->src, req->cryptlen);
        dst_nents = sg_nents(req->dst);

Without any change in the crash.
So the problem is probably present since the introduction of the driver but hidden because it never pass the selftests.
