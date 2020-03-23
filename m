Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F349BC1975A
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 02:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2AE620753
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 02:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584929876;
	bh=pr6AtLlgKDBZy78fBf/+KjGfG2Q9GXU5Ja4T5hoPs2s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FXqGE6STuav7k///DJri02hLpZ8dDUgjTi+74gh0OzyUDuFdmZXu3V+wZyypHRqkb
	 oyevQRNX+7Y3KAAxhNK2LyrVQVIUS+M4Xdoi5sicEJ2P4yeWzZrdcoRHGUA8volpjH
	 Zf3fSvUXsLN/G0txyHH0m1Bj5RLBGr+y1v8PPi2w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCWCR4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Mar 2020 22:17:56 -0400
Received: from condef-07.nifty.com ([202.248.20.72]:26249 "EHLO
        condef-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgCWCR4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Mar 2020 22:17:56 -0400
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-07.nifty.com with ESMTP id 02N2BSGd023375
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2020 11:11:28 +0900
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 02N28urR002941;
        Mon, 23 Mar 2020 11:08:57 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 02N28urR002941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1584929338;
        bh=H8Ul8qvy3/NjGlVWM0US24XZqkIoV6sumKhoWd9ALvU=;
        h=From:To:Cc:Subject:Date:From;
        b=QK1JkiQHss7CKQmUCCDhEmKxIkM/NXpU3k4+HCFbMgGvduOYvmPs6LbrIWByUf67v
         mx8GHDFFWY6SV3/V0w2iVjIt/bmAad+rV0jjTvwer1CrexVtZ9zdP9Ud2h4xA9oWQu
         cQFv7eJRpaXgjKIeYE2RTgBf+gFdImlDKE0Tl4GGQVAKOyTb+ysh6OCFOHb+79geL3
         8mDRTUAzmuxa+PHF6ebp5z5K3v/2b3DrdhsJWXFfKOL0YXlwUJil+T4L82LMtY1+us
         bE92TKWNjwHCk69ME3cR8bkjRL70rb/AI5/9m7dxsrdxYWqfHJ7hf2fU74OJBYfS13
         r44+C0s9neTUg==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux@googlegroups.com, linux-crypto@vger.kernel.org
Subject: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
Date:   Mon, 23 Mar 2020 11:08:37 +0900
Message-Id: <20200323020844.17064-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

arch/x86/Makefile tests instruction code by $(call as-instr, ...)

Some of them are very old.
For example, the check for CONFIG_AS_CFI dates back to 2006.

We raise GCC versions from time to time, and we clean old code away.
The same policy applied to binutils.

The current minimal supported version of binutils is 2.21

This is new enough to recognize the instruction in most of
as-instr calls.



Masahiro Yamada (7):
  x86: remove unneeded defined(__ASSEMBLY__) check from asm/dwarf2.h
  x86: remove always-defined CONFIG_AS_CFI
  x86: remove always-defined CONFIG_AS_CFI_SIGNAL_FRAME
  x86: remove always-defined CONFIG_AS_CFI_SECTIONS
  x86: remove always-defined CONFIG_AS_SSSE3
  x86: remove always-defined CONFIG_AS_AVX
  x86: add comments about the binutils version to support code in
    as-instr

 arch/x86/Makefile                             | 21 +++------
 arch/x86/crypto/Makefile                      | 32 ++++++--------
 arch/x86/crypto/aesni-intel_avx-x86_64.S      |  3 --
 arch/x86/crypto/aesni-intel_glue.c            | 14 +-----
 arch/x86/crypto/blake2s-core.S                |  2 -
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl |  8 ----
 arch/x86/crypto/poly1305_glue.c               |  6 +--
 arch/x86/crypto/sha1_ssse3_asm.S              |  4 --
 arch/x86/crypto/sha1_ssse3_glue.c             |  9 +---
 arch/x86/crypto/sha256-avx-asm.S              |  3 --
 arch/x86/crypto/sha256_ssse3_glue.c           |  8 +---
 arch/x86/crypto/sha512-avx-asm.S              |  2 -
 arch/x86/crypto/sha512_ssse3_glue.c           |  7 +--
 arch/x86/include/asm/dwarf2.h                 | 43 -------------------
 arch/x86/include/asm/xor_avx.h                |  9 ----
 lib/raid6/algos.c                             |  2 -
 lib/raid6/recov_ssse3.c                       |  6 ---
 lib/raid6/test/Makefile                       |  3 --
 18 files changed, 26 insertions(+), 156 deletions(-)

-- 
2.17.1

