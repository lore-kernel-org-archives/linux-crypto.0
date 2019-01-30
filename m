Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22D9C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 10:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0CB2184D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 10:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfA3KJv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:09:51 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:37442 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfA3KJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 05:09:50 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gomnq-0006RY-7X; Wed, 30 Jan 2019 18:09:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gomne-0000ZS-Uz; Wed, 30 Jan 2019 18:08:54 +0800
Date:   Wed, 30 Jan 2019 18:08:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/6] General Key Derivation Function Support
Message-ID: <20190130100854.iey2mbmz6777pn2n@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com>
 <9733066.Vrs4h5eWcW@positron.chronox.de>
 <2082192.jPI8ve1O8G@positron.chronox.de>
 <5418064.ltLFQScYi2@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5418064.ltLFQScYi2@tauon.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 28, 2019 at 11:07:28AM +0100, Stephan Mueller wrote:
> Am Mittwoch, 16. Januar 2019, 12:06:54 CET schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > Changes v2:
> > * Incorporation of all comments from Eric Biggers
> > 
> > Stephan Mueller (6):
> >   crypto: add template handling for RNGs
> >   crypto: kdf - SP800-108 Key Derivation Function
> >   crypto: kdf - add known answer tests
> >   crypto: hkdf - HMAC-based Extract-and-Expand KDF
> >   crypto: hkdf - add known answer tests
> >   crypto: tcrypt - add KDF test invocation
> > 
> >  crypto/Kconfig                |  13 +
> >  crypto/Makefile               |   2 +
> >  crypto/hkdf.c                 | 272 +++++++++++++++++++
> >  crypto/kdf_sp800108.c         | 491 ++++++++++++++++++++++++++++++++++
> >  crypto/rng.c                  |  44 +++
> >  crypto/tcrypt.c               |   8 +
> >  crypto/testmgr.c              | 245 +++++++++++++++++
> >  crypto/testmgr.h              | 198 ++++++++++++++
> >  include/crypto/internal/rng.h |  26 ++
> >  9 files changed, 1299 insertions(+)
> >  create mode 100644 crypto/hkdf.c
> >  create mode 100644 crypto/kdf_sp800108.c
> 
> Do you happen to have any comments on this patch set?

I'm still not convinced why this needs to go into the crypto API
instead of being hosted in a helper which should achieve pretty
much the same result.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
