Return-Path: <SRS0=hbeB=QN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA19C169C4
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Feb 2019 16:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7D020811
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Feb 2019 16:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="pUSqOxoq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfBFQk3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:40:29 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:39883 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731219AbfBFQk2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Feb 2019 11:40:28 -0500
Received: by mail-vs1-f66.google.com with SMTP id e16so2488904vsq.6
        for <linux-crypto@vger.kernel.org>; Wed, 06 Feb 2019 08:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=CwNRmJ39BCMJhurs9kha3HnBJ2b+RnxmENgiWs10btI=;
        b=pUSqOxoqaqx4c8OhQ1UnXPcG3foe+KX7hU/crWhzG1vRCa0RaKbqLddENtOg7vs+jL
         uCCfXTplKtCE0eBtjYXyTIjxgmi8xePMHEVQAKFJD4ZPpAnk2V1wmXj6hihTjHBcRqz4
         c+gPNBUJUPG/YK2EH3RI8ssLNFA3fJdZYXWt+25W1Ds50Tt1TcKzE1ik8JGWvUo+IO0O
         WqJ8WQwD3Ff51AhkcaQiS0dzUH1gHEx433cGXWD53zVKUuSfsQOT+L7EgqcWuISc+3ty
         vErOL6/xHMjL+ccJlutpKpwpil84qtNrj+HXtsZhm2JVbsWaGbQEusUBGcUT1RvGrbn2
         YIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=CwNRmJ39BCMJhurs9kha3HnBJ2b+RnxmENgiWs10btI=;
        b=RAVTbqoEAnvlPGSuNnPO4Xj0GA8Z1gVeWnKI30m6HTu0kvHEmKm5fsJ1HDmhdU0zlA
         02O/Vla2/4dM4yEDNjLQ502QHIqvRBB6j2U3zMHJi/w2Wub3BBu8PoP0jZFq4Xt4I9AZ
         T3lC8eBsHrwVqBZRg3z2QNhnWT+oW2haTVGVdM0pYe4u4fBdeCsGb1wQi2Qa+lpMXg4R
         Un/Zzfr4bTw2zrO9jrB8UkNea0E1cSe6ZQeNe3DYGqH3ptdodP7CcypyDPIZzWP9j9tA
         NvYPSDmYtnl/mwetmTDLe6E7jMgUBCqOc85og22rjFmr13lwaq8VNb3dfcZJT932p7MP
         CDGg==
X-Gm-Message-State: AHQUAuYLCnX/FovgLY6vXjnzF9aZ2ZRp/arrV7dJwe0DrQc5Q0QojtNs
        Mxd4t/Y3Rh0D/c98yGZ3Ktq5FQZSKnPiCnzbeSPkH1jI3Dniwg==
X-Google-Smtp-Source: AHgI3Ib7G4Pjv1EF/+KDXuLpYWS0SNyZh/jUx82hW52+vzkRU7tHzj9/dEn8Pq8tKdO9aWvl1zZ+6T2TLhY6rftuczI=
X-Received: by 2002:a67:7657:: with SMTP id r84mr4681809vsc.117.1549471226968;
 Wed, 06 Feb 2019 08:40:26 -0800 (PST)
MIME-Version: 1.0
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 6 Feb 2019 18:40:16 +0200
Message-ID: <CAOtvUMd-38BL1jJnHQY0J68mmtxW1WBQF2qGqyNpWtwsrwUcYg@mail.gmail.com>
Subject: Regression due to "PM-runtime: Switch autosuspend over to using hrtimers"
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc:     Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

A regression was spotted in the ccree driver running on Arm 32 bit
causing a kernel panic during the crypto API self test phase (panic
messages included with this message) happening in the PM resume
callback that was not happening before.

I've bisected the change that caused this to commit 8234f6734c5d
("PM-runtime: Switch autosuspend over to using hrtimers").

I'm still trying to figure out what is going on inside the callback,
but as it was not happening before, I thought I'd give you a shout out
to make you aware of this.

Panic message follows. The specific panic is from the specific commit
(hence the 4.20.y version number) but of course the same thing happens
also for 5.0.x.

Thanks!
Gilad

[   10.770402] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   10.778547] pgd =3D (ptrval)
[   10.781256] [00000000] *pgd=3D00000000
[   10.784864] Internal error: Oops - BUG: 17 [#1] PREEMPT SMP ARM
[   10.790781] Modules linked in:
[   10.793838] CPU: 1 PID: 784 Comm: cryptomgr_test Not tainted
4.20.0-rc7-xilinx-00001-g8234f6734c5d-dirty #412
[   10.803756] Hardware name: Xilinx Zynq Platform
[   10.808298] PC is at cc_init_hash_sram+0x20/0x290
[   10.813006] LR is at cc_pm_resume+0x78/0xf0
[   10.817184] pc : [<c05ebd8c>]    lr : [<c05f18a8>]    psr: 60080113
[   10.823453] sp : ee54b898  ip : ee54ba50  fp : ef14a810
[   10.828676] r10: 00000000  r9 : ffffe000  r8 : c046527c
[   10.833903] r7 : ef14a68c  r6 : ee54ba40  r5 : ef0ce100  r4 : c3803c48
[   10.840431] r3 : 00000000  r2 : 00000000  r1 : 00041400  r0 : ef0ce100
[   10.846961] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 none
[   10.854095] Control: 18c5387d  Table: 2e45404a  DAC: 00000051
[   10.859839] Process cryptomgr_test (pid: 784, stack limit =3D 0x(ptrval)=
)
[   10.866454] Stack: (0xee54b898 to 0xee54c000)
[   10.870732] b880:
    c38442e8 ef0ce180
[   10.878981] b8a0: 00000040 c38442e8 c3803c48 c05e7368 00000000
00000000 c09428f8 00000040
[   10.887165] b8c0: ee54b900 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.895350] b8e0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.903535] b900: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.911720] b920: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.919905] b940: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.928091] b960: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.936276] b980: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   10.944462] b9a0: 00000200 0002e513 00000000 c3806e04 c38568c0
c01155c4 c011947c 00000000
[   10.952647] b9c0: 00000000 00000000 efdc2260 00000200 00000000
c08017b0 c0115474 00000001
[   10.960833] b9e0: 00000000 c0115610 c011947c c3803c48 ef0ce100
efdc2260 ef14a610 00000000
[   10.969017] ba00: 00000000 c011571c ee54bd3c ef14a610 00000000
c01160e8 00000000 00000000
[   10.977203] ba20: 00000000 ee54bd3c 00000010 ef14a610 c3803c48
c011602c ef0ce100 c05e1ce4
[   10.985388] ba40: 00000000 00000000 ef0ce100 ef14a610 ef14a68c
c046527c ffffe000 c3803c48
[   10.993573] ba60: ef14a810 c05f18a8 ef14a610 00000000 00000000
c04672d8 00000000 eeae9c40
[   11.001759] ba80: c3803c48 ef14a610 c046527c 00000000 c3802d00
c0153630 ffffe000 c3803c48
[   11.009944] baa0: ef14a810 c0467404 ef14a610 c046527c 00000000
c0466ee0 00000000 ef14a6b0
[   11.018129] bac0: 00000001 00000000 00000000 0000003c c38655ac
00041400 0000003c ef14a610
[   11.026314] bae0: ef14a68c 00000004 60080113 00000400 00000000
00000004 ee480000 c0467200
[   11.034500] bb00: ef14a610 ef0ce100 ee54bb98 02801020 00000400
c05e6a74 00000400 00000185
[   11.042685] bb20: 00000196 00000004 00480020 ee54bbc4 ee54be3c
eeae9c00 ef0ce1c0 c3803c48
[   11.050870] bb40: 02801020 00000200 c38442e8 00000004 ee54bbc4
c05e7a6c eeae9c10 ee54bd3c
[   11.059056] bb60: ee54bd3c 00480020 ffffffff ef14a610 ee54bd3c
ee54bd3c 00000010 eeae9c40
[   11.067241] bb80: 00000001 ef14a610 2eae8ac0 2e51be00 00000000
00000020 c05e7564 eeae9c00
[   11.075425] bba0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   11.083611] bbc0: 00000000 2eae8ac0 04000082 00000000 00000000
04801020 00000000 2eae8ae0
[   11.091796] bbe0: 04000082 00000200 00000000 05801021 00000000
2e51be00 04000042 00000000
[   11.099981] bc00: 00000000 02801020 00000000 2e513000 04000802
2e513000 8c000802 00000001
[   11.108167] bc20: 00000000 7fffffff ee54bcec ee54a000 00000002
00041400 c3803c48 c09428f8
[   11.116352] bc40: 00000040 ef0ce180 eebd0080 00000000 00000005
00041400 ef0ce180 c0833f10
[   11.124537] bc60: ee513000 ee54bd3c ee54be3c 00000004 00000005
eeae9c00 ef0ce180 c032a00c
[   11.132722] bc80: 00000000 00000000 00000000 00000000 00000000
00000001 c0833c5c 00000005
[   11.140908] bca0: 00000000 00000000 00000010 00000000 c3803c48
00000000 ee54bce8 00000000
[   11.149093] bcc0: 00000000 c0833e60 eebd0128 00000000 c0947d34
00000000 c093fc94 00000000
[   11.157278] bce0: 00000000 00000000 00000000 000c000c ee54bcf0
ee54bcf0 00000000 ee513000
[   11.165464] bd00: ee514000 ee515000 ee516000 ee517000 ee518000
ee519000 ee51a000 00013c00
[   11.173649] bd20: 00000002 ef009e80 00000400 00000000 c3802d00
c3803c48 00000000 efdc2262
[   11.181834] bd40: 00000000 00000200 2e513000 00000400 00000071
00000001 00000000 00000001
[   11.190019] bd60: 00000000 00000000 00000000 ef03f380 ef03f2c0
00000001 0000004f 00000800
[   11.198204] bd80: 00000027 0000004f 0000004f 0000004f 0000004f
00000400 00000071 00000001
[   11.206389] bda0: 00000000 00000001 00000000 00000000 00000000
00000000 00000000 00000000
[   11.214575] bdc0: 00000000 00000400 0000017c 00000000 00000040
0002eae8 00000ac0 c3806e04
[   11.222761] bde0: c38568c0 c01155c4 c011947c ef03f2c0 ef7e5cc0
00000ac0 efdcdd00 00000040
[   11.230946] be00: 00000001 00000040 ef14a600 eebd0080 eeae8f9c
c0115610 c011947c c37dccc0
[   11.239131] be20: eebd0080 efdcdd00 ef14a610 00000ac0 ef14a610
c011571c ef0ce1c0 000000ff
[   11.247316] be40: 00000000 00000000 00000000 00000000 c081c544
ef0ce1c0 ef0ce180 00041400
[   11.255501] be60: eebd0080 ef0ce180 00000001 c0833e60 00000005
c3803c48 00001085 ef069cbc
[   11.263686] be80: eeae8f9c c032cd24 00000000 00000000 ef0ce180
c081daf4 000000ae eebd1e00
[   11.271872] bea0: c3803c48 c032cdec c032cdb4 ffffffff 000000ae
ee54a000 c3803c48 c032ddf8
[   11.280057] bec0: ee54bf00 eebd1e00 00000400 eebd1e80 ef7e6380
00000000 c3848d14 00000001
[   11.288242] bee0: 00000001 00000002 c3803c48 c37dccc0 ffffffff
00000000 ef086000 c013bcd8
[   11.296428] bf00: c3846ee4 00000002 ef086000 ef7e5cc0 ef247300
ef0832c0 c3803c48 eea8fc40
[   11.304612] bf20: 00000000 c080429c ee54bf74 c0797e74 00000000
c0152e80 00000000 00000000
[   11.312798] bf40: 00000000 ef069cc0 ef069cbc 00041400 ffffe000
00041400 eeae8480 eebd1e00
[   11.320983] bf60: eeae8480 00000000 ee54a000 eebd1e00 c0328d04
ef069cbc eeae8f9c c0328d44
[   11.329168] bf80: eeae8f80 c013aac8 00000000 eeae8480 c013a980
00000000 00000000 00000000
[   11.337353] bfa0: 00000000 00000000 00000000 c01010e8 00000000
00000000 00000000 00000000
[   11.345538] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   11.353723] bfe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[   11.361923] [<c05ebd8c>] (cc_init_hash_sram) from [<c05f18a8>]
(cc_pm_resume+0x78/0xf0)
[   11.369954] [<c05f18a8>] (cc_pm_resume) from [<c04672d8>]
(__rpm_callback+0xc0/0x1cc)
[   11.377800] [<c04672d8>] (__rpm_callback) from [<c0467404>]
(rpm_callback+0x20/0x80)
[   11.385557] [<c0467404>] (rpm_callback) from [<c0466ee0>]
(rpm_resume+0x398/0x66c)
[   11.393144] [<c0466ee0>] (rpm_resume) from [<c0467200>]
(__pm_runtime_resume+0x4c/0x64)
[   11.401164] [<c0467200>] (__pm_runtime_resume) from [<c05e6a74>]
(cc_send_request+0x64/0x22c)
[   11.409703] [<c05e6a74>] (cc_send_request) from [<c05e7a6c>]
(cc_cipher_process+0x3b0/0x96c)
[   11.418153] [<c05e7a6c>] (cc_cipher_process) from [<c032a00c>]
(__test_skcipher+0x21c/0xb30)
[   11.426605] [<c032a00c>] (__test_skcipher) from [<c032cd24>]
(test_skcipher+0x28/0xb8)
[   11.434535] [<c032cd24>] (test_skcipher) from [<c032cdec>]
(alg_test_skcipher+0x38/0x8c)
[   11.442635] [<c032cdec>] (alg_test_skcipher) from [<c032ddf8>]
(alg_test.part.5+0x11c/0x284)
[   11.451081] [<c032ddf8>] (alg_test.part.5) from [<c0328d44>]
(cryptomgr_test+0x40/0x48)
[   11.459100] [<c0328d44>] (cryptomgr_test) from [<c013aac8>]
(kthread+0x148/0x150)
[   11.466594] [<c013aac8>] (kthread) from [<c01010e8>]
(ret_from_fork+0x14/0x2c)
[   11.473823] Exception stack(0xee54bfb0 to 0xee54bff8)
[   11.478872] bfa0:                                     00000000
00000000 00000000 00000000
[   11.487057] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   11.495241] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   11.501863] Code: e24ddf6b e1a05000 e5941000 e28d6f6a (e1ca80d0)
[   11.508053] ---[ end trace 19720bed5fe13807 ]---


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
