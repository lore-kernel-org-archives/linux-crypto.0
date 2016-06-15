From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: RE: [PATCH 0/2] Add SHA-3 algorithm and test vectors.
Date: Wed, 15 Jun 2016 16:27:10 +0530
Message-ID: <f42ae4b169750d44d9d5dbfe0973175a@mail.gmail.com>
References: <1465983719-8313-1-git-send-email-raveendra.padasalagi@broadcom.com>
 6f1cb88dfcf33cfa06f64e9eb78e830a@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33820 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbcFOK5N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 06:57:13 -0400
Received: by mail-yw0-f174.google.com with SMTP id c72so16381651ywb.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jun 2016 03:57:13 -0700 (PDT)
In-Reply-To: 6f1cb88dfcf33cfa06f64e9eb78e830a@mail.gmail.com
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch set can be fetched from iproc-sha3-v1 branch of
https://github.com/Broadcom/arm64-linux.git


Regards,
Raveendra
> -----Original Message-----
> From: Raveendra Padasalagi [mailto:raveendra.padasalagi@broadcom.com]
> Sent: 15 June 2016 15:20
> To: 'Herbert Xu'; 'David S. Miller'; 'linux-crypto@vger.kernel.org';
'linux-
> kernel@vger.kernel.org'; 'Jeff Garzik'; 'Jeff Garzik'
> Cc: 'Jon Mason'; 'Florian Fainelli'; Anup Patel; 'Ray Jui'; 'Scott
Branden'; Pramod
> Kumar; 'bcm-kernel-feedback-list@broadcom.com'
> Subject: RE: [PATCH 0/2] Add SHA-3 algorithm and test vectors.
>
> Forgot to add Jeff Garzik in the email list.
>
> ++  Jeff Garzik.
>
>
> Regards,
> Raveendra
>
> > -----Original Message-----
> > From: Raveendra Padasalagi [mailto:raveendra.padasalagi@broadcom.com]
> > Sent: 15 June 2016 15:12
> > To: Herbert Xu; David S. Miller; linux-crypto@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: Jon Mason; Florian Fainelli; Anup Patel; Ray Jui; Scott Branden;
> > Pramod Kumar; bcm-kernel-feedback-list@broadcom.com; Raveendra
> > Padasalagi
> > Subject: [PATCH 0/2] Add SHA-3 algorithm and test vectors.
> >
> > This patchset adds the implementation of SHA-3 algorithm in software
> > and it's based on original implementation pushed in patch
> > https://lwn.net/Articles/518415/ with additional changes to match the
> > padding rules specified in SHA-3 specification.
> >
> > This patchset also includes changes in tcrypt module to add support
> > for SHA-3 algorithms test and related test vectors for basic testing.
> >
> > Broadcom Secure Processing Unit-2(SPU-2) engine supports offloading of
> > SHA-3 operations in hardware, in order to add SHA-3 support in SPU-2
> > driver we needed to have the software implementation and test
framework in
> place.
> >
> > The patchset is based on v4.7-rc1 tag and its tested on Broadcom
> > NorthStar2 SoC.
> >
> > Jeff Garzik (1):
> >   Crypto: Add SHA-3 hash algorithm
> >
> > Raveendra Padasalagi (1):
> >   Crypto: Add SHA-3 Test's in tcrypt
> >
> >  crypto/Kconfig        |  10 ++
> >  crypto/Makefile       |   1 +
> >  crypto/sha3_generic.c | 296
> > ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  crypto/tcrypt.c       |  53 ++++++++-
> >  crypto/testmgr.c      |  40 +++++++
> >  crypto/testmgr.h      | 125 +++++++++++++++++++++
> >  include/crypto/sha3.h |  29 +++++
> >  7 files changed, 553 insertions(+), 1 deletion(-)  create mode 100644
> > crypto/sha3_generic.c  create mode 100644 include/crypto/sha3.h
> >
> > --
> > 1.9.1
