From: Emil Karlson <jekarlson@gmail.com>
Subject: encrypt_done called from interrupt context on rk3288 crypto driver
Date: Thu, 25 May 2017 22:38:13 +0300
Message-ID: <CAELSAVav4OQD1eTqtOey8_oZQPCBieO-HQQg1CaC23VmfD4KWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Zain Wang <zain.wang@rock-chips.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33321 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdEYTiO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 15:38:14 -0400
Received: by mail-qt0-f178.google.com with SMTP id t26so189004450qtg.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 May 2017 12:38:14 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Greetings

It seems to me that rk3288 crypto driver calls encrypt_done from
interrupt context which causes runtime tests to fail.

This regression is probably introduced with patch:
crypto: xts - Convert to skcipher by Herbert Xu <herbert@gondor.apana.org.au>
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/crypto/xts.c?h=v4.12-rc2&id=f1c131b45410a202eb45cc55980a7a9e4e4b4f40

[   18.912744] random: crng init done
[   26.085491] ------------[ cut here ]------------
[   26.087764] WARNING: CPU: 0 PID: 176 at crypto/skcipher.c:431
skcipher_walk_first+0x5c/0x14c
[   26.090045] Modules linked in:
[   26.092284] CPU: 0 PID: 176 Comm: cryptomgr_test Not tainted 4.12.0-rc2 #2
[   26.094546] Hardware name: Rockchip (Device Tree)
[   26.096799] [<8022f9d4>] (unwind_backtrace) from [<8022aeec>]
(show_stack+0x20/0x24)
[   26.099069] [<8022aeec>] (show_stack) from [<8060fc14>]
(dump_stack+0x88/0xa4)
[   26.101339] [<8060fc14>] (dump_stack) from [<80244f2c>] (__warn+0xf0/0x110)
[   26.103598] [<80244f2c>] (__warn) from [<80244ff0>]
(warn_slowpath_null+0x30/0x38)
[   26.105819] [<80244ff0>] (warn_slowpath_null) from [<805c3264>]
(skcipher_walk_first+0x5c/0x14c)
[   26.108054] [<805c3264>] (skcipher_walk_first) from [<805c341c>]
(skcipher_walk_skcipher+0xc8/0xcc)
[   26.110310] [<805c341c>] (skcipher_walk_skcipher) from [<805c365c>]
(skcipher_walk_virt+0x2c/0x48)
[   26.112593] [<805c365c>] (skcipher_walk_virt) from [<805cece4>]
(post_crypt+0x44/0x1cc)
[   26.114898] [<805cece4>] (post_crypt) from [<805cf33c>]
(encrypt_done+0x5c/0x7c)
[   26.117204] [<805cf33c>] (encrypt_done) from [<80874d40>]
(rk_crypto_complete+0x28/0x2c)
[   26.119544] [<80874d40>] (rk_crypto_complete) from [<80875044>]
(rk_ablk_rx+0x80/0x128)
[   26.121899] [<80875044>] (rk_ablk_rx) from [<80874358>]
(rk_crypto_irq_handle+0x68/0x94)
[   26.124294] [<80874358>] (rk_crypto_irq_handle) from [<8029838c>]
(__handle_irq_event_percpu+0x54/0x218)
[   26.126714] [<8029838c>] (__handle_irq_event_percpu) from
[<80298588>] (handle_irq_event_percpu+0x38/0x8c)
[   26.129152] [<80298588>] (handle_irq_event_percpu) from
[<80298630>] (handle_irq_event+0x54/0x78)
[   26.131601] [<80298630>] (handle_irq_event) from [<8029c3a0>]
(handle_fasteoi_irq+0xbc/0x140)
[   26.134096] [<8029c3a0>] (handle_fasteoi_irq) from [<80297afc>]
(generic_handle_irq+0x28/0x38)
[   26.136575] [<80297afc>] (generic_handle_irq) from [<80297bbc>]
(__handle_domain_irq+0xb0/0xc4)
[   26.139029] [<80297bbc>] (__handle_domain_irq) from [<80201584>]
(gic_handle_irq+0x58/0x84)
[   26.141497] [<80201584>] (gic_handle_irq) from [<80a73e78>]
(__irq_svc+0x58/0x74)
[   26.143955] Exception stack(0x821bdaa0 to 0x821bdae8)
[   26.146386] daa0: ed13ab80 00000000 6cafb000 000044fb ed13ab80
82106400 810c12c0 8204de40
[   26.148869] dac0: edbbc2c0 6cafb000 80a6d804 821bdb34 821bdb38
821bdaf0 80a6d804 8026c3e8
[   26.151359] dae0: 60080013 ffffffff
[   26.153842] [<80a73e78>] (__irq_svc) from [<8026c3e8>]
(finish_task_switch+0xf4/0x2b4)
^[[?1;2c[   26.156355] [<8026c3e8>] (finish_task_switch) from
[<80a6d804>] (__schedule+0x5f4/0x974)
[   26.158899] [<80a6d804>] (__schedule) from [<80a6dc64>]
(preempt_schedule_common+0x20/0x30)
[   26.161452] [<80a6dc64>] (preempt_schedule_common) from
[<80a6dcb4>] (_cond_resched+0x40/0x48)
[   26.164031] [<80a6dcb4>] (_cond_resched) from [<80a6e8bc>]
(wait_for_common+0x38/0x1a8)
[   26.166656] [<80a6e8bc>] (wait_for_common) from [<80a6ea4c>]
(wait_for_completion+0x20/0x24)
[   26.169243] [<80a6ea4c>] (wait_for_completion) from [<805c6fa0>]
(__test_skcipher+0x314/0x8a8)
[   26.171784] [<805c6fa0>] (__test_skcipher) from [<805c99a0>]
(test_skcipher+0x38/0xc4)
[   26.174299] [<805c99a0>] (test_skcipher) from [<805c9ac0>]
(alg_test_skcipher+0x94/0xb0)
^[[?1;2c^[[?1;2c[   26.176809] [<805c9ac0>] (alg_test_skcipher) from
[<805ca740>] (alg_test+0x240/0x2e0)^[[?1;2c
[   26.179325] [<805ca740>] (alg_test) from [<805c6458>]
(cryptomgr_test+0x34/0x54)
[   26.181841] [<805c6458>] (cryptomgr_test) from [<802641c8>]
(kthread+0x154/0x16c)
[   26.184359] [<802641c8>] (kthread) from [<80226e08>]
(ret_from_fork+0x14/0x2c)
[   26.186866] ---[ end trace 3311d538cc9cc0a4 ]---
[   26.189429] alg: skcipher: encryption failed on test 1 for
xts(ecb-aes-rk): ret=35
[   26.192050] device-mapper: table: 253:0: crypt: Error allocating crypto tfm
[   26.194682] device-mapper: ioctl: error adding target to table

Best Regards
-Emil
