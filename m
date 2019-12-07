Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0972C43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 14:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A312C21835
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 14:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLGOzH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Dec 2019 09:55:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56142 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfLGOzG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Dec 2019 09:55:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idbU9-0008KT-LQ; Sat, 07 Dec 2019 22:55:05 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idbU8-0002xs-IO; Sat, 07 Dec 2019 22:55:04 +0800
Date:   Sat, 7 Dec 2019 22:55:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/4] crypto: aead - Retain alg refcount in
 crypto_grab_aead
Message-ID: <20191207145504.gcwc75enxhqfqhxe@gondor.apana.org.au>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G9-00051G-5w@gondobar>
 <20191206224155.GE246840@gmail.com>
 <20191207033059.h6kgx7j7jtnqotuy@gondor.apana.org.au>
 <20191207045234.GA5948@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207045234.GA5948@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 08:52:34PM -0800, Eric Biggers wrote:
>
> I think the general idea is much better.  But it's not going to work as-is due
> to all the templates that directly use crypto_init_spawn(),
> crypto_init_shash_spawn(), and crypto_init_ahash_spawn().  I think they should
> be converted to use new functions crypto_grab_cipher(), crypto_grab_shash(), and
> crypto_grab_cipher(), so that everyone is consistently using crypto_grab_*().

While we should certainly convert them eventually, I don't think
they are an immediate obstacle to this patch.  We just need to
make these legacy entry points grab an extra reference count which
they can then drop as they do now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
