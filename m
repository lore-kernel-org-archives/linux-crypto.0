Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3313C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiA1GaM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:30:12 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60628 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231443AbiA1GaJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:30:09 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKkx-0001Jr-1S; Fri, 28 Jan 2022 17:29:12 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:29:10 +1100
Date:   Fri, 28 Jan 2022 17:29:10 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org,
        mirq-linux@rere.qmqm.pl, gregkh@linuxfoundation.org,
        peterz@infradead.org, David.Laight@aculab.com, joe@perches.com,
        dennis@kernel.org, kernel@esmil.dk, npiggin@gmail.com,
        matti.vaittinen@fi.rohmeurope.com, aklimov@redhat.com,
        linux-kernel@vger.kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 21/54] kernel: replace cpumask_weight with cpumask_empty
 in padata.c
Message-ID: <YfONNmDkwcKK+Ik2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123183925.1052919-22-yury.norov@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Yury Norov <yury.norov@gmail.com> wrote:
> padata_do_parallel() calls cpumask_weight() to check if any bit of a
> given cpumask is set. We can do it more efficiently with cpumask_empty()
> because cpumask_empty() stops traversing the cpumask as soon as it finds
> first set bit, while cpumask_weight() counts all bits unconditionally.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
> kernel/padata.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
