From: Romain Izard <romain.izard.pro@gmail.com>
Subject: "BUG: scheduling while atomic" in atmel-aes on Linux v4.14-rc6
Date: Wed, 25 Oct 2017 17:26:31 +0200
Message-ID: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:55991 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdJYP0x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2017 11:26:53 -0400
Received: by mail-qk0-f182.google.com with SMTP id x82so465323qkb.12
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2017 08:26:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

While running the kcapi test suite on a SAMA5D2 Xplained board with a
v4.14-rc6 kernel, I encountered the following error:

# kcapi -x 9 -e -c "cbc(aes)" -i 00000000000000000000000000000000 -k 00000000000
0000000000000000000000000000000000000 -p 1b077a6af4b7f98229de786d7516b639
BUG: scheduling while atomic: kcapi/926/0x00000100
CPU: 0 PID: 926 Comm: kcapi Not tainted 4.14.0-rc6 #2
Hardware name: Atmel SAMA5
[<c010caac>] (unwind_backtrace) from [<c010a9d8>] (show_stack+0x10/0x14)
[<c010a9d8>] (show_stack) from [<c013a914>] (__schedule_bug+0x60/0x80)
[<c013a914>] (__schedule_bug) from [<c074ac70>] (__schedule+0x368/0x3fc)
[<c074ac70>] (__schedule) from [<c074ad74>] (schedule+0x40/0xa0)
[<c074ad74>] (schedule) from [<c05cb96c>] (__lock_sock+0x78/0xb0)
[<c05cb96c>] (__lock_sock) from [<c05cddd0>] (lock_sock_nested+0x48/0x50)
[<c05cddd0>] (lock_sock_nested) from [<c030eec8>] (af_alg_async_cb+0x20/0x80)
[<c030eec8>] (af_alg_async_cb) from [<c0573b70>]
(atmel_aes_transfer_complete+0x38/0x68)
[<c0573b70>] (atmel_aes_transfer_complete) from [<c0121258>]
(tasklet_action+0x68/0xb4)
[<c0121258>] (tasklet_action) from [<c010158c>] (__do_softirq+0xc4/0x250)
[<c010158c>] (__do_softirq) from [<c01215f0>] (irq_exit+0xfc/0x130)
[<c01215f0>] (irq_exit) from [<c014a208>] (__handle_domain_irq+0x58/0xa8)
[<c014a208>] (__handle_domain_irq) from [<c010b60c>] (__irq_svc+0x6c/0x90)
[<c010b60c>] (__irq_svc) from [<c0310280>] (skcipher_recvmsg+0x2d8/0x318)
[<c0310280>] (skcipher_recvmsg) from [<c05c8794>] (sock_read_iter+0x88/0xc8)
[<c05c8794>] (sock_read_iter) from [<c01f1940>]
(aio_read.constprop.3+0xcc/0x178)
[<c01f1940>] (aio_read.constprop.3) from [<c01f2968>]
(SyS_io_submit+0x540/0x644)
[<c01f2968>] (SyS_io_submit) from [<c0107480>] (ret_fast_syscall+0x0/0x48)

After bisecting, I determined that it appeared during the 4.14 merge
window, with the following commit:

e870456d8e7c crypto: algif_skcipher - overhaul memory management


Best regards,
-- 
Romain Izard
