Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vk1-f193.google.com ([209.85.221.193]:37898 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbeLDIik (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 03:38:40 -0500
Received: by mail-vk1-f193.google.com with SMTP id w72so3595225vkd.5
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 00:38:38 -0800 (PST)
MIME-Version: 1.0
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
 <1542102039-22256-3-git-send-email-gilad@benyossef.com> <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
In-Reply-To: <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Tue, 4 Dec 2018 10:38:26 +0200
Message-ID: <CAOtvUMepGR89J-5SQXnReRiHanrOhp52cEKKm58Ej2uoHFAcyA@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for ccree 703
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        yaeceh01 <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 29, 2018 at 8:42 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Nov 13, 2018 at 09:40:36AM +0000, Gilad Ben-Yossef wrote:
> > Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
> > ccree driver.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > ---
> >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
> >  1 file changed, 1 insertion(+)
>
> Which tree is this patch meant to go through?

I'm not sure the question was addressed to me but if it did - either
going through the device tree or the crypto tree is fine by me.

Thanks,
Gilad
