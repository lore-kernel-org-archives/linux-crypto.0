Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7599CC7EE2C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbjFBVjx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 17:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbjFBVjw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 17:39:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA9A3;
        Fri,  2 Jun 2023 14:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B63618A0;
        Fri,  2 Jun 2023 21:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2C7C433D2;
        Fri,  2 Jun 2023 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685741990;
        bh=jJcEafNEBlo7FHkto+qtCLWl4ZJ3NoLaWu0A7agnlOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CvYwJpEkEv2IeDbVrM7f1xbTHhw59xgQ7iXNAUXEIQxjqSfDUJTu5/JCuyzEYHaTm
         l/Ix0E97QmvKv8DY6oTWypTkPrpEQlUOPuBl2dPmiLwWlSuqFIOU5E3CQpE6dH7fYN
         Lv/zaA4zvS3Trh1LCau6D8jnRaWx1xesrW7wfI+SsKbeHOhgXsGOWdSMKakxeTDbPW
         1fTRZ7gFV+cXZcnGe8HBYJ8wePxWpfV5VfV1rOuMXrjpkAxMEhxuUEmOceHJlzMzjX
         jmpg72WzjBC9+n4u+4SWIqwtMIPdnxmon/PcFOIMb9Wp0v/lgOptHM5gfCchjMj2QP
         YS10NsTYZGRXQ==
Date:   Fri, 2 Jun 2023 14:39:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dongsoo Lee <letrhee@nsr.re.kr>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, letrhee@gmail.com
Subject: Re: [PATCH v2 0/2] crypto: LEA block cipher implementation
Message-ID: <20230602213946.GD628@quark.localdomain>
References: <20230525121301.722682-1-letrhee@nsr.re.kr>
 <ZHh1H3yKPU68J7Uv@gondor.apana.org.au>
 <008d01d99518$33db63f0$9b922bd0$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008d01d99518$33db63f0$9b922bd0$@nsr.re.kr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 02, 2023 at 03:05:16PM +0900, Dongsoo Lee wrote:
> Additionally, we are exploring the possibility of using `blk-crypto` for
> encryption. Currently, the ciphers available for `blk-crypto` are
> AES-256-XTS, AES-128-CBC-ESSIV, Adiantum, and SM4-XTS. We would like to add
> LEA-256-XTS to these.
> 
> ( https://github.com/torvalds/linux/blob/master/block/blk-crypto.c#L21 )
> 
> Instead of disk encryption, it is also possible to use `fscrypt` to encrypt
> the file system for data-at-rest environments. `fscrypt` currently supports
> AES-256-XTS, AES-256-CTS-CBC, AES-128-CBC-ESSIV, AES-128-CTS-CBC, SM4-XTS,
> SM4-CTS-CBC, Adiantum, and AES-256-HCTR2.
> 
> ( https://github.com/torvalds/linux/blob/master/fs/crypto/keysetup.c#L16 )
> 

Currently the only user of blk-crypto is fscrypt.  So the above two paragraphs
are really talking about the same thing.

I haven't seen any patch that proposes adding LEA support to fscrypt.  Also, I'm
not sure that the information you've provided so far is sufficient motivation
for adding it to fscrypt.  I did recently allow another national pride cipher,
SM4, to be added to fscrypt, but that was only because a user said they were
being *required* to use SM4.  It's not clear that's the case for LEA.

- Eric
