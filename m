From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 03 Aug 2015 09:18:42 +0200
Message-ID: <1580424.u6GEQiXd8T@myon.chronox.de>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48078 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbbHCHSr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:18:47 -0400
In-Reply-To: <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 3. August 2015, 00:14:28 schrieb Marcel Holtmann:

Hi Marcel,

> 
> It does not. The RSA Private Key has a different format.
> 
>       RSAPrivateKey ::= SEQUENCE {
>           version           Version,
>           modulus           INTEGER,  -- n
>           publicExponent    INTEGER,  -- e
>           privateExponent   INTEGER,  -- d
>           prime1            INTEGER,  -- p
>           prime2            INTEGER,  -- q
>           exponent1         INTEGER,  -- d mod (p-1)
>           exponent2         INTEGER,  -- d mod (q-1)
>           coefficient       INTEGER,  -- (inverse of q) mod p
>       }
> 
> And honestly that the RSA Public Key magically matches seems more luck then
> clear intention.
> 
>       RSAPublicKey ::= SEQUENCE {
>           modulus           INTEGER,  -- n
>           publicExponent    INTEGER   -- e
>       }

I think here we may have the issue: the ASN.1 structure the kernel uses should 
be changed to implement that commonly used ASN.1 structure. If this change 
would allow a DER to be used, I think we have the solution.


-- 
Ciao
Stephan
