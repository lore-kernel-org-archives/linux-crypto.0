Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F069C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F112C2133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfF1ETU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:19:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55940 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbfF1ETT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:19:19 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hgiLw-0004vB-QN; Fri, 28 Jun 2019 12:19:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hgiLw-00025s-LT; Fri, 28 Jun 2019 12:19:12 +0800
Date:   Fri, 28 Jun 2019 12:19:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] crypto: serpent - mark __serpent_setkey_sbox
 noinline
Message-ID: <20190628041912.qprczc23gzeelag7@gondor.apana.org.au>
References: <20190618111953.3183723-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618111953.3183723-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 18, 2019 at 01:19:42PM +0200, Arnd Bergmann wrote:
> The same bug that gcc hit in the past is apparently now showing
> up with clang, which decides to inline __serpent_setkey_sbox:
> 
> crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]
> 
> Marking it 'noinline' reduces the stack usage from 2112 bytes to
> 192 and 96 bytes, respectively, and seems to generate more
> useful object code.
> 
> Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: style improvements suggested by Eric Biggers
> ---
>  crypto/serpent_generic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
