From: Cata Vasile <cata.vasile@nxp.com>
Subject: ARM-CE aes encryption on uneven blocks
Date: Mon, 24 Oct 2016 14:41:11 +0000
Message-ID: <HE1PR04MB13065DBD6C9844835123FAF9EEA90@HE1PR04MB1306.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0074.outbound.protection.outlook.com ([104.47.2.74]:33606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754175AbcJYBQa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 21:16:30 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi,

I'm trying to understand the code for AES encryption from ARM-CE.
>From the aes-glue.S calls I understand that the encryption primitives recei=
ve the number of blocks, but have no way of determining the number of bytes=
 to encrypt, if for example the plaintext does not have a length of a multi=
ple of AES block size.
How does, for example, ecb_encrypt() also encrypt the last remaining bytes =
in the plaintext if it is not a multiple of AES block size if It can never =
deduce the full plaintext size?

Catalin Vasile=
