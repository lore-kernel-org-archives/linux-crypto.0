From: "Vasile Marii" <vasile.marii@gmail.com>
Subject: geode-aes interface with ipsec
Date: Mon, 31 Mar 2008 20:21:25 +0200
Message-ID: <b25669db0803311121k7620ca1dy3a883bcb493bee86@mail.gmail.com>
References: <b25669db0803311049y37f497b2l86e47a7ce49e7718@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:53603 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYCaSV0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Mar 2008 14:21:26 -0400
Received: by rv-out-0910.google.com with SMTP id k20so953809rvb.1
        for <linux-crypto@vger.kernel.org>; Mon, 31 Mar 2008 11:21:25 -0700 (PDT)
In-Reply-To: <b25669db0803311049y37f497b2l86e47a7ce49e7718@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm trying to write a driver for hardware accelerated aes-cbc crypting
device to use with ipsec. I have a geode-aes and I'm spying on it
trying to understand all the stuff needed to make it work.
Well, when I'm initializing the geode module, I'm sending some test vectors:
 Key       : 0xc286696d887c9aa0611bbb3e2025a45a
IV        : 0x562e17996d093d28ddb3ba695a2e6f58
Plaintext : 0x000102030405060708090a0b0c0d0e0f
              101112131415161718191a1b1c1d1e1f
Ciphertext expected:
               d296cd94 c2cccf8a 3a863028 b5e1dc0a
              7586602d 253cfff9 1b8266be a6d61ab1
expecting to see the cipher text on output. I,m just sending the
address of data stored on my local machine to src field on geode-aes
engine AES_SOURCEA_REG, and all the flags needed for CBC encryption,
it work
 surely because obtained data is decrypted to the original plain text.
And i recieve this:
c1398353 61a38726 4db45c3f 513bc0cc
a1835114 42f2fdd0 86fc8bdc 5b3aeeef
Where is the problem?
Is the plaintext in ipsec not so "plain"? Is the kernel doing some
modifications on it while  trabelling thru blkcipher_walkvirt &
friends?
 What is the real interface between ipsec and algorithms?
Thanks in advance!

-- 
Vasile Marii
