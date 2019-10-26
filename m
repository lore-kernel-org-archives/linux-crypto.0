Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5293CA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 16:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CD32084C
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572106800;
	bh=wFjMu8m3ai3Ct8xrKw9TUr8s16HjDW6xboREIc7VQ7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sTf21T/tOgw1u4s4u34zEW1lpmVDbfHUfHbX3Hj3BDoB/wAbNH/RRe2ndohdWqyFf
	 joeciYTCPb8n75/R1bzNFSIt3xGh0lrZ6BOuE6RshgC3Hkh8qL4u5lfGsgOtOgSFQd
	 7Nfu0eAqkyx0Ui3CzrsRqQMvBx0lHPEDEx9KQr9M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfJZQT7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 12:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfJZQT7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 12:19:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6452084C;
        Sat, 26 Oct 2019 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572106798;
        bh=wFjMu8m3ai3Ct8xrKw9TUr8s16HjDW6xboREIc7VQ7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5rmBx5qBTZ9QmZoXn0AKrljr7CxAaNjzzu6YA5HePqSJri3kZ9J+G9QwRGjayYcs
         CWjW02CKUQXErd2fUP+dva5ZTNOLMge/M5An913YPEjs/hiOG6no8CfzMDHYC+hln7
         rmbCoQ87Bwjzz4DDVl7Bvwed2GqDIptyGAqJoTxg=
Date:   Sat, 26 Oct 2019 09:19:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/5] crypto: remove blkcipher
Message-ID: <20191026161945.GA736@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
 <CAKv+Gu8Y2AnWfz8Up9V6YF9v7n-s_BYsMXbxMQ7s4tMNw5eusQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8Y2AnWfz8Up9V6YF9v7n-s_BYsMXbxMQ7s4tMNw5eusQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 26, 2019 at 05:32:05PM +0200, Ard Biesheuvel wrote:
> On Fri, 25 Oct 2019 at 21:45, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Now that all "blkcipher" algorithms have been converted to "skcipher",
> > this series removes the blkcipher algorithm type.
> >
> > The skcipher (symmetric key cipher) algorithm type was introduced a few
> > years ago to replace both blkcipher and ablkcipher (synchronous and
> > asynchronous block cipher).  The advantages of skcipher include:
> >
> >   - A much less confusing name, since none of these algorithm types have
> >     ever actually been for raw block ciphers, but rather for all
> >     length-preserving encryption modes including block cipher modes of
> >     operation, stream ciphers, and other length-preserving modes.
> >
> >   - It unified blkcipher and ablkcipher into a single algorithm type
> >     which supports both synchronous and asynchronous implementations.
> >     Note, blkcipher already operated only on scatterlists, so the fact
> >     that skcipher does too isn't a regression in functionality.
> >
> >   - Better type safety by using struct skcipher_alg, struct
> >     crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.
> >
> >   - It sometimes simplifies the implementations of algorithms.
> >
> > Also, the blkcipher API was no longer being tested.
> >
> > Eric Biggers (5):
> >   crypto: unify the crypto_has_skcipher*() functions
> >   crypto: remove crypto_has_ablkcipher()
> >   crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
> >   crypto: remove the "blkcipher" algorithm type
> >   crypto: rename the crypto_blkcipher module and kconfig option
> >
> 
> 
> For the series
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> although obviously, this needs to wait until my albkcipher purge
> series is applied.
> 

Why does it need to wait?  This just removes blkcipher, not ablkcipher.

- Eric
