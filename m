Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38019C33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 09:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9C5214D8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 09:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Vd1cPzWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgA1JuD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 04:50:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41900 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgA1JuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 04:50:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so15214827wrw.8
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2020 01:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=krzQC6LqfwtaefGbtLfnweRUXZnrIw45EFVRk7Dwe0M=;
        b=Vd1cPzWTU2CwUahMQwXNc6ikKQRlZciwb53KDJxby5esl0lZquxqFUBzGPHqdZiPg/
         3YIVQlHixFP9LZ24H2wEpwItCpelzpBwY++rOPGbj31myI/llqTBKEIPXFcShk7dvs1x
         Do5Y1hHqPWGIXWSfF44ZVutgstFPUnIcAHznyMY3tELtc2l5kA0ixFpS9i4TJyjZFjc8
         /sAIKR/dCGvNC1pNmDcsh96tRhQFrGBPvIZoTUmQtWD+aUzlDvj/dLv5zs4U69WTOlF/
         kHuJ8Q/DD2tfA5niaXipsHAWVwWb9KhcIJVIGGcWyv8HZUL2gb38eDmU9GY2AEAs0UZg
         fgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=krzQC6LqfwtaefGbtLfnweRUXZnrIw45EFVRk7Dwe0M=;
        b=azAasFe2AN9av7+8UbJOnrE7MCDkzMBbFFliDMoaEonZgOkuy7lfFydVseNB2+9GL+
         +BQsmUHqZF7vStzSAgR+k2GGWpe0h/LFRGFLSyqgCfZiWj1wKFzBZSmdQetACTcPMFEq
         WK9/uDJ4oZkNfe/1wg5qV1dAZu+oPtXUug7Lrznlkqeahma5XoNpzpSvzgjpYCIXZ7rB
         6omdTR855YgIPQOmMN4zgdHBY/X7z23P8L0phsBNdNH2S9hiFRoQnVSTn21Zy9eNjeYk
         ZP+Ya5OixdCzyn6R8g36Nh28xn6iRvyAHK9H0TLO2/AH5G1/LKoX5sL8cSlL8oJw2zPf
         6WjA==
X-Gm-Message-State: APjAAAUlEN+XfNYvVK4t+QIXKnZwbe9xCpkixxdZ2r+hwsLd/Eoj7q+3
        fOxV8/2S9dD2tHJWlxiTr35yFQ==
X-Google-Smtp-Source: APXvYqwbmLK25eGGh921vryiHgxw5hyfvygM98trY/hU88fxM4cgTrzDxfcuv847HVkD38LBVnlzPA==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr26436272wrm.13.1580205000172;
        Tue, 28 Jan 2020 01:50:00 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id c2sm24676359wrp.46.2020.01.28.01.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 01:49:59 -0800 (PST)
Date:   Tue, 28 Jan 2020 10:49:57 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [CRASH] crypto: virtio: crash when modprobing tcrypt on 5.5-rc7
 / next-20200122
Message-ID: <20200128094957.GC10493@Red>
References: <20200123101000.GB24255@Red>
 <20200123065150-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123065150-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 23, 2020 at 06:52:29AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 23, 2020 at 11:10:00AM +0100, LABBE Corentin wrote:
> > Hello
> > 
> > When modprobing tcrypt on qemu 4.1.0 I get a kernel panic on 5.5-rc7 and next-20200122
> > qemu is started by:
> > /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net nic,model=e1000,macaddr=52:54:00:12:34:58 -net tap -m 512 -monitor none -object cryptodev-backend-builtin,id=cryptodev0 -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 -append 'console=ttyS0 root=/dev/ram0 ip=dhcp' -kernel /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/kernel/bzImage -initrd /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/ramdisk/rootfs.cpio.gz -drive format=qcow2,file=/var/lib/lava/dispatcher/tmp/41332/apply-overlay-guest-icy4k1ol/lava-guest.qcow2,media=disk,if=ide,id=lavatest
> > 
> > [  112.771925] general protection fault: 0000 [#1] SMP PTI
> > [  112.772686] CPU: 0 PID: 126 Comm: virtio0-engine Not tainted 5.5.0-rc7+ #1
> > [  112.773576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
> > [  112.775319] RIP: 0010:sg_next+0x0/0x20
> > [  112.775821] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
> > [  112.778330] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
> > [  112.779071] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
> > [  112.780081] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
> > [  112.781081] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
> > [  112.782079] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
> > [  112.783079] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
> > [  112.784077] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
> > [  112.785202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  112.786030] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0
> > [  112.787034] Call Trace:
> > [  112.787393]  virtqueue_add_sgs+0x4c/0x90
> > [  112.787998]  virtio_crypto_skcipher_crypt_req+0x310/0x3e0
> > [  112.788817]  crypto_pump_work+0x10c/0x240
> > [  112.789420]  ? __kthread_init_worker+0x50/0x50
> > [  112.790082]  kthread_worker_fn+0x89/0x180
> > [  112.790690]  kthread+0x10e/0x130
> > [  112.791182]  ? kthread_park+0x80/0x80
> > [  112.791736]  ret_from_fork+0x35/0x40
> > [  112.792282] Modules linked in: cts lzo salsa20_generic camellia_x86_64 camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate sha512_ssse3 sha512_generic cfb ofb serpent_sse2_x86_64 serpent_generic lrw twofish_x86_64_3way twofish_x86_64 crypto_simd cryptd glue_helper twofish_generic twofish_common blowfish_x86_64 blowfish_generic blowfish_common md4 tcrypt(+)
> > [  112.797652] ---[ end trace 4a8142d4a08c2518 ]---
> > [  112.798320] RIP: 0010:sg_next+0x0/0x20
> > [  112.798865] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
> > [  112.801452] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
> > [  112.802189] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
> > [  112.803190] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
> > [  112.804192] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
> > [  112.805201] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
> > [  112.806195] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
> > [  112.807222] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
> > [  112.808352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  112.809169] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0
> > 
> > I have tested also 5.4.14 
> > and I got random freeze with:
> > qemu-system-x86_64: virtio: zero sized buffers are not allowed
> > 
> > Regards
> 
> did any of previous versions work for you?
> Any chance of a bisect?
> 

I will try latest version, and if I found a working version I will bisect.
