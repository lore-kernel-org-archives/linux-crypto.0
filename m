Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DD1C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 15:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6126208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 15:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390515AbfGRP1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 11:27:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53328 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbfGRP1s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 11:27:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ho8Jr-00019q-JN; Thu, 18 Jul 2019 23:27:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ho8Jm-0006gi-8R; Thu, 18 Jul 2019 23:27:38 +0800
Date:   Thu, 18 Jul 2019 23:27:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
Message-ID: <20190718152738.e6yfjymggsdtcafg@gondor.apana.org.au>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b042649c-db98-9710-b063-242bdf520252@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
>
> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> 
> (That said, I will try to find some volunteer to help with CTS in XTS implementation, if needed.)

Well the main advantage of doing it on top of the existing xts is
that you can retain the existing ARM implementations without any
changes.  This would also apply to any existing xts drivers that
also don't implement CTS (I'm not aware of the status on these so
someone will need to check them one by one).

But if you were going to volunteer to change them all in one swoop
then it wouldn't matter.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
