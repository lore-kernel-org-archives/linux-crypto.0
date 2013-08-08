From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/3] crypto: dcp: rename 'compatible' property to 'fsl,dcp'
Date: Thu,  8 Aug 2013 15:30:29 +0200
Message-ID: <1375968629-10091-4-git-send-email-LW@KARO-electronics.de>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Stephen Warren <swarren@wwwdotorg.org>,
 Rob Herring <rob.herring@calxeda.com>, linux-crypto@vger.kernel.org,
 Tobias Rauter <tobiasrauter@gmail.com>, linux-arm-kernel@lists.infradead.org,
 =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: devicetree@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
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

TGVhdmUgdGhlIG9sZCAnZnNsLWRjcCcgdmFsdWUgaW4gcGxhY2Ugd2l0aCBhbiBhcHByb3ByaWF0
ZSBjb21tZW50CnVudGlsIGV4dGVybmFsIHVzZXJzIGhhdmUgdXBkYXRlZCB0aGVpciBEVEJzLgoK
U2lnbmVkLW9mZi1ieTogTG90aGFyIFdhw59tYW5uIDxMV0BLQVJPLWVsZWN0cm9uaWNzLmRlPgot
LS0KIGFyY2gvYXJtL2Jvb3QvZHRzL2lteDI4LmR0c2kgfCAgICAyICstCiBkcml2ZXJzL2NyeXB0
by9kY3AuYyAgICAgICAgIHwgICAgMiArKwogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14Mjgu
ZHRzaSBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDI4LmR0c2kKaW5kZXggZWE5OWQwOS4uMDU4NDkz
NSAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14MjguZHRzaQorKysgYi9hcmNoL2Fy
bS9ib290L2R0cy9pbXgyOC5kdHNpCkBAIC03OTQsNyArNzk0LDcgQEAKIAkJCX07CiAKIAkJCWRj
cDogZGNwQDgwMDI4MDAwIHsKLQkJCQljb21wYXRpYmxlID0gImZzbC1kY3AiOworCQkJCWNvbXBh
dGlibGUgPSAiZnNsLGRjcCI7CiAJCQkJcmVnID0gPDB4ODAwMjgwMDAgMHgyMDAwPjsKIAkJCQlp
bnRlcnJ1cHRzID0gPDUyIDUzIDU0PjsKIAkJCQlzdGF0dXMgPSAiZGlzYWJsZWQiOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcnlwdG8vZGNwLmMgYi9kcml2ZXJzL2NyeXB0by9kY3AuYwppbmRleCA2
YTI0OTVlLi43MjE5NmMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NyeXB0by9kY3AuYworKysgYi9k
cml2ZXJzL2NyeXB0by9kY3AuYwpAQCAtODg5LDYgKzg4OSw4IEBAIHN0YXRpYyBpbnQgZGNwX3Jl
bW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogfQogCiBzdGF0aWMgc3RydWN0IG9m
X2RldmljZV9pZCBmc19kY3Bfb2ZfbWF0Y2hbXSA9IHsKKwl7IC5jb21wYXRpYmxlID0gImZzbCxk
Y3AiLCB9LAorCS8qIFRvIGJlIHJlbW92ZWQgd2hlbiB0aGUgRFQgYmxvYnMgcmVmZXJlbmNpbmcg
dGhpcyBoYXZlIGJlZW4gdXBkYXRlZCAqLwogCXsgLmNvbXBhdGlibGUgPSAiZnNsLWRjcCIsIH0s
CiAJe30KIH07Ci0tIAoxLjcuMi41CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QKbGludXgtYXJtLWtl
cm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
