Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C74C0650F
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 20:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85BF2147A
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 20:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565555659;
	bh=zyT1J9izO43wde10EowpdqxvCnXXhgr2NVZbukgkcUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CJZ2Eyl5eOxJEoQmPOGY2t6y2IZeVMHDGvmCdG4GaVIFTzilHUPqJ1SXN3foMiMYP
	 LcEnShPkzEnlVCref/dy9uDNvcLbFKKW1NkPaeUW4rttMalTjH7Kvt0WowL/G50iOA
	 y49eKNypX+Smh6PVph8PB9oygVPxHcO/e74A2evk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfHKUeS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 16:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfHKUeS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 16:34:18 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C18A208C2;
        Sun, 11 Aug 2019 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565555657;
        bh=zyT1J9izO43wde10EowpdqxvCnXXhgr2NVZbukgkcUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CLvhhSDarI/wDRTxJuVwt9RYXfG91H1jVia5EHiciPqlZrpDff5/3dIF5Vro1oy4D
         4ycK+28p68QG45ykghs3CbBKNIGCwJ3US7HezFXecIzfoKNjVnhLmIKtWOR/rpYvI8
         7v+1eAUDjJR4y3eo0+hdtKwcXSm0bIj17z/f44Ao=
Date:   Sun, 11 Aug 2019 13:34:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Message-ID: <20190811203406.GA17421@sol.localdomain>
Mail-Followup-To: Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au>
 <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
 <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
 <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 11, 2019 at 01:12:56PM +0200, Milan Broz wrote:
> On 10/08/2019 06:39, Ard Biesheuvel wrote:
> > Truncated IVs are a huge issue, since we already expose the correct
> > API via AF_ALG (without any restrictions on how many of the IV bits
> > are populated), and apparently, if your AF_ALG request for xts(aes)
> > happens to be fulfilled by the CAAM driver and your implementation
> > uses more than 64 bits for the IV, the top bits get truncated silently
> > and your data might get eaten.
> 
> Actually, I think we have already serious problem with in in kernel (no AF_ALG needed).
> 
> I do not have the hardware, but please could you check that dm-crypt big-endian IV
> (plain64be) produces the same output on CAAM?
> 
> It is 64bit IV, but big-endian and we use size of cipher block (16bytes) here,
> so the first 8 bytes are zero in this case.
> 
> I would expect data corruption in comparison to generic implementation,
> if it supports only the first 64bit...
> 
> Try this:
> 
> # create small null device of 8 sectors,  we use zeroes as fixed ciphertext
> dmsetup create zero --table "0 8 zero"
> 
> # create crypt device on top of it (with some key), using plain64be IV
> dmsetup create crypt --table "0 8 crypt aes-xts-plain64be e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"
> 
> # and compare it with and without your driver, this is what I get here:
> # sha256sum /dev/mapper/crypt 
> 532f71198d0d84d823b8e410738c6f43bc3e149d844dd6d37fa5b36d150501e1  /dev/mapper/crypt
> # dmsetup remove crypt
> 
> You can try little-endian version (plain64), this should always work even with CAAM
> dmsetup create crypt --table "0 8 crypt aes-xts-plain64 e8cfa3dbfe373b536be43c5637387786c01be00ba5f730aacb039e86f3eb72f3 0 /dev/mapper/zero 0"
> 
> # sha256sum /dev/mapper/crypt 
> f17abd27dedee4e539758eabdb6c15fa619464b509cf55f16433e6a25da42857  /dev/mapper/crypt
> # dmsetup remove crypt
> 
> # dmsetup remove zero
> 
> 
> If you get different plaintext in the first case, your driver is actually creating
> data corruption in this configuration and it should be fixed!
> (Only the first sector must be the same, because it has IV == 0.)
> 
> Milan
> 
> p.s.
> If you ask why we have this IV, it was added per request to allow map some chipset-based
> encrypted drives directly. I guess it is used for some data forensic things.
> 

Also, if the CAAM driver is really truncating the IV for "xts(aes)", it should
already be failing the extra crypto self-tests, since the fuzz testing in
test_skcipher_vs_generic_impl() uses random IVs.

- Eric
