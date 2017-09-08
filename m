From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH] Staging: ccree: Merge assignment with
 return
Date: Fri, 8 Sep 2017 22:31:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709082231030.2510@hadrien>
References: <1504900895-13110-1-git-send-email-srishtishar@gmail.com> <alpine.DEB.2.20.1709082210410.2510@hadrien> <CAB3L5ow4-GeOfh=23T58JNUmxu4mmOoG1rwH6fccrzwTNvTu1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:61520
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756895AbdIHUbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 16:31:32 -0400
In-Reply-To: <CAB3L5ow4-GeOfh=23T58JNUmxu4mmOoG1rwH6fccrzwTNvTu1w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Sat, 9 Sep 2017, Srishti Sharma wrote:

> On Sat, Sep 9, 2017 at 1:42 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> >
> >
> > On Sat, 9 Sep 2017, Srishti Sharma wrote:
> >
> >> Return the return value of a function directly, instead of first saving it in a variable and then returning it. This change was made using the following
> >
> > Your commit message should respect the 80 character limit. The above is
> > one very long line.
>
> Yes, I'll fix it . Thanks
> >
> >> semantic patch by coccinelle.
> >>
> >> @@
> >> local idexpression ret;
> >> expression e;
> >> @@
> >>
> >> -ret =
> >> +return
> >>      e;
> >> -return ret;
> >>
> >> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> >> ---
> >>  drivers/staging/ccree/ssi_aead.c | 21 ++++++---------------
> >>  1 file changed, 6 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> >> index 5abe6b2..6bb98f7 100644
> >> --- a/drivers/staging/ccree/ssi_aead.c
> >> +++ b/drivers/staging/ccree/ssi_aead.c
> >> @@ -651,17 +651,14 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
> >>  static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
> >>  {
> >>       struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
> >> -     int rc = 0;
> >> -
> >> +
> >
> > I'm not sure what happened here, but you should not be removing and then
> > adding back a blank line.  Likewise below.
>
> Sorry , I must have removed an already existing blank line by mistake
> and must have re-added it upon realising the same. I'll fix these and
> send again.

There must be some change in spacing.  Otherwise there would be no diff.

julia

>
> Regards,
> Srishti
>
> >
> > julia
> >
> >>       if (keylen < 3)
> >>               return -EINVAL;
> >>
> >>       keylen -= 3;
> >>       memcpy(ctx->ctr_nonce, key + keylen, 3);
> >>
> >> -     rc = ssi_aead_setkey(tfm, key, keylen);
> >> -
> >> -     return rc;
> >> +     return ssi_aead_setkey(tfm, key, keylen);
> >>  }
> >>  #endif /*SSI_CC_HAS_AES_CCM*/
> >>
> >> @@ -2214,8 +2211,7 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
> >>  static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
> >>  {
> >>       struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
> >> -     int rc = 0;
> >> -
> >> +
> >>       SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
> >>
> >>       if (keylen < 4)
> >> @@ -2224,16 +2220,13 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
> >>       keylen -= 4;
> >>       memcpy(ctx->ctr_nonce, key + keylen, 4);
> >>
> >> -     rc = ssi_aead_setkey(tfm, key, keylen);
> >> -
> >> -     return rc;
> >> +     return ssi_aead_setkey(tfm, key, keylen);
> >>  }
> >>
> >>  static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
> >>  {
> >>       struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
> >> -     int rc = 0;
> >> -
> >> +
> >>       SSI_LOG_DEBUG("%s()  keylen %d, key %p\n", __func__, keylen, key);
> >>
> >>       if (keylen < 4)
> >> @@ -2242,9 +2235,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
> >>       keylen -= 4;
> >>       memcpy(ctx->ctr_nonce, key + keylen, 4);
> >>
> >> -     rc = ssi_aead_setkey(tfm, key, keylen);
> >> -
> >> -     return rc;
> >> +     return ssi_aead_setkey(tfm, key, keylen);
> >>  }
> >>
> >>  static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
> >> --
> >> 2.7.4
> >>
> >> --
> >> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> >> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> >> To post to this group, send email to outreachy-kernel@googlegroups.com.
> >> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504900895-13110-1-git-send-email-srishtishar%40gmail.com.
> >> For more options, visit https://groups.google.com/d/optout.
> >>
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/CAB3L5ow4-GeOfh%3D23T58JNUmxu4mmOoG1rwH6fccrzwTNvTu1w%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
