Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C7CC433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 22:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11809601FF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 22:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhCAWN0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 17:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237022AbhCAWKr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 17:10:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F5A60231;
        Mon,  1 Mar 2021 22:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614636589;
        bh=2EyZztf+czU2hOx+uTf8aKFtuzHaAtkh8pbrMOtqHck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mq7gqc1WOBkF1FtIqgG1YAlQZa5UaGLoY9snM5Goqellv1liOk0NYJp3i4rEasgll
         q2bKfgpm0HkPkJPJJBLKJETtqoneVefXgQ+L3H+uXK9Kb6waOOc42FkJIvXK/we7TL
         HKzs+tnaxCh/1ha/7XVLLLPN9qjJajw0dZF3RYw+YzVSdMek4MfjNNdawmXiAgsg8n
         /AX89Gdef1a0Gi8grxW1kx+XnMZX4oQMN0rPSxqq/fwkEMFNWJRIpUNRrWsSy4eVbN
         nVoDnuBwCs6spIVnC8SNm2W2cb8fJKt+1jdqAOxwFdcgnqbE31XhVQyalDhAWPBnbY
         79NudbDItP2lw==
Date:   Mon, 1 Mar 2021 14:09:47 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: expose needs_key in procfs
Message-ID: <YD1mK8HseZpiCWDU@gmail.com>
References: <20210301165917.2576180-1-christoph.boehmwalder@linbit.com>
 <YD02vJhFkFiARX0q@gmail.com>
 <e82c30b0-e96f-d5cd-f7a3-d97f4e049b83@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e82c30b0-e96f-d5cd-f7a3-d97f4e049b83@linbit.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 01, 2021 at 09:51:56PM +0100, Christoph Böhmwalder wrote:
> > Do you have a specific use case in mind for this information?  Normally, users
> > should already know which algorithm they want to use (or set of algorithms they
> > might want to use).
> 
> I have a pretty specific use case in mind, yes. For DRBD, we use crypto
> algorithms for peer authentication and for the online-verify mechanism (to
> verify data integrity). The peer authentication algos require a shared
> secret (HMAC), while the verify algorithms are just hash functions without
> keys (we don't configure a shared secret here, so these must explicitly be
> "keyless").
> 
> Now, we also have a solution which sits on top of DRBD (LINSTOR), which
> resides purely in userspace. We recently implemented a feature where LINSTOR
> automatically chooses the "best" verify algorithm for all nodes in a
> cluster. It does this by parsing /proc/crypto and prioritizing accordingly.
> The problem is that /proc/crypto currently doesn't contain information about
> whether or not an algorithm requires a key – i.e. whether or not it is
> suitable for DRBD's online-verify mechanism.
> 
> See this commit for some context:
> https://github.com/LINBIT/drbd/commit/34ee32e6922994c8e9390859e1790ca

Shouldn't you know ahead of time which algorithm you are using (or set of
algorithms which you might use), and not be parsing /proc/crypto and choosing
some random one (which might be a non-cryptographic algorithm like CRC-32, or
something known to be insecure like MD5)?

Using the algorithm attributes in /proc/crypto only really makes sense if the
decision of which algorithm to use is punted to a higher level and the program
just needs to be able to pass through *any* algorithm available in Linux -- like
how 'cryptsetup' works.  But it's preferable to avoid that sort of design, as it
invites users to start depending on weird or insecure things.

> > 
> > Also, what about algorithms such as blake2b-256 which optionally take a key (as
> > indicated by CRYPTO_ALG_OPTIONAL_KEY being set)?  So it's not really "yes" or
> > "no"; there is a third state as well.
> 
> Correct me if I'm missing something, but crypto_shash_alg_needs_key reads:
> 
> static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
> {
> 	return crypto_shash_alg_has_setkey(alg) &&
> 		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
> }
> 
> So this already accounts for optional keys. It just returns "no" for an
> optional key, which seems like reasonable behavior to me (it doesn't *need*
> a key after all).
> 
> Another option would be to make it "yes/no/optional". I'm not sure if that's
> more desirable for most people.
> 

BLAKE2 does need a key if it is being used as a keyed hash algorithm.  So it
depends on the user, not the algorithm per se.

- Eric
