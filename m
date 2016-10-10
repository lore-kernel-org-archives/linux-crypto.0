From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Mon, 10 Oct 2016 11:07:43 -0700
Message-ID: <20161010180743.GB115716@google.com>
References: <1476119715-71397-2-git-send-email-ebiggers@google.com>
 <1476120595.2856.28.camel@perches.com>
 <20161010173756.GA115716@google.com>
 <1476121874.2856.30.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476121874.2856.30.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 10, 2016 at 10:51:14AM -0700, Joe Perches wrote:
> 
> Hey Eric.
> 
> I don't see any PTR_ALIGN uses in crypto/ or drivers/crypto/ that
> use a bitwise or, just mask + 1, but I believe the effect is the
> same.  Anyway, your choice, but I think using min is clearer.
> 
> cheers, Joe

Usually the bitwise OR is used when setting cra_alignmask in the 'struct
crypto_alg'.  Indeed, the problem could be solved by setting

	inst->alg.base.cra_alignmask = alg->cra_alignmask | (__alignof__(__be64) - 1);

I decided against that because it would always force 8-byte alignment for CMAC
input buffers and keys, when in fact they don't need that level of alignment
unless the underlying block cipher requires it.

Eric
