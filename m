Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C85C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 06:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPGBS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 01:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPGBS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 01:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCF9305D3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 22:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF268B825D5
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 06:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD8CC433EF;
        Thu, 16 Feb 2023 06:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527274;
        bh=B8EnOWQp9IW+EksHEviZXan3nsADXulpFP1iibm9HLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDn+bmHsf9aF8r0eSYNf5pPgKVsTv7fJed4i9sGjSR2s7jZmJd0ngpPAeY58t2IBw
         8YvvAKGfbcumIuXtNgjRtRoL5enAhDxnOrpFv282JEc6ZNZiII7wyzmTJOCaLmBmLV
         Vsut30h4y7FTPfYmh7cCmGcOkNT6EszPuCjS5d8XdDLgcQILSdLorP6Tqw2/CfwJDU
         wyaM8/GN/220CToV90gF9cckhQd2f9+iXDlxXrro5FAmnSFFKi2GbGn9qup9Eim/Bh
         wcdCKO/YkkEbBlrRMVvrViXE9KJr13MNBXvav/qim8yPV1oPg5BGa3BowXNC0lMXeO
         ZqXSoB2LQDHgA==
Date:   Wed, 15 Feb 2023 22:01:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 8/10] crypto: rng - Count error stats differently
Message-ID: <Y+3GqFH/DQw3mfYn@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2T-00BVlo-VL@formenos.hmeau.com>
 <Y+3DOhaA7F4/nUwT@sol.localdomain>
 <Y+3FlS3c/MOEogt+@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3FlS3c/MOEogt+@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 16, 2023 at 01:56:37PM +0800, Herbert Xu wrote:
> On Wed, Feb 15, 2023 at 09:46:34PM -0800, Eric Biggers wrote:
> >
> > Please keep field comments in the same order as the fields themselves.
> 
> Is that a requirement of kdoc? Because we may need to rearrange
> the fields from time to time in order to minimise unnecessary
> padding and moving comments around at the same time woulds seem
> to create unnecessary churn.
> 

scripts/kernel-doc doesn't complain.  It makes it harder to find the
documentation if it's in some random order, though.

- Eric
