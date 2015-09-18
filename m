From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] caam: desc: Remove unused JUMP_TYPE_MASK definition
Date: Fri, 18 Sep 2015 22:06:20 +0800
Message-ID: <20150918140620.GH9249@gondor.apana.org.au>
References: <1442336093-22688-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: horia.geanta@freescale.com, linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34396 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbIROGX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:06:23 -0400
Content-Disposition: inline
In-Reply-To: <1442336093-22688-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 15, 2015 at 01:54:53PM -0300, Fabio Estevam wrote:
> Commit a1efb01feca597b ("jump_label, locking/static_keys: Rename=20
> JUMP_LABEL_TYPE_* and related helpers to the static_key* pattern")
> introduced the definition of JUMP_TYPE_MASK in=20
> include/linux/jump_label.h causing the following name collision:
>=20
> In file included from drivers/crypto/caam/desc_constr.h:7:0,
>                  from drivers/crypto/caam/ctrl.c:15:
> drivers/crypto/caam/desc.h:1495:0: warning: "JUMP_TYPE_MASK" redefine=
d
>  #define JUMP_TYPE_MASK  (0x03 << JUMP_TYPE_SHIFT)
>  ^
> In file included from include/linux/module.h:19:0,
>                  from drivers/crypto/caam/compat.h:9,
>                  from drivers/crypto/caam/ctrl.c:11:
> include/linux/jump_label.h:131:0: note: this is the location of the p=
revious definition
>  #define JUMP_TYPE_MASK 1UL
>=20
> As JUMP_TYPE_MASK definition in desc.h is never used, we can safely r=
emove
> it to avoid the name collision.
>=20
> Reported-by: Olof's autobuilder <build@lixom.net>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Patch applied.  Thanks.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
