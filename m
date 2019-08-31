Return-Path: <SRS0=ef2Z=W3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A44C3A59F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 12:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A89D21670
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 12:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfHaMNK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Aug 2019 08:13:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59840 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfHaMNK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Aug 2019 08:13:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i42Fa-0005nJ-NJ; Sat, 31 Aug 2019 22:13:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Aug 2019 22:12:59 +1000
Date:   Sat, 31 Aug 2019 22:12:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT] Crypto Fixes for 5.3
Message-ID: <20190831121259.GA16726@gondor.apana.org.au>
References: <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
 <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
 <20190809061548.GA10530@gondor.apana.org.au>
 <20190830073906.GA4579@gondor.apana.org.au>
 <CAHk-=whnH09S73Nfo-HMH+V-Ew39+tZdEzaLUQo41PJEo=PZZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whnH09S73Nfo-HMH+V-Ew39+tZdEzaLUQo41PJEo=PZZw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 30, 2019 at 07:01:42PM -0700, Linus Torvalds wrote:
>
> It could be in the subject line (ie change the "[GIT]" to "[GIT
> PULL]") but it could also be anywhere in the email body (ie a "please
> pull" or something like that).

Sure I'll do that for the next pull request.

I used to have the word pull in my email body but since I switched
over to git request-pull the pull word isn't there anymore.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
