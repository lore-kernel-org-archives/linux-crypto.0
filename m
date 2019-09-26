Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB91C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 917F6222C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="w5GqWHS/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfIZLAG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 07:00:06 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:50625 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfIZLAG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 07:00:06 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 254ccd22
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 10:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=OMOzv5omucJd4GVIqn0w61KzgP4=; b=w5GqWH
        S/5rIueHmdHNJQ2ozR3M8N4Op4jY1IjXhStqrTHSfZfZ2h/2hH7hpOXFd0O68jxN
        tnOulFFLFa6fgZq2Cq8cRk48Nk/RE9UEH8OBMN1tt6kKh4zk1kXJFPtt0z1efNei
        codu7TURoH7SD+fJmkoBmuVVYGIU+S83mHWod36cA8wI9jubXCEhdkxG9s47DYuh
        uCGVanB+c7tk9NiHo+IxLA5V1VeWJrVKP4v9CEywvqIF5CUTUO1i9aOSwX1tCbq0
        GppXdHrUFCKw3PFVLiyjy4D2xDTRKjOCCZv4F9lTH0G/VFg/uM7kjiF6glgEZ9ej
        gHBwoegJiT377New==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5f5b6732 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 10:14:11 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id w6so1662133oie.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 04:00:03 -0700 (PDT)
X-Gm-Message-State: APjAAAUBryxvySwfA8gdnWqgkvgPgSArav3OQIsym/In3Wcc5gYHu+Ut
        zi2w5W/YYwbfNTfmGqaPvB41mvyWZtsLgXPa1Gg=
X-Google-Smtp-Source: APXvYqw7XDVbdEQOtu6Uk43Zy457ni1rT1sdFCQhIJbCnoxqGO04mdmpZeChsNbk+yAB1w+VwttiF7uo/vkUohYeCNk=
X-Received: by 2002:a54:4807:: with SMTP id j7mr1970768oij.122.1569495601762;
 Thu, 26 Sep 2019 04:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com> <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 Sep 2019 12:59:50 +0200
X-Gmail-Original-Message-ID: <CAHmME9rsUoU6N6pQnUmz=NQeaaJzu7_E7R47M095JptPhk7nbQ@mail.gmail.com>
Message-ID: <CAHmME9rsUoU6N6pQnUmz=NQeaaJzu7_E7R47M095JptPhk7nbQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 26, 2019 at 12:19 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
> Actually, that assumption is factually wrong. I don't know if anything
> is *publicly* available, but I can assure you the silicon is running in
> labs already.

Great to hear, and thanks for the information. I'll follow up with
some questions on this in another thread.
