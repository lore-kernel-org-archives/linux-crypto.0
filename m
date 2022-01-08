Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B9FC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Jan 2022 06:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiAHGrQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Jan 2022 01:47:16 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:46865 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiAHGrP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Jan 2022 01:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641624429;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=k8FUPqdeh3TPHO1BDuQ2Utg3TIP1xk24IAQX+zRc9jg=;
    b=cbAa/xAvn2wwCF7HoMD8vM7E8q5LfJM2g8F1jOJkgN36ICvQMR9pp5bcrZ8IdxYjTW
    TkPG0P8cax2dEYD+rqlNvKYirttgayX+TSOOJ+WZxaPJwq+H8bdW1XhkGkDy9MarzM6V
    xQxQ+t6Q8QXtREUCjiJv/2kKClklfl+/100XkCdfYPtEBUTOGqP6AUAjDTORySaFhx1W
    G1n8laF10wQCbudgNoXQMHOQMHJTpx3HRmmTWxQnJBBWBu5Lex9LVPEY5aJv+AwwDvtG
    IKxorDmp+SYqUoFed1OtirT9HmxR8CwkX9JuP+JxXXNbMjX6nrI4I82SxEKQMcjUN/ab
    HaIQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/SdIS4="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id t60e2cy086l84mJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 8 Jan 2022 07:47:08 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Niolai Stange <nstange@suse.com>, Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Sat, 08 Jan 2022 07:39:27 +0100
Message-ID: <2042139.9o76ZdvQCi@positron.chronox.de>
In-Reply-To: <YdjMn75GFEOLvoDr@sol.localdomain>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YdjMn75GFEOLvoDr@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 8. Januar 2022, 00:28:31 CET schrieb Eric Biggers:

Hi Eric,

> Hi Stephan,
>=20
> On Fri, Jan 07, 2022 at 08:25:24PM +0100, Stephan M=FCller wrote:
> > FIPS 140 requires a minimum security strength of 112 bits. This implies
> > that the HMAC key must not be smaller than 112 in FIPS mode.
> >=20
> > This restriction implies that the test vectors for HMAC that have a key
> > that is smaller than 112 bits must be disabled when FIPS support is
> > compiled.
> >=20
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
>=20
> This could make sense, but the weird thing is that the HMAC code has been
> like this from the beginning, yet many companies have already gotten this
> exact same HMAC implementation FIPS-certified.  What changed?

=46IPS 140-3 (which is now mandatory) requires this based on SP800-131A.
>=20
> - Eric


Ciao
Stephan


