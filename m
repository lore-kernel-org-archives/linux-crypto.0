From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] remove unnecessary variable in xfrm_output_resume()
Date: Tue, 12 Aug 2008 22:53:44 -0700 (PDT)
Message-ID: <20080812.225344.09653172.davem@davemloft.net>
References: <E1KT4y4-0007n6-00@gondolin.me.apana.org.au>
	<200808130750.17226.jcd@tribudubois.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: jcd@tribudubois.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbYHMFxm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Aug 2008 01:53:42 -0400
In-Reply-To: <200808130750.17226.jcd@tribudubois.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Jean-Christophe Dubois <jcd@tribudubois.net>
Date: Wed, 13 Aug 2008 07:50:16 +0200

> Le Wednesday 13 August 2008 03:16:04 Herbert Xu, vous avez =E9crit=A0=
:
> > Jean-Christophe Dubois <jcd@tribudubois.net> wrote:
> > > Small fix removing an unnecessary intermediate variable.
> > >
> > > Signed-off-by: Jean-Christophe DUBOIS  <jcd@tribudubois.net>
> >
> > Please send this to davem@davemloft.net and cc netdev@vger.kernel.o=
rg.
>=20
> Done

Ugh, I didn't see Herbert tell you this sorry :-)

I do really already have a copy of this in my backlog.
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
