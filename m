Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A0DC6FA89
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 07:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiIGH1I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIGH1H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 03:27:07 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F0F74CD8;
        Wed,  7 Sep 2022 00:27:03 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oVpRr-001w5E-4t; Wed, 07 Sep 2022 17:26:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Sep 2022 15:26:11 +0800
Date:   Wed, 7 Sep 2022 15:26:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pankaj Gupta <pankaj.gupta@nxp.com>
Cc:     "jarkko@kernel.org" <jarkko@kernel.org>,
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
        Horia Geanta <horia.geanta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>
Subject: Re: [EXT] Re: [RFC PATCH HBK: 2/8] hw-bound-key: flag-is_hbk added
 to the tfm
Message-ID: <YxhHkz+UlE9XAG/Z@gondor.apana.org.au>
References: <20220906065157.10662-1-pankaj.gupta@nxp.com>
 <20220906065157.10662-3-pankaj.gupta@nxp.com>
 <YxbsBiCrIQT/0xz6@gondor.apana.org.au>
 <DU2PR04MB86308036FB517BF8CAD3D32795419@DU2PR04MB8630.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU2PR04MB86308036FB517BF8CAD3D32795419@DU2PR04MB8630.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 07, 2022 at 07:22:42AM +0000, Pankaj Gupta wrote:
>
> Current support, does not permit the hardware to support both types of keys: HBK & Plain Key, at the same time.
> 
> This change is generic and permit any driver that supports both- HBK and plain-key, to differentiate and use the keys accordingly.

Existing drivers simply register hardware keys under a different
algorithm name, there is no reason why they can't coexist with a
plain key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
