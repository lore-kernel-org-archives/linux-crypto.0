Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83385C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 10:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C932467B
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 10:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="lEZ6F2Y3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAWKKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 05:10:04 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:36170 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWKKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 05:10:04 -0500
Received: by mail-wr1-f51.google.com with SMTP id z3so2408736wru.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2020 02:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CPtiGh3pLVRqM/RhdEdGDHKOR3MHqHacHg8X7Y8s2e4=;
        b=lEZ6F2Y3XuFJJ+f1L3xrMx1z5WAfHx5lpS0EBr9opnokRMqukIqIqhwGGeKAPwlCcL
         JGuqDB/aIDlkL/hUmWsag1p+ar/UNmmzmTrPH2dbu9i+EDK9G14srPRYivZk7CuWIo7c
         9nncpMgC3UoI9fXRMEvtxn5bWbO0DkMBSsbbIkUhDwqKrF43+4tb7+C7Qt+B+Yolhjjr
         VEbsfQsB+n6c7my2S4Cgj3Hjq/FJ82bqeBGgldw1ZvUgDuQCKyA9BlkdbybHOuKkGUEH
         8cPT1tCIT1WiCYgZXDcg9GS33SWuWvXWesDTkAMg2y0WlivRUtPrblssZrLY83zwSdv4
         3Nhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CPtiGh3pLVRqM/RhdEdGDHKOR3MHqHacHg8X7Y8s2e4=;
        b=c0zgxxbIdLIdFaXASid0O9LxFGxUwKfCURcJZcspaQw8CkZuLE4PlPUHo9/uDx0p7z
         2N8t7LZoBu/Pr2rmoNrtgJSqEnKddjGf3F7HWW/wauUC4Tan1YaoTeOCDIwGXPWfzIOr
         5TfYQzcQLMrR5SZK4Ddadwpajtso7dhYmbgotf42SOsyQCoFMd3wLl1c93WuJN0lQyKM
         KMODIZPuSRmKZyyBzaAGN/73tNLzzPsEe2DSG+F8zvSw4dOjhRPKxR5jVfkW3OuF0HQN
         tpevKGpCQpelwOcbKOJ08vBf08iYEcwg+CmofqkNzcFi9vmGgRR/sozugsCCB8LTqbSp
         lTrg==
X-Gm-Message-State: APjAAAV89AMFUSMnYhFGwpqj1BnnIB3ZYe6OvcKt16Ysw5EmLmtwQuRn
        owdZrlfPA6lE7XtWiCLHCtSbPg==
X-Google-Smtp-Source: APXvYqysNIh/eaPEJ9Qrn6D+jgs5CR8M8Bul4ynZ8ZQyY/NCkS8niuCrkSUJIY9lJjgLK1bUNuvMiA==
X-Received: by 2002:a5d:484f:: with SMTP id n15mr16446703wrs.365.1579774202577;
        Thu, 23 Jan 2020 02:10:02 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id q6sm2551467wrx.72.2020.01.23.02.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 02:10:02 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:10:00 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        virtualization@lists.linux-foundation.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [CRASH] crypto: virtio: crash when modprobing tcrypt on 5.5-rc7 /
 next-20200122
Message-ID: <20200123101000.GB24255@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

When modprobing tcrypt on qemu 4.1.0 I get a kernel panic on 5.5-rc7 and next-20200122
qemu is started by:
/usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net nic,model=e1000,macaddr=52:54:00:12:34:58 -net tap -m 512 -monitor none -object cryptodev-backend-builtin,id=cryptodev0 -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 -append 'console=ttyS0 root=/dev/ram0 ip=dhcp' -kernel /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/kernel/bzImage -initrd /var/lib/lava/dispatcher/tmp/41332/deployimages-td18675m/ramdisk/rootfs.cpio.gz -drive format=qcow2,file=/var/lib/lava/dispatcher/tmp/41332/apply-overlay-guest-icy4k1ol/lava-guest.qcow2,media=disk,if=ide,id=lavatest

[  112.771925] general protection fault: 0000 [#1] SMP PTI
[  112.772686] CPU: 0 PID: 126 Comm: virtio0-engine Not tainted 5.5.0-rc7+ #1
[  112.773576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
[  112.775319] RIP: 0010:sg_next+0x0/0x20
[  112.775821] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
[  112.778330] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
[  112.779071] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
[  112.780081] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
[  112.781081] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
[  112.782079] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
[  112.783079] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
[  112.784077] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
[  112.785202] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  112.786030] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0
[  112.787034] Call Trace:
[  112.787393]  virtqueue_add_sgs+0x4c/0x90
[  112.787998]  virtio_crypto_skcipher_crypt_req+0x310/0x3e0
[  112.788817]  crypto_pump_work+0x10c/0x240
[  112.789420]  ? __kthread_init_worker+0x50/0x50
[  112.790082]  kthread_worker_fn+0x89/0x180
[  112.790690]  kthread+0x10e/0x130
[  112.791182]  ? kthread_park+0x80/0x80
[  112.791736]  ret_from_fork+0x35/0x40
[  112.792282] Modules linked in: cts lzo salsa20_generic camellia_x86_64 camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate sha512_ssse3 sha512_generic cfb ofb serpent_sse2_x86_64 serpent_generic lrw twofish_x86_64_3way twofish_x86_64 crypto_simd cryptd glue_helper twofish_generic twofish_common blowfish_x86_64 blowfish_generic blowfish_common md4 tcrypt(+)
[  112.797652] ---[ end trace 4a8142d4a08c2518 ]---
[  112.798320] RIP: 0010:sg_next+0x0/0x20
[  112.798865] Code: cc cc cc cc cc cc cc cc cc cc c7 47 10 00 00 00 00 89 57 0c 48 89 37 89 4f 08 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <f6> 07 02 75 17 48 8b 57 20 48 8d 47 20 48 89 d1 48 83 e1 fc 83 e2
[  112.801452] RSP: 0018:ffffa92440237d90 EFLAGS: 00010006
[  112.802189] RAX: fefefefe00000000 RBX: 000000000000000a RCX: fefefefe00000000
[  112.803190] RDX: 0000000000000001 RSI: ffff9b19da1a2180 RDI: fefefefe00000000
[  112.804192] RBP: ffff9b19da1a2198 R08: ffff9b19dfb24ee8 R09: 0000000000000a20
[  112.805201] R10: ffff9b19da125010 R11: 0000000000000000 R12: ffff9b19da1a21b8
[  112.806195] R13: 0000000000000003 R14: ffff9b19da1a2180 R15: 0000000000000004
[  112.807222] FS:  0000000000000000(0000) GS:ffff9b19de400000(0000) knlGS:0000000000000000
[  112.808352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  112.809169] CR2: 00007f18a157b050 CR3: 000000001040a004 CR4: 0000000000060ef0

I have tested also 5.4.14 
and I got random freeze with:
qemu-system-x86_64: virtio: zero sized buffers are not allowed

Regards
