Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7062CC64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 10:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjCJKP4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCJKPw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 05:15:52 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7097D10DE4B
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 02:15:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paZmp-002Wci-KG; Fri, 10 Mar 2023 18:15:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 18:15:43 +0800
Date:   Fri, 10 Mar 2023 18:15:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB
 mode
Message-ID: <ZAsDT00Jgs2p6luL@gondor.apana.org.au>
References: <20230217144348.1537615-1-ardb@kernel.org>
 <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
 <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 20, 2023 at 08:28:05AM +0100, Ard Biesheuvel wrote:
>
> We would still not have any in-tree users of cfb(aes) or any other
> cfb(*), so in that sense, yes.
> 
> However, skciphers can be called from user space, and we also rely on
> this template for the extended testing of the various cfb() hardware
> implementations that we have in the tree.
> 
> So the answer is no, I suppose. I would like to simplify it a bit,
> though - it is a bit more complicated than it needs to be.

Could we hold onto this for a little bit? I'd like to finally
remove crypto_cipher, and in doing so I will add a virtual address
interface (i.e., not sg) to skcipher like we do with scomp and shash.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
