Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC78C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA3CF208C4
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561741480;
	bh=BsPYtytOvJul2BuzSQXvFrwBLMCrjy5hrv3TUGtD/JM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ufA/G8yG9rDaw5+c04YggG+LD7114dX+89iAjfteRd4Ube9GVI4iHsLEZ9hmPROKL
	 l2EFpD0vn292Ire/rvKj77LdGvZbvT+tZ4Hs1OVagLF9o3spELPWRt82KnC65968vS
	 Eyu0a8Sw5RKxccxpDiEVZgqBSkh2USOai9Q2Dsn4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfF1REk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfF1REk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:04:40 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B80D20645;
        Fri, 28 Jun 2019 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561741479;
        bh=BsPYtytOvJul2BuzSQXvFrwBLMCrjy5hrv3TUGtD/JM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nJG9FLuWQYEtgQYBQ9beqbOVZZghPxJUMVMF9sBn71EPG1vk4TcOffu7V3TiE7q0B
         Vfg5X2+BRaOkWZQChB8DYV6DKQnH937yJQKpC+WhSBe6xrEYcFfhsVf2qmv6YaqKr9
         1Di2m7II27dkMYENvTnoopQUwc5TCoKu+NKtzGRo=
Date:   Fri, 28 Jun 2019 10:04:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] crypto: serpent - mark __serpent_setkey_sbox
 noinline
Message-ID: <20190628170437.GA103946@gmail.com>
References: <20190618111953.3183723-1-arnd@arndb.de>
 <20190628041912.qprczc23gzeelag7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628041912.qprczc23gzeelag7@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 12:19:12PM +0800, Herbert Xu wrote:
> On Tue, Jun 18, 2019 at 01:19:42PM +0200, Arnd Bergmann wrote:
> > The same bug that gcc hit in the past is apparently now showing
> > up with clang, which decides to inline __serpent_setkey_sbox:
> > 
> > crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]
> > 
> > Marking it 'noinline' reduces the stack usage from 2112 bytes to
> > 192 and 96 bytes, respectively, and seems to generate more
> > useful object code.
> > 
> > Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > v2: style improvements suggested by Eric Biggers
> > ---
> >  crypto/serpent_generic.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Patch applied.  Thanks.
> -- 

Hi Herbert, seems you forgot to push?  I don't see this in cryptodev.

- Eric
