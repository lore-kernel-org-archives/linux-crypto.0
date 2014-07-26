From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] arm aes: fix encryption of unaligned data
Date: Sat, 26 Jul 2014 15:24:22 +0200
Message-ID: <CAKv+Gu-woTRoy7KcuwTwzMiSYgwNCJCqah+C3pkgetE-9+3Tyg@mail.gmail.com>
References: <alpine.LRH.2.02.1407251940380.11227@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Pitre <nico@linaro.org>,
	"Alasdair G. Kergon" <agk@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	dm-devel@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61639 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaGZNYX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Jul 2014 09:24:23 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so4237695lbi.24
        for <linux-crypto@vger.kernel.org>; Sat, 26 Jul 2014 06:24:22 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.02.1407251940380.11227@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26 July 2014 01:42, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Fix the same alignment bug as in arm64 - we need to pass residue
> unprocessed bytes as the last argument to blkcipher_walk_done.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org      # 3.13+
>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

As for the previous patch, this correctly fixes a thinko on my part
regarding the guarantees offered by the blkcipher API.

@Russell: could you please indicate whether you prefer to take this
yourself or ack it so we can ask Herbert to take both ARM and arm64
patches as a set.

Regards,
Ard.

> Index: linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm/crypto/aesbs-glue.c
> ===================================================================
> --- linux-3.16.0-0.rc6.git1.1.fc21.aarch64.orig/arch/arm/crypto/aesbs-glue.c
> +++ linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm/crypto/aesbs-glue.c
> @@ -137,7 +137,7 @@ static int aesbs_cbc_encrypt(struct blkc
>                                 dst += AES_BLOCK_SIZE;
>                         } while (--blocks);
>                 }
> -               err = blkcipher_walk_done(desc, &walk, 0);
> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
>         }
>         return err;
>  }
> @@ -158,7 +158,7 @@ static int aesbs_cbc_decrypt(struct blkc
>                 bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
>                                   walk.nbytes, &ctx->dec, walk.iv);
>                 kernel_neon_end();
> -               err = blkcipher_walk_done(desc, &walk, 0);
> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
>         }
>         while (walk.nbytes) {
>                 u32 blocks = walk.nbytes / AES_BLOCK_SIZE;
> @@ -182,7 +182,7 @@ static int aesbs_cbc_decrypt(struct blkc
>                         dst += AES_BLOCK_SIZE;
>                         src += AES_BLOCK_SIZE;
>                 } while (--blocks);
> -               err = blkcipher_walk_done(desc, &walk, 0);
> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
>         }
>         return err;
>  }
> @@ -268,7 +268,7 @@ static int aesbs_xts_encrypt(struct blkc
>                 bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
>                                   walk.nbytes, &ctx->enc, walk.iv);
>                 kernel_neon_end();
> -               err = blkcipher_walk_done(desc, &walk, 0);
> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
>         }
>         return err;
>  }
> @@ -292,7 +292,7 @@ static int aesbs_xts_decrypt(struct blkc
>                 bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
>                                   walk.nbytes, &ctx->dec, walk.iv);
>                 kernel_neon_end();
> -               err = blkcipher_walk_done(desc, &walk, 0);
> +               err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
>         }
>         return err;
>  }
