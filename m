From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5] KEYS: add SP800-56A KDF support for DH
Date: Tue, 20 Sep 2016 14:51:39 +0200
Message-ID: <5900952.XSODrmg63B@tauon.atsec.com>
References: <1571629.ErTDR5PMQO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47992 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbcITMvn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 08:51:43 -0400
In-Reply-To: <1571629.ErTDR5PMQO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 19. August 2016, 20:39:09 CEST schrieb Stephan Mueller:

Hi David,

> 
> SP800-56A defines the use of DH with key derivation function based on a
> counter. The input to the KDF is defined as (DH shared secret || other
> information). The value for the "other information" is to be provided by
> the caller.
> 
> The KDF is implemented using the hash support from the kernel crypto API.
> The implementation uses the symmetric hash support as the input to the
> hash operation is usually very small. The caller is allowed to specify
> the hash name that he wants to use to derive the key material allowing
> the use of all supported hashes provided with the kernel crypto API.
> 
> As the KDF implements the proper truncation of the DH shared secret to
> the requested size, this patch fills the caller buffer up to its size.
> 
> The patch is tested with a new test added to the keyutils user space
> code which uses a CAVS test vector testing the compliance with
> SP800-56A.

Is there a decision about this patch set?

Ciao
Stephan
