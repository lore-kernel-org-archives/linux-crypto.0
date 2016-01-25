From: Stephan Mueller <smueller@chronox.de>
Subject: GCM: cra_name == cra_driver_name
Date: Mon, 25 Jan 2016 22:48:38 +0100
Message-ID: <4642565.JLlnFcM15x@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42506 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbcAYVsm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 16:48:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

with the current cryptodev tree, when I call a compound AEAD cipher with 
cra_driver_name for the first time, this cra_driver_name gets registered also 
as cra_name. Note, using other compound ciphers (like HMAC or symmetric 
ciphers), I do not see that error.

With that registering, I am not able to resolve the cipher with usual common 
cra_name.

Note, when I initialized an AEAD cipher with a cra_name, then all works as it 
used to be.

For example:

name         : seqiv(rfc4106(gcm_base(ctr(aes-generic),ghash-generic)))
driver       : seqiv(rfc4106(gcm_base(ctr(aes-generic),ghash-generic)))
module       : seqiv
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>

name         : rfc4106(gcm_base(ctr(aes-generic),ghash-generic))
driver       : rfc4106(gcm_base(ctr(aes-generic),ghash-generic))
module       : gcm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>

name         : ccm_base(ctr(aes-generic),aes-generic)
driver       : ccm_base(ctr(aes-generic),aes-generic)
module       : ccm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 16
maxauthsize  : 16
geniv        : <none>

name         : gcm_base(ctr(aes-generic),ghash-generic)
driver       : gcm_base(ctr(aes-generic),ghash-generic)
module       : gcm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 12
maxauthsize  : 16
geniv        : <none>

name         : seqiv(rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni)))
driver       : seqiv(rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni)))
module       : seqiv
priority     : 350
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>

name         : rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni))
driver       : rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni))
module       : gcm
priority     : 350
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>

name         : gcm_base(ctr(aes-aesni),ghash-clmulni)
driver       : gcm_base(ctr(aes-aesni),ghash-clmulni)
module       : gcm
priority     : 350
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 12
maxauthsize  : 16
geniv        : <none>

name         : ccm_base(ctr-aes-aesni,aes-aesni)
driver       : ccm_base(ctr-aes-aesni,aes-aesni)
module       : ccm
priority     : 350
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 16
maxauthsize  : 16
geniv        : <none>

name         : gcm_base(ctr-aes-aesni,ghash-clmulni)
driver       : gcm_base(ctr-aes-aesni,ghash-clmulni)
module       : gcm
priority     : 400
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 1
ivsize       : 12
maxauthsize  : 16
geniv        : <none>





Ciao
Stephan
