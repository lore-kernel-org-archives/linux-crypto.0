From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 19/20] security/keys: rewrite big_key crypto
 to use Zinc
Date: Tue, 18 Sep 2018 19:12:33 +0200
Message-ID: <20180918171231.GA22973@zx2c4.com>
References: <20180918161646.19105-20-Jason@zx2c4.com>
 <20180918161646.19105-1-Jason@zx2c4.com>
 <2826.1537290107@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2826.1537290107@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

On Tue, Sep 18, 2018 at 06:01:47PM +0100, David Howells wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > A while back, I noticed that the crypto and crypto API usage in big_keys
> > were entirely broken in multiple ways, so I rewrote it. Now, I'm
> > rewriting it again, but this time using Zinc's ChaCha20Poly1305
> > function.
> 
> warthog>git grep chacha20poly1305_decrypt net-next/master 
> warthog1>
> 
> Where do I find this?
> 
> David

Previously in the patchset:
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard
https://lore.kernel.org/lkml/20180918161646.19105-1-Jason@zx2c4.com/

Regards,
Jason
