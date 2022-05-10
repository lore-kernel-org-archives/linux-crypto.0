Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887A7C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 10 May 2022 18:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiEJS6i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 May 2022 14:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiEJS6h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 May 2022 14:58:37 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 May 2022 11:58:35 PDT
Received: from salsa.cs.uic.edu (salsa.cs.uic.edu [131.193.32.108])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 60C3B34BA9
        for <linux-crypto@vger.kernel.org>; Tue, 10 May 2022 11:58:34 -0700 (PDT)
Received: (qmail 26735 invoked by uid 1010); 10 May 2022 18:51:52 -0000
Received: from unknown (unknown)
  by unknown with QMTP; 10 May 2022 18:51:52 -0000
Received: (qmail 80608 invoked by uid 1000); 10 May 2022 18:51:23 -0000
Message-ID: <20220510185123.80607.qmail@cr.yp.to>
Mail-Followup-To: Jason@zx2c4.com,
  dodis@cs.nyu.edu,
  tytso@mit.edu,
  nadiah@cs.ucsd.edu,
  noahsd@gmail.com,
  tessaro@cs.washington.edu,
  torvalds@linux-foundation.org,
  jeanphilippe.aumasson@gmail.com,
  jann@thejh.net,
  keescook@chromium.org,
  gregkh@linuxfoundation.org,
  peter@cryptojedi.org,
  linux-crypto@vger.kernel.org,
  linux-kernel@vger.kernel.org
Automatic-Legal-Notices: See https://cr.yp.to/mailcopyright.html.
Date:   Tue, 10 May 2022 20:51:23 +0200
From:   "D. J. Bernstein" <djb@math.uic.edu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yevgeniy Dodis <dodis@cs.nyu.edu>, tytso <tytso@mit.edu>,
        Nadia Heninger <nadiah@cs.ucsd.edu>,
        Noah Stephens-Dawidowitz <noahsd@gmail.com>,
        Stefano Tessaro <tessaro@cs.washington.edu>,
        torvalds@linux-foundation.org, jeanphilippe.aumasson@gmail.com,
        jann@thejh.net, keescook@chromium.org, gregkh@linuxfoundation.org,
        Peter Schwabe <peter@cryptojedi.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: is "premature next" a real world rng concern, or just an
 academic exercise?
References: <YmlMGx6+uigkGiZ0@zx2c4.com>
 <Ym3ZM1P+uYYABtRm@mit.edu>
 <Ym5sICj5iBMn2w/E@zx2c4.com>
 <CAMvzKsiA52Si=PzOJXYwGSA1WUz-1S0A8cpgRJWDzpMkfFbX+Q@mail.gmail.com>
 <CAMvzKsiMY_+8HZqeFqD3tR65a3-JB0LG=+0jBBy1zF4GanrsGA@mail.gmail.com>
 <YnqDC25iR8mcL3XB@zx2c4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qId8Ue31mwkR5Glx"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--qId8Ue31mwkR5Glx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Jason A. Donenfeld writes:
> Right, VMs are super problematic, but for that, there's now this
> "vmgenid" driver, where the hypervisor actually gives a 128-bit seed to
> guests when they're resumed, so that we can immediately reseed, which
> should pretty comprehensively handle that situation.

Hmmm. If an application initializes its own RNG state from /dev/urandom,
and is then cloned, and then generates an ECDSA nonce from the RNG
state, and then uses this nonce to sign a message that's different
across the clones, how is disaster averted?

Given the goal of sending money to cryptographers, I'm pretty sure we
want the answer to be a security-audit nightmare, so let me suggest the
following idea. There's SIGWINCH to notify processes about window-size
changes, so there should also be a signal for RNG changes, which should
be called SIGRINCH, and there should be a different mechanism to address
RNG output cloning inside the kernel, and there should be endless papers
on Grinch Attacks, including papers that sort of prove security against
Grinch Attacks, and deployment of software that's sort of protected
against Grinch Attacks, and fear of the bad PR from abandoning anything
labeled as protection, because, hey, _maybe_ the protection accomplishes
something, and it's not as if anyone is going to be blamed for whatever
damage is caused by the systems-level effect of the added complexity.

---D. J. Bernstein

P.S. Yes, yes, I know the name "Grinch Attack" has been used before.

--qId8Ue31mwkR5Glx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3QolqQXydru4e4ITsMANTjsOVFkFAmJ6tCsACgkQsMANTjsO
VFk8WBAAzyMKEWbIPxsLZOwf6gPOb+FqsG2NNiI/RzpnGOWlnohjbpo+2r2pOpD/
dPBsToDrAuBs1ypA2rrcdbQ40gepN6vUJwK4TBVvBn1h3UM2hRrJ7JFA8mlA9RpT
1R8KXXnCbkhV92p6Y1YOzPP1mynkZ5XVhE87/03rJ3T0Sole8qv25tn75XZvKY6U
p4HiYl7mbZuQ84OgUCmp7bYC7nKCKzgAb3nNXZCTotv7ecZGQgnlGC+ClOZz6+TB
KwcDw9cF2LfJvP5qvNGmkVtMEtWEvPzmBMp6MCXJytBJ15vXaM0B5M0NDwbpM2I9
FtsH1/yzbnGQs2slSERlDv5PhrMjroydwC07YpRKMKY59uITV7tf8Q/2gcK5+C7z
zPOkbKvXkjas+cqM4wjXDt/cOyBiUkW9RzMXG7ODldkh8oI8D30qyUOl8+IqxF6h
d5SL9mJ7RLQ3LumSiat/B2HbHlODU4CJqubidyFgYvdGOyXhOOsTpfImNMuJoP5x
zapVfrONCJ5497AZY24mr4rWI/Vp+pcge9lVxQjBnAPJrQx32SsL6szWKUkLL9lc
H9jDaxcoJSjMR7GdBmgCEvVFHmFpLszoE4Cg/XPswQdYzjHikO9k41Ni2ge7jKf0
Mf2OP2wpKIpFxL/N+xdpEWFuywJt+bMnQXsChAIM8530UgDYjGs=
=AY+X
-----END PGP SIGNATURE-----

--qId8Ue31mwkR5Glx--
