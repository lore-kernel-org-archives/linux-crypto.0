Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8E0C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Mar 2023 14:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjCIOzd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Mar 2023 09:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjCIOy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2023 09:54:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDD1F5ABA
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2023 06:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678373492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=P5xqb/NYFNxAiSb3FHtvnScfSqKj4ozeuOnF35KZ8RI=;
        b=KstGP/zpc3ht5AFbX1SM1wckuQk5n7dONw2f1QUHUaVFmApsbBTPHvIO5vERxjk6FJ6WI2
        O08f57qEo9cb5UtvSwWN9u3E9pnY3sSYIcarcrxyOcXEqJ3V49wJIXFDWsks9kkpj4J7c6
        WrIVFfgGVjybxBxJRI/bn9F+7sVUHag=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-OdX8TcrtPjGABkZv5NrJSw-1; Thu, 09 Mar 2023 09:51:30 -0500
X-MC-Unique: OdX8TcrtPjGABkZv5NrJSw-1
Received: by mail-ed1-f69.google.com with SMTP id ev6-20020a056402540600b004bc2358ac04so3277284edb.21
        for <linux-crypto@vger.kernel.org>; Thu, 09 Mar 2023 06:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373486;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P5xqb/NYFNxAiSb3FHtvnScfSqKj4ozeuOnF35KZ8RI=;
        b=6yIeqC5kQCPtDxKCyWyE4v8tm2uYn4zazLuObsYAkwihaXBisOce+ly8h7iIfbb2M+
         zQr/SBrCHFcEUQWScWZnxDdFp8kOG+uTuK9y0IW/1Jn+ML2sDxfBpJgeVWqZfkTf1Z91
         slZeNcp4cGTTr1qjzgRuVM8U6HXKTJ0VrmcgdywXP6ykRDUWn0VyypASPZngmx48NQco
         H7xsB3yKjS2yqe/cl0YKKpnVbCl7nx+KwuVp8xZp1J5xocMa/Yr4fcNqHSbLK4SLUWQz
         CzenMAw8LOGqL+180G32/psFTNTku08bMYTwI1it/YTl6xY51JCe4GAXsZzkuLad29gI
         eFxg==
X-Gm-Message-State: AO0yUKUt+cvPoz7ma8HJuzzl5u9DYVNDYkeetEHZ6OgxIu23k9w2Aacu
        QfP5zUABt8JXg2mnpOdeBcX0SRS1+JYITfJhJQk60W8qlPmYrCslGgXxs+ICEJOJ43kyxYhg5I0
        m4HUEUvZW3du82FiyT1QxCt/u
X-Received: by 2002:a17:907:c292:b0:8b1:7569:b51a with SMTP id tk18-20020a170907c29200b008b17569b51amr4785211ejc.53.1678373485830;
        Thu, 09 Mar 2023 06:51:25 -0800 (PST)
X-Google-Smtp-Source: AK7set+QabQAhsovggRRlc50Xs6dK/Ek640VXv+t+q50MhjFByVXPhhIeSGF99fjkuC+jkaJXkxhKw==
X-Received: by 2002:a17:907:c292:b0:8b1:7569:b51a with SMTP id tk18-20020a170907c29200b008b17569b51amr4785156ejc.53.1678373484763;
        Thu, 09 Mar 2023 06:51:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id lt21-20020a170906fa9500b008e267d7ec18sm8927715ejb.50.2023.03.09.06.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:51:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 303C39E25B4; Thu,  9 Mar 2023 15:51:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathew McBride <matt@traverse.com.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Hitting BUG_ON in crypto_unregister_alg() on reboot with
 caamalg_qi2 driver
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Mar 2023 15:51:22 +0100
Message-ID: <87r0tyq8ph.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi folks

I'm hitting what appears to be a deliberate BUG_ON() in
crypto_unregister_alg() when rebooting my traverse ten64 device on a
6.2.2 kernel (using the Arch linux-aarch64 build, which is basically an
upstream kernel).

Any idea what might be causing this? It does not appear on an older
(5.17, which is the newest kernel that works reliably, for unrelated
reasons).

-Toke

[  188.329145] kernel BUG at crypto/algapi.c:496!
[  188.333588] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[  188.340378] Modules linked in: 8021q garp mrp tun bridge stp llc wireguard libchacha20poly1305 ip6_udp_tunnel udp_tunnel libcurve25519_generic cfg80211 rfkill nft_nat nft_chain_nat nf_nat nft_reject_inet nf_reject_ipv6 nft_reject nft_limit nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink caam_jr dpaa2_caam caamhash_desc caamalg_desc authenc libdes fsl_dpaa2_eth pcs_lynx phylink caam error xgmac_mdio sp805_wdt qoriq_cpufreq rtc_fsl_ftm_alarm dpaa2_console pci_endpoint_test loop fuse gpio_keys
[  188.385875] CPU: 0 PID: 1 Comm: shutdown Tainted: G        W          6.2.2-1-aarch64-ARCH #1
[  188.394404] Hardware name: traverse ten64/ten64, BIOS 2020.07-rc1-g488778dc 11/22/2021
[  188.402324] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  188.409289] pc : crypto_unregister_alg+0x104/0x110
[  188.414087] lr : crypto_unregister_alg+0x94/0x110
[  188.418793] sp : ffff80000aa2b740
[  188.422104] x29: ffff80000aa2b740 x28: ffff008000252dc0 x27: 0000000000000000
[  188.429248] x26: 0000000000000000 x25: ffff80000156a700 x24: dead000000000100
[  188.436390] x23: dead000000000122 x22: ffff008024517800 x21: ffff80000aa2b778
[  188.443533] x20: ffff80000a5866b0 x19: ffff008004772980 x18: ffffffffffffffff
[  188.450676] x17: 7270642f636d2d6c x16: 73662e3030303030 x15: ffffffffffffffff
[  188.457818] x14: 0000000000000004 x13: ffff008000165b10 x12: 0000000000000000
[  188.464960] x11: ffff008002027700 x10: ffff0080020276c0 x9 : ffff008000165b10
[  188.472104] x8 : ffff80000aa2b5f8 x7 : 0000000000000000 x6 : 0000000000000000
[  188.479245] x5 : 0000000000200017 x4 : ffff008004772980 x3 : ffff80000aa2b728
[  188.486387] x2 : 0000000000000001 x1 : ffff008000252dc0 x0 : 0000000000000002
[  188.493530] Call trace:
[  188.495971]  crypto_unregister_alg+0x104/0x110
[  188.500417]  crypto_unregister_ahash+0x14/0x20
[  188.504863]  dpaa2_caam_remove+0xec/0x234 [dpaa2_caam]
[  188.510015]  fsl_mc_driver_remove+0x24/0x60
[  188.514198]  device_remove+0x70/0x80
[  188.517776]  device_release_driver_internal+0x1e4/0x250
[  188.523004]  device_links_unbind_consumers+0xd8/0x100
[  188.528057]  device_release_driver_internal+0xe4/0x250
[  188.533197]  device_links_unbind_consumers+0xd8/0x100
[  188.538249]  device_release_driver_internal+0x12c/0x250
[  188.543477]  device_release_driver+0x18/0x24
[  188.547748]  bus_remove_device+0xd0/0x15c
[  188.551759]  device_del+0x174/0x3a0
[  188.555246]  fsl_mc_device_remove+0x28/0x40
[  188.559429]  __fsl_mc_device_remove+0x10/0x20
[  188.563785]  device_for_each_child+0x5c/0xac
[  188.568054]  dprc_remove+0x94/0xbc
[  188.571455]  fsl_mc_driver_remove+0x24/0x60
[  188.575637]  device_remove+0x70/0x80
[  188.579213]  device_release_driver_internal+0x1e4/0x250
[  188.584440]  device_release_driver+0x18/0x24
[  188.588711]  bus_remove_device+0xd0/0x15c
[  188.592721]  device_del+0x174/0x3a0
[  188.596210]  fsl_mc_bus_remove+0x88/0x100
[  188.600218]  fsl_mc_bus_shutdown+0x10/0x20
[  188.604314]  platform_shutdown+0x24/0x34
[  188.608235]  device_shutdown+0x11c/0x220
[  188.612158]  kernel_restart+0x40/0xac
[  188.615821]  __do_sys_reboot+0x1e0/0x264
[  188.619743]  __arm64_sys_reboot+0x24/0x30
[  188.623753]  invoke_syscall+0x48/0x11c
[  188.627505]  el0_svc_common.constprop.0+0x44/0xf0
[  188.632211]  do_el0_svc+0x2c/0x40
[  188.635526]  el0_svc+0x2c/0x84
[  188.638581]  el0t_64_sync_handler+0xf4/0x120
[  188.642852]  el0t_64_sync+0x190/0x194
[  188.646517] Code: 9129c000 942f316c d4210000 17ffffee (d4210000) 
[  188.652613] ---[ end trace 0000000000000000 ]---
   

