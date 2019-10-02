Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC4DC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB28F21920
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570026655;
	bh=ZYdzo0Px946IuNxwqPNu5QFnVbYhubUDkbwdLukdGbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZggFKyN3odwMTTPxZ+ZrJ6wLfG6vLyeLMyJRzGiLpo/cATB7Rd8MPuRzxqqa1aszA
	 ztebWKr3XzV05wUhxRX6ifiLt/jsLTdNnuaCfeJdIpfvIIKOx3Gkj+bCWXBymmMkE+
	 0gvcwF5kP/D8onhlEM7TPqVclU9Jr8/FPcwA4ZIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfJBOaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfJBOay (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:30:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3AD21783;
        Wed,  2 Oct 2019 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570026653;
        bh=ZYdzo0Px946IuNxwqPNu5QFnVbYhubUDkbwdLukdGbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jggd4mpRQSRlnZNkoNRHkIADKII5FXJAxS09CRTobQ8Uj5N1xC0Db5BLPIehGn+wE
         7ftmD7qLCVolKlXF3yNDVoGkELvj/u49LC/A0qYTj6aS/ciyuS5Li/9FWI7smWj+qx
         6OqoUQOfdx7ei2WwhC5m1CxPhnnbbhZ3L5PhcdU8=
Date:   Wed, 2 Oct 2019 16:30:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 01/20] crypto: chacha - move existing library code
 into lib/crypto
Message-ID: <20191002143050.GA1743118@kroah.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:16:54PM +0200, Ard Biesheuvel wrote:
> Move the existing shared ChaCha code into lib/crypto, and at the
> same time, split the support header into a public version, and an
> internal version that is only intended for consumption by crypto
> implementations.
> 
> At the same time, refactor the generic implementation so it only gets
> exposed as the chacha_crypt() library function if the architecture does
> not override it with its own implementation, potentially falling back
> to the generic routine if needed.

That's a _lot_ to do all in one patch.

And you are saying _what_ you are doing, but not _why_.

Why move all this around and do these changes?  What's wrong with the
code as-is in the current location?  Is all of the crc and other
"crypto" code going to be moved into lib/crypto/ as well?

thanks,

greg k-h
