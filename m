From: Karl Hiramoto <karl@hiramoto.org>
Subject: authenc(hmac(sha1-generic),atmel-cbc-aes)  not using HW SHA
Date: Mon, 09 Dec 2013 17:49:02 +0100
Message-ID: <52A5F47E.8090005@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:33737 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794Ab3LIQyK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Dec 2013 11:54:10 -0500
Received: from homiemail-a85.g.dreamhost.com (caiajhbdcbhh.dreamhost.com [208.97.132.177])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 9F57ADC2B8
	for <linux-crypto@vger.kernel.org>; Mon,  9 Dec 2013 08:54:09 -0800 (PST)
Received: from homiemail-a85.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a85.g.dreamhost.com (Postfix) with ESMTP id 72C2FBC053
	for <linux-crypto@vger.kernel.org>; Mon,  9 Dec 2013 08:53:22 -0800 (PST)
Received: from [10.64.1.2] (216.Red-83-39-200.dynamicIP.rima-tde.net [83.39.200.216])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: karl@hiramoto.org)
	by homiemail-a85.g.dreamhost.com (Postfix) with ESMTPSA id 69397BC051
	for <linux-crypto@vger.kernel.org>; Mon,  9 Dec 2013 08:53:20 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm using the HW crypto drivers at drivers/crypto/atmel-{sha,aes}.c


When I startup a ipsec tunnel (strongswan)  /proc/crypto shows:
   "authenc(hmac(sha1-generic),atmel-cbc-aes)"

I can tell the SHA hardware is not being used now as "sha_transform" is  
at the top of the list with oprofile, and the HW interrupts on the SHA 
hardware are not incrementing.


I would want it to show that it's using HW acceleration eg:
   authenc(hmac(atmel-sha1),atmel-cbc-aes)



Can you please point me in the right direction of what's missing?

Do I just need to  create and register a function for the 
shash_alg.import()   and .export()?   Or is there a different/better way?


  cat /proc/crypto
name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-generic),atmel-cbc-aes)
module       : kernel
priority     : 1000
refcnt       : 3
selftest     : passed
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <built-in>

name         : hmac(sha1)
driver       : hmac(sha1-generic)
module       : kernel
priority     : 0
refcnt       : 5
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : cbc(aes)
driver       : atmel-cbc-aes
module       : kernel
priority     : 100
refcnt       : 3
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : eseqiv

name         : cbc(des3_ede)
driver       : atmel-cbc-tdes
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 24
ivsize       : 8
geniv        : eseqiv

name         : cbc(des)
driver       : atmel-cbc-des
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : eseqiv

name         : sha512
driver       : atmel-sha512
module       : atmel_sha
priority     : 100
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : atmel-sha384
module       : atmel_sha
priority     : 100
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 128
digestsize   : 48

name         : sha224
driver       : atmel-sha224
module       : atmel_sha
priority     : 100
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 28

name         : sha256
driver       : atmel-sha256
module       : atmel_sha
priority     : 100
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : sha1
driver       : atmel-sha1
module       : atmel_sha
priority     : 100
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : ofb(des3_ede)
driver       : atmel-ofb-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : cfb32(des3_ede)
driver       : atmel-cfb32-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 4
min keysize  : 16
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cfb16(des3_ede)
driver       : atmel-cfb16-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 2
min keysize  : 16
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cfb8(des3_ede)
driver       : atmel-cfb8-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 16
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cfb(des3_ede)
driver       : atmel-cfb-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cbc(des3_ede)
driver       : atmel-cbc-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : ecb(des3_ede)
driver       : atmel-ecb-tdes
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 24
ivsize       : 0
geniv        : <default>

name         : ofb(des)
driver       : atmel-ofb-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : cfb32(des)
driver       : atmel-cfb32-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 4
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : cfb16(des)
driver       : atmel-cfb16-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 2
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : cfb8(des)
driver       : atmel-cfb8-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : cfb(des)
driver       : atmel-cfb-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : cbc(des)
driver       : atmel-cbc-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : ecb(des)
driver       : atmel-ecb-des
module       : atmel_tdes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 0
geniv        : <default>

name         : cfb64(aes)
driver       : atmel-cfb64-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ctr(aes)
driver       : atmel-ctr-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cfb8(aes)
driver       : atmel-cfb8-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cfb16(aes)
driver       : atmel-cfb16-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 2
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cfb32(aes)
driver       : atmel-cfb32-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 4
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cfb(aes)
driver       : atmel-cfb-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ofb(aes)
driver       : atmel-ofb-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(aes)
driver       : atmel-cbc-aes
module       : atmel_aes
priority     : 100
refcnt       : 3
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : atmel-ecb-aes
module       : atmel_aes
priority     : 100
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 2
selftest     : passed
type         : compression

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 2
selftest     : passed
type         : compression

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 3
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16





Thanks,

Karl
