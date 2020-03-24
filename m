Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB0FC54FCF
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 237D020774
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008978;
	bh=nZl1kdkRRl5gOJ4P1UAHlaXYyaC5Jqfvcc1mB+wkgAo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=A73dVKN73F/9j9d+t0wMDBTnR20m4Bosr2mdzyITIHQRysnqUhCLsHE9P++g2+2l4
	 xPkvGJhme594WioY1xwtoaycFDDwSxhutSWp/DMZfbO/S1GNqngnIjc8LEsq6dbu8e
	 RZNqxKzVKzODe8dvszQW/l5/KCjDmHk8KXii3mO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCXAQR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:16:17 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:30520 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgCXAQR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:16:17 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHnn026701;
        Tue, 24 Mar 2020 09:14:18 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHnn026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008859;
        bh=AK5ED2xHmoH0oAFvRY1nFJ+Uo32DkkXlg/b7H5WM2LE=;
        h=From:To:Cc:Subject:Date:From;
        b=tMsQDW5QY1p/zxjGYXdrSK43/KLEAWGHV5zzBXogS9Fmukv+UITuDSA/nctKFlbV7
         eB/37RLi+SMClEqCwtyy12NtEmPVD9osWTvnRYurU2Iy2IqKj9hSJhUOTxs2Nr8dmJ
         JQ6gHtET3+9iKbwgxdnVkc7pf1twgrVvmqIpMYx0udk27w9oob5PgTVXwifhNVHNFZ
         0D/KzY+2DGK5FEfo/BWNclI1PkFVrHHFjSDC6la6OQ3Y3X/ggKR4hGpiILy16hBDOn
         XgfXXFtYp8BVTb/lkjPMGxKxPQXjYqW+gN7vps1tGxcFj/grMo6WjbWSYjtCq6CCVR
         wjp61iiKaeqCA==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        clang-built-linux@googlegroups.com
Subject: [PATCH v2 0/9] x86: remove always-defined CONFIG_AS_* options
Date:   Tue, 24 Mar 2020 09:13:49 +0900
Message-Id: <20200324001358.4520-1-masahiroy@kernel.org>
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

If this series looks good, how to merge it?
Via x86 tree or maybe crypto ?


Changes in v2:
  - New patch
  - Remove CFI_SIGNAL_FRAME entirely (per Nick)
  - add ifdef CONFIG_X86 to fix build errors on non-x86 arches

Masahiro Yamada (9):
  lib/raid6/test: fix build on distros whose /bin/sh is not bash
  x86: remove unneeded defined(__ASSEMBLY__) check from asm/dwarf2.h
  x86: remove always-defined CONFIG_AS_CFI
  x86: remove unneeded (CONFIG_AS_)CFI_SIGNAL_FRAME
  x86: remove always-defined CONFIG_AS_CFI_SECTIONS
  x86: remove always-defined CONFIG_AS_SSSE3
  x86: remove always-defined CONFIG_AS_AVX
  x86: add comments about the binutils version to support code in
    as-instr
  x86: replace arch macros from compiler with CONFIG_X86_{32,64}

 arch/x86/Makefile                             | 21 +++------
 arch/x86/crypto/Makefile                      | 32 +++++---------
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
 arch/x86/include/asm/dwarf2.h                 | 44 -------------------
 arch/x86/include/asm/xor_avx.h                |  9 ----
 kernel/signal.c                               |  2 +-
 lib/raid6/algos.c                             |  6 +--
 lib/raid6/recov_ssse3.c                       |  6 ---
 lib/raid6/test/Makefile                       |  8 ++--
 19 files changed, 33 insertions(+), 161 deletions(-)

-- 
2.17.1

