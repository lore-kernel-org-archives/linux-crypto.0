From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4] crypto: AF_ALG - fix AEAD tag memory handling
Date: Wed, 07 Dec 2016 12:49:25 +0100
Message-ID: <1650428.hiZ6moN7tX@tauon.atsec.com>
References: <2319539.qMqmu7oTgO@positron.chronox.de> <20161207114245.GA20486@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39088 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751725AbcLGLta (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 06:49:30 -0500
In-Reply-To: <20161207114245.GA20486@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Dezember 2016, 19:42:45 CET schrieb Herbert Xu:

Hi Herbert,
> 
> Hmm, I don't see the code that copies the AAD over.  Did I miss it?

You do not miss it. As I mentioned in a previous email, I would like:

- to include the current patch around the tag now as it has been on the 
mailing list for a long time -- that current patch fixes the superfluous 
copying of the tag value. That fix of the tag handling is unrelated to any AAD 
logic. However, it changes the user-visible memory structure and therefore the 
user interface (i.e. during decryption, the returned data is smaller than it 
used to be and during encryption, less data is required as input).

- the AAD handling with the copying over of data shall come in the next 
development cycle for 4.10. That change is not user visible as it does not 
change the memory structure and thus the user interface. Also, the AAD change 
is unrelated to the tag change provided with this patch.


Ciao
Stephan
