Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4D6C6FA86
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Sep 2022 02:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIMCGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Sep 2022 22:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIMCGi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2022 22:06:38 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6AB4F6AA;
        Mon, 12 Sep 2022 19:06:34 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oXvIx-0045If-6p; Tue, 13 Sep 2022 12:05:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Sep 2022 10:05:39 +0800
Date:   Tue, 13 Sep 2022 10:05:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Varun Sethi <V.Sethi@nxp.com>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "sumit.garg@linaro.org" <sumit.garg@linaro.org>,
        "david@sigma-star.at" <david@sigma-star.at>,
        "michael@walle.cc" <michael@walle.cc>,
        "john.ernberg@actia.se" <john.ernberg@actia.se>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "j.luebbe@pengutronix.de" <j.luebbe@pengutronix.de>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "richard@nod.at" <richard@nod.at>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Sahil Malhotra <sahil.malhotra@nxp.com>,
        Kshitiz Varshney <kshitiz.varshney@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [EXT] Re: [RFC PATCH HBK: 2/8] hw-bound-key: flag-is_hbk added
 to the tfm
Message-ID: <Yx/lc1YjWm9+df1r@gondor.apana.org.au>
References: <20220906065157.10662-1-pankaj.gupta@nxp.com>
 <20220906065157.10662-3-pankaj.gupta@nxp.com>
 <YxbsBiCrIQT/0xz6@gondor.apana.org.au>
 <DU2PR04MB86308036FB517BF8CAD3D32795419@DU2PR04MB8630.eurprd04.prod.outlook.com>
 <YxhHkz+UlE9XAG/Z@gondor.apana.org.au>
 <DU2PR04MB86308DB7CFBC7A31CEB612D295419@DU2PR04MB8630.eurprd04.prod.outlook.com>
 <YxhuC3QlurfSgdXG@gondor.apana.org.au>
 <AM9PR04MB8211C7D59379D4C9F877D20EE8449@AM9PR04MB8211.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8211C7D59379D4C9F877D20EE8449@AM9PR04MB8211.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 12, 2022 at 05:19:44PM +0000, Varun Sethi wrote:
>
> > On Wed, Sep 07, 2022 at 09:58:45AM +0000, Pankaj Gupta wrote:
> > >
> > > There are 3rd party IP(s), which uses kernel for crypto-algorithm's operations.
> > > Modifying the algorithm name in these IP(s), is not always allowed or easy to
> > maintain.
> > 
> > So the objective is to support out-of-tree modules?
> [Varun] No, the intention is not to use out of tree modules but to allow seamless use of crytpo ciphers with keys backed by security co-processors (keys only visible to security co-processors), by Linux kernel and userspace components. Hardware backed keys are being introduced as a variant of existing Trusted keys, with the difference that these are not un-sealed and released in plain to the kernel memory. With the current patchset, the existing set of ciphers can be used along with newly introduced hardware backed flag. The security co-processor driver is able to interpret the flag and subsequently program the hardware, to interpret the supplied key as a hardware backed key.

Well I asked why isn't the existing arrangement for hardware key
algorithms sufficient, and I was given the response that you needed
this for compatibility with third-party IP(s).

Now are you saying this is not the case? So the existing framework
should work then?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
