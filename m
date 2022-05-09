Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A24C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  9 May 2022 13:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiEINI6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 May 2022 09:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiEINI6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 May 2022 09:08:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AA523276A
        for <linux-crypto@vger.kernel.org>; Mon,  9 May 2022 06:05:04 -0700 (PDT)
Received: from birne.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::51])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1no33x-0005Ao-B0; Mon, 09 May 2022 15:04:33 +0200
Message-ID: <5e7c0b3c9bc285f1cf9f7b20f055aa376e1688cc.camel@pengutronix.de>
Subject: Re: [EXT] [PATCH v9 3/7] crypto: caam - determine whether CAAM
 supports blob encap/decap
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Michael Walle <michael@walle.cc>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Richard Weinberger <richard@nod.at>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Date:   Mon, 09 May 2022 15:04:20 +0200
In-Reply-To: <DU2PR04MB8630501008F661C596C0106295C69@DU2PR04MB8630.eurprd04.prod.outlook.com>
References: <20220506062553.1068296-1-a.fatoum@pengutronix.de>
         <20220506062553.1068296-4-a.fatoum@pengutronix.de>
         <DU2PR04MB8630501008F661C596C0106295C69@DU2PR04MB8630.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::51
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pankaj,

On Mon, 2022-05-09 at 12:39 +0000, Pankaj Gupta wrote:
> > -       if (ctrlpriv->era < 10)
> > +       comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ls);
> > +       ctrlpriv->blob_present = !!(comp_params & CTPR_LS_BLOB);
> > +
> > +       if (ctrlpriv->era < 10) {
> >                 rng_vid = (rd_reg32(&ctrl->perfmon.cha_id_ls) &
> >                            CHA_ID_LS_RNG_MASK) >>
> > CHA_ID_LS_RNG_SHIFT;
> 
> Check for AES CHAs for Era < 10, should be added.

Do I need this? I only do this check for Era >= 10, because apparently
there are Layerscape non-E processors that indicate BLOB support via
CTPR_LS_BLOB, but fail at runtime. Are there any Era < 10 SoCs
that are similarly broken?

Cheers,
Ahmad

