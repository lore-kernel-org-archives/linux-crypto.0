Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C21C04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 06:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E225B2083E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 06:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfEQGAu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 02:00:50 -0400
Received: from [128.1.224.119] ([128.1.224.119]:54072 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbfEQGAu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 02:00:50 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRVv9-0007sG-Jh; Fri, 17 May 2019 14:00:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRVv3-0000Yj-Jw; Fri, 17 May 2019 14:00:37 +0800
Date:   Fri, 17 May 2019 14:00:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Axtens <dja@axtens.net>
Cc:     mpe@ellerman.id.au, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: Re: [PATCH] crypto: vmx - CTR: always increment IV as quadword
Message-ID: <20190517060037.obxagoes7fdfftuj@gondor.apana.org.au>
References: <20190515102450.30557-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515102450.30557-1-dja@axtens.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 08:24:50PM +1000, Daniel Axtens wrote:
> The kernel self-tests picked up an issue with CTR mode:
> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
> 
> Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
> after 3 increments it should wrap around to 0.
> 
> In the aesp8-ppc code from OpenSSL, there are two paths that
> increment IVs: the bulk (8 at a time) path, and the individual
> path which is used when there are fewer than 8 AES blocks to
> process.
> 
> In the bulk path, the IV is incremented with vadduqm: "Vector
> Add Unsigned Quadword Modulo", which does 128-bit addition.
> 
> In the individual path, however, the IV is incremented with
> vadduwm: "Vector Add Unsigned Word Modulo", which instead
> does 4 32-bit additions. Thus the IV would instead become
> FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.
> 
> Use vadduqm.
> 
> This was probably a typo originally, what with q and w being
> adjacent. It is a pretty narrow edge case: I am really
> impressed by the quality of the kernel self-tests!
> 
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> 
> ---
> 
> I'll pass this along internally to get it into OpenSSL as well.
> ---
>  drivers/crypto/vmx/aesp8-ppc.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
