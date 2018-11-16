Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25073C43441
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Nov 2018 06:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A6C2145D
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Nov 2018 06:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0A6C2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbeKPQNj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Nov 2018 11:13:39 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:37548 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQNj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:13:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gNXDA-0004on-2K; Fri, 16 Nov 2018 14:02:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gNXD1-0007Gm-Lc; Fri, 16 Nov 2018 14:02:27 +0800
Date:   Fri, 16 Nov 2018 14:02:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Subject: Re: [RFC PATCH v3 10/15] crypto: poly1305 - use structures for key
 and accumulator
Message-ID: <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
References: <20181105232526.173947-1-ebiggers@kernel.org>
 <20181105232526.173947-11-ebiggers@kernel.org>
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181112185816.GA8663@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181116060227.NhwyVl5DWAulQYTFRDM8ZCO4nJBKZmha4arqsFjE-KU@z>

Hi Eric:

On Mon, Nov 12, 2018 at 10:58:17AM -0800, Eric Biggers wrote:
>
> I prefer separate types so that the type system enforces that a key is never
> accidentally used as an accumulator, and vice versa.  Then the poly1305_core_*
> functions will be harder to misuse, and the Poly1305 MAC implementations harder
> to get wrong.
> 
> The key also has certain bits clear whereas the accumulator does not.  In the
> future, the Poly1305 C implementation might use base 2^32 and take advantage of
> this.  In that case, the two inputs to each multiplication won't be
> interchangeable, so using the same type for both would be extra confusing.
> 
> Having a poly1305_val nested inside poly1305_key and poly1305_state would work,
> but seemed excessive.

So it looks like there are no more unresolved issues with this
patch series.  Please let me know when you want it to go in.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
