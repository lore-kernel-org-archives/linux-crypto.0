Return-Path: <SRS0=waMk=NM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34623 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbeKARoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Nov 2018 13:44:19 -0400
MIME-Version: 1.0
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com> <CALT56yNN6N8J040Ce7B-FgGSyO0WngUoePp+3TsVn3PpvEQORw@mail.gmail.com>
 <20181101084109.lme4cd2x5wfsj2fg@gondor.apana.org.au>
In-Reply-To: <20181101084109.lme4cd2x5wfsj2fg@gondor.apana.org.au>
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Thu, 1 Nov 2018 11:42:04 +0300
Message-ID: <CALT56yMu8WS-Gd_RyCnPkh-vkNjmtEN5-jmkogp+t4QJMVs0Xw@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: James.Bottomley@hansenpartnership.com, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=D1=87=D1=82, 1 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 11:41, Herber=
t Xu <herbert@gondor.apana.org.au>:
>
> On Thu, Nov 01, 2018 at 11:32:37AM +0300, Dmitry Eremin-Solenikov wrote:
> >
> > Since 4.20 pull went into Linus'es tree, any change of getting these tw=
o patches
> > in crypto tree?
>
> These aren't critical enough for the current mainline so they will
> go in at the next merge window.

Thank you.


--=20
With best wishes
Dmitry
