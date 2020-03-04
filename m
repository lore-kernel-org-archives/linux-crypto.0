Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF889C3F2CE
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3C62084E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583361963;
	bh=RtfsotL8na2/bdOFT2GNPlGMGsHTiwNqZ75GK/DY3v0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nAfKdia33998APvGF6FHzB5nkkf7xTB5WqkqT0lHRQq0mPtquRtU1e7jWXrffo+wq
	 tj3K7YfaPeREhI/4Bwqxo+DhsVubxYjQa3cqsZCeDN/B74hJ+c/w4QQ5uyGRlvYkhK
	 laf86FM9g/L1Lov08uysLQCuk2DqdZkuDMYaH4zc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbgCDWqD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 17:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388389AbgCDWqD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 17:46:03 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B01B20716;
        Wed,  4 Mar 2020 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361961;
        bh=RtfsotL8na2/bdOFT2GNPlGMGsHTiwNqZ75GK/DY3v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zEkBNC0Q2kzb1uj04q4Hyq/BmHvb9oMOrYf3+1gxh65CC/qEBkNXjqfO+8vq5d/KV
         4g6J7+49kFCW3q9X9JFnMMUvfX8D8a9+E4/pxKmxcV298dnvgKbFcYsPeDS/2QonXd
         oJnSB8ga8hqeQlDB2nV/ZkBfuBS2qrYhbNUnNZrE=
Date:   Wed, 4 Mar 2020 14:46:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: testmgr - sync both RFC4106 IV copies
Message-ID: <20200304224600.GD1005@sol.localdomain>
References: <20200303120925.12067-1-gilad@benyossef.com>
 <20200304000606.GB89804@sol.localdomain>
 <CAOtvUMd6Ak3n-ABO1h440BoDASJUvh+-9PwEGFi-WzA=g84kLg@mail.gmail.com>
 <20200304195853.GA1005@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304195853.GA1005@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 04, 2020 at 11:58:53AM -0800, Eric Biggers wrote:
> On Wed, Mar 04, 2020 at 03:48:47PM +0200, Gilad Ben-Yossef wrote:
> > 
> > >
> > > > +     const unsigned int aad_tail_size = suite->skip_aad_iv ? aad_ivsize : 0;
> > > >       const unsigned int authsize = vec->clen - vec->plen;
> > > >
> > > >       if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
> > > >                /* Mutate the AAD */
> > > >               flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
> > > > +             if (suite->auth_aad_iv)
> > > > +                     memcpy((u8 *)vec->iv,
> > > > +                            (vec->assoc + vec->alen - aad_ivsize),
> > > > +                            aad_ivsize);
> > >
> > > Why sync the IV copies here?  When 'auth_aad_iv', we assume the copy of the IV
> > > in the AAD (which was just corrupted) is authenticated.  So we already know that
> > > decryption should fail, regardless of the other IV copy.
> > 
> > Nope. We know there needs to be a copy of the IV in the AAD and we know the IV
> > should be included in calculating in the authentication tag. We don't know which
> > copy of the IV will be used by the implementation.
> > 
> > Case in point - the ccree driver actually currently uses the copy of
> > the IV passed via
> > req->iv for calculating the IV contribution to the authentication tag,
> > not the one in the AAD.
> > 
> > And what happens then if you don't do this copy than is that you get
> > an unexpected
> > decryption success where the test expects failure, because the driver
> > fed the HW the
> > none mutated copy of the IV from req->iv and not the mutated copy
> > found in the AAD.
> 
> Okay, well in that case I don't see any difference between the two flags.  This
> is because changing the IV *must* affect the authentication tag for *any* AEAD
> algorithm, otherwise it's not actually authenticated encryption.
> 
> So why don't we just use a single flag 'aad_iv' that's set on rfc4106, rfc4309,
> rfc4543, and rfc7539esp?  This flag would mean that the last bytes of the AAD
> buffer must contain another copy of the IV for the behavior to be well-defined.
> 
> > > > @@ -2208,6 +2220,10 @@ static void generate_aead_message(struct aead_request *req,
> > > >       /* Generate the AAD. */
> > > >       generate_random_bytes((u8 *)vec->assoc, vec->alen);
> > > >
> > > > +     if (suite->auth_aad_iv && (vec->alen > ivsize))
> > > > +             memcpy(((u8 *)vec->assoc + vec->alen - ivsize), vec->iv,
> > > > +                    ivsize);
> > >
> > > Shouldn't this be >= ivsize, not > ivsize?
> > Indeed.
> > 
> > > And doesn't the IV need to be synced
> > > in both the skip_aad_iv and auth_aad_iv cases?
> > 
> > Nope, because in the skip_aad_iv case we never mutate the IV, so no
> > point in copying.
> 
> But even if the IV isn't mutated, both copies still need to be the same, right?
> We seem to have concluded that the behavior should be implementation-defined
> when they're different, so that's the logical consequence...
> 

I sent out new patches -- can you review and test them?
https://lkml.kernel.org/r/20200304224405.152829-1-ebiggers@kernel.org

Thanks,

- Eric
