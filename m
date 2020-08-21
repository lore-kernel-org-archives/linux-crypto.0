Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DD4C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2F220738
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgHUH52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 03:57:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49974 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgHUH51 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 03:57:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k91vN-0003zs-2B; Fri, 21 Aug 2020 17:57:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 17:57:21 +1000
Date:   Fri, 21 Aug 2020 17:57:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] crypto/x86: Use CRC32 mnemonic in crc32c-intel_glue.c
Message-ID: <20200821075720.GH25143@gondor.apana.org.au>
References: <20200805111729.359078-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805111729.359078-1-ubizjak@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 05, 2020 at 01:17:29PM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.23,
> which supports CRC32 instruction mnemonic.
> 
> Replace the byte-wise specification of CRC32 with this proper mnemonic.
> The compiler is now able to pass memory operand to the instruction,
> so there is no need for a temporary register anymore.
> 
> Some examples of the improvement:
> 
>  12a:	48 8b 08             	mov    (%rax),%rcx
>  12d:	f2 48 0f 38 f1 f1    	crc32q %rcx,%rsi
>  133:	48 83 c0 08          	add    $0x8,%rax
>  137:	48 39 d0             	cmp    %rdx,%rax
>  13a:	75 ee                	jne    12a <crc32c_intel_update+0x1a>
> 
> to:
> 
>  125:	f2 48 0f 38 f1 06    	crc32q (%rsi),%rax
>  12b:	48 83 c6 08          	add    $0x8,%rsi
>  12f:	48 39 d6             	cmp    %rdx,%rsi
>  132:	75 f1                	jne    125 <crc32c_intel_update+0x15>
> 
> and:
> 
>  146:	0f b6 08             	movzbl (%rax),%ecx
>  149:	f2 0f 38 f0 f1       	crc32b %cl,%esi
>  14e:	48 83 c0 01          	add    $0x1,%rax
>  152:	48 39 d0             	cmp    %rdx,%rax
>  155:	75 ef                	jne    146 <crc32c_intel_update+0x36>
> 
> to:
> 
>  13b:	f2 0f 38 f0 02       	crc32b (%rdx),%eax
>  140:	48 83 c2 01          	add    $0x1,%rdx
>  144:	48 39 ca             	cmp    %rcx,%rdx
>  147:	75 f2                	jne    13b <crc32c_intel_update+0x2b>
> 
> As the compiler has some more freedom w.r.t. register allocation,
> there is also a couple of reg-reg moves removed.
> 
> There are no hidden states for CRC32 insn, so there is no need to mark
> assembly as volatile.
> 
> v2: Introduce CRC32_INST define.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/crypto/crc32c-intel_glue.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
