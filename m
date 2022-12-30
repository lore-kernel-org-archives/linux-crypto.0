Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA8AC4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 08:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiL3Iia (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 03:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiL3Ii3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 03:38:29 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DFF10553
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 00:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672389503; bh=dlJPAiNZuF6udlpZv37E30phayIj7Ar9U7/QgLQlAz0=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=WWjVM6tGP7ktZsceJHapVCMPpJ4iR99Uamn1/7k8UCHk4Xlzf9oN8FsxQGqs02YuJ
         /U5Cg/YGg2/81ALoltSD8GCh3RdWueTozyIyNwCtU5jh+AgMQb05cvHx8v2uLhAPyk
         EPnm4NrgcYd8apaZngc9tQdaPb6S4dBSVe6mqSFUPxmaqE2Ry0SjqpZUuCr9KpGNdR
         HLpKXAVddn43izFTPeYz7qr3O/kdmwvHJM2liDfGCoFQ6iGQYOMmhoFsGBbCvclH6y
         88nOPCqz4PbBXbvEm8GWsJJqddl0bn2DICokqqlFhrrYrKUWxBoExHe4pVzyNdsdDv
         GxwKJlClRAtMg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MrhUK-1oWKMc43me-00ngt1; Fri, 30
 Dec 2022 09:38:23 +0100
Message-ID: <b9931836dea5109a8a5aaa0a6e1abe558766d137.camel@gmx.de>
Subject: Re: [PATCH v2 3/6] crypto/realtek: hash algorithms
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Fri, 30 Dec 2022 09:38:21 +0100
In-Reply-To: <Y66ZgBx+hduj9S3K@gondor.apana.org.au>
References: <Y66ZgBx+hduj9S3K@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:cuRrZGUic9YFPkw71QKadqbVkgNwsLCkBVf5R5A4K01zSTQFg2U
 WaOEouahPU9LZjxY2siIkUcKk4wakCTTYQHD0gipvJih0zVZMdmI7l1hgNSuBQXXOjI2CuT
 BzLgNwc32rsy0wXOsHJUgRYyfjRgwx6ngV9Cfx+uuJrOhftzSUlyb9STDbHzVPgvyoSQjPG
 CwZaVWpXPw2tZ6pRjt8uw==
UI-OutboundReport: notjunk:1;M01:P0:rqb47yshblk=;CW7EuWlRai9knENEIE+kcqstIkV
 griGM2gasK9GELgOew8FX7c+QlEyBpEGkIVyiRPFTd1Teqi8EDZJ03ajkfSbkSuNusqj56MJZ
 EL8k9irKj/X6+4f6pYhsjewUgpIeDIpHeJFbPwqTqKmerxcuJqOf/DGHv7c/xbKSd2WNr9V4G
 BEH/uB/cWVPgj0AmK0zW9ycwipFKrsyBCn/lNV6YwrpYyHOdQbdUSspW63IRVNxkcaIxQpWHD
 ZA34r2H8M8ALw6Gwgx1P5dU+RfUVXnCmlxdWzBHk4PptMMuepT4ptXzpd8frbaHuEM8bhWD/N
 rLbAGdZzROM7YE94+bxWTKdWKcaM5wtDD5hYN5P0CNEM0sNu18WSgHvvBmk5AdZIRt6JPPtvW
 a7WFvGKVgreJZElLoSLgcICLqaguBIH36WfHgnxx/w26TodALiA6jnJgCiNTkU2e7D6NYdLr4
 4zvEgnIINpiCea/VfJ1vft7o73NnzROeyLlkMw1/A0Tc9rqtc0eatLK4r3XiF1x95C3Qp1PsP
 pRLuZ4UFYuzGzI4X/TrIYfb7E6mFJsXDCjP8TvEBlNoyYzKCwVYUgF+VlQuDtuwAWBu1RCBrA
 0scraZBaFJdZ8afpq1zN9H5t2gVwzrY3Vd4ivfMmXExl2OsuwwMH0m9DxX/5xk4UYuOHU1+n3
 j+RXYKgoEIyCK7MIofJLuiGxZTX4jci0i9HaqqyGT8YFvMLvXBOsEukTxlZsoI7prrfPknFxy
 WLUAfA+3TtwkZ9xdRkTXguUaNNUap0kwmN59xUThtivXmYgn8ea+ZHmjG9X8JyBa5hPqIPS/f
 DUxe9RQ8v1DLf8615GNsTyXX2cprAZes44Ot0qgA5kKG4pHkBTpj5TQDIQuca61Ns/RT3Q8Fo
 QtkeBE6RImvuzUa523PgRwdbvNn9ctRk6s1OKFO/RO9QV7waWw07kWqloHTUD7TOSPwhI97Ga
 NsW+Qw==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 30.12.2022 um 15:55 +0800 schrieb Herbert Xu:
> Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Write back any uncommitted dat=
a to memory. */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (hreq->buflen)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 dma_sync_single_for_device(cdev->dev,
> > virt_to_phys(hreq->buf),
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 hreq->buflen,
> > DMA_TO_DEVICE);
>=20
> This is not how the DMA API works.=C2=A0 You must not do virt_to_phys.
> Instead use dma_map_single and dma_sync_* is not necessary unless
> you are using the mapping for something else.
>=20

DMA is totally new for me so thanks for the hint.=C2=A0

The simple thing we need to achieve is to flush the CPU caches so that
data becomes visible to the crypto engine. No other hardware specific
DMA commands needed for these SOCs as far as testing shows. I made use
of this because kernel for these devices is compiled with option
CONFIG_DMA_NONCOHERENT=3Dy and I found references to the function in the
caam crypto driver.

Can I just replace the calls with dma_map_single() or do I need other
initialization or cleanup calls?

Best regards.
