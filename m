Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2BCC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90DAD20772
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 04:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgGCEtE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:49:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40256 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGCEtD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 00:49:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jrDcm-000826-Fg; Fri, 03 Jul 2020 14:48:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2020 14:48:32 +1000
Date:   Fri, 3 Jul 2020 14:48:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jian Cai <caij2003@gmail.com>
Cc:     jiancai@google.com, ndesaulniers@google.com, manojgupta@google.com,
        sedat.dilek@gmail.com, maskray@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto, x86: aesni: add compatibility with IAS
Message-ID: <20200703044832.GD23200@gondor.apana.org.au>
References: <20200622232434.162730-1-caij2003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622232434.162730-1-caij2003@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 22, 2020 at 04:24:33PM -0700, Jian Cai wrote:
> Clang's integrated assembler complains "invalid reassignment of
> non-absolute variable 'var_ddq_add'" while assembling
> arch/x86/crypto/aes_ctrby8_avx-x86_64.S. It was because var_ddq_add was
> reassigned with non-absolute values several times, which IAS did not
> support. We can avoid the reassignment by replacing the uses of
> var_ddq_add with its definitions accordingly to have compatilibility
> with IAS.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1008
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reported-by: Fangrui Song <maskray@google.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot Linux v5.7.5; clang v11.0.0-git
> Signed-off-by: Jian Cai <caij2003@gmail.com>
> ---
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
