From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Asymmetric cryptography HW offloading
Date: Mon, 23 Sep 2013 15:28:14 +0200
Message-ID: <524041EE.5070209@gnutls.org>
References: <524034A1.70204@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37067 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3IWN2W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 09:28:22 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so1713106eek.23
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2013 06:28:21 -0700 (PDT)
In-Reply-To: <524034A1.70204@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/23/2013 02:31 PM, Horia Geant=C4=83 wrote:
> Hi,
>=20
> CAAM crypto engine (drivers/crypto/caam/*) is capable of asymmetric
> operations, like: modular exponentiation, RSA
> sign/verify/encrypt/decrypt, (EC)DSA sign etc.
> I would appreciate some design guidelines on how to harness these
> capabilities, for crypto engines in general.
>=20
> 1. In-kernel interface for asymmetric crypto
> Should crypto/asymmetric_keys/* be used, i.e. appended with modular
> exponentiation, other asymmetric operations?=20

The BSD's cryptodev supports the following operations which may help in
that aspect (no elliptic curve operations present). I don't know if all
of them worth the context switch.

#define CRK_MOD_EXP		0
#define CRK_MOD_EXP_CRT		1
#define CRK_DSA_SIGN		2
#define CRK_DSA_VERIFY		3
#define CRK_DH_COMPUTE_KEY	4
#define CRK_MOD_ADD		5
#define CRK_MOD_ADDINV		6
#define CRK_MOD_SUB		7
#define CRK_MOD_MULT		8
#define CRK_MOD_MULTINV		9
#define CRK_MOD			10

> 2. User space interface
> Should AF_ALG be expanded to provide access to this new asymmetric cy=
pto
> API? The API would allow user space applications to offload PKC opera=
tions in
> HW.

I'd be interested into adding this support into cryptodev-linux once
present in kernel.

regards,
Nikos
