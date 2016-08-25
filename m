From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: caam - IV source for IPsec decryption
Date: Thu, 25 Aug 2016 16:12:35 +0000
Message-ID: <DB4PR04MB0847411DA278511045969E6998ED0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0083.outbound.protection.outlook.com ([104.47.2.83]:48192
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751223AbcHZTLl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 15:11:41 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,=0A=
=0A=
Commits=0A=
7021b2e1cddd "esp4: Switch to new AEAD interface"=0A=
000ae7b2690e "esp6: Switch to new AEAD interface"=0A=
removed the following:=0A=
	/* Get ivec. This can be wrong, check against another impls. */=0A=
	iv =3D esph->enc_data;=0A=
from IPsec decryption - esp{4,6}_input(),=0A=
so the IV in req->iv received by the implementer is no longer valid.=0A=
=0A=
Thus, the load of IV in caam driver - caamalg.c, init_authenc_job():=0A=
        if (ivsize && (is_rfc3686 || !(alg->caam.geniv && encrypt)))=0A=
                append_load_as_imm(desc, req->iv, ivsize,=0A=
                                   LDST_CLASS_1_CCB |=0A=
                                   LDST_SRCDST_BYTE_CONTEXT |=0A=
                                   (ivoffset << LDST_OFFSET_SHIFT));=0A=
is not suited for case mentioned above.=0A=
=0A=
Instead, the IV should be read from the req->src scatterlist=0A=
(which consists of assoc data, iv, ciphertext).=0A=
Please let me know if this is accurate, so I could prepare a fix.=0A=
=0A=
Thanks,=0A=
Horia=0A=
