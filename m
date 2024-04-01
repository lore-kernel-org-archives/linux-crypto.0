Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462E8480
	for <linux-crypto@vger.kernel.org>; Mon,  1 Apr 2024 07:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711956123; cv=none; b=LKq05Lr7mCQTalQbqasIQmv8SIHogITaptZv+qmrWI26IKiWoVeeaqIfKNYOhsT3N511RHV9w0XpPWu1A6NATswbJ8kFhQOWNKdtng78yMPxsfoDa+FHWpg+I1XGEzlVpX7lktBMnFKRp83S/Hz61fYv4Hr6EYQ3PYvf6K7j22w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711956123; c=relaxed/simple;
	bh=7uCBpdUQqMdaFVV1CiCrRQFvtHFssZcU3IF0u3adNiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s2DmLd/6i3bdFeS1tIbiGIGCK/Q3ZL8dXIFXA3xpP4RnLLHTLEGYcyouHhkT8B1cUxWbzU3LztRcjjm3gPBv3BVemzZhUnOYHQWGnSH2BkNIcJRjt0itmAbuRdrP+QF4rmydbv56lT9bEtuf6EDm+Z/zB55TLceXkyYtIJzf6yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=JKyBST8W; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="JKyBST8W"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-61453963883so25364697b3.1
        for <linux-crypto@vger.kernel.org>; Mon, 01 Apr 2024 00:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1711956119; x=1712560919; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vRywTY4RxmqdPRqGAhhdnwUi8dosc+U+3Uc8Us+Tfo=;
        b=JKyBST8WIM3d6UXyJ7zEqm8jwSZf/7VyVCOZQbreqyxm/K4UJlRAFX2NbvUUNNDGlb
         jgLGbWaeJYTbpjRauFdG9o9Q+evjNdufVGW5dTwax3oiNO+ZElf9CeylzcEAm/Hf8UPq
         r+ikwKJKEF7VCuV2CRFejXh0XqYzUXDCx4h3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711956119; x=1712560919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vRywTY4RxmqdPRqGAhhdnwUi8dosc+U+3Uc8Us+Tfo=;
        b=IPBbcSXIcLpqD/eJexpYGTYMCenZdmVjW4KlHZttogUavhVDRNrmGXiiTiv2zW6cpj
         6h9w2eEX4RDufgkRxf+LPJdufrMCtHBZGi8T0/Rb/5x9/MnEoqxJsa9HnL4VvANpuGOP
         RebojpnlMxDu0ufL2VQUpSCuinYcoydPweLlufxfNqcfoEtchOCq9XMc1zbPbvr+mYpT
         FG4Ay0dMTye1y1uMHq3ZPeN002ZDGtI0Thkfk4uVEqmVGkYafH0D9J/WgpCnvsKdHOpK
         v+9K4AwVBTpqTdaiPG8ic5ZIXoqvxQWoIgAruOzpHHfUflMrVeYO5zp28LFnIQchma2e
         w7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUu4bjKSOI8rgZGqFqQHPZt43a+uXcvP8Z7Rsdl7oSo+arIpdz4MkauBFs0hZZzzmjD2JC7vDYiKB1YPtY/5yVGgUid7dVRDTNOTf8Z
X-Gm-Message-State: AOJu0YxfKTe5CqBD77XlmcRQNDpcZCbnycXpqawpQp/Ww+NgN8wnhaqY
	J0zutM9aPPiim9WUMFrYY4ffMwf76Cs6CtSXQuv1dInPs4KIk7UQH4Fd17n/voKtN4ohM0MM+YC
	v0tBpF2SAfOemWlMUmT9Id/0fvxYWrbBPklaVfQ==
X-Google-Smtp-Source: AGHT+IG+HmbBXY2HGvwPSPByL0MgIhFFKZlpnbyzSVw3qfW7uB127Up1IeEc6VqMnGqa/8xfMBELP9HylfLdGDYcb54=
X-Received: by 2002:a0d:ca90:0:b0:60c:cc04:5f05 with SMTP id
 m138-20020a0dca90000000b0060ccc045f05mr8336777ywd.10.1711956119133; Mon, 01
 Apr 2024 00:21:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
 <20240328182652.3587727-2-pavitrakumarm@vayavyalabs.com> <6e486947-54cb-4ff5-bcf3-97e6ae106412@linux.microsoft.com>
In-Reply-To: <6e486947-54cb-4ff5-bcf3-97e6ae106412@linux.microsoft.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 1 Apr 2024 12:51:47 +0530
Message-ID: <CALxtO0=tvJh+h9W+1eN4xLQtwOugteABpA0QUTrgJ=f_dgeVoA@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] Add SPAcc driver to Linux kernel
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Easwar,
  My comments are embedded below. Also should I wait for more comments
from you or
should I go ahead and push v2 with the below fixes ?

Warm regards,
PK

On Fri, Mar 29, 2024 at 11:26=E2=80=AFPM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> Partial review comments below, more to come. Please, in the future, split=
 the patches up more so reviewers
> don't have to review ~9k lines in 1 email.
>
> On 3/28/2024 11:26 AM, Pavitrakumar M wrote:
> > Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1382 ++++++++++
> >  drivers/crypto/dwc-spacc/spacc_ahash.c     | 1183 ++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.c      | 2917 ++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h      |  839 ++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c    |  324 +++
> >  drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
> >  drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
> >  drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  204 ++
> >  drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
> >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  754 +++++
> >  11 files changed, 8987 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> >
> > diff --git a/drivers/crypto/dwc-spacc/spacc_aead.c b/drivers/crypto/dwc=
-spacc/spacc_aead.c
> > new file mode 100644
> > index 000000000000..f4b1ae9a4ef1
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_aead.c
> > @@ -0,0 +1,1382 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <crypto/aes.h>
> > +#include <crypto/sm4.h>
> > +#include <crypto/gcm.h>
> > +#include <crypto/aead.h>
> > +#include <crypto/authenc.h>
> > +#include <linux/rtnetlink.h>
> > +#include <crypto/scatterwalk.h>
> > +#include <crypto/internal/aead.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include "spacc_device.h"
> > +#include "spacc_core.h"
> > +
> > +static LIST_HEAD(spacc_aead_alg_list);
> > +static DEFINE_MUTEX(spacc_aead_alg_mutex);
> > +
> > +#define SPACC_B0_LEN         16
> > +#define SET_IV_IN_SRCBUF     0x80000000
> > +#define SET_IV_IN_CONTEXT    0x0
> > +#define IV_PTEXT_BUF_SZ              8192
> > +#define XTRA_BUF_LEN         4096
> > +#define IV_B0_LEN            (XTRA_BUF_LEN + SPACC_B0_LEN +\
> > +                              SPACC_MAX_IV_SIZE)
> > +
> > +struct spacc_iv_buf {
> > +     unsigned char iv[SPACC_MAX_IV_SIZE];
> > +     unsigned char fulliv[SPACC_MAX_IV_SIZE + SPACC_B0_LEN + XTRA_BUF_=
LEN];
>
> So the value here is identical to IV_B0_LEN defined above, is there a sem=
antic or documentation
> reason we are adding these up again? It feels natural to me to have a ful=
liv buffer of size IV_B0_LEN,
> but I'm new to crypto, and maybe I'm missing something?
>
> Also I'm wondering why there is a mix of *LEN, *SZ, and *SIZE in the defi=
nes.
>
PK: Will fix that

> > +     unsigned char ptext[IV_PTEXT_BUF_SZ];
> > +     struct scatterlist sg[2], fullsg[2], ptextsg[2];
> > +};
> > +
> > +static struct kmem_cache *spacc_iv_pool;
> > +
> > +static void spacc_init_aead_alg(struct crypto_alg *calg,
> > +                             const struct mode_tab *mode)
> > +{
> > +     snprintf(calg->cra_name, sizeof(mode->name), "%s", mode->name);
> > +     snprintf(calg->cra_driver_name, sizeof(calg->cra_driver_name),
> > +                                     "spacc-%s", mode->name);
> > +     calg->cra_blocksize =3D mode->blocklen;
> > +}
> > +
> > +static struct mode_tab possible_aeads[] =3D {
> > +     { MODE_TAB_AEAD("rfc7539(chacha20,poly1305)",
> > +                     CRYPTO_MODE_CHACHA20_POLY1305, CRYPTO_MODE_NULL,
> > +                     16, 12, 1), .keylen =3D { 16, 24, 32 }
> > +     },
> > +     { MODE_TAB_AEAD("gcm(aes)",
> > +                     CRYPTO_MODE_AES_GCM, CRYPTO_MODE_NULL,
> > +                     16, 12, 1), .keylen =3D { 16, 24, 32 }
> > +     },
> > +     { MODE_TAB_AEAD("gcm(sm4)",
> > +                     CRYPTO_MODE_SM4_GCM, CRYPTO_MODE_NULL,
> > +                     16, 12, 1), .keylen =3D { 16 }
> > +     },
> > +     { MODE_TAB_AEAD("ccm(aes)",
> > +                     CRYPTO_MODE_AES_CCM, CRYPTO_MODE_NULL,
> > +                     16, 16, 1), .keylen =3D { 16, 24, 32 }
> > +     },
> > +     { MODE_TAB_AEAD("ccm(sm4)",
> > +                     CRYPTO_MODE_SM4_CCM, CRYPTO_MODE_NULL,
> > +                     16, 16, 1), .keylen =3D { 16, 24, 32 }
> > +     },
> > +};
> > +
> > +static int ccm_16byte_aligned_len(int in_len)
> > +{
> > +     int len;
> > +     int computed_mod;
> > +
> > +     if (in_len > 0) {
> > +             computed_mod =3D in_len % 16;
> > +             if (computed_mod)
> > +                     len =3D in_len - computed_mod + 16;
> > +             else
> > +                     len =3D in_len;
> > +     } else {
> > +             len =3D in_len;
> > +     }
> > +
> > +     return len;
> > +}
> > +
> > +/* taken from crypto/ccm.c */
> > +static int spacc_aead_format_adata(u8 *adata, unsigned int a)
> > +{
> > +     int len =3D 0;
> > +
> > +     /* add control info for associated data
> > +      * RFC 3610 and NIST Special Publication 800-38C
> > +      */
> > +     if (a < 65280) {
> > +             *(__be16 *)adata =3D cpu_to_be16(a);
> > +             len =3D 2;
> > +     } else  {
> > +             *(__be16 *)adata =3D cpu_to_be16(0xfffe);
> > +             *(__be32 *)&adata[2] =3D cpu_to_be32(a);
> > +             len =3D 6;
> > +     }
> > +
> > +     return len;
> > +}
> > +
> > +
> > +/* taken from crypto/ccm.c */
> > +static int spacc_aead_set_msg_len(u8 *block, unsigned int msglen, int =
csize)
> > +{
> > +     __be32 data;
> > +
> > +     memset(block, 0, csize);
> > +     block +=3D csize;
> > +
> > +     if (csize >=3D 4)
> > +             csize =3D 4;
> > +     else if (msglen > (unsigned int)(1 << (8 * csize)))
> > +             return -EOVERFLOW;
> > +
> > +     data =3D cpu_to_be32(msglen);
> > +     memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
> > +
> > +     return 0;
> > +}
> > +
> > +static int spacc_aead_init_dma(struct device *dev, struct aead_request=
 *req,
> > +                            u64 seq, uint32_t icvlen,
> > +                            int encrypt, int *alen)
> > +{
> > +     struct crypto_aead *reqtfm      =3D crypto_aead_reqtfm(req);
> > +     struct spacc_crypto_ctx *tctx   =3D crypto_aead_ctx(reqtfm);
> > +     struct spacc_crypto_reqctx *ctx =3D aead_request_ctx(req);
> > +
> > +     gfp_t mflags =3D GFP_ATOMIC;
> > +     struct spacc_iv_buf *iv;
> > +     int ccm_aad_16b_len =3D 0;
> > +     int rc, B0len;
> > +     int payload_len, fullsg_buf_len;
> > +     unsigned int ivsize =3D crypto_aead_ivsize(reqtfm);
> > +
> > +     /* always have 1 byte of IV */
> > +     if (!ivsize)
> > +             ivsize =3D 1;
> > +
> > +     if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
> > +             mflags =3D GFP_KERNEL;
> > +
> > +     ctx->iv_buf =3D kmem_cache_alloc(spacc_iv_pool, mflags);
> > +     if (!ctx->iv_buf)
> > +             return -ENOMEM;
> > +     iv =3D ctx->iv_buf;
> > +
> > +     sg_init_table(iv->sg, ARRAY_SIZE(iv->sg));
> > +     sg_init_table(iv->fullsg, ARRAY_SIZE(iv->fullsg));
> > +     sg_init_table(iv->ptextsg, ARRAY_SIZE(iv->ptextsg));
> > +
> > +     B0len =3D 0;
> > +     ctx->ptext_nents =3D 0;
> > +     ctx->fulliv_nents =3D 0;
> > +
> > +     memset(iv->iv, 0, SPACC_MAX_IV_SIZE);
> > +     memset(iv->fulliv, 0, IV_B0_LEN);
> > +     memset(iv->ptext, 0, IV_PTEXT_BUF_SZ);
> > +
> > +     /* copy the IV out for AAD */
> > +     memcpy(iv->iv, req->iv, ivsize);
> > +
> > +     /* now we need to figure out the cipher IV which may or
> > +      * may not be "req->iv" depending on the mode we are
>
> ...depending on the mode we are *in*
>
PK: will fix that

> > +      */
> > +     if (tctx->mode & SPACC_MANGLE_IV_FLAG) {
> > +             switch (tctx->mode & 0x7F00) {
> > +             case SPACC_MANGLE_IV_RFC3686:
> > +             case SPACC_MANGLE_IV_RFC4106:
> > +             case SPACC_MANGLE_IV_RFC4543:
> > +                     {
> > +                             unsigned char *p =3D iv->fulliv;
> > +                             /* we're in RFC3686 mode so the last
> > +                              * 4 bytes of the key are the SALT
> > +                              */
> > +                             memcpy(p, tctx->csalt, 4);
> > +                             memcpy(p + 4, req->iv, ivsize);
> > +
> > +                             p[12] =3D 0;
> > +                             p[13] =3D 0;
> > +                             p[14] =3D 0;
> > +                             p[15] =3D 1;
> > +                     }
> > +                     break;
> > +             case SPACC_MANGLE_IV_RFC4309:
> > +                     {
> > +                             unsigned char *p =3D iv->fulliv;
> > +                             int L, M;
> > +                             u32 lm =3D req->cryptlen;
> > +
> > +                             /* CCM mode */
> > +                             /* p[0..15] is the CTR IV */
> > +                             /* p[16..31] is the CBC-MAC B0 block*/
> > +                             B0len =3D SPACC_B0_LEN;
> > +                             /* IPsec requires L=3D4*/
> > +                             L =3D 4;
> > +                             M =3D tctx->auth_size;
> > +
> > +                             /* CTR block */
> > +                             p[0] =3D L - 1;
> > +                             memcpy(p + 1, tctx->csalt, 3);
> > +                             memcpy(p + 4, req->iv, ivsize);
> > +                             p[12] =3D 0;
> > +                             p[13] =3D 0;
> > +                             p[14] =3D 0;
> > +                             p[15] =3D 1;
> > +
> > +                             /* store B0 block at p[16..31] */
> > +                             p[16] =3D (1 << 6) | (((M - 2) >> 1) << 3=
)
> > +                                     | (L - 1);
> > +                             memcpy(p + 1 + 16, tctx->csalt, 3);
> > +                             memcpy(p + 4 + 16, req->iv, ivsize);
> > +
> > +                             /* now store length */
> > +                             p[16 + 12 + 0] =3D (lm >> 24) & 0xFF;
> > +                             p[16 + 12 + 1] =3D (lm >> 16) & 0xFF;
> > +                             p[16 + 12 + 2] =3D (lm >> 8) & 0xFF;
> > +                             p[16 + 12 + 3] =3D (lm) & 0xFF;
> > +
> > +                             /*now store the pre-formatted AAD */
> > +                             p[32] =3D (req->assoclen >> 8) & 0xFF;
> > +                             p[33] =3D (req->assoclen) & 0xFF;
> > +                             /* we added 2 byte header to the AAD */
> > +                             B0len +=3D 2;
> > +                     }
> > +                     break;
> > +             }
> > +     } else if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM ||
> > +                tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM) {
> > +             unsigned char *p =3D iv->fulliv;
> > +             int L, M;
> > +
> > +             u32 lm =3D (encrypt) ?
> > +                      req->cryptlen :
> > +                      req->cryptlen - tctx->auth_size;
> > +
> > +             /* CCM mode */
> > +             /* p[0..15] is the CTR IV */
> > +             /* p[16..31] is the CBC-MAC B0 block*/
> > +             B0len =3D SPACC_B0_LEN;
> > +
> > +             /* IPsec requires L=3D4 */
> > +             L =3D req->iv[0] + 1;
> > +             M =3D tctx->auth_size;
> > +
> > +             /* CTR block */
> > +             memcpy(p, req->iv, ivsize);
> > +             memcpy(p + 16, req->iv, ivsize);
> > +
> > +             /* Store B0 block at p[16..31] */
> > +             p[16] |=3D (8 * ((M - 2) / 2));
> > +
> > +             /* set adata if assoclen > 0 */
> > +             if (req->assoclen)
> > +                     p[16] |=3D 64;
> > +
> > +             /* now store length, this is L size starts from 16-L
> > +              * to 16 of B0
> > +              */
> > +             spacc_aead_set_msg_len(p + 16 + 16 - L, lm, L);
> > +
> > +             if (req->assoclen) {
> > +
> > +                     /* store pre-formatted AAD:
> > +                      * AAD_LEN + AAD + PAD
> > +                      */
> > +                     *alen =3D spacc_aead_format_adata(&p[32], req->as=
soclen);
> > +
> > +                     ccm_aad_16b_len =3D
> > +                             ccm_16byte_aligned_len(req->assoclen + *a=
len);
> > +
> > +                     /* Adding the rest of AAD from req->src */
> > +                     scatterwalk_map_and_copy(p + 32 + *alen,
> > +                                              req->src, 0,
> > +                                              req->assoclen, 0);
> > +
> > +                     /* Copy AAD to req->dst */
> > +                     scatterwalk_map_and_copy(p + 32 + *alen, req->dst=
,
> > +                                              0, req->assoclen, 1);
> > +
> > +             }
> > +
> > +             /* Adding PT/CT from req->src to ptext here */
> > +             if (req->cryptlen)
> > +                     memset(iv->ptext, 0,
> > +                            ccm_16byte_aligned_len(req->cryptlen));
> > +
> > +             scatterwalk_map_and_copy(iv->ptext, req->src,
> > +                                      req->assoclen,
> > +                                      req->cryptlen, 0);
> > +
> > +
> > +     } else {
> > +
> > +             /* default is to copy the iv over since the
> > +              * cipher and protocol IV are the same
> > +              */
> > +             memcpy(iv->fulliv, req->iv, ivsize);
> > +
> > +     }
> > +
> > +     /* this is part of the AAD */
> > +     sg_set_buf(iv->sg, iv->iv, ivsize);
> > +
> > +     /* GCM and CCM don't include the IV in the AAD */
> > +     if (tctx->mode =3D=3D CRYPTO_MODE_AES_GCM_RFC4106   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_GCM           ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_SM4_GCM_RFC8998   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_CHACHA20_POLY1305 ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_NULL) {
>
> Is this better constructed as a switch..case? You could even consolidate =
the
> sg creation and submission to the SPACC engine below into a common case w=
ith
> some indirection for the differing parameters...
>
PK: Sure, will refactor and fix that

> > +
> > +             ctx->iv_nents  =3D 0;
> > +             payload_len    =3D req->cryptlen + icvlen + req->assoclen=
;
> > +             fullsg_buf_len =3D SPACC_MAX_IV_SIZE + B0len;
> > +
> > +             /* this is the actual IV getting fed to the core
> > +              * (via IV IMPORT)
> > +              */
> > +
> > +             sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
> > +
> > +             rc =3D spacc_sgs_to_ddt(dev,
> > +                                   iv->fullsg, fullsg_buf_len,
> > +                                   &ctx->fulliv_nents, NULL, 0,
> > +                                   &ctx->iv_nents, req->src,
> > +                                   payload_len, &ctx->src_nents,
> > +                                   &ctx->src, DMA_TO_DEVICE);
> > +
> > +     } else if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM         ||
> > +                tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309 ||
> > +                tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM) {
> > +
> > +
> > +             ctx->iv_nents =3D 0;
> > +
> > +             if (encrypt)
> > +                     payload_len =3D
> > +                             ccm_16byte_aligned_len(req->cryptlen + ic=
vlen);
> > +             else
> > +                     payload_len =3D
> > +                             ccm_16byte_aligned_len(req->cryptlen);
> > +
> > +             fullsg_buf_len =3D SPACC_MAX_IV_SIZE + B0len + ccm_aad_16=
b_len;
> > +
> > +
> > +             /* this is the actual IV getting fed to the core (via IV =
IMPORT)
> > +              * This has CTR IV + B0 + AAD(B1, B2, ...)
> > +              */
> > +             sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
> > +             sg_set_buf(iv->ptextsg, iv->ptext, payload_len);
> > +
> > +             rc =3D spacc_sgs_to_ddt(dev,
> > +                                   iv->fullsg, fullsg_buf_len,
> > +                                   &ctx->fulliv_nents, NULL, 0,
> > +                                   &ctx->iv_nents, iv->ptextsg,
> > +                                   payload_len, &ctx->ptext_nents,
> > +                                   &ctx->src, DMA_TO_DEVICE);
> > +
> > +     } else {
> > +             payload_len =3D req->cryptlen + icvlen + req->assoclen;
> > +             fullsg_buf_len =3D SPACC_MAX_IV_SIZE + B0len;
> > +
> > +             /* this is the actual IV getting fed to the core (via IV =
IMPORT)
> > +              * This has CTR IV + B0 + AAD(B1, B2, ...)
> > +              */
> > +             sg_set_buf(iv->fullsg, iv->fulliv, fullsg_buf_len);
> > +
> > +             rc =3D spacc_sgs_to_ddt(dev, iv->fullsg, fullsg_buf_len,
> > +                                   &ctx->fulliv_nents, iv->sg,
> > +                                   ivsize, &ctx->iv_nents,
> > +                                   req->src, payload_len, &ctx->src_ne=
nts,
> > +                                   &ctx->src, DMA_TO_DEVICE);
> > +     }
> > +
> > +     if (rc < 0)
> > +             goto err_free_iv;
>
> ...and that would allow this result check to be next to the spacc_sgs_to_=
ddt call that it gets
> its value from
>
PK: That check is applicable to all "spacc_sgs_to_ddt" calls in if-elseif-e=
lse;
       but I do see your point for code readability/control issues.
Will fix this.

> > +
> > +     /* Putting in req->dst is good since it won't overwrite anything
> > +      * even in case of CCM this is fine condition
> > +      */
> > +     if (req->dst !=3D req->src) {
> > +             if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM) {
>
> Similar comment to above, looks like this could be better structured as a=
 switch-case.
>
PK: Sure, will fix this.

> > +                     /* If req->dst buffer len is not-positive,
> > +                      * then skip setting up of DMA
> > +                      */
> > +                     if (req->dst->length <=3D 0) {
> > +                             ctx->dst_nents =3D 0;
> > +                             return 0;
> > +                     }
> > +
> > +                     if (encrypt)
> > +                             payload_len =3D req->cryptlen + icvlen +
> > +                                             req->assoclen;
> > +                     else
> > +                             payload_len =3D req->cryptlen - tctx->aut=
h_size +
> > +                                             req->assoclen;
>
> No check for payload_len =3D=3D 0 after these operations here, unlike in =
the else case that
> returns -EBADMSG. Is this intentional?
>
PK: Yes that check is not needed in case of Encryption, so we dont have tha=
t.

> > +
> > +                     /* For corner cases where PTlen=3DAADlen=3D0, we =
set default
> > +                      * to 16
> > +                      */
> > +                     rc =3D spacc_sg_to_ddt(dev, req->dst,
> > +                                          payload_len > 0 ? payload_le=
n : 16,
> > +                                          &ctx->dst, DMA_FROM_DEVICE);
> > +                     if (rc < 0)
> > +                             goto err_free_src;
> > +
> > +                     ctx->dst_nents =3D rc;
> > +             } else {
> > +
> > +                     /* If req->dst buffer len is not-positive,
> > +                      * then skip setting up of DMA
> > +                      */
> > +                     if (req->dst->length <=3D 0) {
> > +                             ctx->dst_nents =3D 0;
> > +                             return 0;
> > +                     }
> > +
> > +                     if (encrypt)
> > +                             payload_len =3D SPACC_MAX_IV_SIZE + req->=
cryptlen
> > +                                             + icvlen + req->assoclen;
> > +                     else {
> > +                             payload_len =3D req->cryptlen - tctx->aut=
h_size +
> > +                                             req->assoclen;
> > +                             if (payload_len =3D=3D 0)
> > +                                     return -EBADMSG;
>
> Should this be checking for <=3D 0?
PK: Sure, will fix that

>
> > +                     }
> > +
> > +
> > +                     rc =3D spacc_sg_to_ddt(dev, req->dst, payload_len=
,
> > +                                             &ctx->dst, DMA_FROM_DEVIC=
E);
> > +                     if (rc < 0)
> > +                             goto err_free_src;
> > +
> > +                     ctx->dst_nents =3D rc;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +
> > +err_free_src:
> > +     if (ctx->fulliv_nents)
> > +             dma_unmap_sg(dev, iv->fullsg, ctx->fulliv_nents,
> > +                          DMA_TO_DEVICE);
> > +
> > +     if (ctx->iv_nents)
> > +             dma_unmap_sg(dev, iv->sg, ctx->iv_nents, DMA_TO_DEVICE);
> > +
> > +     if (ctx->ptext_nents)
> > +             dma_unmap_sg(dev, iv->ptextsg, ctx->ptext_nents,
> > +                          DMA_TO_DEVICE);
> > +
> > +     dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE);
> > +     pdu_ddt_free(&ctx->src);
> > +
> > +err_free_iv:
> > +     kmem_cache_free(spacc_iv_pool, ctx->iv_buf);
> > +
> > +     return rc;
> > +}
> > +
> > +static void spacc_aead_cleanup_dma(struct device *dev, struct aead_req=
uest *req)
> > +{
> > +     struct spacc_crypto_reqctx *ctx =3D aead_request_ctx(req);
> > +     struct spacc_iv_buf *iv =3D ctx->iv_buf;
> > +
> > +     if (req->src !=3D req->dst) {
> > +             if (req->dst->length > 0) {
> > +                     dma_unmap_sg(dev, req->dst, ctx->dst_nents,
> > +                                  DMA_FROM_DEVICE);
> > +                     pdu_ddt_free(&ctx->dst);
> > +             }
> > +     }
> > +
> > +     if (ctx->fulliv_nents)
> > +             dma_unmap_sg(dev, iv->fullsg, ctx->fulliv_nents,
> > +                          DMA_TO_DEVICE);
> > +
> > +     if (ctx->ptext_nents)
> > +             dma_unmap_sg(dev, iv->ptextsg, ctx->ptext_nents,
> > +                          DMA_TO_DEVICE);
> > +
> > +     if (ctx->iv_nents)
> > +             dma_unmap_sg(dev, iv->sg, ctx->iv_nents,
> > +                          DMA_TO_DEVICE);
>
> The ordering of unmapping ptext and iv sgs differs from the err_free_src(=
) cleanup above. If it
> isn't intentional, maybe we can share some code here to prevent inadverte=
nt ordering violations?
>
PK: That is not a problem since there is no dependency, but I will fix
that so its uniform across.

> > +
> > +     if (req->src->length > 0) {
> > +             dma_unmap_sg(dev, req->src, ctx->src_nents, DMA_TO_DEVICE=
);
> > +             pdu_ddt_free(&ctx->src);
> > +     }
> > +
> > +     kmem_cache_free(spacc_iv_pool, ctx->iv_buf);
> > +}
> > +
> > +static bool spacc_keylen_ok(const struct spacc_alg *salg, unsigned int=
 keylen)
> > +{
> > +     unsigned int i, mask =3D salg->keylen_mask;
> > +
> > +     BUG_ON(mask > (1ul << ARRAY_SIZE(salg->mode->keylen)) - 1);
>
> Do we really need to panic the kernel here? If we do, maybe we can write =
a comment explaining why this
> should be fatal.
>
PK: Agreed, I think returning EINVAL is better than panicking. Will fix tha=
t.

> > +
> > +     for (i =3D 0; mask; i++, mask >>=3D 1) {
> > +             if (mask & 1 && salg->mode->keylen[i] =3D=3D keylen)
> > +                     return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
>
> <snip>
>
> > +
>
> > +static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key, u=
nsigned
> > +             int keylen)
> > +{
> > +     struct spacc_crypto_ctx *ctx  =3D crypto_aead_ctx(tfm);
> > +     const struct spacc_alg  *salg =3D spacc_tfm_aead(&tfm->base);
> > +     struct spacc_priv       *priv;
> > +     struct rtattr *rta =3D (void *)key;
> > +     struct crypto_authenc_key_param *param;
> > +     unsigned int x, authkeylen, enckeylen;
> > +     const unsigned char *authkey, *enckey;
> > +     unsigned char xcbc[64];
> > +
> > +     int err =3D -EINVAL;
> > +     int singlekey =3D 0;
> > +
> > +     /* are keylens valid? */
> > +     ctx->ctx_valid =3D false;
> > +
> > +     switch (ctx->mode & 0xFF) {
> > +     case CRYPTO_MODE_SM4_GCM:
> > +     case CRYPTO_MODE_SM4_CCM:
> > +     case CRYPTO_MODE_NULL:
> > +     case CRYPTO_MODE_AES_GCM:
> > +     case CRYPTO_MODE_AES_CCM:
> > +     case CRYPTO_MODE_CHACHA20_POLY1305:
> > +             authkey      =3D key;
> > +             authkeylen   =3D 0;
> > +             enckey       =3D key;
> > +             enckeylen    =3D keylen;
> > +             ctx->keylen  =3D keylen;
> > +             singlekey    =3D 1;
> > +             goto skipover;
> > +     }
> > +
> > +     if (!RTA_OK(rta, keylen))
> > +             goto badkey;
> > +
> > +     if (rta->rta_type !=3D CRYPTO_AUTHENC_KEYA_PARAM)
> > +             goto badkey;
> > +
> > +     if (RTA_PAYLOAD(rta) < sizeof(*param))
> > +             goto badkey;
>
> Can these 3 checks be combined or is this some idiomatic code to individu=
ally validate
> these? If you can combine them, you can return -EINVAL here and for keyle=
n < enckeylen
> below, and keep the pattern of do something...check...return errorcode of=
 the rest
> of the function and get rid of the badkey label.
>
PK: Sure, will combine that so I can do away with that badkey and
return -EINVAL.

> > +
> > +     param =3D RTA_DATA(rta);
> > +     enckeylen =3D be32_to_cpu(param->enckeylen);
> > +
> > +     key +=3D RTA_ALIGN(rta->rta_len);
> > +     keylen -=3D RTA_ALIGN(rta->rta_len);
> > +
> > +     if (keylen < enckeylen)
> > +             goto badkey;
> > +
> > +     authkeylen =3D keylen - enckeylen;
> > +
> > +     /* enckey is at &key[authkeylen] and
> > +      * authkey is at &key[0]
> > +      */
> > +     authkey =3D &key[0];
> > +     enckey  =3D &key[authkeylen];
> > +
> > +skipover:
> > +     /* detect RFC3686/4106 and trim from enckeylen(and copy salt..) *=
/
> > +     if (ctx->mode & SPACC_MANGLE_IV_FLAG) {
> > +             switch (ctx->mode & 0x7F00) {
> > +             case SPACC_MANGLE_IV_RFC3686:
> > +             case SPACC_MANGLE_IV_RFC4106:
> > +             case SPACC_MANGLE_IV_RFC4543:
> > +                     memcpy(ctx->csalt, enckey + enckeylen - 4, 4);
> > +                     enckeylen -=3D 4;
> > +                     break;
> > +             case SPACC_MANGLE_IV_RFC4309:
> > +                     memcpy(ctx->csalt, enckey + enckeylen - 3, 3);
> > +                     enckeylen -=3D 3;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (!singlekey) {
> > +             if (authkeylen > salg->mode->hashlen) {
> > +                     dev_warn(ctx->dev, "Auth key size of %u is not va=
lid\n",
> > +                              authkeylen);
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     if (!spacc_keylen_ok(salg, enckeylen)) {
> > +             dev_warn(ctx->dev, "Enc key size of %u is not valid\n",
> > +                      enckeylen);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* if we're already open close the handle since
> > +      * the size may have changed
> > +      */
> > +     if (ctx->handle !=3D -1) {
> > +             priv =3D dev_get_drvdata(ctx->dev);
> > +             spacc_close(&priv->spacc, ctx->handle);
> > +             put_device(ctx->dev);
> > +             ctx->handle =3D -1;
> > +     }
> > +
> > +     /* Open a handle and
> > +      * search all devices for an open handle
> > +      */
> > +     priv =3D NULL;
> > +     for (x =3D 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
> > +             priv =3D dev_get_drvdata(salg->dev[x]);
> > +
> > +             /* increase reference */
> > +             ctx->dev =3D get_device(salg->dev[x]);
> > +
> > +             /* check if its a valid mode ... */
> > +             if (spacc_isenabled(&priv->spacc, salg->mode->aead.ciph &=
 0xFF,
> > +                                 enckeylen) &&
> > +                 spacc_isenabled(&priv->spacc,
> > +                                 salg->mode->aead.hash & 0xFF, authkey=
len)) {
> > +                             /* try to open spacc handle */
> > +                     ctx->handle =3D spacc_open(&priv->spacc,
> > +                                              salg->mode->aead.ciph & =
0xFF,
> > +                                              salg->mode->aead.hash & =
0xFF,
> > +                                              -1, 0, spacc_aead_cb, tf=
m);
> > +             }
> > +
> > +             if (ctx->handle < 0)
> > +                     put_device(salg->dev[x]);
> > +             else
> > +                     break;
> > +     }
> > +
> > +     if (ctx->handle < 0) {
> > +             dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
> > +             return -EIO;
> > +     }
> > +
> > +     /* setup XCBC key */
> > +     if (salg->mode->aead.hash =3D=3D CRYPTO_MODE_MAC_XCBC) {
> > +             err =3D spacc_compute_xcbc_key(&priv->spacc,
> > +                                          salg->mode->aead.hash,
> > +                                          ctx->handle, authkey,
> > +                                          authkeylen, xcbc);
> > +             if (err < 0) {
> > +                     dev_warn(ctx->dev, "Failed to compute XCBC key: %=
d\n",
> > +                              err);
> > +                     return -EIO;
> > +             }
> > +             authkey    =3D xcbc;
> > +             authkeylen =3D 48;
> > +     }
> > +
> > +     /* handle zero key/zero len DEC condition for SM4/AES GCM mode */
> > +     ctx->zero_key =3D 0;
> > +     if (!key[0]) {
> > +             int i, val =3D 0;
> > +
> > +             for (i =3D 0; i < keylen ; i++)
> > +                     val +=3D key[i];
> > +
> > +             if (val =3D=3D 0)
> > +                     ctx->zero_key =3D 1;
> > +     }
> > +
> > +     err =3D spacc_write_context(&priv->spacc, ctx->handle,
> > +                               SPACC_CRYPTO_OPERATION, enckey,
> > +                               enckeylen, NULL, 0);
> > +
> > +     if (err) {
> > +             dev_warn(ctx->dev,
> > +                      "Could not write ciphering context: %d\n", err);
> > +             return -EIO;
> > +     }
> > +
> > +     if (!singlekey) {
> > +             err =3D spacc_write_context(&priv->spacc, ctx->handle,
> > +                                       SPACC_HASH_OPERATION, authkey,
> > +                                       authkeylen, NULL, 0);
> > +             if (err) {
> > +                     dev_warn(ctx->dev,
> > +                              "Could not write hashing context: %d\n",=
 err);
> > +                     return -EIO;
> > +             }
> > +     }
> > +
> > +     /* set expand key */
> > +     spacc_set_key_exp(&priv->spacc, ctx->handle);
> > +     ctx->ctx_valid =3D true;
> > +
> > +     memset(xcbc, 0, sizeof(xcbc));
> > +
> > +     /* copy key to ctx for fallback */
> > +     memcpy(ctx->key, key, keylen);
> > +
> > +     return 0;
> > +
> > +badkey:
> > +     return err;
> > +}
> > +
>
> <snip>
>
> > +
> > +static int spacc_aead_process(struct aead_request *req, u64 seq, int
> > +             encrypt)
> > +{
> > +     int rc;
> > +     int B0len;
> > +     int alen;
> > +     u32 dstoff;
> > +     int icvremove;
> > +     int ivaadsize;
> > +     int ptaadsize;
> > +     int iv_to_context;
> > +     int spacc_proc_len;
> > +     u32 spacc_icv_offset;
> > +     int spacc_pre_aad_size;
> > +     int ccm_aad_16b_len;
> > +     struct crypto_aead *reqtfm      =3D crypto_aead_reqtfm(req);
> > +     int ivsize                      =3D crypto_aead_ivsize(reqtfm);
> > +     struct spacc_crypto_ctx *tctx   =3D crypto_aead_ctx(reqtfm);
> > +     struct spacc_crypto_reqctx *ctx =3D aead_request_ctx(req);
> > +     struct spacc_priv *priv         =3D dev_get_drvdata(tctx->dev);
> > +     u32 msg_len =3D req->cryptlen - tctx->auth_size;
> > +     u32 l;
> > +
> > +     ctx->encrypt_op =3D encrypt;
> > +     alen =3D 0;
> > +     ccm_aad_16b_len =3D 0;
> > +
> > +     if (tctx->handle < 0 || !tctx->ctx_valid || (req->cryptlen +
> > +                             req->assoclen) > priv->max_msg_len)
> > +             return -EINVAL;
> > +
> > +     /* IV is programmed to context by default */
> > +     iv_to_context =3D SET_IV_IN_CONTEXT;
> > +
> > +     if (encrypt) {
> > +             switch (tctx->mode & 0xFF) {
> > +             case CRYPTO_MODE_AES_GCM:
> > +             case CRYPTO_MODE_SM4_GCM:
> > +             case CRYPTO_MODE_CHACHA20_POLY1305:
> > +                     /* For cryptlen =3D 0 */
> > +                     if (req->cryptlen + req->assoclen =3D=3D 0)
> > +                             return spacc_aead_fallback(req, tctx, enc=
rypt);
> > +                     break;
> > +             case CRYPTO_MODE_AES_CCM:
> > +             case CRYPTO_MODE_SM4_CCM:
> > +                     l =3D req->iv[0] + 1;
> > +
> > +                     /* 2 <=3D L <=3D 8, so 1 <=3D L' <=3D 7. */
> > +                     if (req->iv[0] < 1 || req->iv[0] > 7)
> > +                             return -EINVAL;
> > +
> > +                     /* verify that msglen can in fact be represented
> > +                      * in L bytes
> > +                      */
> > +                     if (l < 4 && msg_len >> (8 * l))
> > +                             return -EOVERFLOW;
> > +
> > +                     break;
> > +             default:
> > +                     pr_debug("Unsupported algo");
> > +                     return -EINVAL;
> > +             }
> > +     } else {
> > +             int ret;
> > +
> > +             /* Handle the decryption */
> > +             switch (tctx->mode & 0xFF) {
> > +             case CRYPTO_MODE_AES_GCM:
> > +             case CRYPTO_MODE_SM4_GCM:
> > +             case CRYPTO_MODE_CHACHA20_POLY1305:
> > +                     /* For assoclen =3D 0 */
> > +                     if (req->assoclen =3D=3D 0 && (req->cryptlen - tc=
tx->auth_size =3D=3D 0)) {
> > +                             ret =3D spacc_aead_fallback(req, tctx, en=
crypt);
> > +                             return ret;
> > +                     }
> > +                     break;
> > +             case CRYPTO_MODE_AES_CCM:
> > +             case CRYPTO_MODE_SM4_CCM:
> > +                     /* 2 <=3D L <=3D 8, so 1 <=3D L' <=3D 7. */
> > +                     if (req->iv[0] < 1 || req->iv[0] > 7)
> > +                             return -EINVAL;
> > +                     break;
> > +             default:
> > +                     pr_debug("Unsupported algo");
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     icvremove =3D (encrypt) ? 0 : tctx->auth_size;
> > +
> > +     rc =3D spacc_aead_init_dma(tctx->dev, req, seq, (encrypt) ?
> > +                     tctx->auth_size : 0, encrypt, &alen);
> > +     if (rc < 0)
> > +             return -EINVAL;
> > +
> > +     if (req->assoclen)
> > +             ccm_aad_16b_len =3D ccm_16byte_aligned_len(req->assoclen =
+ alen);
> > +
> > +     /* Note: This won't work if IV_IMPORT has been disabled */
> > +     ctx->cb.new_handle =3D spacc_clone_handle(&priv->spacc, tctx->han=
dle,
> > +                                             &ctx->cb);
> > +     if (ctx->cb.new_handle < 0) {
> > +             spacc_aead_cleanup_dma(tctx->dev, req);
> > +             return -EINVAL;
> > +     }
> > +
> > +     ctx->cb.tctx  =3D tctx;
> > +     ctx->cb.ctx   =3D ctx;
> > +     ctx->cb.req   =3D req;
> > +     ctx->cb.spacc =3D &priv->spacc;
> > +
> > +     /* Write IV to the spacc-context
> > +      * IV can be written to context or as part of the input src buffe=
r
> > +      * IV in case of CCM is going in the input src buff.
> > +      * IV for GCM is written to the context.
> > +      */
> > +     if (tctx->mode =3D=3D CRYPTO_MODE_AES_GCM_RFC4106   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_GCM           ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_SM4_GCM_RFC8998   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_CHACHA20_POLY1305 ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_NULL) {
> > +             iv_to_context =3D SET_IV_IN_CONTEXT;
> > +             rc =3D spacc_write_context(&priv->spacc, ctx->cb.new_hand=
le,
> > +                                      SPACC_CRYPTO_OPERATION, NULL, 0,
> > +                                      req->iv, ivsize);
> > +     }
>
> We are either assuming success here, or the return value doesn't matter. =
Intentional?
>
PK: Better to have that check in place. Will fix that.

> > +
> > +     /* CCM and GCM don't include the IV in the AAD */
> > +     if (tctx->mode =3D=3D CRYPTO_MODE_AES_GCM_RFC4106   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_GCM           ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM           ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_SM4_GCM_RFC8998   ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_CHACHA20_POLY1305 ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_NULL) {
> > +             ivaadsize =3D 0;
> > +     } else {
> > +             ivaadsize =3D ivsize;
> > +     }
> > +
> > +     /* CCM requires an extra block of AAD */
> > +     if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309 ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_AES_CCM         ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM)
> > +             B0len =3D SPACC_B0_LEN;
> > +     else
> > +             B0len =3D 0;
> > +
> > +     /* GMAC mode uses AAD for the entire message.
> > +      * So does NULL cipher
> > +      */
> > +     if (tctx->mode =3D=3D CRYPTO_MODE_AES_GCM_RFC4543 ||
> > +         tctx->mode =3D=3D CRYPTO_MODE_NULL) {
> > +             if (req->cryptlen >=3D icvremove)
> > +                     ptaadsize =3D req->cryptlen - icvremove;
> > +     } else {
> > +             ptaadsize =3D 0;
> > +     }
> > +
> > +     /* Calculate and set the below, important parameters
> > +      * spacc icv offset     - spacc_icv_offset
> > +      * destination offset   - dstoff
> > +      * IV to context        - This is set for CCM, not set for GCM
> > +      */
> > +     if (req->dst =3D=3D req->src) {
> > +             dstoff =3D ((uint32_t)(SPACC_MAX_IV_SIZE + B0len +
> > +                                  req->assoclen + ivaadsize));
> > +
> > +             if (req->assoclen + req->cryptlen >=3D icvremove)
> > +                     spacc_icv_offset =3D  ((uint32_t)(SPACC_MAX_IV_SI=
ZE +
> > +                                             B0len + req->assoclen +
> > +                                             ivaadsize + req->cryptlen=
 -
> > +                                             icvremove));
> > +             else
> > +                     spacc_icv_offset =3D  ((uint32_t)(SPACC_MAX_IV_SI=
ZE +
> > +                                             B0len + req->assoclen +
> > +                                             ivaadsize + req->cryptlen=
));
> > +
> > +             /* CCM case */
> > +             if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM) {
> > +                     iv_to_context =3D SET_IV_IN_SRCBUF;
> > +                     dstoff =3D ((uint32_t)(SPACC_MAX_IV_SIZE + B0len =
+
> > +                              ccm_aad_16b_len + ivaadsize));
> > +
> > +                     if (encrypt)
> > +                             spacc_icv_offset =3D ((uint32_t)(SPACC_MA=
X_IV_SIZE
> > +                                     + B0len + ccm_aad_16b_len
> > +                                     + ivaadsize
> > +                                     + ccm_16byte_aligned_len(req->cry=
ptlen)
> > +                                     - icvremove));
> > +                     else
> > +                             spacc_icv_offset =3D ((uint32_t)(SPACC_MA=
X_IV_SIZE
> > +                                     + B0len + ccm_aad_16b_len + ivaad=
size
> > +                                     + req->cryptlen - icvremove));
> > +             }
> > +
> > +     } else {
> > +             dstoff =3D ((uint32_t)(req->assoclen + ivaadsize));
> > +
> > +             if (req->assoclen + req->cryptlen >=3D icvremove)
> > +                     spacc_icv_offset =3D ((uint32_t)(SPACC_MAX_IV_SIZ=
E
> > +                                     + B0len + req->assoclen
> > +                                     + ivaadsize + req->cryptlen
> > +                                     - icvremove));
> > +             else
> > +                     spacc_icv_offset =3D ((uint32_t)(SPACC_MAX_IV_SIZ=
E
> > +                                     + B0len + req->assoclen
> > +                                     + ivaadsize + req->cryptlen));
> > +
> > +             /* CCM case */
> > +             if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM) {
> > +                     iv_to_context =3D SET_IV_IN_SRCBUF;
> > +                     dstoff =3D ((uint32_t)(req->assoclen + ivaadsize)=
);
> > +
> > +                     if (encrypt)
> > +                             spacc_icv_offset =3D ((uint32_t)(SPACC_MA=
X_IV_SIZE
> > +                                     + B0len
> > +                                     + ccm_aad_16b_len + ivaadsize
> > +                                     + ccm_16byte_aligned_len(req->cry=
ptlen)
> > +                                     - icvremove));
> > +                     else
> > +                             spacc_icv_offset =3D ((uint32_t)(SPACC_MA=
X_IV_SIZE
> > +                                     + B0len + ccm_aad_16b_len + ivaad=
size
> > +                                     + req->cryptlen - icvremove));
> > +             }
> > +     }
> > +
> > +     /* Calculate and set the below, important parameters
> > +      * spacc proc_len - spacc_proc_len
> > +      * pre-AAD size   - spacc_pre_aad_size
> > +      */
> > +     if (encrypt) {
> > +             if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM_RFC8998) {
> > +                     rc =3D spacc_set_operation(&priv->spacc,
> > +                                      ctx->cb.new_handle,
> > +                                      encrypt ? OP_ENCRYPT : OP_DECRYP=
T,
> > +                                      ICV_ENCRYPT_HASH, IP_ICV_APPEND,
> > +                                      spacc_icv_offset,
> > +                                      tctx->auth_size, 0);
> > +
> > +                     spacc_proc_len =3D B0len + ccm_aad_16b_len
> > +                                     + req->cryptlen + ivaadsize
> > +                                     - icvremove;
> > +                     spacc_pre_aad_size =3D B0len + ccm_aad_16b_len
> > +                                     + ivaadsize + ptaadsize;
> > +
> > +             } else {
> > +                     rc =3D spacc_set_operation(&priv->spacc,
> > +                                      ctx->cb.new_handle,
> > +                                      encrypt ? OP_ENCRYPT : OP_DECRYP=
T,
> > +                                      ICV_ENCRYPT_HASH, IP_ICV_APPEND,
> > +                                      spacc_icv_offset,
> > +                                      tctx->auth_size, 0);
> > +
> > +                     spacc_proc_len =3D B0len + req->assoclen
> > +                                     + req->cryptlen - icvremove
> > +                                     + ivaadsize;
> > +                     spacc_pre_aad_size =3D B0len + req->assoclen
> > +                                     + ivaadsize + ptaadsize;
> > +             }
> > +     } else {
> > +             if (tctx->mode =3D=3D CRYPTO_MODE_AES_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM           ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_AES_CCM_RFC4309   ||
> > +                 tctx->mode =3D=3D CRYPTO_MODE_SM4_CCM_RFC8998) {
> > +                     rc =3D spacc_set_operation(&priv->spacc,
> > +                                      ctx->cb.new_handle,
> > +                                      encrypt ? OP_ENCRYPT : OP_DECRYP=
T,
> > +                                      ICV_ENCRYPT_HASH, IP_ICV_OFFSET,
> > +                                      spacc_icv_offset,
> > +                                      tctx->auth_size, 0);
> > +
> > +                     spacc_proc_len =3D B0len + ccm_aad_16b_len
> > +                                     + req->cryptlen + ivaadsize
> > +                                     - icvremove;
> > +                     spacc_pre_aad_size =3D B0len + ccm_aad_16b_len
> > +                                     + ivaadsize + ptaadsize;
> > +
> > +             } else {
> > +                     rc =3D spacc_set_operation(&priv->spacc,
> > +                                      ctx->cb.new_handle,
> > +                                      encrypt ? OP_ENCRYPT : OP_DECRYP=
T,
> > +                                      ICV_ENCRYPT_HASH, IP_ICV_APPEND,
> > +                                      req->cryptlen - icvremove +
> > +                                      SPACC_MAX_IV_SIZE + B0len +
> > +                                      req->assoclen + ivaadsize,
> > +                                      tctx->auth_size, 0);
> > +
> > +                     spacc_proc_len =3D B0len + req->assoclen
> > +                                     + req->cryptlen - icvremove
> > +                                     + ivaadsize;
> > +                     spacc_pre_aad_size =3D B0len + req->assoclen
> > +                                     + ivaadsize + ptaadsize;
> > +             }
> > +     }
>
> There's a bunch of (almost) copy-paste in the call to spacc_set_operation=
() above, combined with ignoring
> the return value. Can we restructure a bit so the repetition is minimized=
?
>
PK: There are subtle differences, but I see your point. Looks very
much a copy. Will refactor that.

> > +
> > +     rc =3D spacc_packet_enqueue_ddt(&priv->spacc, ctx->cb.new_handle,
> > +                                   &ctx->src,
> > +                                   (req->dst =3D=3D req->src) ? &ctx->=
src :
> > +                                   &ctx->dst, spacc_proc_len,
> > +                                   (dstoff << SPACC_OFFSET_DST_O) |
> > +                                   SPACC_MAX_IV_SIZE,
> > +                                   spacc_pre_aad_size,
> > +                                   0, iv_to_context, 0);
> > +
> > +     if (rc < 0) {
> > +             spacc_aead_cleanup_dma(tctx->dev, req);
> > +             spacc_close(&priv->spacc, ctx->cb.new_handle);
> > +
> > +             if (rc !=3D -EBUSY) {
> > +                     dev_err(tctx->dev, "  failed to enqueue job, ERR:=
 %d\n",
> > +                             rc);
> > +             }
> > +
> > +             if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
> > +                     return -EBUSY;
> > +
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* At this point the job is in flight to the engine ... remove fi=
rst use
> > +      * so subsequent calls don't expand the key again... ideally we w=
ould
> > +      * pump a dummy job through the engine to pre-expand the key so t=
hat by
> > +      * time setkey was done we wouldn't have to do this
> > +      */
> > +     priv->spacc.job[tctx->handle].first_use  =3D 0;
>
> Does this need some locking, given the comment?
>
PK: Sure. So far we have not seen the need, but will check.

> > +     priv->spacc.job[tctx->handle].ctrl &=3D ~(1UL
> > +                     << priv->spacc.config.ctrl_map[SPACC_CTRL_KEY_EXP=
]);
> > +
> > +     return -EINPROGRESS;
> > +}
> > +
>
> <snip>
>
> > diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dw=
c-spacc/spacc_ahash.c
> > new file mode 100644
> > index 000000000000..53c76ee16c53
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> > @@ -0,0 +1,1183 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/dmapool.h>
> > +#include <crypto/sm3.h>
> > +#include <crypto/sha1.h>
> > +#include <crypto/sha2.h>
> > +#include <crypto/sha3.h>
> > +#include <crypto/md5.h>
> > +#include <crypto/aes.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/platform_device.h>
> > +#include <crypto/internal/hash.h>
> > +
> > +#include "spacc_device.h"
> > +#include "spacc_core.h"
> > +
> > +#define PPP_BUF_SZ 128
> > +
> > +struct sdesc {
> > +     struct shash_desc shash;
> > +     char ctx[];
> > +};
> > +
> > +struct my_list {
> > +     struct list_head list;
> > +     char *buffer;
> > +};
> > +
>
> Unless my is an acronym, maybe a better name? :) Maybe sg_list_iter or su=
ch, given its role
> in iterating through the sg list below?
>
PK: Sure :0) seems to have escaped the eyeballs .. will fix that.

> > +static struct dma_pool *spacc_hash_pool;
> > +static LIST_HEAD(spacc_hash_alg_list);
> > +static LIST_HEAD(head_sglbuf);
> > +static DEFINE_MUTEX(spacc_hash_alg_mutex);
> > +
>
> <snip>
>
> > +
> > +static void sgl_node_delete(void)
> > +{
> > +     /* go through the list and free the memory. */
> > +     struct my_list *cursor, *temp;
> > +
> > +     list_for_each_entry_safe(cursor, temp, &head_sglbuf, list) {
> > +             kfree(cursor->buffer);
> > +             list_del(&cursor->list);
> > +             kfree(cursor);
> > +     }
> > +}
> > +
> > +static void sg_node_create_add(char *sg_buf)
> > +{
> > +     struct my_list *temp_node =3D NULL;
> > +
> > +     /*Creating Node*/
> > +     temp_node =3D kmalloc(sizeof(struct my_list), GFP_KERNEL);
> > +
> > +     /*Assgin the data that is received*/
> > +     temp_node->buffer =3D sg_buf;
> > +
> > +     /*Init the list within the struct*/
> > +     INIT_LIST_HEAD(&temp_node->list);
> > +
> > +     /*Add Node to Linked List*/
> > +     list_add_tail(&temp_node->list, &head_sglbuf);
> > +}
> > +
> > +static int spacc_ctx_clone_handle(struct ahash_request *req)
> > +{
> > +     struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(tfm);
> > +     struct spacc_crypto_reqctx *ctx =3D ahash_request_ctx(req);
> > +     struct spacc_priv *priv =3D dev_get_drvdata(tctx->dev);
> > +
> > +     ctx->acb.new_handle =3D spacc_clone_handle(&priv->spacc, tctx->ha=
ndle,
> > +                     &ctx->acb);
> > +
> > +     if (ctx->acb.new_handle < 0) {
> > +             spacc_hash_cleanup_dma(tctx->dev, req);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     ctx->acb.tctx  =3D tctx;
> > +     ctx->acb.ctx   =3D ctx;
> > +     ctx->acb.req   =3D req;
> > +     ctx->acb.spacc =3D &priv->spacc;
> > +
> > +     return 0;
> > +}
> > +
> > +
>
> <snip>
>
> > +
> > +static int spacc_hash_setkey(struct crypto_ahash *tfm, const u8 *key,
> > +                          unsigned int keylen)
> > +{
> > +     int x, rc;
> > +     const struct spacc_alg *salg =3D spacc_tfm_ahash(&tfm->base);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(tfm);
> > +     struct spacc_priv *priv =3D dev_get_drvdata(tctx->dev);
> > +     unsigned int digest_size, block_size;
> > +     char hash_alg[CRYPTO_MAX_ALG_NAME];
> > +
> > +     block_size =3D crypto_tfm_alg_blocksize(&tfm->base);
> > +     digest_size =3D crypto_ahash_digestsize(tfm);
> > +
> > +     /*
> > +      * If keylen > hash block len, the key is supposed to be hashed s=
o that
> > +      * it is less than the block length. This is kind of a useless
> > +      * property of HMAC as you can just use that hash as the key dire=
ctly.
> > +      * We will just not use the hardware in this case to avoid the is=
sue.
> > +      * This test was meant for hashes but it works for cmac/xcbc sinc=
e we
> > +      * only intend to support 128-bit keys...
> > +      */
> > +
> > +     if (keylen > block_size && salg->mode->id !=3D CRYPTO_MODE_MAC_CM=
AC) {
> > +             dev_dbg(salg->dev[0], "Exceeds keylen: %u\n", keylen);
> > +             dev_dbg(salg->dev[0], "Req. keylen hashing %s\n",
> > +                     salg->calg->cra_name);
> > +
> > +             memset(hash_alg, 0x00, CRYPTO_MAX_ALG_NAME);
> > +             switch (salg->mode->id) {
> > +             case CRYPTO_MODE_HMAC_SHA224:
> > +                     rc =3D do_shash("sha224", tctx->ipad, key, keylen=
,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             case CRYPTO_MODE_HMAC_SHA256:
> > +                     rc =3D do_shash("sha256", tctx->ipad, key, keylen=
,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             case CRYPTO_MODE_HMAC_SHA384:
> > +                     rc =3D do_shash("sha384", tctx->ipad, key, keylen=
,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             case CRYPTO_MODE_HMAC_SHA512:
> > +                     rc =3D do_shash("sha512", tctx->ipad, key, keylen=
,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             case CRYPTO_MODE_HMAC_MD5:
> > +                     rc =3D do_shash("md5", tctx->ipad, key, keylen,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             case CRYPTO_MODE_HMAC_SHA1:
> > +                     rc =3D do_shash("sha1", tctx->ipad, key, keylen,
> > +                                   NULL, 0, NULL, 0);
> > +                     break;
> > +
> > +             default:
> > +                     return -EINVAL;
> > +             }
> > +
> > +             if (rc < 0) {
> > +                     pr_err("ERR: %d computing shash for %s\n",
> > +                                                             rc, hash_=
alg);
> > +                     return -EIO;
> > +             }
> > +
> > +             keylen =3D digest_size;
> > +             dev_dbg(salg->dev[0], "updated keylen: %u\n", keylen);
> > +     } else {
> > +             memcpy(tctx->ipad, key, keylen);
> > +     }
> > +
> > +     tctx->ctx_valid =3D false;
> > +
> > +     if (salg->mode->sw_fb) {
> > +             rc =3D crypto_ahash_setkey(tctx->fb.hash, key, keylen);
> > +             if (rc < 0)
> > +                     return rc;
> > +     }
> > +
> > +     /* close handle since key size may have changed */
> > +     if (tctx->handle >=3D 0) {
> > +             spacc_close(&priv->spacc, tctx->handle);
> > +             put_device(tctx->dev);
> > +             tctx->handle =3D -1;
> > +             tctx->dev =3D NULL;
> > +     }
> > +
> > +     priv =3D NULL;
> > +     for (x =3D 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
> > +             priv =3D dev_get_drvdata(salg->dev[x]);
> > +             tctx->dev =3D get_device(salg->dev[x]);
> > +             if (spacc_isenabled(&priv->spacc, salg->mode->id, keylen)=
) {
> > +                     tctx->handle =3D spacc_open(&priv->spacc,
> > +                                               CRYPTO_MODE_NULL,
> > +                                               salg->mode->id, -1,
> > +                                               0, spacc_digest_cb, tfm=
);
> > +
> > +             } else
> > +                     pr_debug("  Keylen: %d not enabled for algo: %d",
> > +                                                     keylen, salg->mod=
e->id);
> > +
>
> Please run scripts/checkpatch.pl through all the patches, it will point o=
ut things like the unbalanced
> braces here.
>
PK: Yes, thats part of the process before pushing patches that we follow.
       Checkpatch didnt complain. But sure will fix things for readability.


> > +             if (tctx->handle >=3D 0)
> > +                     break;
> > +
> > +             put_device(salg->dev[x]);
> > +     }
> > +
> > +     if (tctx->handle < 0) {
> > +             pr_err("ERR: Failed to open SPAcc context\n");
> > +             dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
> > +             return -EIO;
> > +     }
> > +
> > +     rc =3D spacc_set_operation(&priv->spacc, tctx->handle, OP_ENCRYPT=
,
> > +                              ICV_HASH, IP_ICV_OFFSET, 0, 0, 0);
> > +     if (rc < 0) {
> > +             spacc_close(&priv->spacc, tctx->handle);
> > +             tctx->handle =3D -1;
> > +             put_device(tctx->dev);
> > +             return -EIO;
> > +     }
> > +
> > +     if (salg->mode->id =3D=3D CRYPTO_MODE_MAC_XCBC ||
> > +         salg->mode->id =3D=3D CRYPTO_MODE_MAC_SM4_XCBC) {
> > +             rc =3D spacc_compute_xcbc_key(&priv->spacc, salg->mode->i=
d,
> > +                                         tctx->handle, tctx->ipad,
> > +                                         keylen, tctx->ipad);
> > +             if (rc < 0) {
> > +                     dev_warn(tctx->dev,
> > +                              "Failed to compute XCBC key: %d\n", rc);
> > +                     return -EIO;
> > +             }
> > +             rc =3D spacc_write_context(&priv->spacc, tctx->handle,
> > +                                      SPACC_HASH_OPERATION, tctx->ipad=
,
> > +                                      32 + keylen, NULL, 0);
> > +     } else {
> > +             rc =3D spacc_write_context(&priv->spacc, tctx->handle,
> > +                                      SPACC_HASH_OPERATION, tctx->ipad=
,
> > +                                      keylen, NULL, 0);
> > +     }
> > +
> > +     memset(tctx->ipad, 0, sizeof(tctx->ipad));
> > +     if (rc < 0) {
> > +             pr_err("ERR: Failed to write SPAcc context\n");
> > +             dev_warn(tctx->dev, "Failed to write SPAcc context %d: %d=
\n",
> > +                      tctx->handle, rc);
> > +
> > +             /* Non-fatal; we continue with the software fallback. */
> > +             return 0;
> > +     }
> > +
> > +     tctx->ctx_valid =3D true;
> > +
> > +     return 0;
> > +}
> > +
>
> <snip>
>
> Thanks,
> Easwar
>
