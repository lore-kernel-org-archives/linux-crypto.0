Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898C4EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 08:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjFWIXo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 04:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjFWIXo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 04:23:44 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72D4B7;
        Fri, 23 Jun 2023 01:23:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qCc4U-006KZI-E6; Fri, 23 Jun 2023 16:23:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jun 2023 16:23:10 +0800
Date:   Fri, 23 Jun 2023 16:23:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH-next 0/3] crypto: cmac - clone fixes
Message-ID: <ZJVWbsC3y0xYpOC4@gondor.apana.org.au>
References: <20230614174643.3836590-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614174643.3836590-1-dima@arista.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 14, 2023 at 06:46:40PM +0100, Dmitry Safonov wrote:
> Make cipher cloning possible in atomic contexts + prevent use-after-free
> on the crypto algorithm.
> Those seems to be all pitfalls I found while adapting TCP-AO patches to
> use crypto clone-tfm and dropping per-CPU requests allocations.
> 
> Cc: Bob Gilligan <gilligan@arista.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Francesco Ruggeri <fruggeri05@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Salam Noureddine <noureddine@arista.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> 
> Thanks,
>             Dmitry
> 
> Dmitry Safonov (3):
>   crypto: api - Remove crypto_init_ops()
>   crypto: api - Provide gfp mask for tfm allocation
>   crypto: cipher - On clone do crypto_mod_get()
> 
>  crypto/algapi.c         |  2 +-
>  crypto/api.c            | 20 +++-----------------
>  crypto/cipher.c         |  9 +++++++--
>  crypto/internal.h       |  2 +-
>  include/crypto/algapi.h |  1 -
>  5 files changed, 12 insertions(+), 22 deletions(-)
> 
> 
> base-commit: b16049b21162bb649cdd8519642a35972b7910fe
> -- 
> 2.40.0

All appleed with patch 2 replaced by my version.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
