From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Mon, 19 Jun 2017 12:12:34 +0800
Message-ID: <20170619041234.GA12984@gondor.apana.org.au>
References: <20170512041734.31945-1-vapier@gentoo.org>
 <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
 <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
 <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
 <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Frysinger <vapier@chromium.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59548 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdFSEND (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 00:13:03 -0400
Content-Disposition: inline
In-Reply-To: <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 12, 2017 at 01:49:52PM +0530, PrasannaKumar Muralidharan wrote:
>
> I leave it to Herbert to decide whether to accept this patch in
> current form or not.

I think the correct fix would be for the TPM subsystem to signal that
it is ready and then register the tpm-rng device.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
