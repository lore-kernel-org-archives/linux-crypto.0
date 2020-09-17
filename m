Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B219C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 08:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1952075B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 08:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgIQILO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:11:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54830 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgIQIK5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 04:10:57 -0400
X-Greylist: delayed 2637 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:10:55 EDT
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kIoJY-0004gr-B0; Thu, 17 Sep 2020 17:26:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Sep 2020 17:26:44 +1000
Date:   Thu, 17 Sep 2020 17:26:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200917072644.GA5311@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916233042.51634-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When a CPU selects which CRNG to use, it accesses crng_node_pool without
> a memory barrier.  That's wrong, because crng_node_pool can be set by
> another CPU concurrently.  Without a memory barrier, the crng_state that
> is used might not appear to be fully initialized.

The only architecture that requires a barrier for data dependency
is Alpha.  The correct primitive to ensure that barrier is present
is smp_barrier_depends, or you could just use READ_ONCE.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
