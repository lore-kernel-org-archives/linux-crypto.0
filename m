From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 02 Mar 2016 16:09:22 +0100
Message-ID: <1891205.oYGzDiGSlD@tauon.atsec.com>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <1547276.hIHXt6xUvB@positron.chronox.de> <69E0CA7E-C7A5-4AC5-8FC1-930A115F6F66@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:44702 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbcCBPJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 10:09:57 -0500
In-Reply-To: <69E0CA7E-C7A5-4AC5-8FC1-930A115F6F66@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 2. M=E4rz 2016, 06:54:21 schrieb Marcel Holtmann:

Hi Marcel,

>=20
> and why is this not an userspace policy decision on what minimum it a=
llows?
> Why are we discussing this in the context of the kernel in the first =
place?
> The kernel should just expose the support for it.

You are right on the mark, this would be the best.
>=20
> Regards
>=20
> Marcel


Ciao
Stephan
