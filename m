Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBEBC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 14:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8237A218E2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 14:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GpwSX9sP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfCVONH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:13:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38574 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfCVONF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 10:13:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id g12so2525147wrm.5
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2019 07:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=pyh8vTTyohuChTUCwCbUo+zep28Eqjn+MIdM/zUjGMM=;
        b=GpwSX9sP+gNxrrwDGevhFnH156BVULnPdMflC4EtA2nV5lH09Tj9ZNxZfRoZPonkkk
         EZYp9DTPfimc62wMxnLuYxS/1wRf6cgCWrpp6d2XWUYKRjZKBVrMef1zmIwZQITWGpdu
         2pzENXU7WyIAu3mT4EIk4vaUGZfffzBs9CkyJ8RvEBBKRwthR607UR1a9dBaok1bwXPy
         nC6+h5AyM9NkpksPsthgutWR7BYgD3F8CFnCXA0y6NL5fbhbnxQxcgqOeSVja29p7OfG
         85UWRqiC9taTqaSglL+sJL8+7K1c7lqmuT1FmHe43dNts2yP95v0oWQEmvNaM38fRYYj
         6u+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=pyh8vTTyohuChTUCwCbUo+zep28Eqjn+MIdM/zUjGMM=;
        b=uOB2XITyureIbi1XRlp1i6lSeeiDj3/UvQSYLrO3TIXG/Tc4euoiwoAcmPW8iD/E0W
         3aP4IxEYSLwr4oQ5lwpSC4cR1odrdvApz90S0JdpdNx3MmddzC17nMGNYphHiKUsxBpZ
         q+XmPNf75cXET06FptziCD1sCzS0OUujXJJsllhcW6ZxhQzKn0S/M5K/lOhUuK9DX2tw
         IT+O/YM1aLAgl1k+KBjkgG3d4y4xmg/gFOuO2UC7ImXYb6PGKrNATY9edOJEK0SL1bzI
         OTlLgNwyMaesZmakGVqixaKO+WVadKoPxRlOat56/naElx1qGHUetzFZqc7476a9xB/T
         nLJA==
X-Gm-Message-State: APjAAAVKpxsrorUfgJS5bgehFj8mz9RroO+kO9274ex0isPffqL/dnZ2
        2p2Fi/fi/TrBAK1cGamkagPILg==
X-Google-Smtp-Source: APXvYqxLQZ1mBf+svpCyGy80Ng16k+BzxRCmfTGNFpxGLnO31wV2tjKhMi7e/fAjrPJb+2FV31UnCw==
X-Received: by 2002:adf:f451:: with SMTP id f17mr2603032wrp.272.1553263983118;
        Fri, 22 Mar 2019 07:13:03 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id x18sm520275wrw.14.2019.03.22.07.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 07:13:02 -0700 (PDT)
Date:   Fri, 22 Mar 2019 14:13:00 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Joe Perches <joe@perches.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
Message-ID: <20190322141300.foza2h2lx5aklchq@holly.lan>
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
 <4ea24643-5832-981f-3d39-9a84692be6e7@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ea24643-5832-981f-3d39-9a84692be6e7@c-s.fr>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 22, 2019 at 01:54:47PM +0100, Christophe Leroy wrote:
> 
> 
> Le 08/03/2019 à 01:15, Joe Perches a écrit :
> > Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
> > there is no -DDEBUG in the Makefile here.
> > 
> > Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
> > blocks.
> 
> By doing this you hide a big part of the code which cannot be verified
> unless DEBUG is defined.

The dump functions already use dev_dbg() throughout and appear not to
have any side effects (only local variables are modified). Can we not simply
*remove* the if(IS_ENABLED_DEBUG) and rely on dev_dbg() to hide things
from the code generater when the debug messages are disabled?

Or put another way, is there any harm in allowing a system that enables
CONFIG_DYNAMIC_DEBUG to observe the status dumps?


Daniel.


> static bool is_debug_enabled(void)
> {
> #ifdef DEBUG
> 	return true;
> #else
> 	return false;
> #endif
> }
> 
> then replace
> 
> if (IS_ENABLED(DEBUG))
> 
> by
> 
> if (is_debug_enabled())
> 
> Christophe
> 
> > 
> > Miscellanea:
> > 
> > o Move the sahara_state array into the function that uses it.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >   drivers/crypto/sahara.c | 20 +++++++++-----------
> >   1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> > index 8c32a3059b4a..d2b4bd483507 100644
> > --- a/drivers/crypto/sahara.c
> > +++ b/drivers/crypto/sahara.c
> > @@ -348,14 +348,13 @@ static void sahara_decode_error(struct sahara_dev *dev, unsigned int error)
> >   	dev_err(dev->device, "\n");
> >   }
> > -static const char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
> > -
> >   static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
> >   {
> > +#ifdef DEBUG
> >   	u8 state;
> > -
> > -	if (!IS_ENABLED(DEBUG))
> > -		return;
> > +	static const char *sahara_state[4] = {
> > +		"Idle", "Busy", "Error", "HW Fault"
> > +	};
> >   	state = SAHARA_STATUS_GET_STATE(status);
> > @@ -400,15 +399,14 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
> >   		sahara_read(dev, SAHARA_REG_CDAR));
> >   	dev_dbg(dev->device, "Initial DAR: 0x%08x\n\n",
> >   		sahara_read(dev, SAHARA_REG_IDAR));
> > +#endif
> >   }
> >   static void sahara_dump_descriptors(struct sahara_dev *dev)
> >   {
> > +#ifdef DEBUG
> >   	int i;
> > -	if (!IS_ENABLED(DEBUG))
> > -		return;
> > -
> >   	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
> >   		dev_dbg(dev->device, "Descriptor (%d) (%pad):\n",
> >   			i, &dev->hw_phys_desc[i]);
> > @@ -421,15 +419,14 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
> >   			dev->hw_desc[i]->next);
> >   	}
> >   	dev_dbg(dev->device, "\n");
> > +#endif
> >   }
> >   static void sahara_dump_links(struct sahara_dev *dev)
> >   {
> > +#ifdef DEBUG
> >   	int i;
> > -	if (!IS_ENABLED(DEBUG))
> > -		return;
> > -
> >   	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
> >   		dev_dbg(dev->device, "Link (%d) (%pad):\n",
> >   			i, &dev->hw_phys_link[i]);
> > @@ -439,6 +436,7 @@ static void sahara_dump_links(struct sahara_dev *dev)
> >   			dev->hw_link[i]->next);
> >   	}
> >   	dev_dbg(dev->device, "\n");
> > +#endif
> >   }
> >   static int sahara_hw_descriptor_create(struct sahara_dev *dev)
> > 
