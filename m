From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Wed, 18 May 2016 13:56:00 +0000
Message-ID: <DB5PR04MB130247A73997B1D4F918A945EE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Denis B <begun.denis@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0100.outbound.protection.outlook.com ([157.56.112.100]:26256
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932113AbcEROLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 10:11:44 -0400
In-Reply-To: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Inline comments.

________________________________________
=46rom: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> on behalf of Denis B <begun.denis@gmail.com>
Sent: Wednesday, May 18, 2016 3:06 PM
To: linux-crypto@vger.kernel.org
Subject: IV generation in cryptographic driver in AEAD

Hello,

In AEAD mode (or in any case, in IPSec ESP IPv4 =96 esp4.c), in kernel
versions prior to 4.2 the cryptographic driver is expected to generate
an IV.

What if my driver is unable to generate an IV?
[Catalin Vasile]
Simple: You do not implement the givcrypt() primitive. The kernel will =
generate the IV in software and then call your encrypt() primitive.

Thanks,
Dennis.
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
