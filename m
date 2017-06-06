From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3 02/13] random: add get_random_{bytes,u32,u64,int,long,once}_wait
 family
Date: Tue, 6 Jun 2017 14:21:53 +0200
Message-ID: <CAHmME9pWe15nBc+AusJ9W-ujkbq+LjNiQq8mzT_fmqHCeCmNSQ@mail.gmail.com>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-3-Jason@zx2c4.com>
 <CAH8yC8kq7OVBw_L32qD+OMgUhhh0K3huHpamO+4ABrE5i=fPkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:59377 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdFFMV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 08:21:56 -0400
In-Reply-To: <CAH8yC8kq7OVBw_L32qD+OMgUhhh0K3huHpamO+4ABrE5i=fPkw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 6, 2017 at 7:11 AM, Jeffrey Walton <noloader@gmail.com> wrote:
> On Mon, Jun 5, 2017 at 8:50 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> These functions are simple convenience wrappers that call
>> wait_for_random_bytes before calling the respective get_random_*
>> function.
>
> It may be advantageous to add a timeout, too.

This was in v1, but was removed because of a lack of particular use
case in this context.
