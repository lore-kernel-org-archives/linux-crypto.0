Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6CAC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jan 2022 23:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiAGX2g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jan 2022 18:28:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45516 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiAGX2f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jan 2022 18:28:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8233FB82411
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jan 2022 23:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19524C36AE9;
        Fri,  7 Jan 2022 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641598113;
        bh=MBq+Ok3mCpAgc7rJACvW+rvwe6/7NsA2f+PjEX5S9vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=heIKHBBfim0R1Q/txR9UMQtdW10pn2lvdZD339P6kfVKYK45eUDAxiWm1eGp1vZa+
         sI1K0DRN3Em3cAI5or941giT3Ejkufy5n98gbc4R6quGbOTImMTOhq3dU8PKuln4Ye
         WCdfbm8msRgLK1tZSL8Iq6GCiZrIid2Q9xStdpcgTSIbYf47pMiE5a16tQZ6pw4GL7
         QNxJvZ4O0oXNJYOaBix4Fe7idmRHOVszamsAuE4vVCW+72ckA51bSEa3wKDftDvdlI
         BnhSxqsOI2C9DIWyPZlLpU9gDHe0WOCjKZdm7eJohv5qkDzXBnuymz5uoIIx9wZrVx
         fHgGUqpZdKBxA==
Date:   Fri, 7 Jan 2022 15:28:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Niolai Stange <nstange@suse.com>, Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Message-ID: <YdjMn75GFEOLvoDr@sol.localdomain>
References: <2075651.9o76ZdvQCi@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2075651.9o76ZdvQCi@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Fri, Jan 07, 2022 at 08:25:24PM +0100, Stephan Müller wrote:
> FIPS 140 requires a minimum security strength of 112 bits. This implies
> that the HMAC key must not be smaller than 112 in FIPS mode.
> 
> This restriction implies that the test vectors for HMAC that have a key
> that is smaller than 112 bits must be disabled when FIPS support is
> compiled.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

This could make sense, but the weird thing is that the HMAC code has been like
this from the beginning, yet many companies have already gotten this exact same
HMAC implementation FIPS-certified.  What changed?

- Eric
