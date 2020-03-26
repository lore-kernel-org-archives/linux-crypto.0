Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BCEC43331
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0147720719
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgCZEjA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 00:39:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49850 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgCZEjA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 00:39:00 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jHKID-0004BY-C5; Thu, 26 Mar 2020 15:38:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2020 15:38:57 +1100
Date:   Thu, 26 Mar 2020 15:38:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH crypto] crypto: arm[64]/poly1305 - add artifact to
 .gitignore files
Message-ID: <20200326043857.GA6690@gondor.apana.org.au>
References: <20200319180114.6437-1-Jason@zx2c4.com>
 <CAHmME9p5KnsUpRCve3_6ugobG9c-fnqQgNOE8F28CX4SvsTX1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9p5KnsUpRCve3_6ugobG9c-fnqQgNOE8F28CX4SvsTX1w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 25, 2020 at 10:32:41PM -0600, Jason A. Donenfeld wrote:
> I think this might have slipped through the cracks?

It's on the list:

	https://patchwork.kernel.org/project/linux-crypto/list/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
