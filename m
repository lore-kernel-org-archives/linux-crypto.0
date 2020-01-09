Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53BBC32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F002073A
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgAIFN3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:13:29 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40376 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgAIFN2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:13:28 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ8N-0003GR-OF; Thu, 09 Jan 2020 13:13:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ8M-0003VR-Vi; Thu, 09 Jan 2020 13:13:27 +0800
Date:   Thu, 9 Jan 2020 13:13:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Richard van Schagen <vschagen@cs.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: Hardware ANSI X9.31 PRNG, handling multiple context?
Message-ID: <20200109051326.axgvplafz3h5pflf@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2345369f0bf4169a1ec792545df7d409dd7fecd1.camel@cs.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Richard van Schagen <vschagen@cs.com> wrote:
> As part of my EIP93 crypto module I would like to implement the PRNG.
> This is intented to be used to automaticly insert an IV for IPSEC /
> full ESP processing, but can be used "just as PRNG" and its full ANSI
> X9.31 compliant.
> 
> Looking over the code in "ansi_cprng.c" I can implement the none "FIPS"
> part since it doesnt require a reseed everytime. For full FIPS it needs
> to be seeded by the user which means if I do this in Hardware I can not
> "switch" seeds or reseed with another one from another context becasue
> that would not give the expected results.
> 
> Is it acceptable to only implement "none-fips" and/or return an error
> (-EBUSY ?) when more than 1 call occurs to "cra_init" before the
> previous user called "cra_exit" ?

Yes you could certainly add such a PRNG.  However, please don't make
cra_init return an error.  Instead you should make all tfms of your
PRNG use the same underlying hardware PRNG.  IOW it's as if users
of those tfms are actually using just one tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
