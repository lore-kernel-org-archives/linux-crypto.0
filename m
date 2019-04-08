Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EC8C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 17:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767BD2084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554745446;
	bh=YtY9+rsM8lRZLMYflVDn6aRvxVMM3yhVaRTilSGAyrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mTiIP+zzn3DRv8Sr+K/fpC0iCtp0cydErMPjpDsTBRu12sF5/lDa5C329xyQwgNK0
	 ZTQpnQG9sm2jW2PQvpwEO/bAcNxhulxkr9PeutTfrXhp2sv5lPer+mq8VPOJVskmRH
	 kDWSv9mLEkDUYGjU2i8qH0Vu3ncfWDZwqWwb2aG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfDHRoF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 13:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfDHRoF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 13:44:05 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A7620855;
        Mon,  8 Apr 2019 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554745444;
        bh=YtY9+rsM8lRZLMYflVDn6aRvxVMM3yhVaRTilSGAyrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G96WlFINBk9PJR98SRLIHvdfS8FAz7NAYsS5KWyFMr0ismRJH6qwCIJITBnZqRkHK
         ZysWw1bS2oqzfDBQaY8AE+17s5l3aczytv2DfEELeQbfgmAKJhXFA7o3rEpQMPBgqJ
         JC+Bp+Tvgos9hOKkOXPvAOlzs4H1RiFsTYdzthNc=
Date:   Mon, 8 Apr 2019 10:44:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 18/18] crypto: run initcalls for generic
 implementations earlier
Message-ID: <20190408174402.GB9145@gmail.com>
References: <20190331200428.26597-19-ebiggers@kernel.org>
 <20190408055322.kke6emtixhhbkppn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408055322.kke6emtixhhbkppn@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 01:53:22PM +0800, Herbert Xu wrote:
> Hi Eric:
> 
> Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Use subsys_initcall for registration of all templates and generic
> > algorithm implementations, rather than module_init.
> 
> I think this is fine except that algboss already hooks in at
> subsys_initcall and either it needs to move further up or we
> need to change these ones to occur after subsys_initcall.
> 
> Otherwise the generic algorithms themselves may not get tested
> if algboss isn't loaded first.
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

My patch also moved cryptomgr earlier in the Makefile, so it's linked first.  Do
you think that's too fragile?  Otherwise, I'll probably change cryptomgr_init()
to arch_initcall().

BTW, I found another problem caused by allocating the generic implementation
during the self-tests, which is that the generic implementation will fulfill any
outstanding allocation requests before the other implementation has finished
testing.  E.g. on x86_64, the first call to

	crypto_alloc_skcipher("adiantum(xchacha12,aes)", 0, 0)

will get "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)" rather
than "adiantum(xchacha12-simd,aes-aesni,nhpoly1305-avx2)" as expected.  Do you
have any suggestion on the best way to fix this?

- Eric
