From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Tue, 27 Dec 2016 14:26:35 +0000
Message-ID: <6124F827-BA28-4A3D-B05F-EBCB1323955D@linaro.org>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org> <20161227100400.GA10629@gondor.apana.org.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33792 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcL0O0l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 09:26:41 -0500
Received: by mail-wm0-f45.google.com with SMTP id u144so70047337wmu.1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2016 06:26:40 -0800 (PST)
In-Reply-To: <20161227100400.GA10629@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> On 27 Dec 2016, at 10:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
>> On Thu, Dec 08, 2016 at 02:28:57PM +0000, Ard Biesheuvel wrote:
>> Another port of existing x86 SSE code to NEON, again both for arm64 and A=
RM.
>>=20
>> ChaCha20 is a stream cipher described in RFC 7539, and is intended to be
>> an efficient software implementable 'standby cipher', in case AES cannot
>> be used.
>>=20
>> This NEON implementation is almost 2x as fast as the generic C code
>> (measured on Cortex-A57 using the arm64 version)
>>=20
>> I'm aware that blkciphers are deprecated in favor of skciphers, but this
>> code (like the x86 version) uses the init and setkey routines of the gene=
ric
>> version, so it is probably better to port all implementations at once.
>>=20
>> Ard Biesheuvel (2):
>>  crypto: arm64/chacha20 - implement NEON version based on SSE3 code
>>  crypto: arm/chacha20 - implement NEON version based on SSE3 code
>=20
> Both patches applied.  Thanks.

You just nacked the v2 of this series (due to the chunksize/walksize) and i r=
ewrote them as skciphers as well

> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
