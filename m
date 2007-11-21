From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 3/3] dm-crypt: Add support for stream ciphers using blkcipher interface
Date: Thu, 22 Nov 2007 05:38:12 +0800
Message-ID: <fd3e431c0711211338r5b7f04e5s4466e193b3f3743f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3109_31788005.1195681092745"
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>
To: "Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:24945 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989AbXKUViN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 16:38:13 -0500
Received: by rn-out-0102.google.com with SMTP id s46so3778915rnb
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 13:38:12 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

------=_Part_3109_31788005.1195681092745
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Current implementation of dm-crypt supports block ciphers of the form
"template(cipher)", e.g. "cbc(aes)". It does not support stream
ciphers of the form "cipher", e.g. "salsa20", that uses the blkcipher
interface directly.

This patch adds support for stream ciphers using the blkcipher
interface directly. It uses a special chainmode called "stream".
Example of usage:
    cryptsetup luksFormat -c salsa20-stream-plain /dev/loop0

Due to the way ESSIV uses the cipher interface directly, it is not
possible to use something like "salsa20-stream-essiv:md5". However
this is probably not an issue since ESSIV was created to prevent
watermarking attacks and for stream ciphers it is always possible,
i.e. flip the bits in the plaintext and the ciphertext will flip
accordingly. In other words, plain IV generation should be sufficient.

WARNING: Using stream ciphers with dm-crypt must be exercised with
care. If used on a read-write filesystem, it is trivial to extract the
keystream by over-writing files with 0x00s and thus recovering the
original plaintext of the overwritten files. Stream ciphers are
probably more useful for encrypting large amount of data on read-only
filesystem (e.g. media files on DVD-ROMs).

Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

------=_Part_3109_31788005.1195681092745
Content-Type: text/plain; name=patch3-dm_crypt.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9acyrwy0
Content-Disposition: attachment; filename=patch3-dm_crypt.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQu
YwppbmRleCAyOGM2YWUwLi43ZTA3YjcxIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLWNyeXB0
LmMKKysrIGIvZHJpdmVycy9tZC9kbS1jcnlwdC5jCkBAIC03ODIsMTAgKzc4MiwxOSBAQCBzdGF0
aWMgaW50IGNyeXB0X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2Ms
IGNoYXIgKiphcmd2KQogCQlnb3RvIGJhZF9jaXBoZXI7CiAJfQogCi0JaWYgKHNucHJpbnRmKGNj
LT5jaXBoZXIsIENSWVBUT19NQVhfQUxHX05BTUUsICIlcyglcykiLAotCQkgICAgIGNoYWlubW9k
ZSwgY2lwaGVyKSA+PSBDUllQVE9fTUFYX0FMR19OQU1FKSB7Ci0JCXRpLT5lcnJvciA9ICJDaGFp
biBtb2RlICsgY2lwaGVyIG5hbWUgaXMgdG9vIGxvbmciOwotCQlnb3RvIGJhZF9jaXBoZXI7CisJ
aWYgKHN0cmNtcChjaGFpbm1vZGUsICJzdHJlYW0iKSAhPSAwKSB7CisJCWlmIChzbnByaW50Zihj
Yy0+Y2lwaGVyLCBDUllQVE9fTUFYX0FMR19OQU1FLCAiJXMoJXMpIiwKKwkJCSAgICAgY2hhaW5t
b2RlLCBjaXBoZXIpID49IENSWVBUT19NQVhfQUxHX05BTUUpIHsKKwkJCXRpLT5lcnJvciA9ICJD
aGFpbiBtb2RlICsgY2lwaGVyIG5hbWUgaXMgdG9vIGxvbmciOworCQkJZ290byBiYWRfY2lwaGVy
OworCQl9CisJfSBlbHNlIHsKKwkJaWYgKHNucHJpbnRmKGNjLT5jaXBoZXIsIENSWVBUT19NQVhf
QUxHX05BTUUsICIlcyIsCisJCQkgICAgIGNpcGhlcikgPj0gQ1JZUFRPX01BWF9BTEdfTkFNRSkg
eworCQkJdGktPmVycm9yID0gIlN0cmVhbSBjaXBoZXIgbmFtZSBpcyB0b28gbG9uZyI7CisJCQln
b3RvIGJhZF9jaXBoZXI7CisJCX0KKwkJCiAJfQogCiAJdGZtID0gY3J5cHRvX2FsbG9jX2Jsa2Np
cGhlcihjYy0+Y2lwaGVyLCAwLCBDUllQVE9fQUxHX0FTWU5DKTsK
------=_Part_3109_31788005.1195681092745--
