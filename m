From: Stephan Mueller <smueller@chronox.de>
Subject: Re: CONFIG_FIPS without module loading support?
Date: Thu, 15 Sep 2016 06:58:54 +0200
Message-ID: <2523179.y8adHMcoDs@tauon.atsec.com>
References: <CAM5Ud7Pw84GcjpooX_5VfBuRTgU8+HMKkM6GBnD1z=JEw0PkXw@mail.gmail.com> <20160902142208.GA12938@gondor.apana.org.au> <CAM5Ud7OVvjh1WirzLh9YGzTqQn8qG8mNMe9+0rC7Q7E-0K7Yqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: NTU <neotheuser@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47960 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbcIOE67 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 00:58:59 -0400
In-Reply-To: <CAM5Ud7OVvjh1WirzLh9YGzTqQn8qG8mNMe9+0rC7Q7E-0K7Yqg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 14. September 2016, 19:18:43 CEST schrieb NTU:

Hi NTU,

> Hello,
> 
> I've never written a patch before to the official kernel mailing list
> (that I remember) so please forgive me if I didn't send this in
> properly. I've generated this using git format-patch HEAD~ --stdout &>
> kconfig_fix_for_fips.patch and have attached the file in this email,
> gathering as much as I could from the Documentation/SubmittingPatches
> page.

Please read Documentation/SubmittingPatches
> 
> Few more things, in the help option for CRYPTO_ANSI_CPRNG, it says it
> must be enabled if FIPS is selected, but in the dependencies for FIPS,
> if DRBG is selected, then CRYPTO_ANSI_CPRNG doesn't need to be
> enabled. Which one is true?

The latter one. The X9.31 DRNG is not approved in FIPS mode any more.
> 
> Secondly, in the help option for CRYPTO_DRBG_MENU, it says that one or
> more of the DRBG types must be selected. If this is indeed true,
> shouldn't the options within CRYPTO_DRBG_MENU be converted to
> choice/endchoice versus just booleans? One selection for
> CRYPTO_DRBG_HASH, another for CRYPTO_DRBG_CTR, and then a third option
> for both? Should I submit patches for these as well,
> feedback/thoughts?

Not sure what you want to gain from it. All that the booleans do is to mark 
which types of DRBG are to be compliled. The selector whether the DRBG is 
compiled at all is CRYPTO_DRBG.

Ciao
Stephan
