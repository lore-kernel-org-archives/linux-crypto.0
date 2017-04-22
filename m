From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Sat, 22 Apr 2017 15:54:08 +0800
Message-ID: <CACXcFm=HAew+fMAZXWL9WtT49GVdvUdVShnOOsDLEqUwU5cJng@mail.gmail.com>
References: <20170421121820.GA14381@gondor.apana.org.au> <8205294.2qxUD6mCvD@tauon.chronox.de>
 <9105605.SAXsSHs1iB@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38309 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1042861AbdDVHyK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Apr 2017 03:54:10 -0400
Received: by mail-wm0-f45.google.com with SMTP id r190so32167713wme.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Apr 2017 00:54:09 -0700 (PDT)
In-Reply-To: <9105605.SAXsSHs1iB@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 22, 2017 at 2:56 AM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:

> Am Freitag, 21. April 2017, 17:25:41 CEST schrieb Stephan M=C3=BCller:

> Just for the records: for FIPS 140-2 rules, cipher_null is to be interpre=
ted
> as a memcpy on SGLs. Thus it is no cipher even though it sounds like one.
>
> cipher_null is also needed for seqiv which is required for rfc4106(gcm(ae=
s)),
> which is an approved cipher. Also, it is needed for authenc() which uses =
it
> for copying the AAD from src to dst.
>
> That said, cipher_null must not be used for "encryption" operation but ra=
ther
> for handling data that is not subjected to FIPS 140-2 rules.

In the FreeS/WAN project, back around the turn of the century,
we refused to implement several things required by the RFCs
because we thought they were insecure: null cipher, single
DES & 768-bit DH Group 1.

At that time, not having DES did cause some problems in
interoperating with other IPsec implementations, but I
doubt it would today. Neither of the other dropped items
caused any problems at all.

Today I'd say drop all of those plus the 1024-bit Group 2,
and then look at whether others should go as well. As of
2001 or so, the 1536-bit Group 5 was very widely used,
so dropping it might well be problematic, but I am not
certain if it is either secure or widely used now.
