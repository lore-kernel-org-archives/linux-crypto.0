Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E054DC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972FB21D41
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603737583;
	bh=7VmhnHRkwkCNWziVvSpwif+hE8EvvT/r7OJAvNDEhz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wkxoii4jWbPs7jv1qpZ1J9JtA0Upa9kEluQuujDsmZfNm1UGuZOr74wa1iipR4a60
	 jg+oMTy8ofhiHIX6vNBtxTq5wM2duMVhN6NsuVDMIXHW0Qwln+wWT/RgjUYvr5kDyY
	 Ph/XRsTvA3Hq/r5VR/J5EzI/HXMRSzY7OJUbWvSI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790100AbgJZSjj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 14:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1741485AbgJZSjj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 14:39:39 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4152084C;
        Mon, 26 Oct 2020 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603737578;
        bh=7VmhnHRkwkCNWziVvSpwif+hE8EvvT/r7OJAvNDEhz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4m0UFZbr26BzGxHLiHYpbVuFRZtg9GrOwzWOJU9mVMavylkIeZhVVJFg+/I81tFK
         SIuOw7GoaH+CT2wdVC8TrnSGWROQxIO1cPzaIti2DC0j2HymzmOgSdVNIatT0f7Rvi
         XxMVFJUtLfl+5euCYkTAWP4U0nccEK0q7iXc18Wo=
Date:   Mon, 26 Oct 2020 11:39:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
Message-ID: <20201026183936.GJ858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain>
 <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 07:29:57PM +0100, Milan Broz wrote:
> On 26/10/2020 18:52, Eric Biggers wrote:
> > On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
> >> Replace the explicit EBOIV handling in the dm-crypt driver with calls
> >> into the crypto API, which now possesses the capability to perform
> >> this processing within the crypto subsystem.
> >>
> >> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >>
> >> ---
> >>  drivers/md/Kconfig    |  1 +
> >>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
> >>  2 files changed, 20 insertions(+), 42 deletions(-)
> >>
> >> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> >> index 30ba3573626c..ca6e56a72281 100644
> >> --- a/drivers/md/Kconfig
> >> +++ b/drivers/md/Kconfig
> >> @@ -273,6 +273,7 @@ config DM_CRYPT
> >>  	select CRYPTO
> >>  	select CRYPTO_CBC
> >>  	select CRYPTO_ESSIV
> >> +	select CRYPTO_EBOIV
> >>  	help
> >>  	  This device-mapper target allows you to create a device that
> >>  	  transparently encrypts the data on it. You'll need to activate
> > 
> > Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
> > Bitlocker compatibility support, they can select this option themselves.
> 
> Please no! Until this move of IV to crypto API, we can rely on
> support in dm-crypt (if it is not supported, it is just a very old kernel).
> (Actually, this was the first thing I checked in this patchset - if it is
> unconditionally enabled for compatibility once dmcrypt is selected.)
> 
> People already use removable devices with BitLocker.
> It was the whole point that it works out-of-the-box without enabling anything.
> 
> If you insist on this to be optional, please better keep this IV inside dmcrypt.
> (EBOIV has no other use than for disk encryption anyway.)
> 
> Or maybe another option would be to introduce option under dm-crypt Kconfig that
> defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
> selects these IVs/modes.
> But requiring some random switch in crypto API will only confuse users.

CONFIG_DM_CRYPT can either select every weird combination of algorithms anyone
can ever be using, or it can select some defaults and require any other needed
algorithms to be explicitly selected.

In reality, dm-crypt has never even selected any particular block ciphers, even
AES.  Nor has it ever selected XTS.  So it's actually always made users (or
kernel distributors) explicitly select algorithms.  Why the Bitlocker support
suddenly different?

I'd think a lot of dm-crypt users don't want to bloat their kernels with random
legacy algorithms.

- Eric
