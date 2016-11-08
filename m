From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Tue, 8 Nov 2016 09:26:26 -0800
Message-ID: <20161108172626.GA99078@google.com>
References: <20161107191253.17998-1-Jason@zx2c4.com>
 <20161107194709.20457-1-Jason@zx2c4.com>
 <1478591559.5216.7.camel@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478591559.5216.7.camel@strongswan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 08, 2016 at 08:52:39AM +0100, Martin Willi wrote:
> 
> 
> Not sure what the exact alignment rules for key/iv are, but maybe we
> want to replace the same function in chacha20_generic.c as well?
> 
> Martin

chacha20-generic provides a blkcipher API and sets an alignmask of sizeof(u32)
- 1.  This applies to the key buffer for ->setkey() and to the mapped addresses
for the input/output buffers and IV during the blkcipher walk.  So it does not
appear to have the problems that poly1305 has.  

I do however see one small problem which is that
'u8 stream[CHACHA20_BLOCK_SIZE];' is, strictly speaking, not guaranteed to be
aligned to u32.

Eric
