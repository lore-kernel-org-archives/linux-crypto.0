From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/3] crypto: dcp - cleanup: commas at end of struct
 initializers where appropriate
Date: Thu,  8 Aug 2013 15:30:28 +0200
Message-ID: <1375968629-10091-3-git-send-email-LW@KARO-electronics.de>
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

ClNpZ25lZC1vZmYtYnk6IExvdGhhciBXYcOfbWFubiA8TFdAS0FSTy1lbGVjdHJvbmljcy5kZT4K
LS0tCiBkcml2ZXJzL2NyeXB0by9kY3AuYyB8ICAgMTEgKysrKystLS0tLS0KIDEgZmlsZXMgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY3J5cHRvL2RjcC5jIGIvZHJpdmVycy9jcnlwdG8vZGNwLmMKaW5kZXggYThhN2RkNC4uNmEy
NDk1ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcnlwdG8vZGNwLmMKKysrIGIvZHJpdmVycy9jcnlw
dG8vZGNwLmMKQEAgLTY1MSw4ICs2NTEsNyBAQCBzdGF0aWMgc3RydWN0IGNyeXB0b19hbGcgYWxn
c1tdID0gewogCQkJLmVuY3J5cHQgPSBkY3BfYWVzX2NiY19lbmNyeXB0LAogCQkJLmRlY3J5cHQg
PSBkY3BfYWVzX2NiY19kZWNyeXB0LAogCQkJLml2c2l6ZSA9IEFFU19LRVlTSVpFXzEyOCwKLQkJ
fQotCisJCX0sCiAJfSwKIH07CiAKQEAgLTg5MCw4ICs4ODksOCBAQCBzdGF0aWMgaW50IGRjcF9y
ZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIH0KIAogc3RhdGljIHN0cnVjdCBv
Zl9kZXZpY2VfaWQgZnNfZGNwX29mX21hdGNoW10gPSB7Ci0JewkuY29tcGF0aWJsZSA9ICJmc2wt
ZGNwIn0sCi0Je30sCisJeyAuY29tcGF0aWJsZSA9ICJmc2wtZGNwIiwgfSwKKwl7fQogfTsKIAog
c3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgZnNfZGNwX2RyaXZlciA9IHsKQEAgLTkwMCw4
ICs4OTksOCBAQCBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZlciBmc19kY3BfZHJpdmVyID0g
ewogCS5kcml2ZXIgPSB7CiAJCS5uYW1lID0gImZzbC1kY3AiLAogCQkub3duZXIgPSBUSElTX01P
RFVMRSwKLQkJLm9mX21hdGNoX3RhYmxlID0gZnNfZGNwX29mX21hdGNoCi0JfQorCQkub2ZfbWF0
Y2hfdGFibGUgPSBmc19kY3Bfb2ZfbWF0Y2gsCisJfSwKIH07CiAKIG1vZHVsZV9wbGF0Zm9ybV9k
cml2ZXIoZnNfZGNwX2RyaXZlcik7Ci0tIAoxLjcuMi41CgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QK
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRl
YWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
