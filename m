Return-Path: <SRS0=r3Tc=N4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF05AC43441
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 00:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD36208E3
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 00:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4yzaPld"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FD36208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbeKQKbx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Nov 2018 05:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbeKQKbx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 05:31:53 -0500
Received: from gmail.com (unknown [104.132.1.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA15220858;
        Sat, 17 Nov 2018 00:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542413841;
        bh=WpEAHFm4qMfhy3vUHXMiKwnE4dfkSNHY+5kWRx9RK8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R4yzaPldqmSVztUbPHl15yAiBkyi6+ELaVMrWL09jIrjFc20OfHBYSfZ61yg0DG8R
         2KD06oJOEgE0SHQjAhng8UgvcWcX8GEg7H1z7+ECoABU18KCiLbSMVUipXTlNmGCgX
         xMwACrFFNQPKWdHG8jNPyzBvWlEJ+EfGisDyEFRc=
Date:   Fri, 16 Nov 2018 16:17:19 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
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
Message-ID: <20181117001718.GA175522@gmail.com>
References: <20181105232526.173947-1-ebiggers@kernel.org>
 <20181105232526.173947-11-ebiggers@kernel.org>
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com>
 <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181117001719.-MEcgwNlEl07DxOt7VZwfoDpL0LXhUA7VoQK3PzrbzM@z>

Hi Herbert,

On Fri, Nov 16, 2018 at 02:02:27PM +0800, Herbert Xu wrote:
> Hi Eric:
> 
> On Mon, Nov 12, 2018 at 10:58:17AM -0800, Eric Biggers wrote:
> >
> > I prefer separate types so that the type system enforces that a key is never
> > accidentally used as an accumulator, and vice versa.  Then the poly1305_core_*
> > functions will be harder to misuse, and the Poly1305 MAC implementations harder
> > to get wrong.
> > 
> > The key also has certain bits clear whereas the accumulator does not.  In the
> > future, the Poly1305 C implementation might use base 2^32 and take advantage of
> > this.  In that case, the two inputs to each multiplication won't be
> > interchangeable, so using the same type for both would be extra confusing.
> > 
> > Having a poly1305_val nested inside poly1305_key and poly1305_state would work,
> > but seemed excessive.
> 
> So it looks like there are no more unresolved issues with this
> patch series.  Please let me know when you want it to go in.
> 

I believe it's ready to go in.  I'll need to rebase it onto cryptodev, to
resolve some small conflicts with the recent ChaCha20-related changes.  Also
I'll probably omit the fscrypt patch (patch 15/15) so that that patch can be
taken through the fscrypt tree instead.

Do you prefer that this be merged before or after Zinc?  It seems it may still
be a while before the community is satisfied with Zinc (and Wireguard which is
in the same patchset), and I don't want this blocked unnecessarily...  So on my
part I'd prefer to just have this merged as-is.

Of course, it's always possible to change the xchacha12 and xchacha20
implementations later, whether that's to use "Zinc" or otherwise.  And
NHPoly1305 and Adiantum itself will be the same either way, except that the
Poly1305 helpers may change slightly.

What do you think?

Thanks!

- Eric
