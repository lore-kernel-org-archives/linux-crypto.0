Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A1DC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 02:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C0C216C8
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 02:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfHIC5z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 22:57:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35908 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbfHIC5z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 22:57:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvv6H-0004Ex-6y; Fri, 09 Aug 2019 12:57:53 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvv6E-0001uv-TP; Fri, 09 Aug 2019 12:57:50 +1000
Date:   Fri, 9 Aug 2019 12:57:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: AEAD question
Message-ID: <20190809025750.GA7357@gondor.apana.org.au>
References: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722162240.GB689@sol.localdomain>
 <MN2PR20MB2973B95A0C91380CF881FF25CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973743A8887D20AC6104DC0CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973743A8887D20AC6104DC0CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 06, 2019 at 09:20:52AM +0000, Pascal Van Leeuwen wrote:
> 
> The discussion below still lacks some resolution ...
> 
> What is boils down to is: what should an authenc AEAD driver do when it
> gets a setauthsize request of zero?

It must support zero for the special case of digest_null, which
is used to test the IPsec stack.  In other cases I'm OK with
forbidding the use of zero as the IPsec code won't allow a zero
to get through anyway (IOW you can only access this code path
via af_alg).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
