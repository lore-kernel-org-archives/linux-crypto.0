Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8906C2B9F4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A064D60241
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 13:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFYNwt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:52:49 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:29864 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFYNws (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 09:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624629012;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=x4gsdNJd27Ic7pqfG23li2Pk3MOjsnuCu+ukPna2cdE=;
    b=Ltv+GN64/kwrI+zbcLj15uMhsvHadzfSch0ceyLmFPR2er4ECZDhRNRClkPpTTmB07
    z4sovjPM8j/DM6K4ALuJdta16UMgCpjA4vEOAo4L1OrYVpRZk8XmdxqwSLVubKPo49ux
    /r6i2nFLQoyxYm4MOnNq7O+sauGWHgF2iBGZllVXWjLyR192ShQYNfXw51oXOkQyecvk
    8kA8SozxzB65/OWC4wma5yhT2h1BfrkZADCI5WxHkjfQbBVpIRRUhjGEO+Gu8uvu0YHD
    tWZx4qXz+bbFvQecgoqUEoIbxxvk2KCE7XgW9RUhFJlsB2zKploolnauwjjzSbfJmiVd
    qLRA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJPSYC7Q="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.27.5 DYNA|AUTH)
    with ESMTPSA id L04113x5PDoAAUL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 25 Jun 2021 15:50:10 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     James Morris <jamorris@linux.microsoft.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        hpa@zytor.com, tytso@mit.edu
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A rev1
Date:   Fri, 25 Jun 2021 15:50:09 +0200
Message-ID: <3789849.nkhAASfZ5y@positron.chronox.de>
In-Reply-To: <248b1aae-effc-f511-03af-65a71f176cf1@digikod.net>
References: <20210623120751.3033390-1-mic@digikod.net> <9590fe0e9482e212f2a3223ffae872104659cc4b.camel@chronox.de> <248b1aae-effc-f511-03af-65a71f176cf1@digikod.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 25. Juni 2021, 13:09:26 CEST schrieb Micka=C3=ABl Sala=C3=BCn:

Hi Micka=C3=ABl,

[...]
>=20
> > - applies an entropy_input len of 512 bits during initial seeding
> >=20
> > - applies a nonce of 128 bits during initial seeding
> >=20
> > entropy_input =3D=3D <384 bits get_random_bytes> || <256 bits Jitter RN=
G>
>=20
> We think that using "<384 bits get_random_bytes> || " makes this DRBG
> non-compliant with SP800-90A rev1 because get_random_bytes doesn't use a
> vetted conditioning component (but ChaCha20 instead):
>=20
> SP800-90Ar1, section 8.6.5 says "A DRBG mechanism requires an approved
> randomness source during instantiation and reseeding [...]. An approved
> randomness source is an entropy source that conforms to [SP 800-90B], or
> an RBG that conforms to [SP 800-90C] =E2=88=92 either a DRBG or an NRBG".
> The FIPS 140-2 Implementation Guidance
> (https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validatio=
n-p
> rogram/documents/fips140-2/fips1402ig.pdf), section 7.19 says "As of
> November 7, 2020, all newly submitted modules requiring an entropy
> evaluation must demonstrate compliance to SP 800-90B". In resolution 3 it
> says "all processing of the raw data output from the noise sources that
> happens before it is ultimately output from the entropy source *shall*
> occur within a conditioning chain". Data from get_random_bytes may come
> from multiple noise sources, but they are hashed with ChaCha20.
> In resolution 6 it says "a vetted conditioning component may optionally
> take a finite amount of supplemental data [...] in addition to the data
> from the primary noise source", which would be OK if get_random_bytes
> used a vetted algorithm, but it is not the case for now.

You cite the right references, I think the interpretation is too strict.

The specifications require that

a) The DRBG must be seeded by a 90B entropy source

b) The DRBG must be initially seeded with 256 bits of entropy plus some 128=
=20
bit nonce

We cover a) with the Jitter RNG and b) by pulling 384 bits from it.

The standard does not forbit:

c) the entropy string may contain data from another origin or it contains a=
=20
larger buffer

d) the actual entropy distribution in the entropy string being not an=20
equidistribution over the entire entropy string

Bullet d) implies that it is perfectly fine to have entropy distribution be=
gin=20
loopsided in the entropy string.

Bullet c) implies that other data can be provided with the entropy string.

With that, to be 90A/B compliant, you interpret that the Jitter RNG provide=
s=20
all entropy you need and credit the entropy from get_random_bytes with zero=
=20
bits of entropy.


Note, if you look into the implementation of the DRBG seeding, the differen=
t=20
input strings like entropy string or data without entropy like personalizat=
ion=20
string are simply concatenated and handed to the DRBG. As the Jitter RNG an=
d=20
get_random_bytes data is also concatenated, it follows the concepts of 90A.

If you look into the draft 90C standard, it explicitly allows concatenation=
 of=20
data from an entropy source that you credit with entropy and data without=20
entropy - see the crediting of entropy of multiple entropy sources defined=
=20
with "Method 1" and "Method 2" in the current 90C draft.

This ultimately allows us to have an entropy string that is concatenated fr=
om=20
different entropy sources. If you have an entropy source that is not 90B=20
compliant, you have to credit it with zero bits of entropy in the entropy=20
analysis. Thus, only the entropy source(s) compliant to 90B must provide th=
e=20
entire entropy as mandated by 90A.

After having several discussions with the Entropy Working group sponsored b=
y=20
NIST that included also representatives from the NIST crypto technology gro=
up,=20
there was no concern regarding such approach.

This approach you see in the current DRBG seeding code is now taken for=20
different FIPS validations including FIPS validations that I work on as a F=
IPS=20
tester as part of my duties working for a FIPS lab. My colleagues have=20
reviewed the current kernel DRBG seeding strategy and approved of it for ot=
her=20
=46IPS validations.

Ciao
Stephan


