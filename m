From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Fri, 01 May 2015 15:21:19 +0200
Message-ID: <1472762.oGxlyZfssS@tauon>
References: <1515730.LIeS5qas5m@myon.chronox.de> <43350012.VMEhAijB9c@tauon> <20150501073036.GA1999@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34651 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbEANVW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 09:21:22 -0400
In-Reply-To: <20150501073036.GA1999@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 1. Mai 2015, 15:30:36 schrieb Herbert Xu:

Hi Herbert,
>
>So who is doing the encrypting/decrypting in this case?

The steps from entering the password until having the full dm-crypt partition 
mounted are, assuming that in my example, we use AES256-CBC as cipher:

1. libcryptsetup: asks for the user's password

2. libcryptsetup/libgcrypt perform PBKDF to obtain key P

3. libcryptsetup: create a dm-crypt mapping of the LUKS header with AES256-
CBC(P)

4. libcryptsetup: mount the dm-crypt mapping and read out the master volume 
key M

4a. kernel: perform en/decryption of LUKS header with AES256-CBC for the 
read/write operations of libcryptsetup

5. libcryptsetup: unmount of dm-crypt mapping

6. libcryptsetup: destroy dm-crypt mapping and forget P

7. libcryptsetup: create dm-crypt mapping of the disk encryption container 
holding the user data using AES256-CBC(M) -- this starts at the offset where 
the LUKS header ends

8. somebody calls mount to mount the created dm-crypt mapping

9: kernel: perform AES256-CBC operation for subsequent operations on mounted 
dm-crypt mapping


My idea would be to use keywrap in step 3.


Ciao
Stephan
