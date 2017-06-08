From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded
 before ECDH use
Date: Thu, 8 Jun 2017 14:05:02 +0200
Message-ID: <CAHmME9rEcAZop80q47n1h3PP9hx5-X6R0w-SD2nDxZZLsJOQYw@mail.gmail.com>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-13-Jason@zx2c4.com>
 <20170608030631.ywmldxzehtumeqd3@thunk.org> <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:47103 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdFHMFF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jun 2017 08:05:05 -0400
In-Reply-To: <7B079482-B436-4FE7-A752-9518606F15AB@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Marcel,

On Thu, Jun 8, 2017 at 7:04 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> yes, there are plenty of commands needed before a controller becomes usable.

That doesn't clearly address with precision what Ted was wondering.
Specifically, the inquiry is: can you confirm with certainty whether
or not all calls to get_random_bytes() in the bluetooth directory are
*necessarily* going to come after a call to hci_power_on()?

Jason
