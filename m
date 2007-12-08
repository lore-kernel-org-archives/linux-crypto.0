From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 1/2]: salsa20_i586: Corrected order of source and destination buffers.
Date: Sat, 8 Dec 2007 23:31:30 +0800
Message-ID: <fd3e431c0712080731w4ead1910gf16a256bc7e58ea9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3324_13323929.1197127890172"
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:30405 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbXLHPbc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Dec 2007 10:31:32 -0500
Received: by wr-out-0506.google.com with SMTP id c49so854733wra
        for <linux-crypto@vger.kernel.org>; Sat, 08 Dec 2007 07:31:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

------=_Part_3324_13323929.1197127890172
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The current salsa20_32.c called the salsa20_encrypt_bytes() function
with the source and destination buffers in the wrong order. This patch
corrects it.

Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>


Some thoughts:
I detected this when testing against the large test vector. For small
test vectors, the blkcipher_walk code uses source and destination
buffers that are equal. Only near the page boundary, does
blkcipher_walk uses different buffers. (At least this is true on my
system from what I've observed.) Since many of the tcrypt test vectors
are small, therefore src == dst frequently when blkcipher_walk-ing. It
seems to imply that most of the *_segment() code in the block cipher
modes are seldom tested. Perhaps this is something that a new tcrypt
framework should address.

------=_Part_3324_13323929.1197127890172
Content-Type: text/plain; name=patch1-salsa20_i586_src_dst.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9yah9520
Content-Disposition: attachment; filename=patch1-salsa20_i586_src_dst.txt

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2NyeXB0by9zYWxzYTIwXzMyLmMgYi9hcmNoL3g4Ni9jcnlw
dG8vc2Fsc2EyMF8zMi5jCmluZGV4IDE0ZGQ2OWQuLjExNDhhMTcgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2NyeXB0by9zYWxzYTIwXzMyLmMKKysrIGIvYXJjaC94ODYvY3J5cHRvL3NhbHNhMjBfMzIu
YwpAQCAtNjUsMjEgKzY1LDIxIEBAIHN0YXRpYyBpbnQgZW5jcnlwdChzdHJ1Y3QgYmxrY2lwaGVy
X2Rlc2MgKmRlc2MsCiAKIAlpZiAobGlrZWx5KHdhbGsubmJ5dGVzID09IG5ieXRlcykpCiAJewot
CQlzYWxzYTIwX2VuY3J5cHRfYnl0ZXMoY3R4LCB3YWxrLmRzdC52aXJ0LmFkZHIsCi0JCQkJICAg
ICAgd2Fsay5zcmMudmlydC5hZGRyLCBuYnl0ZXMpOworCQlzYWxzYTIwX2VuY3J5cHRfYnl0ZXMo
Y3R4LCB3YWxrLnNyYy52aXJ0LmFkZHIsCisJCQkJICAgICAgd2Fsay5kc3QudmlydC5hZGRyLCBu
Ynl0ZXMpOwogCQlyZXR1cm4gYmxrY2lwaGVyX3dhbGtfZG9uZShkZXNjLCAmd2FsaywgMCk7CiAJ
fQogCiAJd2hpbGUgKHdhbGsubmJ5dGVzID49IDY0KSB7Ci0JCXNhbHNhMjBfZW5jcnlwdF9ieXRl
cyhjdHgsIHdhbGsuZHN0LnZpcnQuYWRkciwKLQkJCQkgICAgICB3YWxrLnNyYy52aXJ0LmFkZHIs
CisJCXNhbHNhMjBfZW5jcnlwdF9ieXRlcyhjdHgsIHdhbGsuc3JjLnZpcnQuYWRkciwKKwkJCQkg
ICAgICB3YWxrLmRzdC52aXJ0LmFkZHIsCiAJCQkJICAgICAgd2Fsay5uYnl0ZXMgLSAod2Fsay5u
Ynl0ZXMgJSA2NCkpOwogCQllcnIgPSBibGtjaXBoZXJfd2Fsa19kb25lKGRlc2MsICZ3YWxrLCB3
YWxrLm5ieXRlcyAlIDY0KTsKIAl9CiAKIAlpZiAod2Fsay5uYnl0ZXMpIHsKLQkJc2Fsc2EyMF9l
bmNyeXB0X2J5dGVzKGN0eCwgd2Fsay5kc3QudmlydC5hZGRyLAotCQkJCSAgICAgIHdhbGsuc3Jj
LnZpcnQuYWRkciwgd2Fsay5uYnl0ZXMpOworCQlzYWxzYTIwX2VuY3J5cHRfYnl0ZXMoY3R4LCB3
YWxrLnNyYy52aXJ0LmFkZHIsCisJCQkJICAgICAgd2Fsay5kc3QudmlydC5hZGRyLCB3YWxrLm5i
eXRlcyk7CiAJCWVyciA9IGJsa2NpcGhlcl93YWxrX2RvbmUoZGVzYywgJndhbGssIDApOwogCX0K
IAo=
------=_Part_3324_13323929.1197127890172--
