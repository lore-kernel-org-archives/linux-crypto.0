Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B454C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Oct 2022 23:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJTXnF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Oct 2022 19:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJTXnD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2022 19:43:03 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C44616DC38
        for <linux-crypto@vger.kernel.org>; Thu, 20 Oct 2022 16:43:01 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id t25so1043002qkm.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Oct 2022 16:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3AP/tQZsCGWdqocUdGbR0U8FOgV3GYYbflK+bE4iCU=;
        b=n3in2a6l84dZ4h43JiWPEaU07Ag4vYTbida9+trrLRkXvVMbPcyx6HxtX8lAajFZFC
         DtoagUZ1PTH2sW0BvUiuWacOoD+b0oHxbdazrKo7R18xXMv8a3vvGZGyW62mYg4k6lkt
         3/foqWE3SI3G+FIcfErHPBsohl89rS5d99nOCfhFM+R8EWwDBwnmrXXAOdtpDHqEUdZo
         oMi4qWhGG7oSMxykmVnWYIwNz7FJ2k300VniYOJMoYM5/+paUqv5Ir8yBWQ898/Yzkzm
         ihj9GA65p7uqsk6bsfytPAf9WygErO/AX5iGn+8DsaW97NMJqf1dnss8tzD88E+2Oquw
         RSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3AP/tQZsCGWdqocUdGbR0U8FOgV3GYYbflK+bE4iCU=;
        b=RORjCLoBGW/ZY2ZPCu1r8bJvxi4l0AZN01YYbdP2YogehnI9hI3l96lPGH9n+2Hjvu
         jB+dsBaqLDceGWGpBy1xRy+pBSBTKmvdue/W6WnKeZYRYJQKu/qVmFrVbhsWK5uckVLV
         XK8dejJkcisEvB6s/bZkmE2LjGfHl9qUeinEj0rV7XRu55arTVpiDUNhT2n+JuRv9w7U
         p5blVh9N0nQaQO+QBSUeLfDGGGsj65gdxVLo6ZPBZ20iBOS2mzDrUMmTKku+jThTI0MP
         0WCEFgfNKks1dlleaqahDTNDXDWBPRgwN0yr6+D4eQSo5Of2bZjE0OFm6+r2uPm9OMbY
         VcBQ==
X-Gm-Message-State: ACrzQf0V4huOcVKMhhHMPbQkhDY/2J9vV6AEg1c6yqCeh91KojJwvnds
        Ck/SKvz2l+gxo/RCMRZpR0nXOA==
X-Google-Smtp-Source: AMsMyM77ieCA9Ka3hBL0aoBJg1xvsJRStZW8qEvdIlyx1P3eg6ZqCcE+FSB11I0sMIsyLJKF0HZlSQ==
X-Received: by 2002:a05:620a:13b6:b0:6ee:cf79:bfa1 with SMTP id m22-20020a05620a13b600b006eecf79bfa1mr11569554qki.15.1666309380684;
        Thu, 20 Oct 2022 16:43:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id y13-20020a05620a25cd00b006bbf85cad0fsm8537748qko.20.2022.10.20.16.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:42:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1olfBj-00B3Bu-0U;
        Thu, 20 Oct 2022 20:42:59 -0300
Date:   Thu, 20 Oct 2022 20:42:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "gilad@benyossef.com" <gilad@benyossef.com>,
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
Subject: Re: [EXT] Re: [PATCH v0 3/8] crypto: hbk flags & info added to the
 tfm
Message-ID: <Y1HdAmy6ZfN8f5hJ@ziepe.ca>
References: <Yz/OEwDtyTm+VH0p@gondor.apana.org.au>
 <DU2PR04MB8630CBBB8ABDC3768320C18195209@DU2PR04MB8630.eurprd04.prod.outlook.com>
 <Y0Q3JKnWSNIC4Xlu@zx2c4.com>
 <Y0UxY51KQoKCq59o@gondor.apana.org.au>
 <Y0XLqd/+C1sxq2G0@zx2c4.com>
 <Y0aDiLp7BztzwNez@gondor.apana.org.au>
 <Y0m2TU5k78I1AR+p@ziepe.ca>
 <Y1DN3SqEyFZd9i37@sol.localdomain>
 <Y1GgSX+ZmOsxhB2N@ziepe.ca>
 <Y1G9hKPT1MNQQxcG@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1G9hKPT1MNQQxcG@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 20, 2022 at 02:28:36PM -0700, Eric Biggers wrote:
> On Thu, Oct 20, 2022 at 04:23:53PM -0300, Jason Gunthorpe wrote:
> > On Wed, Oct 19, 2022 at 09:26:05PM -0700, Eric Biggers wrote:
> > 
> > > Are you referring to the support for hardware-wrapped inline crypto keys?  It
> > > isn't upstream yet, but my latest patchset is at
> > > https://lore.kernel.org/linux-fscrypt/20220927014718.125308-2-ebiggers@kernel.org/T/#u.
> > > There's also a version of it used by some Android devices already.  Out of
> > > curiosity, are you using it in an Android device, or have you adopted it in some
> > > other downstream?
> > 
> > Unrelated to Android, similar functionality, but slightly different
> > ultimate purpose. We are going to be sending a fscrypt patch series
> > for mlx5 and nvme soonish.
> 
> That's interesting, though also slightly scary in that it sounds like you've
> already shipped some major fscrypt changes without review!

Heh, says the Android guy :)

Fortunately nothing major, we are enterprise focused, we need stuff in
real distros - we know know how to do it.

> > That sounds disappointing that we are now having parallel ways for the
> > admin to manipulate kernel owned keys.
> 
> Well, the keyrings subsystem never worked properly for fscrypt anyway.  At most,
> it's only useful for providing the key to the filesystem initially (by passing a
> key ID to FS_IOC_ADD_ENCRYPTION_KEY, instead of the key bytes), similar to what
> dm-crypt allows.  After that, the keyrings subsystem plays no role.

Sure, but loading the key into the keyring should allow many different
options, including things like TPM PCR secured keys (eg like
bitlocker) - we shouldn't allow user space the ability to see the key
data at all.

Duplicating this in every subsystem makes no sense, there is a
reasonable role for the keyring to play in solving these kinds of
problems for everything.

Jason
