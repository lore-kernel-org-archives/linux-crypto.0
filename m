Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746DBC433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B75061994
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhC3FCi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:02:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41010 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhC3FCf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 01:02:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lR6WE-0003wq-DN; Tue, 30 Mar 2021 16:02:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Mar 2021 16:02:22 +1100
Date:   Tue, 30 Mar 2021 16:02:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: crypto: add info about "fips=" boot option
Message-ID: <20210330050222.GA28431@gondor.apana.org.au>
References: <20210330040001.31524-1-rdunlap@infradead.org>
 <20210330043747.GA28166@gondor.apana.org.au>
 <fb76dd26-eea8-af06-6968-25719a6dba6b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb76dd26-eea8-af06-6968-25719a6dba6b@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 29, 2021 at 10:00:45PM -0700, Randy Dunlap wrote:
> On 3/29/21 9:37 PM, Herbert Xu wrote:
> > On Mon, Mar 29, 2021 at 09:00:01PM -0700, Randy Dunlap wrote:
> >>
> >> +			If fips_enabled = 1, some crypto tests are skipped.
> > 
> > I don't think any tests are skipped.  It does however disable
> > many algorithms by essentially failing them at the testing stage.
> 
> That statement was based on crypto/testmgr.c (in 4 places):
> 
> 		if (fips_enabled && template[i].fips_skip)
> 			continue;

By skipping the test, the algorithm effectively fails the self-test
and therefore is disabled.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
