From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Fix incorrect values in PKCS#1 test vector
Date: Tue, 13 Feb 2018 09:37:07 +0100
Message-ID: <2550703.8XkIRpotY3@tauon.chronox.de>
References: <CE2E46B8F68C4948A08D2E78E3D946C152762D35@IRSMSX104.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Mcloughlin, Conor" <conor.mcloughlin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:25784 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbeBMIhN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:37:13 -0500
In-Reply-To: <CE2E46B8F68C4948A08D2E78E3D946C152762D35@IRSMSX104.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 13. Februar 2018, 09:29:56 CET schrieb Mcloughlin, Conor:

Hi Conor,

> The RSA private key for the first form should have
> version, prime1, prime2, exponent1, exponent2, coefficient
> values 0.
> With non-zero values for prime1,2, exponent 1,2 and coefficient
> the Intel QAT driver will assume that values are provided for the
> private key second form. This will result in signature verification
> failures for modules where QAT device is present and the modules
> are signed with rsa,sha256.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
