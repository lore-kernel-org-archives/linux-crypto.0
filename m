Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF8CC3DA7A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 16:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjAFQR0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 11:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjAFQRX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 11:17:23 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BD46145F
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 08:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673021838; bh=72geejCa80v8OCzI1HX38P8XbglLIU9WAhNhqmivrBs=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=eye9I6B1lMj/8wpYtHAs/ezoPkaGViZHdXf/l5Tss4bOIqRicQVA4EoZYkRy+7oy4
         MlJCWUbnmccfc2E5Qa6u5CX0Ldg6p1fw8FuyvlCbZbl/vXwLOPJoOqqGc7JPraiI+W
         vfiG3MLa0b9FyU0J+OokNOUEMCm57nmWJRNAeRZ/z1dozvTZKwbNd0NNDhnsH9MZNG
         s0tca/8eTYQdaGz8Vl/owuim0jkTJYQ6oEbtvi/oE/0/fsGhvqd9BXbWSM6X9Qi0kL
         wIGO9qaXTBrK5Ks3ZkJLBO1ANRz6/thpF9ED1o8dMAPtHNv93/rDMJ6cunyHsTTDZh
         oCDsuLCn6wZMw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.82.22]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MvbFs-1oxxDH3uvm-00sajB; Fri, 06
 Jan 2023 17:17:17 +0100
Message-ID: <000f04f6ed4aef9bb4a67ae00fc259922f88090c.camel@gmx.de>
Subject: Re: [PATCH v3 2/6] crypto/realtek: core functions
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Fri, 06 Jan 2023 17:17:16 +0100
In-Reply-To: <Y7fjvoc28CUza3qf@gondor.apana.org.au>
References: <Y7fjvoc28CUza3qf@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:wyseWTcQqhlFmiQOVmNddbwp3Aa+lGTVbD4Ar3kBpvfeAwWZdcq
 cAL+jrxBEbQ+6qJdF0aor6nbcqqzDh182A4KmvZ3XuQ+W+1j5MjbhZ0SC3pED9qXUNNFjol
 wDE3G+hLmQQzb6UeqqVAJC6ElW+kUESoDQVu3DIxCLmdrMVHGSXYvBl3YVxw66UZZc1rLha
 moXE0qF5pun+hlMyckHMQ==
UI-OutboundReport: notjunk:1;M01:P0:j94u61MAPZ0=;0l2Ucm73aWy8o4fwYJyclUJOBdM
 YJ/B/bYI08QW5KLNUNXq9DmvMmJXIdIvY+4eglGwe/PS1A5jt6sVKpN33RCvuwGFO71/c6nVz
 ww9W5Iw0MK+5G20dqHA287AOh8Jm49Crnr5y9Z/gDcLuTkMQQqMdkdCh3X3AHJJdFVi4ot5ZX
 lzbVtYLOiF+XSb/Ghvi4Z++eNX3ona4YcQyCc8Nb+WQ9WtMxg9DT3L0vkxj4iA1KD5sPwBCO0
 ztyBYM8D0TrVEYaIndkxOJNKvkwe5wuXi6vbBtjLfsNVa72SI3PjP6zbgZQNI5kJs18ybZu+t
 cXEUdF2CzStcAS/aTkzsE0TZrNQrE8SSmpQ5RrVuRX2iUH9d9FVXR621AmNnkkVSPvU1XjpxR
 QS9itUBEFx7t4sdLYdjtdDpue3G5rLnv+CvyMBslTt4Xfpqj59Hyi0Xb1bv6cDdr88w1yf38E
 AMicb3e5sMesdLqP0RntG5aToaCToUEUQJJ34qN5wE/B3kyiesIY1dQSDp/qV9XYb5xSUe+TW
 NWnHuDJD5ifTqs9fHWyoG9Mxb0hgo/FtZLiWKN4sCXfkxP8jl7xUcliE9DNaoGpttd7fuVz1p
 rvALUDJ8D0Z7ieoY2TlHxVmPHN8HQDGUuDGWeicM8w03LrvNprq9DpZRiQLAzcSudcOWcOL14
 V8JYmcIXrbbxvEzM0Tr4gKyyC//Omi/C05iLOnsUBKRrlgR22fw1qSo2/g76z7SqBbQ6+gejV
 e71EiUn2w83y1sCa7pAu+dg3L5swivDGIAnzr8iIEL7MqAsOrcWAAZ2SsX7p9Oo0IOkeqbi9G
 1Yu5/9hQfbMQyn3hai1CxWiGEvi5VBX1btWPqGEDY4zJUTnE1yZkcsrdiooxlfE8naPHdd1ZE
 j6nbXCtQae+UTudBXkqoY2jhDt8h7bClAba758BwtabH1SHW/Uvoq8kjm0I2GmaHd3PymztiY
 z/sVGBHEFnP4o0pxYXmLnAR0pEA=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 06.01.2023 um 17:02 +0800 schrieb Herbert Xu:
> Markus Stockhausen <markus.stockhausen@gmx.de> wrote:
> >=20
> > +void rtcr_add_src_to_ring(struct rtcr_crypto_dev *cdev, int idx,
> > void *vaddr,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 int blocklen, int totallen)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma_addr_t dma =3D cdev->src_dma =
+ idx * RTCR_SRC_DESC_SIZE;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct rtcr_src_desc *src =3D &cd=
ev->src_ring[idx];
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 src->len =3D totallen;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 src->paddr =3D virt_to_phys(vaddr=
);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 src->opmode =3D RTCR_SRC_OP_OWN_A=
SIC |
> > RTCR_SRC_OP_CALC_EOR(idx) | blocklen;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma_sync_single_for_device(cdev->=
dev, dma,
> > RTCR_SRC_DESC_SIZE, DMA_BIDIRECTIONAL);
>=20
> Why aren't there any calls to dma_sync_single_for_cpu if this is
> truly bidirectional?
>=20
> Cheers,

Thanks, I need to check this again. CPU sets ownership bit in that
descriptor to OWNED_BY_ASIC and after processing we expect that engine
has set it back to OWNED_BY_CPU. So bidirectional operation is somehow
needed.

Markus
