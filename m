Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58462CE79AD
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 06:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjITG0D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 02:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjITG0C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 02:26:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8A99
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 23:25:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6957C433C8;
        Wed, 20 Sep 2023 06:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695191152;
        bh=8HUuNtkf22Rxrb0JqBDE5eeuzu96jbxQjTL30cOOl7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bAK+zYHI5aWxBCCCB2w2xrI3GX8RK6eKdre1Te0dDIjTwyzlJY8UahLEWqUX5zDiP
         dzLEXNuWpRHxV6NAMdosPx4A90OQRwDXG5ro9UV0Y6KCa29b0DE6SsTwdcNpHG1A6m
         gTylTut58gZEzcerjT6OaDAHWXmD5MURx69ZByrZj2hnSA++/ABsMjiF0LpQ/FzFdM
         see6Nofk8wKxgYZmw53xnrpCcHfFj+FfBDVDQ/oiyQYmhtNUAZqcLLL9874r/7jbm6
         MC2ng0EEjLF8PzNab8pf+ZKsaqIWg2fDsMoGNCEp4B7e2n8ANuXnXhD1yO1W4ac8UA
         p5L9Ep6SuLS5w==
Date:   Tue, 19 Sep 2023 23:25:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <20230920062551.GB2739@sol.localdomain>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914082828.895403-5-herbert@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 04:28:24PM +0800, Herbert Xu wrote:
> Add a new API type lskcipher designed for taking straight kernel
> pointers instead of SG lists.  Its relationship to skcipher will
> be analogous to that between shash and ahash.

Is lskcipher only for algorithms that can be computed incrementally?  That would
exclude the wide-block modes, and maybe others too.  And if so, what is the
model for incremental computation?  Based on crypto_lskcipher_crypt_sg(), all
the state is assumed to be carried forward in the "IV".  Does that work for all
algorithms?  Note that shash has an arbitrary state struct (shash_desc) instead.

- Eric
