Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9A2C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB6C21917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfBHHqr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:46:47 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34200 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHqq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:46:46 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0rX-0000jx-H9; Fri, 08 Feb 2019 15:46:15 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0rG-0002RD-5P; Fri, 08 Feb 2019 15:45:58 +0800
Date:   Fri, 8 Feb 2019 15:45:58 +0800
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
Message-ID: <20190208074558.j3k6gw66q4e2y2lv@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com>
 <5418064.ltLFQScYi2@tauon.chronox.de>
 <20190130100854.iey2mbmz6777pn2n@gondor.apana.org.au>
 <12103603.N4N57GesWC@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12103603.N4N57GesWC@tauon.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 30, 2019 at 03:39:10PM +0100, Stephan Mueller wrote:
> Am Mittwoch, 30. Januar 2019, 11:08:54 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > I'm still not convinced why this needs to go into the crypto API
> > instead of being hosted in a helper which should achieve pretty
> > much the same result.
> 
> How do you propose to handle the FIPS 140-2 related requirements of enforcing 
> the integrity test result and the known-answer self tests?

We could easily add self-tests for the helper.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
