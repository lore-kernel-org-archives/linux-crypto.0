From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Wed, 28 Dec 2016 09:11:03 +0000
Message-ID: <AA6F25FA-C998-462F-9E25-FF543BBE3EA7@linaro.org>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org> <20161227100400.GA10629@gondor.apana.org.au> <6124F827-BA28-4A3D-B05F-EBCB1323955D@linaro.org> <20161228090350.GD11904@gondor.apana.org.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36551 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751103AbcL1JLN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:11:13 -0500
Received: by mail-wm0-f50.google.com with SMTP id c85so92810287wmi.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2016 01:11:12 -0800 (PST)
In-Reply-To: <20161228090350.GD11904@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 28 Dec 2016, at 09:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
>> On Tue, Dec 27, 2016 at 02:26:35PM +0000, Ard Biesheuvel wrote:
>>=20
>> You just nacked the v2 of this series (due to the chunksize/walksize) and=
 i rewrote them as skciphers as well
>=20
> Sorry.  Would you like me to revert or just send a new series
> on top of this?
>=20

No worries. If you can, please drop them entirely, or revert them otherwise.=
 I will resend after the holidays


> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
