From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] caam: desc: Remove unused JUMP_TYPE_MASK definition
Date: Tue, 15 Sep 2015 19:42:37 +0300
Message-ID: <55F84A7D.1070002@freescale.com>
References: <1441304489-21738-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vicki.milhoan@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:56009
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752771AbbIOQmv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 12:42:51 -0400
In-Reply-To: <1441304489-21738-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/3/2015 9:21 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> JUMP_TYPE_MASK is defined in desc.h and it is never used, so we can
> safely remove it to avoid the following build warning:
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
> Reported-by: Olof's autobuilder <build@lixom.net>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

The build warning is introduced by commit
a1efb01feca5 ("jump_label, locking/static_keys: Rename JUMP_LABEL_TYPE_=
*
and related helpers to the static_key* pattern")
which currently is not in cryptodev-2.6 tree, i.e. can only be found
upstream.

Other than this,
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Horia
