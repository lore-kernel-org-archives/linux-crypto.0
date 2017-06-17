From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
Date: Sat, 17 Jun 2017 02:41:39 +0200
Message-ID: <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org> <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
 <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com
To: Lee Duncan <lduncan@suse.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:48359 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752152AbdFQAlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 20:41:44 -0400
In-Reply-To: <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Lee,

On Fri, Jun 16, 2017 at 11:58 PM, Lee Duncan <lduncan@suse.com> wrote:
> It seems like what you are doing is basically "good", i.e. if there is
> not enough random data, don't use it. But what happens in that case? The
> authentication fails? How does the user know to wait and try again?

The process just remains in interruptible (kill-able) sleep until
there is enough entropy, so the process doesn't need to do anything.
If the waiting is interrupted by a signal, it returns -ESYSRESTART,
which follows the usual semantics of restartable syscalls.

Jason
