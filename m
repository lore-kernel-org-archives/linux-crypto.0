Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8B5C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE26620787
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGPLyz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 07:54:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40092 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgGPLyz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 07:54:55 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw2TR-0008Nc-DU; Thu, 16 Jul 2020 21:54:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 21:54:49 +1000
Date:   Thu, 16 Jul 2020 21:54:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] crypto/x86: Remove include/asm/inst.h
Message-ID: <20200716115449.GF31166@gondor.apana.org.au>
References: <20200709150857.4304-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150857.4304-1-ubizjak@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 05:08:57PM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.23,
> which supports PSHUFB, PCLMULQDQ, PEXTRD, AESKEYGENASSIST,
> AESIMC, AESENC, AESENCLAST, AESDEC, AESDECLAST and MOVQ
> instruction mnemonics.
> 
> Substitute macros from include/asm/inst.h with a proper
> instruction mnemonics in various assmbly files from
> x86/crypto directory, and remove now unneeded file.
> 
> The patch was tested by calculating and comparing sha256sum
> hashes of stripped object files before and after the patch,
> to be sure that executable code didn't change.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S   |   1 -
>  arch/x86/crypto/aesni-intel_asm.S         | 733 +++++++++++-----------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S  |   1 -
>  arch/x86/crypto/crc32-pclmul_asm.S        |  47 +-
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S |   5 +-
>  arch/x86/crypto/ghash-clmulni-intel_asm.S |  17 +-
>  arch/x86/include/asm/inst.h               | 311 ---------
>  7 files changed, 399 insertions(+), 716 deletions(-)
>  delete mode 100644 arch/x86/include/asm/inst.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
