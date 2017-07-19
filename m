From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Wed, 19 Jul 2017 08:22:18 +0200
Message-ID: <4766174.b2XBWsRgGl@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <1780567.qGdv4EjEMp@positron.chronox.de> <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60698 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdGSGWV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 02:22:21 -0400
In-Reply-To: <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 23:08:16 CEST schrieb Theodore Ts'o:

Hi Theodore,
> 
> I've been trying to take the best features and suggestions from your
> proposal and integrating them into /dev/random already.  Things that
> I've chosen not take is basically because I disbelieve that the Jitter
> RNG is valid.  And that's mostly becuase I trust Peter Anvin (who has
> access to Intel chip architects, who has expressed unease) more than
> you.  (No hard feelings).

I am unsure why you always point to the Jitter RNG. This is one noise source 
to keep or to remove -- at least it provides more data during early boot than 
any other noise source we currently have.

In the email [1] I have expressed the core concerns I see -- none of them 
address the need to keep the Jitter RNG as one noise source. To address those, 
a very deep dive into random.c needs to be made.

Such deep dive has the potential to be disruptive. Therefore, doesn't it make 
more sense to have such conceptual changes rather covered in a separate 
implementation?

[1] https://www.spinics.net/lists/linux-crypto/msg26316.html

Ciao
Stephan
