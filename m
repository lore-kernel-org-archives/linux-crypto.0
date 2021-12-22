Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9E6C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 22:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbhLVWZN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:25:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45978 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhLVWZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 17:25:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B7DDB81A2B
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 22:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A641AC36AE5;
        Wed, 22 Dec 2021 22:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640211911;
        bh=rCzuXorCl3+1bgwnRJj5zQ88qmuA6k9+YBq5r4CopaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mvubgbc6jnq7uU2z565x3LThPg8IaXx+wX1yebQvsV1oCEJFX8BtRxDQKPdldrRpb
         7KSQjc3oTgIQpnqHBd8Kg0ClK8Dcv9JJfW8c6qoda2n0kSrgkfLr3ZAug0FqjdLK9y
         Utce4HUccTN6lXQJMluTwN6N/bVlE7By16EaJ/z5O78J/+/x7SgXgRHw2/etX4pOSK
         wNYxs16sp39SoQbBIDtQQA8WDz5sYHEmXzbrwBP1O7/sRcsKSR95iQ7M8zgstvGOOk
         Bgr8mIWHB6QCQFqk2/Mx/vBQX6wQfmXTBlBlIUUZwoNGC9PHQUx2b/+z3Em2WYSZy9
         bbhXkZthK3EcA==
Date:   Wed, 22 Dec 2021 16:25:07 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-crypto@vger.kernel.org
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcOlw1UJizlngAEG@quark>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcOh6jij1s6KA2ee@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 23, 2021 at 09:08:42AM +1100, Herbert Xu wrote:
> On Wed, Dec 22, 2021 at 08:11:07PM +0100, Petr Vorel wrote:
> > Hi Herbert,
> > 
> > do I understand the crypto code correctly, that although crypto/testmgr.c in
> > alg_test() returns -EINVAL for non-fips allowed algorithms (that means
> > failing crypto API test) the API in crypto_alg_lookup() returns -ELIBBAD for
> > failed test?
> > 
> > Why ELIBBAD and not ENOENT like for missing ciphers? To distinguish between
> > missing cipher and disabled one due fips?
> 
> Correct.  ELIBBAD is returned for a failed self-test while ENOENT
> means that there is no algorithm at all.
> 
> This matters if there is more than one provider of the same algorithm.
> In that case ELIBBAD would only be returned if all failed the self-test.
> 

Isn't it just an implementation detail that !fips_allowed is handled by the
self-test?  Wouldn't it make more sense to report ENOENT for such algorithms?

- Eric
