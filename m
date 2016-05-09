From: Stephan Mueller <smueller@chronox.de>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 09 May 2016 21:02:15 +0200
Message-ID: <10395258.qUa3tSVhS8@tauon.atsec.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de> <6090436.ehl9Rue05E@tauon.atsec.com> <b8a6fad7-629b-bc62-3094-5d4cc564397b@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55082 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbcEITCW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 15:02:22 -0400
In-Reply-To: <b8a6fad7-629b-bc62-3094-5d4cc564397b@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Mai 2016, 11:55:58 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 05/09/2016 11:50 AM, Stephan Mueller wrote:
> > I think I see my error: pkcs1pad(rsa,HASH) -- I missed the hash part that
> > activates the decoding. Thank you for the pointer.
> > 
> > Once I completed my testing, I think I need to beef up the documentation a
> > bit.
> 
> Right, this can work in two modes. The pkcs1pad(rsa) only strips the
> padding. Thanks,

One followup: is the final memcmp() between the decrypted hash and the hash of 
the message implemented in the RSA verify code path? At least I do not see it 
right away.


Ciao
Stephan
