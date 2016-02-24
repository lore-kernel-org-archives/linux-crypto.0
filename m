From: Stephan Mueller <smueller@chronox.de>
Subject: Asymmetric ciphers: counter measures
Date: Wed, 24 Feb 2016 12:27:03 +0100
Message-ID: <1710408.OFMoxk9pvo@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60146 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcBXL1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 06:27:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

currently RSA is implemented as the only asymmetric cipher in software. But 
others must be expected coming. We have seen the DH patch already.

Albeit software asym ciphers is only a fallback, what is your opinion to cover 
those implementations with counter measures?

Currently RSA does not implement anything and is even susceptible to timing 
attacks if I see that right as the leading zeros are stripped. In addition to 
the leading zeroes problem, blinding comes to mind. If we do blinding, what 
type of blinding is sufficient for a fallback (base, exponent, modulus)?

Ciao
Stephan
