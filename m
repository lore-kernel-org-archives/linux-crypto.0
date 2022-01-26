Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F95C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 22:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiAZWtH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:49:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiAZWtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 17:49:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C3F4B82059
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 22:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D202EC340E3;
        Wed, 26 Jan 2022 22:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643237345;
        bh=QthA4VnJuuhg1vXytX6lpMOpUQ+6nIBK61JvSJIkk0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/zjxvE3L4HYT1/VT6aF0MCF9MdYTIaWd8tUmEc8hE1ecP5LDb7XXEj4r5UZYk76u
         AkJufI4XSbLzPI1sjY9TbWZiU56KXx41dvFKMFjwxAM+NyarC02iQgoswTcJdCtV+Z
         BqPkLfYC3v9oNWMRu4TaDTP9FWC5sPCz2yEjUB5ngOWf0uOXXynyrmUzf5LFvwG+HM
         hFd1URYyC6pyGvctri2OwwozodLmE+NhulPzOhjfDfJtdC1pKH74C0Qbyo0klotyDk
         XsJwvfGZtcDGLhhYY4nCwpJ87EHpBslkCWmBzg3cjtswNtj100dDy0SBvCCBYOaH0x
         RhLORmgCSKmsg==
Date:   Wed, 26 Jan 2022 14:49:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        simo@redhat.com, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/7] Common entropy source and DRNG management
Message-ID: <YfHP3xs6f68wR/Z/@sol.localdomain>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 26, 2022 at 08:02:54AM +0100, Stephan Müller wrote:
> The current code base of the kernel crypto API random number support
> leaves the task to seed and reseed the DRNG to either the caller or
> the DRNG implementation. The code in crypto/drbg.c implements its own
> seeding strategy. crypto/ansi_cprng.c does not contain any seeding
> operation. The implementation in arch/s390/crypto/prng.c has yet
> another approach for seeding. Albeit the crypto_rng_reset() contains
> a seeding logic from get_random_bytes, there is no management of
> the DRNG to ensure proper reseeding or control which entropy sources
> are used for pulling data from.

ansi_cprng looks like unused code that should be removed, as does the s390 prng.

With that being the case, what is the purpose of this patchset?

- Eric
