From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 02:46:55 -0400
Message-ID: <CAH8yC8mG8PCd6zLK=oMWdvcAryvY42g1TprUrNg7ZGVyBenKjw@mail.gmail.com>
References: <20180718014344.1309-1-tytso@mit.edu>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718014344.1309-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 9:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This gives the user building their own kernel (or a Linux
> distribution) the option of deciding whether or not to trust the CPU's
> hardware random number generator (e.g., RDRAND for x86 CPU's) as being
> correctly implemented and not having a back door introduced (perhaps
> courtesy of a Nation State's law enforcement or intelligence
> agencies).

+1.

Allowing the user to set local policy is a good idea. Thanks for that.
