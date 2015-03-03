From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 01/17] crypto: talitos - Use zero entry to init descriptors
 ptrs to zero
Date: Tue, 3 Mar 2015 02:46:35 +0100
Message-ID: <20150417142354.5AE601A242C@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, David S Miller <davem@davemloft.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

RG8gdXNlIHplcm9fZW50cnkgdmFsdWUgdG8gaW5pdCB0aGUgZGVzY3JpcHRvcnMgcHRycyB0byB6
ZXJvIGluc3RlYWQgb2YKd3JpdGluZyAwIGluIGVhY2ggZmllbGQKClNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lAYy1zLmZyPgotLS0KIGRyaXZlcnMvY3J5
cHRvL3RhbGl0b3MuYyB8IDggKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vdGFsaXRvcy5j
IGIvZHJpdmVycy9jcnlwdG8vdGFsaXRvcy5jCmluZGV4IDg1NzQxNGEuLjdiZjFiMmIgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvY3J5cHRvL3RhbGl0b3MuYworKysgYi9kcml2ZXJzL2NyeXB0by90YWxp
dG9zLmMKQEAgLTEzNzMsOSArMTM3Myw3IEBAIHN0YXRpYyBpbnQgY29tbW9uX25vbnNub29wKHN0
cnVjdCB0YWxpdG9zX2VkZXNjICplZGVzYywKIAlpbnQgc2dfY291bnQsIHJldDsKIAogCS8qIGZp
cnN0IERXT1JEIGVtcHR5ICovCi0JZGVzYy0+cHRyWzBdLmxlbiA9IDA7Ci0JdG9fdGFsaXRvc19w
dHIoJmRlc2MtPnB0clswXSwgMCk7Ci0JZGVzYy0+cHRyWzBdLmpfZXh0ZW50ID0gMDsKKwlkZXNj
LT5wdHJbMF0gPSB6ZXJvX2VudHJ5OwogCiAJLyogY2lwaGVyIGl2ICovCiAJdG9fdGFsaXRvc19w
dHIoJmRlc2MtPnB0clsxXSwgZWRlc2MtPml2X2RtYSk7CkBAIC0xNDQ1LDkgKzE0NDMsNyBAQCBz
dGF0aWMgaW50IGNvbW1vbl9ub25zbm9vcChzdHJ1Y3QgdGFsaXRvc19lZGVzYyAqZWRlc2MsCiAJ
CQkgICAgICAgRE1BX0ZST01fREVWSUNFKTsKIAogCS8qIGxhc3QgRFdPUkQgZW1wdHkgKi8KLQlk
ZXNjLT5wdHJbNl0ubGVuID0gMDsKLQl0b190YWxpdG9zX3B0cigmZGVzYy0+cHRyWzZdLCAwKTsK
LQlkZXNjLT5wdHJbNl0ual9leHRlbnQgPSAwOworCWRlc2MtPnB0cls2XSA9IHplcm9fZW50cnk7
CiAKIAlyZXQgPSB0YWxpdG9zX3N1Ym1pdChkZXYsIGN0eC0+Y2gsIGRlc2MsIGNhbGxiYWNrLCBh
cmVxKTsKIAlpZiAocmV0ICE9IC1FSU5QUk9HUkVTUykgewotLSAKMi4xLjAKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4cHBjLWRldiBtYWlsaW5n
IGxpc3QKTGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9saXN0cy5vemxhYnMu
b3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRldg==
