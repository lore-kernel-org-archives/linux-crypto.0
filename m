Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DEAC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiBKJe6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:34:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiBKJe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:34:57 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A5F5B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 01:34:56 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISKK-0004R4-Rm; Fri, 11 Feb 2022 20:34:53 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:34:52 +1100
Date:   Fri, 11 Feb 2022 20:34:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v2 0/2] crypto: HMAC - disallow keys < 112 bits in FIPS
 mode
Message-ID: <YgYtvGXpzLyeYMLa@gondor.apana.org.au>
References: <2075651.9o76ZdvQCi@positron.chronox.de>
 <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
 <4609802.vXUDI8C0e8@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4609802.vXUDI8C0e8@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 01, 2022 at 09:40:24AM +0100, Stephan Müller wrote:
> Hi,
> 
> this is patch set version 2 for adding the HMAC limitation to disallow
> keys < 112 bits in FIPS mode.
> 
> Version 2 changes:
> 
> As requested, instead of ifdef'ing test vectors out that violate the
> constraint added with this patch set, they are compiled but disabled in
> FIPS mode based on the .fips_skip flag.
> 
> The first patch adds the generic support for the fips_skip flag to
> hashes / HMAC test vectors similarly to the support found for symmetric
> algorithms.
> 
> The second patch uses the fips_skip flag to mark offending test vectors.
> 
> Stephan Mueller (2):
>   crypto: HMAC - add fips_skip support
>   crypto: HMAC - disallow keys < 112 bits in FIPS mode
> 
>  crypto/hmac.c    |  4 ++++
>  crypto/testmgr.c |  3 +++
>  crypto/testmgr.h | 11 +++++++++++
>  3 files changed, 18 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
