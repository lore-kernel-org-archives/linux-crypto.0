Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C2EC4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Dec 2022 18:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiLESsP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Dec 2022 13:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiLESsK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2022 13:48:10 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E4B84F
        for <linux-crypto@vger.kernel.org>; Mon,  5 Dec 2022 10:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670266081; bh=6jtH4f4Ooe980NRSIA0tlF1i/AESWVKDiXTi4gEhZto=;
        h=X-UI-Sender-Class:Subject:From:To:Date:In-Reply-To:References;
        b=Atlzg2dSIPWW4iBmOANk//MYKabDr4c1csj+R9rZZ4bv3GP9KVI2yN3GxEHSCbUIR
         WBUifroEY6k7kQ/x8bW9DN0sMxjPi5OwYuVu+8e6hvgaMgU8vhoEgTq2cmdT4ZXtcC
         dNlUi5J4L/xGZo93dNr/nwVBB22wKbTQZjFOGKgiXc7qCTl1m1zN4Ud3oG7tD9N7Th
         j/ny+6j/yPyDzSbaUEy7JG5zeu7RkZie6LknheMEGool3FMW3cb4pkomD6WaBsnVIn
         Wm6i9XBs7APmHRokCS/fEFtln/U9huu8Qyi2nk/P38wkdCdqucvDfNgAFenj20NS9v
         9brq2rR3PwqxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.87.22]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M72oH-1p33zr3aqF-008ZFa; Mon, 05
 Dec 2022 19:48:00 +0100
Message-ID: <fe7800282ff11f7822778eb9109864f1f3b144f2.camel@gmx.de>
Subject: Re: [PATCH 0/6] crypto/realtek: add new driver
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Date:   Mon, 05 Dec 2022 19:47:59 +0100
In-Reply-To: <20221013184026.63826-1-markus.stockhausen@gmx.de>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:2zWWRvoIMwXqRhFtJLggEvKd91LsRvgAmzQ5oFRijFVCfIL6RVC
 q61a8yP/0yvEQ/jFpJQ6EeS0nz9qyG1rFExFO9Op5zN0x0fbfGX3qdwvVAbMIiTjIG19LLu
 EfE6T14C6fYUkuxvxLG1gxUeWnPsjsSaofnc2oJYP4B52uVUolu0U2AXnGLL3hF3AqorQ8r
 Pv8INgktvtNnD+EIAJR0w==
UI-OutboundReport: notjunk:1;M01:P0:TX605Fm81n0=;yYO2EUD8ded7d0A4k+ZEWwpePG6
 3MZIVA25bRAZLfHdiPOva/WI6fruWmOp0RIRvr0lUDoNQTCJKNGQGtcCmR4Daba78oKxgnjDp
 K8VLhpEpD6aZ5XKckqVTrdU3J9JbJ1kGLmS1Wy2RhI9afL56ZOxzSmTMX/4AT/t/9p8rguJGV
 Bb3j+gOE8Grh3nPU1GfDBvDsSKPttDluXXMNNjNq4AG/XUZOuls+Rr0WQkDcEqvdbdVFYDdYT
 sYwnw9uqXH6Rt9AecRxwuPZIVzJfYwV0GLiqj7+gTTzNOR4DUP71P7hKpNeiCRld7jZ48+iqX
 RQ+C9HxNIPnc/WHe9g68pxjcxFlWpdecwGPyq04IdS7iphjN/06eaWHa6V7osnnIn6/i1lVUx
 5Jlr3CYgmj/DK0UU5LZXcXFa2bgf33lhXwwdLxoLmtyFHFuYspfkhKKR3qRqVfshJu4bRV9Y0
 FteCQpSmSnZeZ/t7xeY9KNo6zBmV/MI1M0tM3DCqESTz0UQbgP3jzkoplLB/1MIxJV5Mgb7qK
 H6LV6gytYS14m8ZAXcwStegz5TDTwfh7Y2N7605+1NUcAWt6DyJT5GUYt7o4DXZmY84d7/ELq
 Dgrlglvkg5gGpw/AsT2vGv0cnBUjX3kglCwkFx7adYMGBYBT0EJRvTgT6HBjtHjlKbLcs8g3O
 swJXrnkRA5nAcOdnVqZ9eQgnU32Up9rjYB6U76ctc1gaIv6AOYc9w9B8Tc88dOYsiHv/Mghws
 jeTpLjYDcma9yD9lrO+/7vsd06xY53eNpTkWFEvuruNabGYDJpdVcDk66/mKazHMrxf461Q3O
 ncugDYyf0zw8W3UrBAvmN+zFYRdGy+E0bkpQDpZFOii81AdK2ypKOEqqFF4g/nOvOo51ROtW9
 4k6yH9YoGv79ACW6FBarRMee8eSBahZ2HbnQOE6nB+vr12PX+gDNigUyi+uWNPvoNhGzYIFwS
 jbKsfg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, dem 13.10.2022 um 20:40 +0200 schrieb Markus
Stockhausen:

> This driver adds support for the Realtek crypto engine. It provides
> hardware
> accelerated AES, SHA1 & MD5 algorithms. It is included in SoCs of the
> RTL838x
> series, such as RTL8380, RTL8381, RTL8382, as well as SoCs from the
> RTL930x
> series, such as RTL9301, RTL9302 and RTL9303. Some little endian and
> ARM based
> Realtek SoCs seem to have this engine too. Nevertheless this patch
> was only
> developed and verified on MIPS big endian devices.
>=20
> Module has been successfully tested with
> - lots of module loads/unloads with crypto manager extra tests
> enabled.
> - openssl devcrypto benchmarking
> - tcrypt.ko benchmarking
>=20
> ...
>=20
> Markus Stockhausen (6)
> =C2=A0 crypto/realtek: header definitions
> =C2=A0 crypto/realtek: core functions
> =C2=A0 crypto/realtek: hash algorithms
> =C2=A0 crypto/realtek: skcipher algorithms
> =C2=A0 crypto/realtek: enable module
> =C2=A0 crypto/realtek: add devicetree documentation
>=20
> /devicetree/bindings/crypto/realtek,realtek-crypto.yaml|=C2=A0=C2=A0 51 +
> drivers/crypto/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 13
> drivers/crypto/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0=C2=A0 1
> drivers/crypto/realtek/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 5
> drivers/crypto/realtek/realtek_crypto.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 472
> ++++++++++
> drivers/crypto/realtek/realtek_crypto.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 325 +++++=
+
> drivers/crypto/realtek/realtek_crypto_ahash.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 406
> ++++++++
> drivers/crypto/realtek/realtek_crypto_skcipher.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 361 +++++++
> 8 files changed, 1634 insertions(+)

Hi (Herbert),

as I got neither positive nor negative feedback after your last
question I just want to ask if there is any work for me to do on this
series?

Thanks in advance.

Markus


