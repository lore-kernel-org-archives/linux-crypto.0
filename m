Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4759DC433F7
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E09620739
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 11:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgGPL5P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 07:57:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40154 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgGPL4V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 07:56:21 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw2Us-00005M-6p; Thu, 16 Jul 2020 21:56:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 21:56:18 +1000
Date:   Thu, 16 Jul 2020 21:56:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] crypto: xts - prefix function and struct names with "xts"
Message-ID: <20200716115618.GA31633@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711033428.134567-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Overly-generic names can cause problems like naming collisions,
> confusing crash reports, and reduced grep-ability.  E.g. see
> commit d099ea6e6fde ("crypto - Avoid free() namespace collision").
> 
> Clean this up for the xts template by prefixing the names with "xts_".
> 
> (I didn't use "crypto_xts_" instead because that seems overkill.)
> 
> Also constify the tfm context in a couple places, and make
> xts_free_instance() use the instance context structure so that it
> doesn't just assume the crypto_skcipher_spawn is at the beginning.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/xts.c | 137 +++++++++++++++++++++++++++------------------------
> 1 file changed, 72 insertions(+), 65 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
