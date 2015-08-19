From: Stephan Mueller <smueller@chronox.de>
Subject: cbc(aes-aesni) a givcipher?
Date: Wed, 19 Aug 2015 12:11:03 +0200
Message-ID: <3211314.vIIIpsQc2S@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48135 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbbHSKLH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 06:11:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

with the latest cryptodev-2.6 tree I find the following:

name         : cbc(aes)
driver       : cbc(aes-aesni)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : givcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : eseqiv

name         : cbc(aes)
driver       : cbc(aes-aesni)
module       : cbc
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>


Note the type of the ciphers. With this, an allocation of cbc(aes-aesni) does 
not work (ENOENT).

Any ideas?

-- 
Ciao
Stephan
