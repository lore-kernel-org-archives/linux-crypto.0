From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error
	allocating crypto tfm
Date: Thu, 9 Apr 2009 10:18:04 +0800
Message-ID: <20090409021804.GA1756@gondor.apana.org.au>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58848 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbZDICSW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2009 22:18:22 -0400
Content-Disposition: inline
In-Reply-To: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 08, 2009 at 09:35:23PM +0200, Maciej Rutecki wrote:
> Kernel 2.6.30.1
>=20
> I try mount encrypted partition:
> root@zlom:/home/maciek# cryptsetup create secret /dev/sda6
> Enter passphrase:
> Command failed: device-mapper: reload ioctl failed: Z=C5=82y argument
>=20
> "Z=C5=82y argument"=3D"Bad argument"

It looks like try_then_request_module has been broken such that it
returns without waiting for the module to complete loading.  I'm
looking into it.

Thakns,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
