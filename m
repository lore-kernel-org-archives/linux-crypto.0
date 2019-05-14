Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D666CC04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 09:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFBA20675
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 09:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2So0RSU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfENJKQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 05:10:16 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39420 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENJKQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 05:10:16 -0400
Received: by mail-wm1-f43.google.com with SMTP id n25so1958317wmk.4
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2019 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=LtYfeLMxvf7br5CjOTSnAfjyL3N9nvhUvIKkJ3hdj58=;
        b=C2So0RSUnxFkIIK2RUmBVz5wXQA0RmjnYyitkUK/hHgGn+OFVvOF/k7g2GN21LfSJ/
         k8T2sAJD5poGsIYhSPGw8AxVrNFiggNtvorXVDKtcmEtdf/3fZeAaCGLaDA4+bl2S1de
         0neheEyup5WarpBDwbZ4fBIh6LAs1z9zLXxR9qZF8MHzSdnaoOm7Adq5zwrmjXpxR76g
         ssKBtiCPPz4lTR/Y8LhNizHQuIdqBYxqL7B+1bCJBg92T1AgZGal02ploqCH+DaxfxbV
         ypW7398nT/79UD1bT20khytDFp5lcPnlzERG+XguwJHvUU0V2+P1GDyVudw/Zgt8ei+D
         F3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=LtYfeLMxvf7br5CjOTSnAfjyL3N9nvhUvIKkJ3hdj58=;
        b=X8TtAmGu5gb4468d0REtSDaVNqK1QpOgMNczE2i/mMaC+ooxP6c5wmxJCGAQ1wSps0
         o0SwlG3pKtRx4OtVJTjR4gubCTI3JkMqP6FCWjGcDdlOZ/zW4Ahr7Yv5ymlvJL0ClbK3
         VIVaYWPiE23tUv/33qsxNyROIBSgj7JiZRrzo4bVBnKIUA0Lj1EGeVyiXQmBDfmQhFoV
         /yHzvZMp7pymbQRgTkU6zD+exh1qu6bKLb//scGCmKxXmAv7IMMWcwst9dXiEaT2CohJ
         Gam8A5TDzuoZufISeJ7P3GYqqw3OdBUpQRwsQQUSd5G3QO5KijygGqruvKxui0Q53EYG
         4sGw==
X-Gm-Message-State: APjAAAXZTRJ0KcEyknNBjK3vBs8QlL6MEuOx4ngYZLVjw4EeDBfhFf11
        uLNKlSoKN0jyhp/VhF1aBSfGQWRv
X-Google-Smtp-Source: APXvYqyrh0QnckRC31o3xqPWCgMZlZbpCpwolV+mZRLKtfMhGDhnDDgbfPuxLWIH2sVDLUQcU6NtBw==
X-Received: by 2002:a1c:7dcf:: with SMTP id y198mr7454996wmc.94.1557825012868;
        Tue, 14 May 2019 02:10:12 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id s7sm15831966wrn.84.2019.05.14.02.10.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 02:10:12 -0700 (PDT)
Date:   Tue, 14 May 2019 11:10:10 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     linux-crypto@vger.kernel.org, ebiggers@google.com,
        herbert@gondor.apana.org.au
Subject: crypto: Kernel stack is corrupted in: generate_random_hash_testvec
Message-ID: <20190514091010.GA25789@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

Since now 3 weeks, all my CI(qemus and some real boards) leads to:

[  264.100616] TEST: md5 md5-generic
[  264.288660] TEST: sha1 sha1-generic
[  270.267367] TEST: md4 md4-generic
[  270.423889] TEST: sha256 sha256-generic
[  285.238346] CPU feature 'AVX registers' is not supported.
[  285.261400] CPU feature 'AVX registers' is not supported.
[  287.760639] CPU feature 'AVX registers' is not supported.
[  287.779303] CPU feature 'AVX registers' is not supported.
[  291.467853] CPU feature 'AVX registers' is not supported.
[  291.523581] CPU feature 'AVX registers' is not supported.
[  293.398314] CPU feature 'AVX registers' is not supported.
[  293.416337] CPU feature 'AVX registers' is not supported.
[  293.438402] CPU feature 'AVX registers' is not supported.
[  293.456731] CPU feature 'AVX registers' is not supported.
[  301.296291] CPU feature 'AVX registers' is not supported.
[  301.316407] CPU feature 'AVX registers' is not supported.
[  301.352417] CPU feature 'AVX registers' is not supported.
[  301.371220] CPU feature 'AVX registers' is not supported.
[  304.853581] CPU feature 'AVX registers' is not supported.
[  304.873051] CPU feature 'AVX registers' is not supported.
[  304.908282] CPU feature 'AVX registers' is not supported.
[  304.926279] CPU feature 'AVX registers' is not supported.
[  317.182018] TEST: sha384 sha384-generic
[  317.386478] TEST: sha512 sha512-generic
[  318.119704] CPU feature 'AVX registers' is not supported.
[  318.145027] CPU feature 'AVX registers' is not supported.
[  320.111300] CPU feature 'AVX registers' is not supported.
[  320.132432] CPU feature 'AVX registers' is not supported.
[  322.490743] CPU feature 'AVX registers' is not supported.
[  322.512278] CPU feature 'AVX registers' is not supported.
[  323.609391] CPU feature 'AVX registers' is not supported.
[  323.629135] CPU feature 'AVX registers' is not supported.
[  324.864194] TEST: michael_mic michael_mic-generic
[  324.990626] TEST: crc32c crc32c-generic
[  325.147366] TEST: crc32c crc32c-generic
[  327.719523] TEST: wp512 wp512-generic
[  328.213000] TEST: wp384 wp384-generic
[  328.677561] TEST: wp256 wp256-generic
[  332.143974] TEST: tgr192 tgr192-generic
[  332.379017] TEST: tgr160 tgr160-generic
[  332.590082] TEST: tgr128 tgr128-generic
[  337.245417] AVX or AES-NI instructions are not detected.
[  337.272719] AVX or AES-NI instructions are not detected.
[  337.296407] AVX or AES-NI instructions are not detected.
[  337.316576] AVX or AES-NI instructions are not detected.
[  339.663254] AVX or AES-NI instructions are not detected.
[  339.681273] AVX or AES-NI instructions are not detected.
[  339.704385] AVX or AES-NI instructions are not detected.
[  339.722374] AVX or AES-NI instructions are not detected.
[  342.944105] AVX or AES-NI instructions are not detected.
[  342.959325] AVX or AES-NI instructions are not detected.
[  342.995669] AVX or AES-NI instructions are not detected.
[  343.020392] AVX or AES-NI instructions are not detected.
[  344.067202] TEST: sha224 sha224-generic
[  347.337089] TEST: cbcmac(aes-asm) cbcmac(aes-generic)
[  351.151153] TEST: rmd128 rmd128-generic
[  351.659582] TEST: rmd160 rmd160-generic
[  352.240422] TEST: rmd256 rmd256-generic
[  352.690148] TEST: rmd320 rmd320-generic
[  355.907134] TEST: ghash ghash-generic
[  356.520343] TEST: crct10dif crct10dif-generic
[  357.297442] TEST: sha3-224 sha3-224-generic
[  357.590050] TEST: sha3-256 sha3-256-generic
[  357.887517] TEST: sha3-384 sha3-384-generic
[  358.227582] TEST: sha3-512 sha3-512-generic
[  358.835525] TEST: sm3 sm3-generic
[  359.402569] TEST: streebog256 streebog256-generic
[  359.901500] TEST: streebog512 streebog512-generic
[  360.658218] TEST: hmac(md5) hmac(md5-generic)
[  361.073303] TEST: hmac(sha1) hmac(sha1-generic)
[  361.395011] TEST: hmac(sha256) hmac(sha256-generic)
[  361.863977] TEST: hmac(sha384) hmac(sha384-generic)
[  362.336112] TEST: hmac(sha512) hmac(sha512-generic)
[  362.803184] TEST: hmac(sha224) hmac(sha224-generic)
[  363.466134] TEST: xcbc(aes-asm) xcbc(aes-generic)
[  363.765628] TEST: xcbc(aes) xcbc(aes-generic)
[  364.233696] TEST: hmac(rmd128) hmac(rmd128-generic)
[  364.665437] TEST: hmac(rmd160) hmac(rmd160-generic)
[  365.385328] TEST: vmac64(aes-asm) vmac64(aes-generic)
[  365.660669] TEST: vmac64(aes) vmac64(aes-generic)
[  366.041220] TEST: hmac(sha3-224) hmac(sha3-224-generic)
[  366.044195] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: generate_random_hash_testvec.constprop.39+0xe6/0xf4
[  366.046811] CPU: 0 PID: 2247 Comm: modprobe Not tainted 5.1.0-next-20190509+ #38
[  366.048437] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-1.fc28 04/01/2014
[  366.050349] Call Trace:
[  366.052558]  dump_stack+0x46/0x60
[  366.053944]  panic+0xf6/0x2b7
[  366.054354]  ? snprintf+0x49/0x60
[  366.056265]  ? generate_random_hash_testvec.constprop.39+0xe6/0xf4
[  366.056900]  __stack_chk_fail+0x10/0x10
[  366.058161]  generate_random_hash_testvec.constprop.39+0xe6/0xf4
[  366.060709]  test_hash_vs_generic_impl.cold.59+0x47/0x135
[  366.061335]  ? valid_sg_divisions.constprop.45+0x86/0x90
[  366.062674]  ? valid_testvec_config+0xb1/0xe0
[  366.064567]  ? test_hash_vec+0xe0/0x120
[  366.065102]  __alg_test_hash+0x128/0x1b0
[  366.066993]  alg_test_hash+0xb3/0x110
[  366.068136]  alg_test.part.34+0xa0/0x2e0
[  366.068627]  ? sysret32_from_system_call+0x27/0x87
[  366.070554]  ? apic_timer_interrupt+0xa/0x20
[  366.071081]  ? __alg_test_hash+0x170/0x1b0
[  366.073448]  do_test+0x221b/0x4807 [tcrypt]
[  366.074935]  ? 0xffffffffc031c000
[  366.075458]  tcrypt_mod_init+0x50/0x1000 [tcrypt]
[  366.076788]  ? 0xffffffffc031c000
[  366.078528]  do_one_initcall+0x41/0x1df
[  366.079028]  ? _cond_resched+0x10/0x20
[  366.080182]  ? kmem_cache_alloc_trace+0x33/0x150
[  366.081404]  do_init_module+0x55/0x200
[  366.082554]  load_module+0x1f65/0x2410
[  366.083849]  ? __do_sys_finit_module+0xba/0xe0
[  366.085067]  __do_sys_finit_module+0xba/0xe0
[  366.086139]  do_syscall_64+0x43/0x100
[  366.087162]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  366.088321] RIP: 0033:0x7f36177fabb9
[  366.090224] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a7 32 0c 00 f7 d8 64 89 01 48
[  366.092579] RSP: 002b:00007ffd387a4018 EFLAGS: 00000206 ORIG_RAX: 0000000000000139
[  366.094397] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f36177fabb9
[  366.095790] RDX: 0000000000000000 RSI: 00000000023229c0 RDI: 0000000000000003
[  366.097041] RBP: 00000000023229c0 R08: 0000000002321f00 R09: 0000000000000001
[  366.098313] R10: 000000000000001f R11: 0000000000000206 R12: 00000000023229a0
[  366.099574] R13: 0000000000000001 R14: 0000000002321f00 R15: 0000000000000000
[  366.101715] Kernel Offset: 0x16600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  366.103970] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: generate_random_hash_testvec.constprop.39+0xe6/0xf4 ]---

This problem arise when I modprobe tcrypt
I have added some debug to find which alg was causing that, and it seems it is hmac(sha3-224)

Regards

PS: another crash on a real board:
[  186.490735] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: generate_random_hash_testvec.constprop.12+0x128/0x128
[  186.497653] CPU: 2 PID: 6435 Comm: modprobe Tainted: G        W         5.1.0-next-20190513-00100-g5b463b4dd4f8 #30
[  186.507996] Hardware name: Libre Computer Board AML-S905X-CC (DT)
[  186.514034] Call trace:
[  186.516454]  dump_backtrace+0x0/0x140
[  186.520074]  show_stack+0x14/0x20
[  186.523352]  dump_stack+0xa8/0xcc
[  186.526628]  panic+0x140/0x334
[  186.529646]  print_tainted+0x0/0xa8
[  186.533097]  generate_random_sgl_divisions.constprop.14+0x0/0x238
[  186.539134]  test_hash_vs_generic_impl+0x1f8/0x2f8
[  186.543877]  __alg_test_hash+0x188/0x230
[  186.547762] SMP: stopping secondary CPUs
[  186.551641] Kernel Offset: disabled
[  186.555090] CPU features: 0x002,20002004
[  186.558970] Memory Limit: none
[  186.561999] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: generate_random_hash_testvec.constprop.12+0x128/0x128 ]---
