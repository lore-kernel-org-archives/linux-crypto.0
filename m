From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: ahash and crc32c
Date: Fri, 28 Oct 2016 12:46:12 +0000
Message-ID: <DB4PR04MB0847E75798BB417FDCF34ECE98AD0@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <CD52BAD7.26798%zeev@annapurnalabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Zeev Zilberman <zeev@annapurnaLabs.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0083.outbound.protection.outlook.com ([104.47.2.83]:24608
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753174AbcJ1RVi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 13:21:38 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/26/2013 7:11 PM, Zeev Zilberman wrote:=0A=
> Hi,=0A=
> =0A=
> I'm working on an ahash driver that supports CRC32C.=0A=
> I saw that all existing CRC32C implementations (except blackfin) are=0A=
> implementing shash interface, but ahash seems to be the correct choice=0A=
> in our case.=0A=
> On the other hand I saw that CRC32C test in testmgr.c tries to create=0A=
> shash tfm for CRC32C and assumes that the CRC context is saved in first=
=0A=
> 4 bytes of the shash context.=0A=
> =0A=
> When I implement CRC32C algorithm this part of the test fails.=0A=
> =0A=
> How should I treat this failure? What is the reason for the requirement=
=0A=
> that is tested in this scenario?=0A=
=0A=
Same question here.=0A=
=0A=
I've added a crc32c ahash implementation, and reverted commit:=0A=
8e3ee85e68c5d "crypto: crc32c - Test descriptor context format"=0A=
as a temporary workaround for the testmgr.c failure.=0A=
=0A=
Thanks,=0A=
Horia=0A=
