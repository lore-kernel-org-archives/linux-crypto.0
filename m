From: Patrick McHardy <kaber@trash.net>
Subject: HIFN+IPsec crashes in current -git
Date: Wed, 13 Feb 2008 14:17:45 +0100
Message-ID: <47B2EDF9.6020900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYBMNRu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Feb 2008 08:17:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm getting crashes when using HIFN and IPsec (ESP with
AES + MD5) in the current -git tree. I didn't capture the
Oops, but there seem to be a number of problems:

- hifn_setup_session walks over the scatterlist, subtracting
   the scatterlist element size from nbytes until nbytes
   reaches zero. In my case nbytes is 12 byte smaller than
   the scatterlist, so nbytes underflows and it oopses when
   walking over the of the scatterlist.

- similar problem in ablkcipher_walk

- After adding a hack to only walk the correct amount of
   bytes, I got another crash because the return value
   of ablkcipher_walk is not checked for errors, which
   can cause sg_num to take a very large value.

- After adding more hacks to work around the crash,
   I got "bad page state" on resume and a refcount
   underflow in dst_release() called by xfrm_input(),
   but that may very well be caused by my hacks.

I couldn't figure out where in the crypto code the
nbytes decrement by 12 bytes compared to the length
seen when setting up the crypto operation happens
or I might have tried to properly fix it myself.
I'll happily test patches in case someone more
familiar with the code does a proper fix.
