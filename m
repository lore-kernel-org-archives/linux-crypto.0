From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] arm64 aes: fix encryption of unaligned data
Date: Sat, 26 Jul 2014 11:31:41 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407261125470.25378@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407251937110.11227@file01.intranet.prod.int.rdu2.redhat.com> <CAKv+Gu-mdv0E5oSLz3x87Qn6sEO1-=B3Uk-mnJee7YGUWY4cnQ@mail.gmail.com> <CAKv+Gu9=0eH1-SLahzoEhedMcXrcDV3k9LnogBsqnD_6pfJ9WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Pitre <nico@linaro.org>,
	"Alasdair G. Kergon" <agk@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	dm-devel@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaGZPcJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Jul 2014 11:32:09 -0400
In-Reply-To: <CAKv+Gu9=0eH1-SLahzoEhedMcXrcDV3k9LnogBsqnD_6pfJ9WA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Sat, 26 Jul 2014, Ard Biesheuvel wrote:

> On 26 July 2014 15:13, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > On 26 July 2014 01:40, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> cryptsetup fails on arm64 when using kernel encryption via AF_ALG socket.
> >> See https://bugzilla.redhat.com/show_bug.cgi?id=1122937
> >>
> >> The bug is caused by incorrect handling of unaligned data in
> >> arch/arm64/crypto/aes-glue.c. Cryptsetup creates a buffer that is aligned
> >> on 8 bytes, but not on 16 bytes. It opens AF_ALG socket and uses the
> >> socket to encrypt data in the buffer. The arm64 crypto accelerator causes
> >> data corruption or crashes in the scatterwalk_pagedone.
> >>
> >> This patch fixes the bug by passing the residue bytes that were not
> >> processed as the last parameter to blkcipher_walk_done.
> >>
> >> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >>
> >
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Thanks for the patch. This correctly fixes a thinko on my part
> > regarding the guarantees offered by the blkcipher API. Unfortunately,
> > this wasn't caught by the tcrypt test suite, so I will propose some
> > patches later to address cases like this.
> >
> > BTW using kernel crypto with AF_ALG is fairly pointless when using
> > crypto instructions instead of crypto accelerator peripherals, should
> > we change anything on the kernel side so we don't expose these
> > drivers?

The userspace library (gcrypt in this case) doesn't support ARM64, so it's 
still better to call the kernel.

> > @Catalin: this is a bug fix for the code that was merged this cycle. I
> > would recommend to merge this for 3.16, but if not, could you please
> > add a cc stable? Or ack it and perhaps Herbert can take both? (There
> > is a similar patch for ARM as well)
> >
> 
> ... only this patch fails to repair the ECB case.
> @Mikulas: could you do a v2 and include ECB encryption/decryption?
> 
> Cheers,
> Ard.

The patch changes ecb_encrypt and ecb_decrypt just like cbc and xts 
functions. What is the problem with ECB?

Mikulas

> >> Index: linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm64/crypto/aes-glue.c
> >> ===================================================================
> >> --- linux-3.16.0-0.rc6.git1.1.fc21.aarch64.orig/arch/arm64/crypto/aes-glue.c
> >> +++ linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm64/crypto/aes-glue.c
> >> @@ -106,7 +106,7 @@ static int ecb_encrypt(struct blkcipher_
> >>         for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
> >>                 aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key_enc, rounds, blocks, first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>         return err;
> >> @@ -128,7 +128,7 @@ static int ecb_decrypt(struct blkcipher_
> >>         for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
> >>                 aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key_dec, rounds, blocks, first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>         return err;
> >> @@ -151,7 +151,7 @@ static int cbc_encrypt(struct blkcipher_
> >>                 aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key_enc, rounds, blocks, walk.iv,
> >>                                 first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>         return err;
> >> @@ -174,7 +174,7 @@ static int cbc_decrypt(struct blkcipher_
> >>                 aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key_dec, rounds, blocks, walk.iv,
> >>                                 first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>         return err;
> >> @@ -243,7 +243,7 @@ static int xts_encrypt(struct blkcipher_
> >>                 aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key1.key_enc, rounds, blocks,
> >>                                 (u8 *)ctx->key2.key_enc, walk.iv, first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>
> >> @@ -267,7 +267,7 @@ static int xts_decrypt(struct blkcipher_
> >>                 aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> >>                                 (u8 *)ctx->key1.key_dec, rounds, blocks,
> >>                                 (u8 *)ctx->key2.key_enc, walk.iv, first);
> >> -               err = blkcipher_walk_done(desc, &walk, 0);
> >> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
> >>         }
> >>         kernel_neon_end();
> >>
> 
