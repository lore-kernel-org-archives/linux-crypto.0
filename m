Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F164C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 21:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344401AbiA0VhD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 16:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiA0VhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 16:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89470C061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 13:37:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B98618EA
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 21:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4E4C340E4;
        Thu, 27 Jan 2022 21:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643319421;
        bh=qMbqBkkVNK440C8IwMbZegi4qUBpLSoWKFUzbGYL/2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fy1Av58U141oebk3uXZ5QOCtnKv+JJMXQ5mRPHqIACZNBxg09Tw1olGc4TIgn8APP
         aPGGPR9dbxCSnAoKgEx+1UMV+AEwxV6EGXe512Vq3e0obAdTyaeu6fS078n2x8DNaQ
         Pm8rpork0VAHENJw28eFbYVZuTJlNBp96TTVUnvkpWarO85BLGdCcX7dSWH0I8kSx5
         rTePaavjj2akHXlc4BeXbcvtnzznFZc2hRSOCICnXkL0ppl7XuiH15b1qt0BSpJXKR
         iqvpBs0+8LWarDp3gU3vHCjf2whxTG5KTDUVTC7yCE1sRkyPsmB2A47N7+cvFL2G9o
         dsraYvGXh/RhA==
Date:   Thu, 27 Jan 2022 14:36:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 0/2] xor: enable auto-vectorization in Clang
Message-ID: <YfMQeRVkNMHr81P9@dev-arch.archlinux-ax161>
References: <20220127081227.2430-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127081227.2430-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Thu, Jan 27, 2022 at 09:12:25AM +0100, Ard Biesheuvel wrote:
> Update the xor_blocks() prototypes so that the compiler understands that
> the inputs always refer to distinct regions of memory. This is implied
> by the existing implementations, as they use different granularities for
> the load/xor/store loops.
> 
> With that, we can fix the ARM/Clang version, which refuses to SIMD
> vectorize otherwise, and throws a spurious warning related to the GCC
> version being incompatible.
> 
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> 
> Ard Biesheuvel (2):
>   lib/xor: make xor prototypes more friendely to compiler vectorization
>   crypto: arm/xor - make vectorized C code Clang-friendly

I tested multi_v7_defconfig + CONFIG_BTRFS=y (to get
CONFIG_XOR_BLOCKS=y) in QEMU 6.2.0 (10 boots) and the xor neon code gets
faster according to do_xor_speed():

mainline @ 626b2dda7651:

[    2.591449]    neon            :  1166 MB/sec
[    2.579454]    neon            :  1118 MB/sec
[    2.589061]    neon            :  1163 MB/sec
[    2.581827]    neon            :  1167 MB/sec
[    2.599079]    neon            :  1166 MB/sec
[    2.579252]    neon            :  1147 MB/sec
[    2.582637]    neon            :  1168 MB/sec
[    2.582872]    neon            :  1164 MB/sec
[    2.570671]    neon            :  1167 MB/sec
[    2.571830]    neon            :  1166 MB/sec

mainline @ 626b2dda7651 with series:

[    2.570227]    neon            :  1238 MB/sec
[    2.571642]    neon            :  1237 MB/sec
[    2.580370]    neon            :  1234 MB/sec
[    2.581966]    neon            :  1238 MB/sec
[    2.582313]    neon            :  1236 MB/sec
[    2.572291]    neon            :  1238 MB/sec
[    2.570625]    neon            :  1233 MB/sec
[    2.571897]    neon            :  1234 MB/sec
[    2.589616]    neon            :  1228 MB/sec
[    2.582449]    neon            :  1236 MB/sec

This series is currently broken for powerpc [1], as the functions in
arch/powerpc/lib/xor_vmx.c were not updated.

arch/powerpc/lib/xor_vmx.c:52:6: error: conflicting types for '__xor_altivec_2'
void __xor_altivec_2(unsigned long bytes, unsigned long *v1_in,
     ^
arch/powerpc/lib/xor_vmx.h:9:6: note: previous declaration is here
void __xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
     ^
arch/powerpc/lib/xor_vmx.c:70:6: error: conflicting types for '__xor_altivec_3'
void __xor_altivec_3(unsigned long bytes, unsigned long *v1_in,
     ^
arch/powerpc/lib/xor_vmx.h:11:6: note: previous declaration is here
void __xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
     ^
arch/powerpc/lib/xor_vmx.c:92:6: error: conflicting types for '__xor_altivec_4'
void __xor_altivec_4(unsigned long bytes, unsigned long *v1_in,
     ^
arch/powerpc/lib/xor_vmx.h:14:6: note: previous declaration is here
void __xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
     ^
arch/powerpc/lib/xor_vmx.c:119:6: error: conflicting types for '__xor_altivec_5'
void __xor_altivec_5(unsigned long bytes, unsigned long *v1_in,
     ^
arch/powerpc/lib/xor_vmx.h:18:6: note: previous declaration is here
void __xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
     ^
4 errors generated.

If I fix that up [2], it builds and resolves an instance of
-Wframe-larger-than= in the xor altivec code, as seen with
pmac32_defconfig.

Before this series:

arch/powerpc/lib/xor_vmx.c:119:6: error: stack frame size (1232) exceeds limit (1024) in '__xor_altivec_5' [-Werror,-Wframe-larger-than]
void __xor_altivec_5(unsigned long bytes, unsigned long *v1_in,
     ^
1 error generated.

After this patch (with CONFIG_FRAME_WARN=100 and
CONFIG_PPC_DISABLE_WERROR=y):

arch/powerpc/lib/xor_vmx.c:52:6: warning: stack frame size (128) exceeds limit (100) in '__xor_altivec_2' [-Wframe-larger-than]
void __xor_altivec_2(unsigned long bytes,
     ^
arch/powerpc/lib/xor_vmx.c:71:6: warning: stack frame size (160) exceeds limit (100) in '__xor_altivec_3' [-Wframe-larger-than]
void __xor_altivec_3(unsigned long bytes,
     ^
arch/powerpc/lib/xor_vmx.c:95:6: warning: stack frame size (144) exceeds limit (100) in '__xor_altivec_4' [-Wframe-larger-than]
void __xor_altivec_4(unsigned long bytes,
     ^
arch/powerpc/lib/xor_vmx.c:124:6: warning: stack frame size (160) exceeds limit (100) in '__xor_altivec_5' [-Wframe-larger-than]
void __xor_altivec_5(unsigned long bytes,
     ^
4 warnings generated.

There is a similar performance gain as ARM according to do_xor_speed():

Before:

   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   219 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec
   altivec         :   222 MB/sec

After:

   altivec         :   278 MB/sec
   altivec         :   276 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec
   altivec         :   278 MB/sec

I did also build test arm64 and x86_64 and saw no errors. I did runtime
test arm64 for improvements and did not see any, which is good, since I
take that as meaning it was working fine before and there is no
regression.

Once the build error is fixed, consider this series:

Tested-by: Nathan Chancellor <nathan@kernel.org>

[1]: https://lore.kernel.org/r/202112310646.kuh2pXiG-lkp@intel.com/
[2]: https://github.com/ClangBuiltLinux/linux/issues/563#issuecomment-1005175153

Cheers,
Nathan
