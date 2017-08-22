From: Ryder Lee <ryder.lee@mediatek.com>
Subject: Re: [PATCH] crypto: mediatek - Add empty messages check in GCM mode
Date: Tue, 22 Aug 2017 15:25:22 +0800
Message-ID: <1503386722.23987.5.camel@mtkswgap22>
References: <018d5b804a22b0aa2e4d759749884b0e15c25de4.1502861307.git.ryder.lee@mediatek.com>
         <20170822070144.GA5989@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:48267 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754604AbdHVHZ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:25:26 -0400
In-Reply-To: <20170822070144.GA5989@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On Tue, 2017-08-22 at 15:01 +0800, Herbert Xu wrote:
> On Wed, Aug 16, 2017 at 07:19:48PM +0800, Ryder Lee wrote:
> > Currently, empty messages are not supported in GCM mode, hence add
> > a check to prevent producing incorrect results.
> > 
> > Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> > ---
> >  drivers/crypto/mediatek/mtk-aes.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
> > index 9e845e8..efe4e63 100644
> > --- a/drivers/crypto/mediatek/mtk-aes.c
> > +++ b/drivers/crypto/mediatek/mtk-aes.c
> > @@ -928,8 +928,13 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
> >  static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
> >  {
> >  	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
> > +	struct mtk_aes_gcm_ctx *gctx = mtk_aes_gcm_ctx_cast(ctx);
> >  	struct mtk_aes_reqctx *rctx = aead_request_ctx(req);
> >  
> > +	/* Empty messages are not supported yet */
> > +	if (!gctx->textlen && !req->assoclen)
> > +		return -EINVAL
> 
> Your patch does not compile.

Ohh..Somehow I delete the semicolon. I will send v1 soon, sorry about
that.

Ryder
