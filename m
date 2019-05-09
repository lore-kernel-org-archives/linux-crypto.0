Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798D0C004C9
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 03:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4885F2175B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 03:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEIDQj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 May 2019 23:16:39 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52918 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfEIDQj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 May 2019 23:16:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hOZXp-00005y-4k; Thu, 09 May 2019 11:16:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hOZXl-00086W-RE; Thu, 09 May 2019 11:16:25 +0800
Date:   Thu, 9 May 2019 11:16:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joao Moreira <jmoreira@suse.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509031625.f6usxmqzfehrmx7r@gondor.apana.org.au>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <8c9a53b9-12e6-3380-21c8-4fe85342f0ac@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9a53b9-12e6-3380-21c8-4fe85342f0ac@suse.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 09, 2019 at 12:12:54AM -0300, Joao Moreira wrote:
>
> This is how things were done in the original patch set, but some concerns
> were raised about this approach:
> 
> https://lkml.org/lkml/2018/4/16/74

No that's not what I'm suggesting at all.  Just get rid of those
wrapper functions and change the underlying asm functions to take
a void *.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
