From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: Crypto Fixes for 2.6.26
Date: Tue, 15 Jul 2008 19:07:47 +0200
Message-ID: <6101e8c40807151007p3367a985sb3f70e876e109d76@mail.gmail.com>
References: <20080501102812.GA7151@gondor.apana.org.au>
	 <20080509132343.GA12979@gondor.apana.org.au>
	 <20080602080512.GA22059@gondor.apana.org.au>
	 <20080709003741.GA32340@gondor.apana.org.au>
	 <20080710125126.GA25843@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
	stable@kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:14216 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYGORHw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2008 13:07:52 -0400
Received: by fk-out-0910.google.com with SMTP id 18so3235158fkq.5
        for <linux-crypto@vger.kernel.org>; Tue, 15 Jul 2008 10:07:48 -0700 (PDT)
In-Reply-To: <20080710125126.GA25843@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CC stable]

On 7/10/08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Hi Linus:
>
> Just found a regression introduced back in 2.6.25.  This causes
> packet leaks when IPsec is in use.  When that leak grows it can
> eventually lead to hung connections (as their send buffers are
> used up) or worse.
>
> Please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
> or
>
> master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>
>
> Herbert Xu (1):
>       crypto: chainiv - Invoke completion function
>
>  crypto/chainiv.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> Thanks,
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
