Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6198C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 569252067B
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 08:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=temperror (0-bit key) header.d=lancastr.com header.i=@lancastr.com header.b="MtPulnSL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfJMItW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 04:49:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35011 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbfJMItW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 04:49:22 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so13709145lji.2
        for <linux-crypto@vger.kernel.org>; Sun, 13 Oct 2019 01:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lancastr.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=Gobp3CWacqsshKDYawRrpunCLvmL9MMq4DCvSNwewAE=;
        b=MtPulnSLG2gt7oodDTtW1KteTStsp/Wb0OBm/9uTPpiMQzWR0q6c29KQzVIWsD+1kV
         TYzB5yq2hs/q4gigec3pLn5AdaNs8s2BSn0SkincboNOf9Yth1DbpIE5/UivwQLZ81on
         k1VdTGPTZqUWNWT2wCxY9ZZxRe4SFwzsSOHcWwK8P3hna0vRMLXIvc5s6fAqLo+NRNxz
         /F1jSq4eAMZ9omuGLAAbOpo5+KJg3+21e1MxLjbO7TXdv/IoRiV8nMylnK9HaJeD+Cmo
         tOdU3O3Q36MaohiaGIRWjKBQaTMLKMnotZ4JjjPJZOBTSaPC1jTS8KUI/uYuce2qAHYq
         gjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Gobp3CWacqsshKDYawRrpunCLvmL9MMq4DCvSNwewAE=;
        b=lEdctPXQ87PPbhUqUvE0Sf52Y17546eV62kPu+bGioIGCDvFH3Ecp0hhuIi1W02w+n
         CVZf7bVEzjoOHiolvb7VnsibK9IXZ0Ds396kyCfVC7Vscq5pOW2gRPy3ZgQHlkdhN64c
         FLlZwzG228aNsEMKx+t+iWb/pLnwE0u23E7hCppNBzo+Mjz3gobWDSBszVfB2M1jcSfG
         j/tMHs89VFDBfu6Oc3J/1wWtd0YBuopKF6G5vC1IIh54T8PluzEiQeefifrxbLFZbrFv
         6oP8DsEzZIMAP4UQgKpqD9mNylMkcvP0Wa9Ox/cMKkv3IIH/ARujfgpT86A4Jfgok0WC
         FTUw==
X-Gm-Message-State: APjAAAVy0VoyixtgOIDrBqpFmv92/zk/my+t31l6fIFB3cLVYA8cx1Vt
        RY9VEuCAr3o68HAkKQ2bo87qJ8Z+DK+mAehg4hhH4udwoOs=
X-Google-Smtp-Source: APXvYqyoLHlgdIAiidivsl/cpbbnOlUxZSdd1SgpnfKNQ3c0Vb+I6Jqwy1rYimQ00M236sO82XrRL7PBy2vtMW/q2ZM=
X-Received: by 2002:a2e:957:: with SMTP id 84mr14582777ljj.245.1570956558498;
 Sun, 13 Oct 2019 01:49:18 -0700 (PDT)
MIME-Version: 1.0
From:   Gleb Pomykalov <gleb@lancastr.com>
Date:   Sun, 13 Oct 2019 11:49:07 +0300
Message-ID: <CALbZx5WSonqQTuPSLDpDkdCfyj76Fht5EXtN2gF9H5=_qeA9rg@mail.gmail.com>
Subject: EIP97 kernel failure with af_alg/libaio
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

I'm trying to make EIP97 work on Mediatek mtk7623n (Banana PI R2). The
kernel version is 4.14.145. My tests uses af_alg in libaio mode, and
encrypts the data. For smaller blocks it works just fine, but if I
increase the size I'm getting the kernel error (it fails on 8k block
and larger, 4k works fine):

[   38.978165] ------------[ cut here ]------------
[   38.982765] WARNING: CPU: 2 PID: 0 at lib/percpu-refcount.c:155
percpu_ref_switch_to_atomic_rcu+0xc8/0x19c
[   38.992361] percpu ref (free_ioctx_reqs) <= 0 (0) after switching to atomic
[   38.992365] Modules linked in: pppoe ppp_async pppox ppp_generic
nf_conntrack_ipv6 mt76x2e mt76x2_common mt76x02_lib mt7603e mt76
mac80211 iptable_nat ipt_REJECT ipt_MASQUERADE cfg80211 xt_time
xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit
xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD
slhc nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack iptable_mangle iptable_filter ip_tables crc_ccitt compat
cryptodev ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables x_tables tun algif_skcipher
algif_hash af_alg ghash_generic gf128mul gcm authenc leds_gpio
gpio_button_hotplug tpm_tis
[   39.069577]  tpm_tis_core tpm
[   39.072534] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.14.131 #0
[   39.078573] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   39.084112] [<c010e99c>] (unwind_backtrace) from [<c010aa78>]
(show_stack+0x10/0x14)
[   39.091797] [<c010aa78>] (show_stack) from [<c053649c>]
(dump_stack+0x78/0x8c)
[   39.098964] [<c053649c>] (dump_stack) from [<c0116f00>] (__warn+0xe4/0x100)
[   39.105871] [<c0116f00>] (__warn) from [<c0116f54>]
(warn_slowpath_fmt+0x38/0x48)
[   39.113293] [<c0116f54>] (warn_slowpath_fmt) from [<c02d7740>]
(percpu_ref_switch_to_atomic_rcu+0xc8/0x19c)
[   39.122959] [<c02d7740>] (percpu_ref_switch_to_atomic_rcu) from
[<c0163624>] (rcu_process_callbacks+0x308/0x48c)
[   39.133053] [<c0163624>] (rcu_process_callbacks) from [<c010155c>]
(__do_softirq+0xe4/0x250)
[   39.141423] [<c010155c>] (__do_softirq) from [<c011ba90>]
(irq_exit+0xac/0xf4)
[   39.148588] [<c011ba90>] (irq_exit) from [<c01558f0>]
(__handle_domain_irq+0xbc/0xe4)
[   39.156355] [<c01558f0>] (__handle_domain_irq) from [<c0101440>]
(gic_handle_irq+0x5c/0x90)
[   39.164638] [<c0101440>] (gic_handle_irq) from [<c010b64c>]
(__irq_svc+0x6c/0xa8)
[   39.172056] Exception stack(0xef073f88 to 0xef073fd0)
[   39.177065] 3f80:                   00000002 c06bfd0c 2d9ef000
c0113be0 ffffe000 c1e03c74
[   39.185175] 3fa0: c1e03c28 c1e2ac90 8000406a 410fc073 00000000
00000000 00000e24 ef073fd8
[   39.193283] 3fc0: c01081a8 c01081ac 60000013 ffffffff
[   39.198294] [<c010b64c>] (__irq_svc) from [<c01081ac>]
(arch_cpu_idle+0x34/0x38)
[   39.205631] [<c01081ac>] (arch_cpu_idle) from [<c014ac98>]
(do_idle+0xa8/0x11c)
[   39.212881] [<c014ac98>] (do_idle) from [<c014af90>]
(cpu_startup_entry+0x18/0x1c)
[   39.220389] [<c014af90>] (cpu_startup_entry) from [<8010176c>] (0x8010176c)
[   39.227307] ---[ end trace 9954b743e1ffbf50 ]---
[   53.380247] Unable to handle kernel NULL pointer dereference at
virtual address 00000009
[   53.388298] pgd = c143c000
[   53.390978] [00000009] *pgd=81b20835, *pte=00000000, *ppte=00000000
[   53.397199] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[   53.402549] Modules linked in: pppoe ppp_async pppox ppp_generic
nf_conntrack_ipv6 mt76x2e mt76x2_common mt76x02_lib mt7603e mt76
mac80211 iptable_nat ipt_REJECT ipt_MASQUERADE cfg80211 xt_time
xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit
xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_FLOWOFFLOAD
slhc nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_flow_table_hw
nf_flow_table nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack iptable_mangle iptable_filter ip_tables crc_ccitt compat
cryptodev ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables x_tables tun algif_skcipher
algif_hash af_alg ghash_generic gf128mul gcm authenc leds_gpio
gpio_button_hotplug tpm_tis
[   53.472823]  tpm_tis_core tpm
[   53.475768] CPU: 2 PID: 1127 Comm: sh Tainted: G        W       4.14.131 #0
[   53.482668] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   53.488190] task: c191b480 task.stack: c1ad0000
[   53.492685] PC is at kmem_cache_alloc+0x118/0x154
[   53.497345] LR is at 0x2016
[   53.500110] pc : [<c01ddacc>]    lr : [<00002016>]    psr: 20000013
[   53.506321] sp : c1ad1ea0  ip : 2d9ef000  fp : 00000000
[   53.511499] r10: 00000000  r9 : 0000201a  r8 : c193fb00
[   53.516676] r7 : ffffe000  r6 : c0134538  r5 : 014000c0  r4 : ef001d80
[   53.523146] r3 : 00000000  r2 : ef7d0504  r1 : a0000013  r0 : 00000009
[   53.529618] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   53.536692] Control: 10c5387d  Table: 8143c06a  DAC: 00000051
[   53.542387] Process sh (pid: 1127, stack limit = 0xc1ad0218)
[   53.547996] Stack: (0xc1ad1ea0 to 0xc1ad2000)
[   53.552317] 1ea0: 00000011 c191b480 c1e2ad90 00000000 00000000
c191b480 00000000 c0134538
[   53.560427] 1ec0: 00000011 c1bdf380 c1e2ad90 c0134a3c c1bdf380
00000011 c1e2ad90 c0114e38
[   53.568537] 1ee0: c193fb00 c1e0e718 c06041bc 00000000 00000000
ffffe000 c1ad1f38 c01e5a7c
[   53.576648] 1f00: 00000020 c054efb8 eef95d90 00000001 c1ad1f40
00000001 c06041bc c01e5b68
[   53.584758] 1f20: eef95d90 c1b930c0 c1900140 c1900100 00000005
00000011 00000000 00000002
[   53.592868] 1f40: 00000000 00000000 c1ad0000 00000002 00000000
c01161c8 00000000 00000000
[   53.600979] 1f60: ffffffff b6f1eacc 00000051 bed0da10 00000008
00000000 0154be60 bed0da10
[   53.609089] 1f80: 00000002 00000002 c01079e4 c1ad0000 00000002
c01164e8 00000000 00000000
[   53.617199] 1fa0: c01079e4 c01077e0 0154be60 bed0da10 00000000
b6f1eacc bed0da10 00000008
[   53.625309] 1fc0: 0154be60 bed0da10 00000002 00000002 00080844
00000001 00000000 00000000
[   53.633419] 1fe0: 0007fc64 bed0da10 b6efab90 b6efab94 60000010
00000000 00000000 00000000
[   53.641541] [<c01ddacc>] (kmem_cache_alloc) from [<c0134538>]
(prepare_creds+0x2c/0x88)
[   53.649482] [<c0134538>] (prepare_creds) from [<c0134a3c>]
(copy_creds+0x80/0x11c)
[   53.656993] [<c0134a3c>] (copy_creds) from [<c0114e38>]
(copy_process.part.3+0x260/0x1494)
[   53.665191] [<c0114e38>] (copy_process.part.3) from [<c01161c8>]
(_do_fork+0xbc/0x364)
[   53.673043] [<c01161c8>] (_do_fork) from [<c01164e8>] (sys_fork+0x24/0x2c)
[   53.679864] [<c01164e8>] (sys_fork) from [<c01077e0>]
(ret_fast_syscall+0x0/0x54)
[   53.687285] Code: ea00000d e121f001 eaffffc4 e5943014 (e7903003)
[   53.693387] ---[ end trace 9954b743e1ffbf51 ]---
[   53.697967] Kernel panic - not syncing: Fatal exception
[   53.703152] CPU1: stopping
[   53.705836] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W
4.14.131 #0
[   53.713081] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   53.718616] [<c010e99c>] (unwind_backtrace) from [<c010aa78>]
(show_stack+0x10/0x14)
[   53.726301] [<c010aa78>] (show_stack) from [<c053649c>]
(dump_stack+0x78/0x8c)
[   53.733466] [<c053649c>] (dump_stack) from [<c010d998>]
(handle_IPI+0xf4/0x1ac)
[   53.740715] [<c010d998>] (handle_IPI) from [<c0101470>]
(gic_handle_irq+0x8c/0x90)
[   53.748222] [<c0101470>] (gic_handle_irq) from [<c010b64c>]
(__irq_svc+0x6c/0xa8)
[   53.755639] Exception stack(0xef071f88 to 0xef071fd0)
[   53.760648] 1f80:                   00000001 c06bfd0c 2d9e0000
c0113be0 ffffe000 c1e03c74
[   53.768758] 1fa0: c1e03c28 c1e2ac90 8000406a 410fc073 00000000
00000000 00001142 ef071fd8
[   53.776866] 1fc0: c01081a8 c01081ac 60000013 ffffffff
[   53.781875] [<c010b64c>] (__irq_svc) from [<c01081ac>]
(arch_cpu_idle+0x34/0x38)
[   53.789214] [<c01081ac>] (arch_cpu_idle) from [<c014ac98>]
(do_idle+0xa8/0x11c)
[   53.796464] [<c014ac98>] (do_idle) from [<c014af90>]
(cpu_startup_entry+0x18/0x1c)
[   53.803971] [<c014af90>] (cpu_startup_entry) from [<8010176c>] (0x8010176c)
[   53.810873] CPU0: stopping
[   53.813556] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W
4.14.131 #0
[   53.820801] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   53.826330] [<c010e99c>] (unwind_backtrace) from [<c010aa78>]
(show_stack+0x10/0x14)
[   53.834012] [<c010aa78>] (show_stack) from [<c053649c>]
(dump_stack+0x78/0x8c)
[   53.841175] [<c053649c>] (dump_stack) from [<c010d998>]
(handle_IPI+0xf4/0x1ac)
[   53.848424] [<c010d998>] (handle_IPI) from [<c0101470>]
(gic_handle_irq+0x8c/0x90)
[   53.855930] [<c0101470>] (gic_handle_irq) from [<c010b64c>]
(__irq_svc+0x6c/0xa8)
[   53.863348] Exception stack(0xc1e01f48 to 0xc1e01f90)
[   53.868356] 1f40:                   00000000 c06bfd0c 2d9d1000
c0113be0 ffffe000 c1e03c74
[   53.876466] 1f60: c1e03c28 c1e03c00 c1e2a9c0 00000001 efffce00
c0823a28 00001182 c1e01f98
[   53.884574] 1f80: c01081a8 c01081ac 60000013 ffffffff
[   53.889584] [<c010b64c>] (__irq_svc) from [<c01081ac>]
(arch_cpu_idle+0x34/0x38)
[   53.896919] [<c01081ac>] (arch_cpu_idle) from [<c014ac98>]
(do_idle+0xa8/0x11c)
[   53.904168] [<c014ac98>] (do_idle) from [<c014af90>]
(cpu_startup_entry+0x18/0x1c)
[   53.911677] [<c014af90>] (cpu_startup_entry) from [<c0800c88>]
(start_kernel+0x3c0/0x3cc)
[   53.919785] CPU3: stopping
[   53.922469] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D W
4.14.131 #0
[   53.929714] Hardware name: Mediatek Cortex-A7 (Device Tree)
[   53.935242] [<c010e99c>] (unwind_backtrace) from [<c010aa78>]
(show_stack+0x10/0x14)
[   53.942923] [<c010aa78>] (show_stack) from [<c053649c>]
(dump_stack+0x78/0x8c)
[   53.950087] [<c053649c>] (dump_stack) from [<c010d998>]
(handle_IPI+0xf4/0x1ac)
[   53.957336] [<c010d998>] (handle_IPI) from [<c0101470>]
(gic_handle_irq+0x8c/0x90)
[   53.964843] [<c0101470>] (gic_handle_irq) from [<c010b64c>]
(__irq_svc+0x6c/0xa8)
[   53.972261] Exception stack(0xef075f88 to 0xef075fd0)
[   53.977269] 5f80:                   00000003 c06bfd0c 2d9fe000
c0113be0 ffffe000 c1e03c74
[   53.985379] 5fa0: c1e03c28 c1e2ac90 8000406a 410fc073 00000000
00000000 00000003 ef075fd8
[   53.993488] 5fc0: c01081a8 c01081ac 60000013 ffffffff
[   53.998497] [<c010b64c>] (__irq_svc) from [<c01081ac>]
(arch_cpu_idle+0x34/0x38)
[   54.005833] [<c01081ac>] (arch_cpu_idle) from [<c014ac98>]
(do_idle+0xa8/0x11c)
[   54.013082] [<c014ac98>] (do_idle) from [<c014af90>]
(cpu_startup_entry+0x18/0x1c)
[   54.020589] [<c014af90>] (cpu_startup_entry) from [<8010176c>] (0x8010176c)

I use openwrt fork for Banana PI R2, it is available here:
https://github.com/lancastr/openwrt/commits/bananapi-r2-with-eip97-and-letstrust

Appreciate,
Gleb Pomykalov
