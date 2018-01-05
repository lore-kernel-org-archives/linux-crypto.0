From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algapi - fix NULL dereference in
 crypto_remove_spawns()
Date: Fri, 5 Jan 2018 22:18:07 +1100
Message-ID: <20180105111807.GF16156@gondor.apana.org.au>
References: <001a1141c43ad30ccf055efb76ed@google.com>
 <20171229203019.1413-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171229203019.1413-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 29, 2017 at 02:30:19PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> syzkaller triggered a NULL pointer dereference in crypto_remove_spawns()
> via a program that repeatedly and concurrently requests AEADs
> "authenc(cmac(des3_ede-asm),pcbc-aes-aesni)" and hashes "cmac(des3_ede)"
> through AF_ALG, where the hashes are requested as "untested"
> (CRYPTO_ALG_TESTED is set in ->salg_mask but clear in ->salg_feat; this
> causes the template to be instantiated for every request).
> 
> Although AF_ALG users really shouldn't be able to request an "untested"
> algorithm, the NULL pointer dereference is actually caused by a
> longstanding race condition where crypto_remove_spawns() can encounter
> an instance which has had spawn(s) "grabbed" but hasn't yet been
> registered, resulting in ->cra_users still being NULL.
> 
> We probably should properly initialize ->cra_users earlier, but that
> would require updating many templates individually.  For now just fix
> the bug in a simple way that can easily be backported: make
> crypto_remove_spawns() treat a NULL ->cra_users list as empty.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
