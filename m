Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EFAC5ACAE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 08:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D80520CC7
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 08:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BohMUVOw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfILItN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 04:49:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34432 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILItM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 04:49:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so17739910wrx.1;
        Thu, 12 Sep 2019 01:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=e+Gp9bvg2doYl3vt8UvKYTIGNZ3niQ5XGKnO6ggp+VY=;
        b=BohMUVOwccV7eixIyuzSffx1C1R/02VJ5TADZ2b16JPGKurlRaBsjNKAHOstU0x43Q
         OULaaIo4e046DFHcBMKrwxOvZYFwrZ9hz8h5ti5bFb0Bum8I/M3ySKZymFORO9Osnfnp
         mbrMEKqEHAfB5vi8DcBXUCXMWnELXFHJd3AT6BQiA2SVjXDBYXOXWnJqdne0EPRAtdyN
         fFZcZd3TgWFwwvL7dhbDTHVixRDKKpCV2Z0RIt7/Jixclhlg/fTK5bwlNAmNMuggqOpl
         kyudZlApLfcNaxL4sc90Wlehs0dBoKAjwk1J6YuKLLId/JFNXR3+DqKA5dbncj8JTFJA
         Os2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=e+Gp9bvg2doYl3vt8UvKYTIGNZ3niQ5XGKnO6ggp+VY=;
        b=HUMFYdztKbjESzHLKHwqcs0Oc9zioGuxyUl4kMtwIPs7yL7wloVQhoFwieFhhvc93w
         opHWrLugZXIsIIBNSg27lGNrWbaHpvWtOe0H0wqOHfpAJxWUaWeHlL1XeHiHTnI3Cc7l
         +TDV89goQzP1I1HHbPrb/qIVhUf0eFGpdvZwPK0vpqwCe2IZEb7ILts3k0M7wzLwWPh7
         g1CpfhwvfYmQuEig0OUkckEQE9HZN5y5BFbCS2oQqjODYbFzo09gNcHQaTGxY0lyq5co
         v1Ti5HJbqHo2Mm0qD5yaL56/LcwvOfr2wUJNfLOVNAjGi0/j1LgOzTGgd12QHdtyefCN
         zg+g==
X-Gm-Message-State: APjAAAUJ03nKI4vlgiPrbzeEO8mISx+4//+wJiQXzDXTfugvUhJ+blYd
        gows6mvRBgPwajiNB9YmtLk=
X-Google-Smtp-Source: APXvYqyEDkWR4oC31C2oMu6luZi3ueVnPKImB1BJM2Lmv+TtEx9dSjvWD6SJc20F3l41IM99V0/YYQ==
X-Received: by 2002:adf:ffd1:: with SMTP id x17mr4758794wrs.139.1568278150339;
        Thu, 12 Sep 2019 01:49:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id p85sm11790384wme.23.2019.09.12.01.49.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 01:49:09 -0700 (PDT)
Date:   Thu, 12 Sep 2019 10:49:07 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <maxime.ripard@anandra.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/2] crypto: sun4i-ss: enable pm_runtime
Message-ID: <20190912084907.GA26551@Red>
References: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
 <20190911114650.20567-3-clabbe.montjoie@gmail.com>
 <CAO4ZVTM99FksM71BAiraYj7eyREO1Qi=L1NFzEkNmMgBmphBww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO4ZVTM99FksM71BAiraYj7eyREO1Qi=L1NFzEkNmMgBmphBww@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 12, 2019 at 08:35:51AM +0200, Maxime Ripard wrote:
> Hi,
> 
> Le mer. 11 sept. 2019 à 13:46, Corentin Labbe
> <clabbe.montjoie@gmail.com> a écrit :
> >
> > This patch enables power management on the Security System.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  5 +++
> >  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 42 ++++++++++++++++++++++-
> >  2 files changed, 46 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > index fa4b1b47822e..1fedec9e83b0 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > @@ -10,6 +10,8 @@
> >   *
> >   * You could find the datasheet in Documentation/arm/sunxi.rst
> >   */
> > +
> > +#include <linux/pm_runtime.h>
> >  #include "sun4i-ss.h"
> >
> >  static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
> > @@ -497,13 +499,16 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
> >                 return PTR_ERR(op->fallback_tfm);
> >         }
> >
> > +       pm_runtime_get_sync(op->ss->dev);
> >         return 0;
> >  }
> >
> >  void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
> >  {
> >         struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
> > +
> >         crypto_free_sync_skcipher(op->fallback_tfm);
> > +       pm_runtime_put_sync(op->ss->dev);
> >  }
> >
> >  /* check and set the AES key, prepare the mode to be used */
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > index 2c9ff01dddfc..5e6e1a308f60 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> >  #include <crypto/scatterwalk.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/interrupt.h>
> > @@ -258,6 +259,37 @@ static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
> >         return err;
> >  }
> >
> > +#ifdef CONFIG_PM
> > +static int sun4i_ss_pm_suspend(struct device *dev)
> > +{
> > +       struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> > +
> > +       sun4i_ss_disable(ss);
> > +       return 0;
> > +}
> > +
> > +static int sun4i_ss_pm_resume(struct device *dev)
> > +{
> > +       struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> > +
> > +       return sun4i_ss_enable(ss);
> > +}
> > +#endif
> > +
> > +const struct dev_pm_ops sun4i_ss_pm_ops = {
> > +       SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
> > +};
> > +
> > +static void sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
> > +{
> > +       pm_runtime_use_autosuspend(ss->dev);
> > +       pm_runtime_set_autosuspend_delay(ss->dev, 1000);
> > +
> > +       pm_runtime_get_noresume(ss->dev);
> > +       pm_runtime_set_active(ss->dev);
> > +       pm_runtime_enable(ss->dev);
> > +}
> 
> It's not really clear to me what you're doing here? Can you explain?
> 

I set the autosuspend state and delay.

I say that the device is active and so I "get" it.
Then I enable PM.

I do like that since I use the device later in probe(), so I need to keep it up.
At the end of probe() I put the device which go in suspend automaticaly after.

Regards
