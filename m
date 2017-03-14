From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: ccp - Assign DMA commands to the channel's CCP
Date: Tue, 14 Mar 2017 08:17:10 +0100
Message-ID: <4585707.bK1Ho6b7OP@tauon.atsec.com>
References: <20170310180341.21062.82465.stgit@taos> <c50f3dd1-ba28-bc67-4a19-e608d223251f@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58052 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdCNHRO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2017 03:17:14 -0400
In-Reply-To: <c50f3dd1-ba28-bc67-4a19-e608d223251f@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 13. März 2017, 20:35:07 CET schrieb Gary R Hook:

Hi Gary,

> On 03/03/2017 7:15 AM, Stephan Mueller wrote:
> > Am Donnerstag, 2. März 2017, 22:26:54 CET schrieb Gary R Hook:
> > 
> > Hi Gary,
> 
> Thanks for your comments, Stephan.
> 
> > > A version 5 device provides the primitive commands
> > > required for AES GCM. This patch adds support for
> > > en/decryption.
> > > 
> > > Signed-off-by: Gary R Hook <gary.hook@amd.com>
> > > ---
> > > 
> > >  drivers/crypto/ccp/Makefile                |    1
> > >  drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257
> > > 
> > > ++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-crypto-main.c      
> > > |
> > > 12 +
> > > 
> > >  drivers/crypto/ccp/ccp-crypto.h            |   14 ++
> > >  drivers/crypto/ccp/ccp-dev-v5.c            |    2
> > >  drivers/crypto/ccp/ccp-dev.h               |    1
> > >  drivers/crypto/ccp/ccp-ops.c               |  252
> > > 
> > > +++++++++++++++++++++++++++ include/linux/ccp.h                        |
> > > 9 +
> > > 
> > >  8 files changed, 548 insertions(+)
> > >  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
> > > 
> > > diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
> > > b/drivers/crypto/ccp/ccp-crypto-aes-galois.c new file mode 100644
> > > index 0000000..8bc18c9
> > > --- /dev/null
> > > +++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
> > > @@ -0,0 +1,257 @@
> > > +/*
> > > + * AMD Cryptographic Coprocessor (CCP) AES GCM crypto API support
> > > + *
> > > + * Copyright (C) 2016 Advanced Micro Devices, Inc.
> > > + *
> > > + * Author: Gary R Hook <gary.hook@amd.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/scatterlist.h>
> > > +#include <linux/crypto.h>
> > > +#include <crypto/internal/aead.h>
> > > +#include <crypto/algapi.h>
> > > +#include <crypto/aes.h>
> > > +#include <crypto/ctr.h>
> > > +#include <crypto/scatterwalk.h>
> > > +#include <linux/delay.h>
> > > +
> > > +#include "ccp-crypto.h"
> > > +
> > > +#define    AES_GCM_IVSIZE  12
> > > +
> > > +static int ccp_aes_gcm_complete(struct crypto_async_request *async_req,
> > > int ret) +{
> > > +   return ret;
> > > +}
> > > +
> > > +static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
> > > +                         unsigned int key_len)
> > > +{
> > > +   struct ccp_ctx *ctx = crypto_aead_ctx(tfm);
> > > +
> > > +   switch (key_len) {
> > > +   case AES_KEYSIZE_128:
> > > +           ctx->u.aes.type = CCP_AES_TYPE_128;
> > > +           break;
> > > +   case AES_KEYSIZE_192:
> > > +           ctx->u.aes.type = CCP_AES_TYPE_192;
> > > +           break;
> > > +   case AES_KEYSIZE_256:
> > > +           ctx->u.aes.type = CCP_AES_TYPE_256;
> > > +           break;
> > > +   default:
> > > +           crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > > +           return -EINVAL;
> > > +   }
> > > +
> > > +   ctx->u.aes.mode = CCP_AES_MODE_GCM;
> > > +   ctx->u.aes.key_len = key_len;
> > > +
> > > +   memcpy(ctx->u.aes.key, key, key_len);
> > > +   sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
> > > +                              unsigned int authsize)
> > > +{
> > > +   return 0;
> > > +}
> > > +
> > > +static int ccp_aes_gcm_crypt(struct aead_request *req, bool encrypt)
> > > +{
> > > +   struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> > > +   struct ccp_ctx *ctx = crypto_aead_ctx(tfm);
> > > +   struct ccp_aes_req_ctx *rctx = aead_request_ctx(req);
> > > +   struct scatterlist *iv_sg = NULL;
> > > +   unsigned int iv_len = 0;
> > > +   int i;
> > > +   int ret = 0;
> > > +
> > > +   if (!ctx->u.aes.key_len)
> > > +           return -EINVAL;
> > > +
> > > +   if (ctx->u.aes.mode != CCP_AES_MODE_GCM)
> > > +           return -EINVAL;
> > > +
> > > +   if (!req->iv)
> > > +           return -EINVAL;
> > > +
> > > +   /*
> > > +    * 5 parts:
> > > +    *   plaintext/ciphertext input
> > > +    *   AAD
> > > +    *   key
> > > +    *   IV
> > > +    *   Destination+tag buffer
> > > +    */
> > > +
> > > +   /* According to the way AES GCM has been implemented here,
> > > +    * per RFC 4106 it seems, the provided IV is fixed at 12 bytes,
> > 
> > When you have that restriction, should the cipher be called
> > rfc4106(gcm(aes))?
> > 
> > But then, the key is 4 bytes longer than a normal AES key as it contains
> > the leading 32 bits of the IV.
> 
> I had my wires crossed due to an incomplete understanding of an AEAD cipher
> in general, and GCM in particular. I'm hopeful that someone can help me
> understand:
> 
> For the AES GCM encryption tests in testmgr.h, where there is an IV,
> they're all
> 12 bytes in length. As I understand AES GCM the IV can be anywhere from
> 1 to 2^64
> bits in length; the value of 96 makes for convenience and efficiency.
> But it's
> neither a requirement nor restriction.

That is correct. For longer IVs, you would need to use Ghash to compress it to 
96 bits. The remaining 32 bits to get to one AES block is the counter that is 
used for the CTR AES mode in GCM.
> 
> There are no tests (in testmgr.h) that use an IV length other than  0 or 96.

See aes_gcm_rfc4106_enc_tv_template for other types of IV.

> My comment about RFC4106 has to do with requiring an IV 0f 96 bits + a word
> that
> is incremented for each block (making every nonce unique, per the
> requirement).
> But let's ignore that, please.
> 
> It looks as if:
> 
> What seems to be missing is the ability to register a (GCM) transform
> that can
> handle an IV of arbitrary (allowable) length. I have to specify the
> length (ivsize)
> when I register an algorithm, and everything I see in the existing code
> appears
> to expect a GCM ivsize to be 96 bits, period (or zero). This is what I
> meant when
> I referenced RFC4106: I perceive restrictions not in my code, but n the
> way GCM seems
> to be supported in the crypto AEAD framework. A complete GCM
> implementation would not
> seem to have a restriction to a specific IV length (rather, a range of
> allowed
> values).

96 bits is the use case in IPSEC. As the kernel crypto API transforms are used 
for IPSEC. Nobody would prevent you from supporting other IV sizes. But then 
you would need to add a Ghash operation to compress it to the right length. No 
other GCM implementation has that and hence the limitation.

But 96 bits is not the common case. See the 4106 implementations, you see the 
ivsize being 8. This is correct because setkey requires AES keysize + 4 bytes 
in length (see crypto_rfc4106_setkey for an example). The trailing 4 bytes of 
the key are the initial 4 bytes of the GCM IV.

My comment was about your comment to refer to RFC4106. I just wanted to 
understand your code and and make sense of your comments. :-)
> 
> Is my reading of the GCM description in error? Do we need/want the ability
> to have a flexible IV length for GCM? What am I not understanding?

In your case, just change the wording in the comment slightly and we are all 
good.
> 
> For reference, I'm working from the NIST doc:
> http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-s
> pec.pdf

> 
> > > +   rctx->cmd.u.aes.key = &ctx->u.aes.key_sg;
> > > +   rctx->cmd.u.aes.key_len = ctx->u.aes.key_len;
> > > +   rctx->cmd.u.aes.iv = iv_sg;
> > > +   rctx->cmd.u.aes.iv_len = iv_len;
> > > +   rctx->cmd.u.aes.src = req->src;
> > > +   rctx->cmd.u.aes.src_len = req->cryptlen;
> > > +   rctx->cmd.u.aes.aad_len = req->assoclen;
> > 
> > Just to be on the safe side: is the implementation good when cryptlen or
> > assoclen is 0?
> 
> The engine has been designed to handle those two conditions. I've been
> watching the discussions around these issues.
> 
> The first encryption test in testmgr.h has no input data nor IV. This
> implementation passes that test.
> 
> The second encryption test in testmgr.h has input data but no IV, and this
> implementation passes.
> 
> Is that an acceptable validation, or do we need more?

I would recommend at least a private test with no input and no AAD (i.e. 
authentication only).

Maybe you can add a patch to testmgr for this case. An example is found at 
[1]. Here, tag and exp is the expected result of the operation.

[1] https://github.com/smuellerDD/libkcapi/blob/master/test/test.sh#L330
> 
> Thanks,
> Gary



Ciao
Stephan
