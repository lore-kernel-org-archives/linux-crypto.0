From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 4/6] staging: ccree: Fix alignment issues in ssi_cipher.c
Date: Tue, 18 Jul 2017 22:03:55 +0200
Message-ID: <20170718200357.32646-5-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Rml4ZXMgY2hlY2twYXRjaC5wbCBhbGlnbm1lbnQgd2FybmluZ3MuCgpTaWduZWQtb2ZmLWJ5OiBT
aW1vbiBTYW5kc3Ryw7ZtIDxzaW1vbkBuaWthbm9yLm51PgotLS0KIGRyaXZlcnMvc3RhZ2luZy9j
Y3JlZS9zc2lfY2lwaGVyLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9jY3JlZS9zc2lf
Y2lwaGVyLmMgYi9kcml2ZXJzL3N0YWdpbmcvY2NyZWUvc3NpX2NpcGhlci5jCmluZGV4IGJmZTli
MWNjYmYzNy4uYWVjN2MxNDgwMzM2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvY2NyZWUv
c3NpX2NpcGhlci5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9jY3JlZS9zc2lfY2lwaGVyLmMKQEAg
LTIwMyw3ICsyMDMsOCBAQCBzdGF0aWMgaW50IHNzaV9ibGtjaXBoZXJfaW5pdChzdHJ1Y3QgY3J5
cHRvX3RmbSAqdGZtKQogCiAJLyogTWFwIGtleSBidWZmZXIgKi8KIAljdHhfcC0+dXNlci5rZXlf
ZG1hX2FkZHIgPSBkbWFfbWFwX3NpbmdsZShkZXYsICh2b2lkICopY3R4X3AtPnVzZXIua2V5LAot
CQkJCQkgICAgIG1heF9rZXlfYnVmX3NpemUsIERNQV9UT19ERVZJQ0UpOworCQkJCQkJICBtYXhf
a2V5X2J1Zl9zaXplLAorCQkJCQkJICBETUFfVE9fREVWSUNFKTsKIAlpZiAoZG1hX21hcHBpbmdf
ZXJyb3IoZGV2LCBjdHhfcC0+dXNlci5rZXlfZG1hX2FkZHIpKSB7CiAJCVNTSV9MT0dfRVJSKCJN
YXBwaW5nIEtleSAldSBCIGF0IHZhPSVwSyBmb3IgRE1BIGZhaWxlZFxuIiwKIAkJCSAgICBtYXhf
a2V5X2J1Zl9zaXplLCBjdHhfcC0+dXNlci5rZXkpOwotLSAKMi4xMS4wCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkZXZlbCBtYWlsaW5nIGxpc3QKZGV2
ZWxAbGludXhkcml2ZXJwcm9qZWN0Lm9yZwpodHRwOi8vZHJpdmVyZGV2LmxpbnV4ZHJpdmVycHJv
amVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcml2ZXJkZXYtZGV2ZWwK
