From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: get_random_bytes returns bad randomness before seeding is complete
Date: Sun, 4 Jun 2017 01:54:12 -0400
Message-ID: <CAH8yC8moNo7DN06dAt+hUhARuNBkUNAhuS4sxUYCcjWew76hsg@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <2400574.rYAxqaUNNq@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35370 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdFDFyN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 01:54:13 -0400
In-Reply-To: <2400574.rYAxqaUNNq@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 4, 2017 at 1:48 AM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Freitag, 2. Juni 2017, 16:59:56 CEST schrieb Jason A. Donenfeld:
>
>> Alternatively, I'm open to other solutions people might come up with.
>
> How about stirring in some data from the Jitter RNG that we have in the k=
ernel
> already and that is used for the DRBG in case get_random_bytes has
> insufficient entropy? Yes, two kernel developers said that this RNG is
> useless, where in fact a lot of hardware and even crypto folks say that t=
his
> approach has merits.

Almost anything has to be better than (1) silent failures, and (2)
draining the little entropy available when the generators are starting
and trying to become operational.

The [negative] use case for (2) is systemd. See, for example,
https://github.com/systemd/systemd/issues/4167.

Jeff
