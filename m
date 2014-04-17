From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from static functions
Date: Thu, 17 Apr 2014 17:28:41 +0200
Message-ID: <201404171728.41994.marex@denx.de>
References: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jianyu Zhan <nasa4836@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44218 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDQPpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Apr 2014 11:45:32 -0400
In-Reply-To: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, April 16, 2014 at 06:19:50 PM, Jianyu Zhan wrote:
> Commit 128ea04a9885("lto: Make asmlinkage __visible") restricts
> asmlinkage to externally_visible, this causes compilation warnings:
>=20
>     arch/x86/crypto/sha256_ssse3_glue.c:56:1:
>     warning: =E2=80=98externally_visible=E2=80=99 attribute have effe=
ct only on public
> objects [-Wattributes]
>=20
>     static asmlinkage void (*sha256_transform_asm)(const char *, u32 =
*,
> u64); ^
>=20
>     arch/x86/crypto/sha512_ssse3_glue.c:55:1:
>     warning: =E2=80=98externally_visible=E2=80=99 attribute have effe=
ct only on public
> objects [-Wattributes] static asmlinkage void
> (*sha512_transform_asm)(const char *, u64 *, ^
>=20
> Drop asmlinkage here to avoid such warnings.
>=20
> Also see Commit 8783dd3a37a5853689e1("irqchip: Remove asmlinkage from
> static functions")
>=20
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Makes sense, please add my humble

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
