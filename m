Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0CBC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 04:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F0B21951
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 04:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfGZEbe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 00:31:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46284 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfGZEbe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 00:31:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqrt2-0004DT-7H; Fri, 26 Jul 2019 14:31:20 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqrsz-0000Ay-K3; Fri, 26 Jul 2019 14:31:17 +1000
Date:   Fri, 26 Jul 2019 14:31:17 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org,
        ebiggers@google.com, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org, gilad@benyossef.com,
        gmazyland@gmail.com
Subject: Re: [PATCH v8 1/7] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190726043117.GA654@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704183017.31570-2-ard.biesheuvel@linaro.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> + * The typical use of this template is to instantiate the skcipher
> + * 'essiv(cbc(aes),aes,sha256)', which is the only instantiation used by
> + * fscrypt, and the most relevant one for dm-crypt. However, dm-crypt
> + * also permits ESSIV to be used in combination with the authenc template,
> + * e.g., 'essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)', in which case
> + * we need to instantiate an aead that accepts the same special key format
> + * as the authenc template, and deals with the way the encrypted IV is
> + * embedded into the AAD area of the aead request. This means the AEAD
> + * flavor produced by this template is tightly coupled to the way dm-crypt
> + * happens to use it.

IIRC only authenc is allowed in dm-crypt currently in conjunction
with ESSIV.  Does it ever allow a different hash algorithm in
authenc compared to the one used for ESSIV? IOW given

	essiv(authenc(hmac(X),cbc(Y)),Z,U)

is it currently possible for X != U or Y != Z? If not then let's
just make the algorithm name be essiv(Y,X).

Because this is legacy stuff, I don't want it to support any more
than what is currently being supported by dm-crypt.

Similary for the skcipher case, given

	essiv(cbc(X),Y,Z)

is it ever possible for X != Y? If not then we should just make the
algorithm name essiv(X,Z).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
