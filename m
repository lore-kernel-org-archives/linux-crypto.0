Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F8CC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 13:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D346206DA
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 13:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHRNvg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:51:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42790 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgHRNvd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 09:51:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k821Q-0006gY-He; Tue, 18 Aug 2020 23:51:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 23:51:28 +1000
Date:   Tue, 18 Aug 2020 23:51:28 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200818135128.GA25652@gondor.apana.org.au>
References: <20200802090616.1328-1-ardb@kernel.org>
 <20200818082410.GA24497@gondor.apana.org.au>
 <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 18, 2020 at 10:31:39AM +0200, Ard Biesheuvel wrote:
>
> What do you mean? You cannot implement cbcmac using a cbc skcipher
> unless you provide a scratch buffer of arbitrary size as the
> destination, in order to capture the skcipher output IV as the MAC.

Please have a look at patch 6.  The trick is to use an SG list
chained to itself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
