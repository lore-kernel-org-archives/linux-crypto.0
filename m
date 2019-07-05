Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34FFC46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 19:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC3F8216FD
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562355380;
	bh=HpLTg9AXO5LnVgRNnX2OfHwb6jJdZkkgjobt5RKI+II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RmP/APYecFg+j2ZLMyzjfktqFzPvhf/Rq69yKlMODEwxGIt25mA9qvgULra/y8Tpb
	 Cc7fgXnlJkUEQ+IuMRG5awqShrhP97j06N4A6/qDtCtxEOKmKByLdCdXNNRtv8KOkX
	 Xibwx6zU2zeQfQdwkZyZ1Vpt8EBJNlS1ToO3bK0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfGETgP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 15:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbfGETgP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 15:36:15 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9454220989;
        Fri,  5 Jul 2019 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562355374;
        bh=HpLTg9AXO5LnVgRNnX2OfHwb6jJdZkkgjobt5RKI+II=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L2p0PFaC0mZ6mq80pfNo4z/aIruBPzGrCExUny1/dZW5I9ET/lwQcAKJEhnD1n0y0
         qkQDV6ReGUL4D+YyfSAYw/4svEwBFaqkfP0uEsv487GwFPPdAbriLeyOVNxuau9HXB
         /d6j0C6TliqlYMXIy5KTdeNnXQ9u8fUAg37m+v3c=
Date:   Fri, 5 Jul 2019 12:36:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: testmgr fuzzing for AEAD ciphers
Message-ID: <20190705193613.GA4022@sol.localdomain>
References: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB297300C9DA57540354107BEBCAFA0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Thu, Jul 04, 2019 at 08:37:11AM +0000, Pascal Van Leeuwen wrote:
> Hi,
> 
> I was attempting to get some fuzzing going for the RFC3686 AEAD ciphers I'm adding to the 
> inside-secure driver, and I noticed some more things besides what I mentioned below:
> 
> 1) If there is no test suite, but the entry does point to something other then alg_test_null,
> then fuzzing is still not performed if there is no test suite, as all of the alg_test_xxx routines
> first check for suite->count being > 0 and exit due to count being 0 in this case.
> I would think that if there are no reference vectors, then fuzzing against the generic 
> implementation (if enabled) is the very least you can do?
> 
> 2) The AEAD fuzzing routine attempts to determine the maximum key size by actually
> scanning the test suite. So if there is no test suite, this will remain at zero and the AEAD
> fuzzing routine will still exit without performing any tests because of this.
> Isn't there a better way to determine the maximum key size for AEAD ciphers?
> 
> 3) The AEAD fuzzing vector generation generates fully random keydata that is <= maxlen.
> However, for AEAD ciphers, the key blob is actually some RTA struct containing length
> fields and types. Which means that most of the time, it will simply be generating illegal
> key blobs and you are merely testing whether both implementations correctly flag the
> key as illegal. (for which they likely use the same crypto_authenc_extractkeys
> subroutine, so that check probably/likely always passes - and therefore is not very useful)
> 

Yes, these are real issues; we need to make the testing code smarter and perhaps
add some more test vectors too.  But just to clarify (since you keep using the
more general phrase "AEAD ciphers"), these issues actually only apply to RFC3686
ciphers, a.k.a. algorithms with "authenc" in their name, not to other AEADs in
the crypto API such as GCM, ChaCha20-Poly1305, and AEGIS128.

There's no way to easily determine the max key size of an arbitrary AEAD
currently, since it's not stored in struct aead_alg.  That's why the current
code is scanning the test vectors.  Instead, we probably should store
information about the supported key sizes and formats directly in struct
alg_test_desc, independent of the test vectors themselves.  That would make it
possible to solve all three issues you've identified.

- Eric
