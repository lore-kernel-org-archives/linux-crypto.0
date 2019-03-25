Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A53C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 11:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD6F20850
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 11:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfCYLwH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 07:52:07 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:51386 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730605AbfCYLwH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 07:52:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h8O96-000159-O0; Mon, 25 Mar 2019 19:52:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h8O8y-0000Ok-TE; Mon, 25 Mar 2019 19:51:56 +0800
Date:   Mon, 25 Mar 2019 19:51:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jason@zx2c4.com,
        torvalds@linux-foundation.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, ebiggers@kernel.org,
        ard.biesheuvel@linaro.org, samuel.c.p.neves@gmail.com
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
Message-ID: <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322071122.6677-1-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Changes v8->v9, along with who suggested it.
> --------------------------------------------
> - [EVERYBODY] Zinc no longer ships generated assembly code. Rather, we now
>  bundle in the original perlasm generator for it. This is ongoing joint work
>  with Andy Polyakov upstream, so that the same .pl files can live in our tree
>  as well as in the CRYPTOGAMS tree. I personally find that the code required
>  to share this in both repositories to be a tiny bit ugly. I think there would
>  be some degree of an advantage to removing that and making the .pl
>  kernel-only, and then carefully tracking Andy's changes (as we already
>  do). Previous opinions on the list, though, were that there's also
>  significant advantage to being able to share the exact same code in both.
>  And I think there's a decent amount of wisdom in that too. Since that
>  appeared to be the prevailing view, and since it also has good reasons
>  arguments, we'll go with that for now.

Thanks for the update.
 
> - Following the Adiantum merge, the two commits that port the old crypto API
>  over to use Zinc have been removed from this series. We can certainly add
>  them back in at some point, but I thought it'd be favorable to at least
>  begin to receive some sign-offs on the Zinc-specific commits, now that
>  (hopefully all of) the previous feedback has been taken care of. The two
>  commits porting it over are fairly standalone as well, so that shouldn't
>  impact the ability to review this. For now those are living in the
>  jd/with-cryptoapi-port branch of kernel.org's zx2c4/linux.git tree. This
>  also allows us to move this all forward a little bit.

Sorry but adding new implementations of chacha20/poly1305 without
removing the existing ones is not acceptable.  I really think
we ought to separate the zinc interface from these new crypto
implementations.  They have nothing to do with each other.

As we've been stuck on this point for so long, let's get the
ball rolling by first merging just the zinc interface itself
with the existing chacha20/poly1305 code.  Then we can replace
these implementations with your implementations without getting
bogged down by all these other discussions.

AFAICS once we resolve Thomas's concerns with regards to the simd
patch, then we can merge the zinc interface right away and go from
there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
