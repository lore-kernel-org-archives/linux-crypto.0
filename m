From: SviMik <svimik@gmail.com>
Subject: invalid opcode: 0000 [#1] SMP [aesni_intel]
Date: Mon, 23 Oct 2017 19:01:32 +0300
Message-ID: <CA++DawbkD6nioFR70ph1J26erZAwt74egm-pPDXJEHNt-QDAGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:53230 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdJWQBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 12:01:33 -0400
Received: by mail-ua0-f175.google.com with SMTP id i35so13263025uah.9
        for <linux-crypto@vger.kernel.org>; Mon, 23 Oct 2017 09:01:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

Got the following kernel panic:

invalid opcode: 0000 [#1] SMP
CPU: 0 PID: 1449 Comm: openvpn Not tainted 4.8.13-1.el6.elrepo.x86_64 #1
----cut----
Call Trace:
<IRQ>
[<ffffffff810be15e>] ? enqueue_entity+0x45e/0x6f0
[<ffffffffa0104f25>] ? aesni_gcm_enc_avx+0x95/0xd0 [aesni_intel]
[<ffffffffa0105417>] helper_rfc4106_encrypt+0x167/0x2f0 [aesni_intel]
[<ffffffffa0104bfb>] rfc4106_encrypt+0x5b/0x90 [aesni_intel]
----cut----

The detailed bug report with full oops dump can be found here:
https://bugzilla.kernel.org/show_bug.cgi?id=197363

Could not trigger this bug intentionally, but it happened three times
already (all three dumps are available).
