From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/3] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Thu, 15 Feb 2018 16:33:16 +0800
Message-ID: <20180215083316.GA5212@gondor.apana.org.au>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
 <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mips@linux-mips.org,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: James Hogan <jhogan@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38828 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755118AbeBOIdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 03:33:35 -0500
Content-Disposition: inline
In-Reply-To: <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 09, 2018 at 10:11:06PM +0000, James Hogan wrote:
> From: Marcin Nowakowski <marcin.nowakowski@mips.com>
> 
> This module registers crc32 and crc32c algorithms that use the
> optional CRC32[bhwd] and CRC32C[bhwd] instructions in MIPSr6 cores.
> 
> Signed-off-by: Marcin Nowakowski <marcin.nowakowski@mips.com>
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-mips@linux-mips.org
> Cc: linux-crypto@vger.kernel.org
> ---
> Changes in v3:
>  - Convert to using assembler macros to support CRC instructions on
>    older toolchains, using the helpers merged for 4.16. This removes the
>    need to hardcode either rt or rs (i.e. as $v0 (CRC_REGISTER) and
>    $at), and drops the C "register" keywords sprinkled everywhere.
>  - Minor whitespace rearrangement of _CRC32 macro.
>  - Add SPDX-License-Identifier to crc32-mips.c and the crypo Makefile.
>  - Update copyright from ImgTec to MIPS Tech, LLC.
>  - Update imgtec.com email addresses to mips.com.
> 
> Changes in v2:
>  - minor code refactoring as suggested by JamesH which produces
>    a better assembly output for 32-bit builds
> ---
>  arch/mips/Kconfig             |   4 +-
>  arch/mips/Makefile            |   3 +-
>  arch/mips/crypto/Makefile     |   6 +-
>  arch/mips/crypto/crc32-mips.c | 346 +++++++++++++++++++++++++++++++++++-
>  crypto/Kconfig                |   9 +-
>  5 files changed, 368 insertions(+)
>  create mode 100644 arch/mips/crypto/Makefile
>  create mode 100644 arch/mips/crypto/crc32-mips.c

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
