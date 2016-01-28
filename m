From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
Subject: Re: [Linux-ima-user] [RFC] i.MX6 CAAM blob generator for IMA/EVM
 initialization
Date: Thu, 28 Jan 2016 17:27:56 +0100
Message-ID: <1453998476.25454.71.camel@pengutronix.de>
References: <1447082306-19946-1-git-send-email-s.trumtrar@pengutronix.de>
	 <1447100981.2728.23.camel@linux.vnet.ibm.com>
	 <73d1snz6bp.fsf@unicorn.hi.pengutronix.de>
	 <1453995694.8290.34.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	keyrings@linux-nfs.org, linux-ima-user@lists.sourceforge.net,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	linux-ima-devel@lists.sourceforge.net,
	David Woodhouse <dwmw2@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35062 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbcA1Q2C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jan 2016 11:28:02 -0500
In-Reply-To: <1453995694.8290.34.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Do, 2016-01-28 at 10:41 -0500, Mimi Zohar wrote:
> On Wed, 2016-01-27 at 11:04 +0100, Steffen Trumtrar wrote:
> > Can I somehow use the keyring framework as an abstraction around my
> > blobbing/deblobbing functionality?
> > So that the "keyring" calls into the crypto driver to decrypt the d=
ata
> > and uses the crypto driver to encrypt the keys when I want to "dump=
"
> > them?
>=20
> Definitely.   It sounds like you want the equivalent functionality as
> the TPM based trusted keys using OTP on the CAAM.
>=20
> From Documentation/security/keys-trusted-encrypted.txt:
>=20
> "Trusted Keys use a TPM both to generate and to seal the keys.  Keys =
are
> sealed under a 2048 bit RSA key in the TPM, and optionally sealed to =
specified
> PCR (integrity measurement) values, and only unsealed by the TPM, if =
PCRs
> and blob integrity verifications match."

OK. The implementation is in security/keys/trusted.c, right? This talks
directly to the TPM. Also the code in security/keys/encrypted-keys/
explicitly uses the interface in keys/trusted-type.h.

Now I'm not sure how to best allow using the CAAM as an alternative to =
a
TPM. Would we have different "backends" in the trusted keys
implementation so that for example encrypted keys don't need to know
about the difference?

Otherwise we would need to add another key type ("trusted-caam?"). Then
we'd need to add code to support trusted-caam keys wherever we already
support trusted(-tpm) keys?

Do you have a suggestion on how we should proceed?

Best regards,
Jan L=C3=BCbbe
--=20
Pengutronix e.K.                           |                           =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |
