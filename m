From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Problem with key sizes
Date: Fri, 16 Mar 2007 16:23:47 +0100
Message-ID: <20070316152347.GE13744@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40798 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbXCPPz7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Mar 2007 11:55:59 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HSEHT-0002hb-4O
	for linux-crypto@vger.kernel.org; Fri, 16 Mar 2007 16:23:47 +0100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

I have a little problem with the min|max keysize: /proc/crypto:

name         : aes
driver       : aes-special
module       : aes2
priority     : 150
refcnt       : 1
type         : cipher
blocksize    : 16
min keysize  : 24
max keysize  : 32

name         : aes
driver       : aes-generic
module       : aes
priority     : 100
refcnt       : 1
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

16bit key are not supported by the -special algo, only by the -generic
driver. My understanding of this was if someone needs 16bit keys
aes-generic id used and for 24 and 32 bit long keys the -special driver.
Unfortunately crypto_alloc_blkcipher() does not care about the min|max
keysize field.
I thing the main problem here is that the crypto api knows nothing about
the key size until crypto_blkcipher_setkey() what is probably too late.
Is it possible to modify the api to something like OpenSSL's
aes-128-cbc (or cbc(aes(128)) in our case :) ) ?

I have a question regarding the git tree: Which one is valid?
MAINTAINERS says .../git/herbert/crypto-2.6.git but once I clone it,
there is .git directory in it (with 151MB but no source code).
./git/herbert/cryptodev-2.6.git on the other has source inside.

-- 
Best regards
Sebastian Siewior
