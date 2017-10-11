From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: crypto API - async semantics
Date: Wed, 11 Oct 2017 12:36:11 +0000
Message-ID: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0048.outbound.protection.outlook.com ([104.47.1.48]:2176
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752006AbdJKMgN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 08:36:13 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,=0A=
=0A=
I am evaluating whether ahash implementation in caam crypto driver=0A=
behaves correctly.=0A=
One thing I've noticed is that for each ahash tfm there is support for=0A=
at most two in-flight requests, and I would like to know whether this is=0A=
an issue or not.=0A=
=0A=
In this context, could you please clarify whether your previous answer:=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04029.html=0A=
> If any async operation returns EINPROGRESS, the client must not=0A=
> proceed until that operation has completed.=0A=
refers only to ahash operations OR to any crypto API async operation?=0A=
IIUC this would be equivalent to saying that crypto API allows only for=0A=
one in-flight request per tfm, correct?=0A=
=0A=
If your answer applies to any async operation, then I see at least one=0A=
in-kernel user not complying with the rule - dm-crypt.=0A=
=0A=
Does it actually apply to ahash and, generalizing, to any algorithm for=0A=
which chunking is inherently serial (each crypto request having a data=0A=
dependency on previous request)?=0A=
=0A=
Thanks,=0A=
Horia=0A=
