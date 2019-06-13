Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112A9C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF4720B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbfFMPSY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:18:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60614 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732159AbfFMNJQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 09:09:16 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hbPTY-0001tF-EP; Thu, 13 Jun 2019 21:09:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hbPTS-0005Yj-KZ; Thu, 13 Jun 2019 21:09:02 +0800
Date:   Thu, 13 Jun 2019 21:09:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 4/4] crypto: talitos - drop icv_ool
Message-ID: <20190613130902.bswei465r4ey66gc@gondor.apana.org.au>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <39be46fb40ad77e40ae5c1a979ca6a2ccfab244a.1560263641.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB34852F501B30A09A4E515B4798EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <b2db68d5-d89b-2f38-d5b4-7b7eccf68204@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2db68d5-d89b-2f38-d5b4-7b7eccf68204@c-s.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 13, 2019 at 02:28:51PM +0200, Christophe Leroy wrote:
> 
> 
> Le 13/06/2019 à 14:21, Horia Geanta a écrit :
> > On 6/11/2019 5:39 PM, Christophe Leroy wrote:
> > > icv_ool is not used anymore, drop it.
> > > 
> > > Fixes: 9cc87bc3613b ("crypto: talitos - fix AEAD processing")
> > I can't find this SHA1.
> > 
> > Are you referring to commit e345177ded17 ("crypto: talitos - fix AEAD processing.")?
> > 
> > Horia
> > 
> 
> Oops yes, that's the sha1 it had in my tree before it got merged.
> 
> Do I have to resend it or can Herbert just drop the wrong reference and take
> the following one:

Please resend since you're going to change the other patches too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
