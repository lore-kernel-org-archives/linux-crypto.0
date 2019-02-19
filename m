Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39300C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 05:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1475C217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 05:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbfBSFqL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 00:46:11 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:35764 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSFqL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 00:46:11 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gvyDf-0007Yn-2p; Tue, 19 Feb 2019 13:45:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gvyDC-0007b8-Ah; Tue, 19 Feb 2019 13:44:58 +0800
Date:   Tue, 19 Feb 2019 13:44:58 +0800
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
Message-ID: <20190219054458.ldwl26npnyg7ulic@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com>
 <1798550.XZem68xxzE@tauon.chronox.de>
 <20190208080547.224fudg2m22d3a6d@gondor.apana.org.au>
 <2047284.dgeq8KlW64@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2047284.dgeq8KlW64@tauon.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 08, 2019 at 09:17:50AM +0100, Stephan Mueller wrote:
> > 
> > > Also, shall we add the signature verification enforcemnt to the helper as
> > > well?
> > 
> > What do you mean by that?
> 
> We need to invoke the function crypto_check_module_sig when the module is 
> loaded. Do you have any concerns invoking it from the module init function?

Which module's signature are you going to check? If it's the
underlying crypto API modules then wouldn't they have been
checked already when they were registered?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
