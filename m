From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: Re: [PATCH 00/11] crypto: omap-sham driver fixes
Date: Wed, 8 Jun 2011 22:36:03 +0300
Message-ID: <BANLkTi=RBdtY_-_KGKShvt=LJ044QOO3TQ@mail.gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
	<20110608130833.GD4582@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20110608130833.GD4582@gondor.apana.org.au>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks!

On Wed, Jun 8, 2011 at 4:08 PM, Herbert Xu <herbert@gondor.apana.org.au=
> wrote:
> On Thu, Jun 02, 2011 at 09:10:02PM +0300, Dmitry Kasatkin wrote:
>> Hi,
>>
>> Recently we got crashes few times after some other patches to 2.6.32=
 kernel.
>> This patch set greatly prevents race condition situations.
>> No crashes are noticed any more.
>> Now the driver should be ok for multi core as well.
>
> All applied to cryptodev. =A0Thanks Dmitry!
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
