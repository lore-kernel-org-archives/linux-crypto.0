From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/4] ARM: add support for bit sliced AES using NEON instructions
Date: Mon, 23 Sep 2013 09:08:14 +0200
Message-ID: <CAKv+Gu8us1RRGKzg_91EAxAWJ9oA=StfPfBWqahKAiDjpUjsVQ@mail.gmail.com>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
	<1379702811-8025-5-git-send-email-ard.biesheuvel@linaro.org>
	<523ED087.7050006@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Nicolas Pitre <nico@linaro.org>,
	Andy Polyakov <appro@openssl.org>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:56157 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWHIQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 03:08:16 -0400
Received: by mail-la0-f51.google.com with SMTP id es20so2151655lab.38
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2013 00:08:14 -0700 (PDT)
In-Reply-To: <523ED087.7050006@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 September 2013 13:12, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:

[...]

> Decryption can probably be made faster by implementing InvMixColumns slightly
> differently. Instead of implementing inverse MixColumns matrix directly, use
> preprocessing step, followed by MixColumns as described in section "4.1.3
> Decryption" of "The Design of Rijndael: AES - The Advanced Encryption Standard"
> (J. Daemen, V. Rijmen / 2002).
>
> In short, the MixColumns and InvMixColumns matrixes have following relation:
>  | 0e 0b 0d 09 |   | 02 03 01 01 |   | 05 00 04 00 |
>  | 09 0e 0b 0d | = | 01 02 03 01 | x | 00 05 00 04 |
>  | 0d 09 0e 0b |   | 01 01 02 03 |   | 04 00 05 00 |
>  | 0b 0d 09 0e |   | 03 01 01 02 |   | 00 04 00 05 |
>
> Bit-sliced implementation of the 05-00-04-00 matrix much shorter than 0e-0b-0d-09
> matrix, so even when combined with MixColumns total instruction count for
> InvMixColumns implemented this way should be nearly half of current.
>

That is a very useful tip, thank you. I will have a go at it and
follow up later.

Regards,
Ard.
