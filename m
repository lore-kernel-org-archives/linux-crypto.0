From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 11:16:10 +0200
Message-ID: <CAK8P3a3687Na9Rhi78_46trr94_kPjCFzTCWFJrzUGo90bwN6w@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <20170718084959.GA25267@kroah.com>
 <CAK8P3a1g8_D6Z0d-LOjomGcxuX5v_Y9fJ_b9TEeOQ6izOneE=g@mail.gmail.com> <5156735.IWW3yRWKpB@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33838 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRJQL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 05:16:11 -0400
In-Reply-To: <5156735.IWW3yRWKpB@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 11:10 AM, Stephan M=C3=BCller <smueller@chronox.de>=
 wrote:
> Am Dienstag, 18. Juli 2017, 11:02:02 CEST schrieb Arnd Bergmann:
>
> Hi Arnd,
>>
>> I can see why the jitterentropy implementation avoids using kernel heade=
rs,
>> the problem now is that part of it gets moved into a new header, and tha=
t
>> already violates the original principle.
>>
>> From my reading of the code, we could probably leave the structure
>> definition in the crypto/jitterentropy.c, and have the statically
>> allocated instance in the same file when CONFIG_LRNG is
>> set,
>
> That is a very good idea -- I will implement this approach.

I guess ideally you just move the inner half of lrng_get_jent(),
i.e. everything inside of the spinlock, plus the buffer, into that file.
That should keep the low-level side separate from the caller.

      Arnd
