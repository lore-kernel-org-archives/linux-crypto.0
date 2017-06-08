From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
Date: Thu, 8 Jun 2017 14:01:51 +0200
Message-ID: <CAHmME9rjhdsXiQgJh-qNz9ato3PYL8XHMwHO+GNmZCVpc2YNsw@mail.gmail.com>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-14-Jason@zx2c4.com>
 <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 8, 2017 at 10:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> At the very least we probably should do a logical "uniq" on the output
> (e.g., if we have complained about the previous callsite, don't whinge
> about it again).

That seems okay to me.
