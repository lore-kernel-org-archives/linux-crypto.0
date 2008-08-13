From: Jean-Christophe Dubois <jcd@tribudubois.net>
Subject: Re: [PATCH] remove unnecessary variable in xfrm_output_resume()
Date: Wed, 13 Aug 2008 07:50:16 +0200
Message-ID: <200808130750.17226.jcd@tribudubois.net>
References: <E1KT4y4-0007n6-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:32861 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYHMFuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Aug 2008 01:50:20 -0400
In-Reply-To: <E1KT4y4-0007n6-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le Wednesday 13 August 2008 03:16:04 Herbert Xu, vous avez =E9crit=A0:
> Jean-Christophe Dubois <jcd@tribudubois.net> wrote:
> > Small fix removing an unnecessary intermediate variable.
> >
> > Signed-off-by: Jean-Christophe DUBOIS  <jcd@tribudubois.net>
>
> Please send this to davem@davemloft.net and cc netdev@vger.kernel.org=
=2E

Done

Thanks

>
> Thanks,


--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
