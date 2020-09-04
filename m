Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AD7C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 07:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56896206D4
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 07:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgIDHRR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 03:17:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42572 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgIDHRR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 03:17:17 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kE5y9-0008OZ-LB; Fri, 04 Sep 2020 17:17:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2020 17:17:09 +1000
Date:   Fri, 4 Sep 2020 17:17:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Enderborg <peter.enderborg@sony.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, peter.enderborg@sony.com
Subject: Re: [PATCH] crypto: Mark tfm buffer as non leak.
Message-ID: <20200904071709.GA24539@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903134007.2769-1-peter.enderborg@sony.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Peter Enderborg <peter.enderborg@sony.com> wrote:
>
> This is caused by tfm = (struct crypto_tfm *)(mem + tfmsize);
> that is keept instead of the allocated buffer in mem.
> Reference counting is done on alg.

I don't understand why this is necessary.  We end up returning
mem in crypto_create_tfm_node and that is the primary means of
getting to the object.

The tfm pointer is just an internal thing.  So why do we have
to mark mem as not a leak?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
