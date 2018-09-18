From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH net-next v5 19/20] security/keys: rewrite big_key crypto to use Zinc
Date: Tue, 18 Sep 2018 18:01:47 +0100
Message-ID: <2826.1537290107@warthog.procyon.org.uk>
References: <20180918161646.19105-20-Jason@zx2c4.com> <20180918161646.19105-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-20-Jason@zx2c4.com>
Content-ID: <2825.1537290107.1@warthog.procyon.org.uk>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> A while back, I noticed that the crypto and crypto API usage in big_keys
> were entirely broken in multiple ways, so I rewrote it. Now, I'm
> rewriting it again, but this time using Zinc's ChaCha20Poly1305
> function.

warthog>git grep chacha20poly1305_decrypt net-next/master 
warthog1>

Where do I find this?

David
