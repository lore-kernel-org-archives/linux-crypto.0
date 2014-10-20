From: Jamie Heilman <jamie@audible.transient.net>
Subject: Re: 3.17 regression; alg: skcipher: Chunk test 1 failed on
 encryption at page 0 for ecb-aes-padlock
Date: Mon, 20 Oct 2014 23:43:33 +0000
Message-ID: <20141020234333.GB4084@cucamonga.audible.transient.net>
References: <20141020071454.GA4084@cucamonga.audible.transient.net>
 <CAKv+Gu9UwbUHd0X7=vTJ6ebj4pcGjQKZMAWCjaNcS0AFk+7tZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from audible.transient.net ([24.143.126.66]:38160 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752673AbaJTXne (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Oct 2014 19:43:34 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9UwbUHd0X7=vTJ6ebj4pcGjQKZMAWCjaNcS0AFk+7tZg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ard Biesheuvel wrote:
> On 20 October 2014 09:14, Jamie Heilman <jamie@audible.transient.net> wrote:
> > I get this new failure w/3.17.0 on my system with a VIA Esther
> > processor:
> >
> > alg: skcipher: Chunk test 1 failed on encryption at page 0 for ecb-aes-padlock
> > 00000000: 71 73 f7 db 24 93 21 6d 61 1e bb 63 42 79 db 64
> > 00000010: 6f 82 c0 ca a3 9b fa 0b d9 08 c7 4a 90 ae 8f 5f
> > 00000020: 5e 06 f0 5f 31 51 18 37 45 d7 ca 3a fd 6c 3f e1
> > 00000030: dd 8d 22 65 2b 00 50 ce ba 28 67 d7 ce 0e 0d ea
> > 00000040: 78 69 7f ae 8f 8b 69 37 75 e0 dc 96 e0 b7 f4 09
> > 00000050: cb 6d a2 fb da af 09 f8 81 82 27 fa 45 9c 29 a4
> > 00000060: 22 8b 78 69 5b 46 f9 39 1b cc f9 1d 09 eb bc 5c
> > 00000070: 41 72 51 97 1d 07 49 a0 1b 8e 65 4b b2 6a 12 03
> > 00000080: 6a 60 95 ac bd ac 1a 64 de 5a a5 f0 83 2f cb ca
> > 00000090: 22 74 a6 6c 9b 73 ce 3f e1 8b 22 17 59 0c 47 89
> > 000000a0: 33 a1 d6 47 03 19 4f a8 67 69 f0 5b f0 20 ad 06
> > 000000b0: 27 81 92 d8 c5 ba 98 12 be 24 b5 2f 75 02 c2 ad
> > 000000c0: 12 2f 07 32 ee 39 af 64 05 8f b3 d4 eb 1b 46 6e
> > 000000d0: d9 21 f9 c4 b7 c9 45 68 b4 a1 74 9f 82 47 eb cc
> > 000000e0: bd 0a 14 95 0f 8b a8 2f 4b 1b a7 bf 82 a6 43 0c
> > 000000f0: b9 39 4a a8 10 6f 50 7b 25 fb 26 81 e0 2f f0 96
> > 00000100: 8d 8b ac 92 0f f6 ed 64 63 29 4c 8e 18 13 c5 bf
> > 00000110: fc a0 d9 bf 7c 3a 0e 29 6f d1 6c 6f a5 da bf b1
> > 00000120: 30 ea 44 2d c3 8f 16 e1 66 fa a3 21 3e fc 13 ca
> > 00000130: f0 f6 f0 59 bd 8f 38 50 31 cb 69 3f 96 15 d6 f5
> > 00000140: ae ff f6 aa 41 85 4c 10 58 e3 f9 44 e6 28 da 9a
> > 00000150: dc 6a 80 34 73 97 1b c5 ca 26 16 77 0e 60 ab 89
> > 00000160: 0f 04 27 bd ce 3e 71 b4 a0 d7 22 7e db eb 24 70
> > 00000170: 42 71 51 78 70 b3 e0 3d 84 8e 8d 7b d0 6d ea 92
> > 00000180: 11 08 42 4f e5 ad 26 92 d2 00 ae a8 e3 4b 37 47
> > 00000190: 22 c1 95 c1 63 7f cb 03 f3 e3 d7 9d 60 c7 bc ea
> > 000001a0: 35 a2 fd 45 52 39 13 6f c1 53 f3 53 df 33 84 d7
> > 000001b0: d2 c8 37 b0 75 e3 41 46 b3 c7 83 2e 8a bb a4 e5
> > 000001c0: 7f 3c fd 8b eb ea 63 bd b7 46 e7 bf 09 9c 0d 0f
> > 000001d0: 33 84 aa 1c 8d 29 b4 ac 4f ad e6 89
> >
> > I've bisected this to 3b9b8fe0ade1ee84ee4058261d2e39a1f283704b so ...
> > perhaps intended in terms of uncovering problems.  Seems to have
> > identified something in my case at any rate.
> >
> > Attached is my full 3.17.0 dmesg, kernel config, and /proc/crypto contents
> > (the only difference between 3.16 and 3.17 for the latter being the
> > selftest value for ecb-aes-padlock which used to be "passed" with 3.16
> > and earlier.)
> >
> > Let me know if you need anything else.
> >
> 
> Interesting. I don't have access to the hardware, but I found
> something interesting in the driver related to the prefetch size
> (ecb_fetch_bytes) of ECB versus CBC (Note that the CBC selftest
> passes)
> So perhaps this might solve the bug, could you please test it?
> 
> diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
> index 633ba945e153..2834f0b23713 100644
> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -351,7 +351,7 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
>         padlock_reset_key(&ctx->cword.encrypt);
> 
>         blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> +       err = blkcipher_walk_virt_block(desc, &walk, ecb_fetch_bytes);
> 
>         ts_state = irq_ts_save();
>         while ((nbytes = walk.nbytes)) {
> @@ -380,7 +380,7 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
>         padlock_reset_key(&ctx->cword.decrypt);
> 
>         blkcipher_walk_init(&walk, dst, src, nbytes);
> -       err = blkcipher_walk_virt(desc, &walk);
> +       err = blkcipher_walk_virt_block(desc, &walk, ecb_fetch_bytes);
> 
>         ts_state = irq_ts_save();
>         while ((nbytes = walk.nbytes)) {
> 
> It will basically instruct the crypto layer not to pass fewer than 2
> blocks at a time until there is really no other way, i.e., until the
> input is exhausted.

Nope.  Test still fails w/exactly the same output as before.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
