Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55412C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 13:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DD0207FF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 13:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUUMd755"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgLANBu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgLANBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 08:01:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81423C0617A6;
        Tue,  1 Dec 2020 05:01:09 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id g14so2460377wrm.13;
        Tue, 01 Dec 2020 05:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=xs7Kt6JBzFViJzMkfJRrEx/e9uZbiiWxDrd79kV3MxU=;
        b=OUUMd755NYK0EuEAaN4AD6nt1cToYBo6AUI+aZHd6mlP4CN/UtPbdLgf5eAJj/P8Dt
         L2TKwE20Cf2AEG5DRR+PLvN8DWqG03/Ryzz6DGoqRpz+YjW3LYhAX+qm8FwHWnaCihl6
         RfaZi/RIO3GcA1MSh2FxHVhomKklNYA3fXLfpk9CP6BE858LCNxVwcJe58n/gpqFJ1p3
         aExYPyPfMmndiLpBXNa4ecH/GYcd11k3e5sZQaTB6VbZ7N2DIeSHiVCrZqWvEyUrUDdx
         CX+MAKAiQQxGhCBFfuCVxMPj3s5mvKuRvwEy215k5ij3Iy82pNSq/VCNu+GO/tLidwLD
         h/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=xs7Kt6JBzFViJzMkfJRrEx/e9uZbiiWxDrd79kV3MxU=;
        b=C6p7GNv2hATCnhxHoQKhniaI+i40/q6w75oIjQjOW+hvoxc6mH4aqXlLlkAaWQbAR/
         zD5RfmYM5dvm6hayBLVEVx+zWLYMsEvOj5ZvIGQbrTrqFINBHs+py3QwdAlYzVhQLbR6
         bmZpwIeQq/g0J0axKnHUoXeEUkXlAMUHgul45KeK2iC/kUMod7MfEwi5yllc4oin3J4V
         8r7/NaJPXWUkV0qB8ujM5tc8MCmzZTqVadW9iY4lo30m7FTKVEgnSbRYxSJBJSLfCmWh
         4IiXzaVUfWhoKHAnFUi4BcLjDOUlH5rC0RTlA+aD39Hoii86JoVm5rIfMSPMHKYM0346
         F8TA==
X-Gm-Message-State: AOAM532FfSot1cmtE4WsCL0aWYvdNWPkZ7r0PR1ldRJn4V9uedUGHuzz
        +KRwxmD9O3G3TJ5g+Qt9JiL/Xo16enE=
X-Google-Smtp-Source: ABdhPJz4/dOguotlMfXn0WY4Lsc3nGy+4w0lo5Q3e8hKfaSGOzoUgZFHL2UL3uID0xIcH9VItyCvAg==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr3803609wrt.264.1606827667923;
        Tue, 01 Dec 2020 05:01:07 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u85sm2805066wmu.43.2020.12.01.05.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 05:01:07 -0800 (PST)
Date:   Tue, 1 Dec 2020 14:01:02 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        tglx@linutronix.de
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: crypto: sun4i-ss: error with kmap
Message-ID: <20201201130102.GA23461@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

When testing 20201130, I hit this problem:

+[  213.050152] ------------[ cut here ]------------
+[  213.050207] WARNING: CPU: 0 PID: 18430 at mm/highmem.c:581 kunmap_local_indexed+0x194/0x1d4
+[  213.050214] Modules linked in: sm4_generic authenc vmac xcbc hmac streebog_generic sm3_generic sha3_generic crct10dif_generic crct10dif_common seed rmd320 rmd256 rmd160 rmd128 cts lzo lzo_compress salsa20_generic camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate zlib_deflate sha512_generic cfb ofb serpent_generic lrw twofish_generic twofish_common blowfish_generic blowfish_common md4
+[  213.050410] CPU: 0 PID: 18430 Comm: cryptsetup Not tainted 5.10.0-rc5-next-20201130-00059-gf7ecf0611042-dirty #242
+[  213.050416] Hardware name: Allwinner sun7i (A20) Family
+[  213.050448] [<c010d730>] (unwind_backtrace) from [<c010a218>] (show_stack+0x10/0x14)
+[  213.050465] [<c010a218>] (show_stack) from [<c08bbdcc>] (dump_stack+0x98/0xac)
+[  213.050479] [<c08bbdcc>] (dump_stack) from [<c08b93ac>] (__warn+0xc0/0xd8)
+[  213.050491] [<c08b93ac>] (__warn) from [<c08b9428>] (warn_slowpath_fmt+0x64/0xc0)
+[  213.050505] [<c08b9428>] (warn_slowpath_fmt) from [<c02018b4>] (kunmap_local_indexed+0x194/0x1d4)
+[  213.050525] [<c02018b4>] (kunmap_local_indexed) from [<c03e0390>] (sg_miter_stop+0xb4/0x164)
+[  213.050541] [<c03e0390>] (sg_miter_stop) from [<c03e082c>] (sg_miter_next+0xc/0xe4)
+[  213.050560] [<c03e082c>] (sg_miter_next) from [<c06b2d04>] (sun4i_ss_opti_poll+0x278/0x40c)
+[  213.050575] [<c06b2d04>] (sun4i_ss_opti_poll) from [<c06b338c>] (sun4i_ss_cipher_poll+0x4f4/0x5e4)
+[  213.050590] [<c06b338c>] (sun4i_ss_cipher_poll) from [<c03991d4>] (crypto_skcipher_encrypt+0x38/0x5c)
+[  213.050604] [<c03991d4>] (crypto_skcipher_encrypt) from [<c03aa980>] (xts_encrypt+0x8c/0xd4)
+[  213.050617] [<c03aa980>] (xts_encrypt) from [<c03991d4>] (crypto_skcipher_encrypt+0x38/0x5c)
+[  213.050631] [<c03991d4>] (crypto_skcipher_encrypt) from [<c03b3d94>] (skcipher_recvmsg+0x364/0x43c)
+[  213.050646] [<c03b3d94>] (skcipher_recvmsg) from [<c0719650>] (sock_read_iter+0xa8/0xf8)
+[  213.050663] [<c0719650>] (sock_read_iter) from [<c0239e98>] (vfs_read+0x2b8/0x2d8)
+[  213.050676] [<c0239e98>] (vfs_read) from [<c023a398>] (ksys_read+0xb0/0xe4)
+[  213.050688] [<c023a398>] (ksys_read) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
+[  213.050695] Exception stack(0xc4d13fa8 to 0xc4d13ff0)
+[  213.050707] 3fa0:                   00000006 b6f084d0 00000006 b47ff000 00010000 00000000
+[  213.050718] 3fc0: 00000006 b6f084d0 00010000 00000003 00000030 beb6e9bc 00000010 beb6e9fc
+[  213.050727] 3fe0: b6e3609c beb6e958 b6cc8504 b6cc851c
+[  213.050735] ---[ end trace 915906e6b0e8a55d ]---
+[  213.052281] 8<--- cut here ---
+[  213.052288] Unable to handle kernel paging request at virtual address ffefdf70
+[  213.052299] pgd = f9321c11
+[  213.052306] [ffefdf70] *pgd=6ffce861, *pte=00000000, *ppte=00000000
+[  213.052330] Internal error: Oops: 837 [#1] SMP ARM
+[  213.057127] Modules linked in: sm4_generic authenc vmac xcbc hmac streebog_generic sm3_generic sha3_generic crct10dif_generic crct10dif_common seed rmd320 rmd256 rmd160 rmd128 cts lzo lzo_compress salsa20_generic camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate zlib_deflate sha512_generic cfb ofb serpent_generic lrw twofish_generic twofish_common blowfish_generic blowfish_common md4
+[  213.097705] CPU: 0 PID: 18430 Comm: cryptsetup Tainted: G        W         5.10.0-rc5-next-20201130-00059-gf7ecf0611042-dirty #242
+[  213.109424] Hardware name: Allwinner sun7i (A20) Family
+[  213.114651] PC is at __raw_readsl+0x30/0x100
+[  213.118917] LR is at 0xe63d133d
+[  213.122056] pc : [<c041d528>]    lr : [<e63d133d>]    psr: 20000093
+[  213.128314] sp : c4d13ca0  ip : 52cee82d  fp : 00000000
+[  213.133533] r10: c4d12000  r9 : c4fb0240  r8 : 00000000
+[  213.138752] r7 : 00000fa0  r6 : c506fa40  r5 : 00000018  r4 : 13eb444f
+[  213.145271] r3 : 2394c9a0  r2 : 00000004  r1 : ffefdf70  r0 : f08ea204
+[  213.151791] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
+[  213.159004] Control: 10c5387d  Table: 44f8806a  DAC: 00000051
+[  213.164744] Process cryptsetup (pid: 18430, stack limit = 0x41d2aece)
+[  213.171176] Stack: (0xc4d13ca0 to 0xc4d14000)
+[  213.175535] 3ca0: 0000000d c06b2d88 eff19a00 80000013 00000038 00000001 00000000 c506fb64
+[  213.183705] 3cc0: 60000013 00000000 c4d0b900 00000000 00000000 00000000 00000000 00000000
+[  213.191875] 3ce0: 00000000 00000000 00000001 00001000 00000000 00000005 efef0a60 ffefd000
+[  213.200046] 3d00: 00001000 00001000 c4fb00f8 00000000 00000001 00000001 00000000 00001000
+[  213.208216] 3d20: 00000003 d1b3a700 efef06a0 c0dd81c0 c51d6d00 c506fa40 00000000 c4fb0240
+[  213.216387] 3d40: c4fb0008 00000000 00000000 c06b338c 793d365f c0201500 c4d13da8 ff9735a0
+[  213.224557] 3d60: c4d12000 00000000 00000001 c0399a28 c4d13da8 00000000 00000000 c0399fe8
+[  213.232728] 3d80: 44272f52 004bf960 b4c30b1c 310de6b4 c4fb01c0 c03aa018 00000000 c4d12000
+[  213.240899] 3da0: 00000001 00000000 ef864000 c4d80000 efef0a60 ffefe000 c50463f0 00001000
+[  213.249069] 3dc0: 00000000 c4fb00f8 00001000 00000000 c4ff8ec0 c4fb01c0 00000000 00000000
+[  213.257240] 3de0: c4d48cc0 d1b3a700 00000010 c4fb0240 c51d6d00 c0dd81c0 00010000 00000000
+[  213.265410] 3e00: c4d13ea0 c4fb01c0 00000000 c03991d4 c4fb01c0 c4fb0200 00000000 00010000
+[  213.273581] 3e20: 00000000 c03aa980 c4fb01c0 c51d6b80 c4d6f480 c03991d4 c4fb0000 c4d48fd0
+[  213.281752] 3e40: c4d48fc0 c51d6b80 00000000 c03b3d94 00010000 c4d13e70 c4964b40 c0de0e40
+[  213.289923] 3e60: c0394578 c03b20e8 c4d7aa00 c4d12000 00010000 d1b3a700 c4d1b840 c4d13f08
+[  213.298093] 3e80: c03b3a30 c4d12000 c4d1b840 c4964b40 00000000 00000001 00000000 c0719650
+[  213.306263] 3ea0: 00000000 00000000 00000004 00000000 00000000 c4d13f08 00000000 c071d5d4
+[  213.314433] 3ec0: 00000000 00000000 00000000 00000000 c4d13f20 d1b3a700 00010000 c4d1b840
+[  213.322604] 3ee0: 00000000 00000000 c4d12000 c0239e98 00010000 00000020 c4d6f480 c4d48fc0
+[  213.330775] 3f00: b47ff000 00010000 00000004 00000000 00010000 c4d13f00 00000001 c071d5d4
+[  213.338945] 3f20: c4d1b840 00000000 00000000 00000000 00000000 00000000 00000000 00000000
+[  213.347115] 3f40: 00000000 00000000 00000000 d1b3a700 00000000 c4d1b840 c4d1b840 00010000
+[  213.355286] 3f60: 00000003 c4d12000 00010000 b47ff000 beb6e9fc c023a398 c4d48e40 0000011c
+[  213.363456] 3f80: 00000030 d1b3a700 00000006 b6f084d0 00010000 00000003 c0100264 c4d12000
+[  213.371627] 3fa0: 00000003 c0100060 00000006 b6f084d0 00000006 b47ff000 00010000 00000000
+[  213.379797] 3fc0: 00000006 b6f084d0 00010000 00000003 00000030 beb6e9bc 00000010 beb6e9fc
+[  213.387968] 3fe0: b6e3609c beb6e958 b6cc8504 b6cc851c 80000010 00000006 00000000 00000000
+[  213.396142] Code: e5904000 e590c000 e590e000 e2522004 (e8a15018) 
+[  213.402232] ---[ end trace 915906e6b0e8a55e ]---
+[  213.406848] note: cryptsetup[18430] exited with preempt_count 2

The same driver work fine on 5.9.11.

Does someone have any idea on what go wrong ?
Does it is related with recent kmap work ?

Regards
