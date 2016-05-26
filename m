From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 15:15:57 -0400
Message-ID: <CACXcFmmz4GOS_WG0AyXK5nQTy_gKirhJSi0zGCH_RpneDKYB=w@mail.gmail.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
	<CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
	<4972668.UQ1QRNriDb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35095 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbcEZTP6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 15:15:58 -0400
Received: by mail-io0-f170.google.com with SMTP id p64so18149678ioi.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 12:15:58 -0700 (PDT)
In-Reply-To: <4972668.UQ1QRNriDb@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 26, 2016 at 2:49 PM, Stephan Mueller <smueller@chronox.de> wrote:

> Then, the use of the DRBG offers users to choose between a Hash/HMAC and CTR
> implementation to suit their needs. The DRBG code is agnostic of the
> underlying cipher. So, you could even use Blowfish instead of AES or whirlpool
> instead of SHA -- these changes are just one entry in drbg_cores[] away
> without any code change.

Not Blowfish in anything like the code you describe! It has only
64-bit blocks which might or might not be a problem, but it also has
an extremely expensive key schedule which would be awful if you want
to rekey often.

I'd say if you want a block cipher there you can quite safely restrict
the interface to ciphers with the same block & key sizes as AES.
Implement AES and one of the other finalists (I'd pick Serpent) to
test, and others can add the remaining finalists or national standards
like Korean ARIA or the Japanese one if they want them.
