From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5] KEYS: add SP800-56A KDF support for DH
Date: Fri, 10 Feb 2017 14:18:52 +0100
Message-ID: <2372333.Xj222SvEfc@tauon.atsec.com>
References: <1571629.ErTDR5PMQO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55850 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdBJNVH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 08:21:07 -0500
In-Reply-To: <1571629.ErTDR5PMQO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 19. August 2016, 20:39:09 CET schrieb Stephan Mueller:

Hi David,

> Hi,
> 
> This patch now folds the KDF into the keys support as requested by
> Herbert. The caller can only supply the hash name used for the KDF.
> 
> Note, the KDF implementation is identical to the kdf_ctr() support in
> the now unneeded KDF patches to the kernel crypto API.
> 
> The new patch also changes the variable name from kdfname to hashname.
> 
> Also, the patch adds a missing semicolon.
> 
> Finally, the patch adds a guard against compiling the compat code
> if the general Linux kernel configuration does not have the compat
> code enabled. Without that guard, compilation warnings are seen.

May I ask which plans do you have with the KDF support for DH?

Ciao
Stephan
