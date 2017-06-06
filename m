From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH RFC v2 0/8] get_random_bytes_wait family of APIs
Date: Tue, 6 Jun 2017 14:24:33 +0200
Message-ID: <CAHmME9rAH5Qj5naSOWEMSaaR7YrP03UnYzeoQJA-0QF9jnPaRg@mail.gmail.com>
References: <20170605034757.4803-1-Jason@zx2c4.com> <CAHmME9oXmZD2X8hSicVgAZRbaoBNUwRK-16Ekz2JAkNcZE+_dg@mail.gmail.com>
 <20170606074552.GA10432@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:44593 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdFFMYp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 08:24:45 -0400
In-Reply-To: <20170606074552.GA10432@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 6, 2017 at 9:45 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> If it's needed no matter what, can you make it the first patch in the
> series?  And does it need to go to any older kernels as well?

I believe it does belong in older kernels too. I'll work out precisely
which one those are and note it in the commit, which I'll order as the
first in the series and Cc to stable@. This is, of course, pending
Ted's review.
