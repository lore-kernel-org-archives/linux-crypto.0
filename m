From: Stephan Mueller <smueller@chronox.de>
Subject: crypto: algif_skcipher: check for IV size superfluous?
Date: Sat, 08 Nov 2014 01:32:30 +0100
Message-ID: <8150359.mtACJVFlUb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54292 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaKHAcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2014 19:32:36 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S5E07> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sat, 8 Nov 2014 01:32:32 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I am in the process to extend algif_skcipher to support AEAD ciphers as well. 
The code already works but I want to run final tests before releasing it.

In the course of the development I stumbled over the following code:

static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
			    struct msghdr *msg, size_t size)
{
...
		if (con.iv && con.iv->ivlen != ivsize)
			return -EINVAL;

This code effectively requires that any user space code trying to use a cipher 
must provide an IV that is equal to the blocksize of the cipher.

I am wondering why this check is there or whether we can remove that.

When using the kernel crypto API inside the kernel, there is no such 
enforcement. One can take shorter IVs which are implicitly padded with 
trailing zeros.

I would like to allow such non-aligned IVs from user space as well. As the 
user space interface invokes the kernel crypto API functions that allow the 
non-aligned use inside the kernel, I would not anticipate a problem.

However, if we conclude that the check should remain, then I am wondering 
whether we have to move it to the various _setiv functions of the kernel 
crypto API instead of leaving it in the skcipher interface. 

During my testing, I removed the check and provided different sized IVs just 
as I would in kernel space. The kernel crypto API processed them normally and 
the resulting ciphertext / plaintext is as expected.

An example that I used are the following parameters for a decryption operation 
successfully taken from the FIPS 140-2 CAVS tool with an IV shorter than the 
blocksize:

AEAD_name_1="gcm(aes)"
AEAD_msg_1="d127b39d365d16246d2866b2ebabd201"	# Ciphertext
AEAD_key_1="38bd9eb2cb29cc42ac38d6cdbe116760"	# key
AEAD_iv_1="aac774c39e399e7d6371ec1d"		# IV
AEAD_tag_1="34a21cc3562f0ba141d73242e5a3b666"	# Authentication Tag
AEAD_taglen_1="16"
AEAD_assoc_1="5dbb2884f3fe93664613e863c3bd2572855cf808765880ef1fa5787ceef8c793"
						# Associated data
AEAD_exp_1="8f9ec088580c23fc6f5fc011d52f061b"	# Expected plaintext


Thank you
-- 
Ciao
Stephan
