From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: BUG: rsa-pkcs1pad decrypt regression in 4.8
Date: Wed, 21 Sep 2016 16:39:30 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1609211630400.14260@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: smueller@chronox.de
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:39100 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932640AbcIUXjb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2016 19:39:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert -

There was a regression in pkcs1pad signature verification, related to 
signature verification, that you fixed in commit 27710b8ea3defcb:

https://git.kernel.org/cgit/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=27710b8ea3defcbd7d340dbd0423d911b4eb7c4f

There is a very similar problem in the decrypt operation, which was not 
adjusted for the leading zero changes. See pkcs1pad_decrypt_complete().

I haven't had a chance to test a fix yet, but with the final 4.8 release 
coming up very soon I wanted to report the issue.


Regards,

--
Mat Martineau
Intel OTC
