From: Stephan Mueller <smueller@chronox.de>
Subject: testmgr in user space
Date: Wed, 24 Jun 2015 07:34:34 +0200
Message-ID: <3286221.F87xU132y8@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47849 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbFXFel (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 01:34:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

in case it may help for finding a solution for the testmgr, I do have a test 
system that exercises the kernel crypto API via the AF_ALG interface that I 
use for the libkcapi testing. Of course, that needs polishing to make it 
generally applicable.

However, I see the following obstacles in a user space approach:

- User space currently has no information about which ciphers are currently 
available via the kernel crypto API.  The contents in /proc/crypto only lists 
the ciphers but no templates or the technically prossible permutations of 
templates with ciphers.

- There is currently no "notification" information to user spacewhen a new 
cipher is registered with the kernel crypto API. Maybe crypto_user can be 
extended by a poll?

- There is no technical limitation for ciphers in FIPS mode vs non-FIPS mode 
required. For all FIPS validations up to and including level 2, there is no 
requirement to have a technical limitation that non-approved ciphers cannot be 
used. So, in theory, we could drop this fips_allowed flag enforcement.

- There is no AKCIPHER AF_ALG interface, albeit I am already thinking about a 
lean solution for that -- and I think I have one.

- In FIPS mode, it is currently mandatory that all testing must be completed 
before any cipher is put to use. That means, the user space test manager must 
be started early in the boot cycle (I would expect it typically would be 
started from the initramfs).

While we are at it: wouldn't it make sense to move the tcrypt.c out to the 
tools/ directory?

Ciao
Stephan
