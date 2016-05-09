From: Stephan Mueller <smueller@chronox.de>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 09 May 2016 21:24:42 +0200
Message-ID: <1867642.XvlejD3yXB@tauon.atsec.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de> <10395258.qUa3tSVhS8@tauon.atsec.com> <ee26539d-0447-d9cc-a2d7-370cfe05781a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55086 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbcEITYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 15:24:48 -0400
In-Reply-To: <ee26539d-0447-d9cc-a2d7-370cfe05781a@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Mai 2016, 12:17:21 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 05/09/2016 12:02 PM, Stephan Mueller wrote:
> > One followup: is the final memcmp() between the decrypted hash and the
> > hash of the message implemented in the RSA verify code path? At least I
> > do not see it right away.
> 
> It's in line #549

Do you rather mean line 535? If yes, how would I provide the message digest to 
the verify function?

Please note that at the main driver of my question is 
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/asymmetric_keys/public_key.c#n143
where the caller implements the memcmp().

Thank you.


Ciao
Stephan
