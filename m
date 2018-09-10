From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 04/11] soc: fsl: dpio: add congestion notification support
Date: Mon, 10 Sep 2018 20:15:43 +0300
Message-ID: <20180910171550.5659-5-horia.geanta@nxp.com>
References: <20180910171550.5659-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-kernel@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
 "David S . Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Stuart Yoder <stuyoder@gmail.com>,
 Laurentiu Tudor <laurentiu.tudor@nxp.com>, Li Yang <leoyang.li@nxp.com>,
 Roy Pledge <roy.pledge@nxp.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180910171550.5659-1-horia.geanta@nxp.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

QWRkIHN1cHBvcnQgZm9yIENvbmdlc3Rpb24gU3RhdGUgQ2hhbmdlIE5vdGlmaWNhdGlvbnMgKENT
Q04pLCB3aGljaAphbGxvdyBEUElPIHVzZXJzIHRvIGJlIG5vdGlmaWVkIHdoZW4gYSBjb25nZXN0
aW9uIGdyb3VwIGNoYW5nZXMgaXRzCnN0YXRlIChkdWUgdG8gaGl0dGluZyB0aGUgZW50cmFuY2Ug
LyBleGl0IHRocmVzaG9sZCkuCgpTaWduZWQtb2ZmLWJ5OiBIb3JpYSBHZWFudMSDIDxob3JpYS5n
ZWFudGFAbnhwLmNvbT4KLS0tCiBpbmNsdWRlL3NvYy9mc2wvZHBhYTItZ2xvYmFsLmggfCAxNSAr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9zb2MvZnNsL2RwYWEyLWdsb2JhbC5oIGIvaW5jbHVkZS9zb2MvZnNsL2Rw
YWEyLWdsb2JhbC5oCmluZGV4IDliYzA3MTMzNDZhOC4uMmJmYzM3OWQzZGM5IDEwMDY0NAotLS0g
YS9pbmNsdWRlL3NvYy9mc2wvZHBhYTItZ2xvYmFsLmgKKysrIGIvaW5jbHVkZS9zb2MvZnNsL2Rw
YWEyLWdsb2JhbC5oCkBAIC0xNzQsNCArMTc0LDE5IEBAIHN0YXRpYyBpbmxpbmUgY29uc3Qgc3Ry
dWN0IGRwYWEyX2ZkICpkcGFhMl9kcV9mZChjb25zdCBzdHJ1Y3QgZHBhYTJfZHEgKmRxKQogCXJl
dHVybiAoY29uc3Qgc3RydWN0IGRwYWEyX2ZkICopJmRxLT5kcS5mZFswXTsKIH0KIAorI2RlZmlu
ZSBEUEFBMl9DU0NOX1NJWkUJCXNpemVvZihzdHJ1Y3QgZHBhYTJfZHEpCisjZGVmaW5lIERQQUEy
X0NTQ05fQUxJR04JMTYKKyNkZWZpbmUgRFBBQTJfQ1NDTl9TVEFURV9DRwlCSVQoMCkKKworLyoq
CisgKiBkcGFhMl9jc2NuX3N0YXRlX2Nvbmdlc3RlZCgpIC0gQ2hlY2sgY29uZ2VzdGlvbiBzdGF0
ZQorICogQGNzY246IGNvbmdlc3Rpb24gU0NOIChkZWxpdmVyZWQgdG8gV1Egb3IgbWVtb3J5KQor
ICoKK2kgKiBSZXR1cm4gdHJ1ZSBpcyBjb25nZXN0ZWQuCisgKi8KK3N0YXRpYyBpbmxpbmUgYm9v
bCBkcGFhMl9jc2NuX3N0YXRlX2Nvbmdlc3RlZChzdHJ1Y3QgZHBhYTJfZHEgKmNzY24pCit7CisJ
cmV0dXJuICEhKGNzY24tPnNjbi5zdGF0ZSAmIERQQUEyX0NTQ05fU1RBVEVfQ0cpOworfQorCiAj
ZW5kaWYgLyogX19GU0xfRFBBQTJfR0xPQkFMX0ggKi8KLS0gCjIuMTYuMgoKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWFybS1rZXJuZWwgbWFp
bGluZyBsaXN0CmxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwpodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJuZWwK
