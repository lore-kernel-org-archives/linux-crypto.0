From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/3] ARM: dts: mxs: set dcp to "disabled" by default
Date: Thu,  8 Aug 2013 15:30:27 +0200
Message-ID: <1375968629-10091-2-git-send-email-LW@KARO-electronics.de>
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

UmVpbnRyb2R1Y2UgJ3N0YXR1cyA9ICJkaXNhYmxlZCInIGZvciB0aGUgZGNwIG5vZGUgdGhhdCB3
YXMgZHJvcHBlZCBieQpjb21taXQgNTE5ZDhiMWEgIkFkZGVkIHN1cHBvcnQgZm9yIEZyZWVzY2Fs
ZSdzIERDUCBjby1wcm9jZXNzb3IiLgoKRXhwbGljaXRseSBlbmFibGUgaXQgaW4gaW14MjgtZXZr
IHdoaWNoIGlzIHJlZmVyZW5jZWQgaW4gdGhlIGNvbW1pdAptZXNzYWdlIG9mIHRoYXQgY29tbWl0
LgoKU2lnbmVkLW9mZi1ieTogTG90aGFyIFdhw59tYW5uIDxMV0BLQVJPLWVsZWN0cm9uaWNzLmRl
PgotLS0KIGFyY2gvYXJtL2Jvb3QvZHRzL2lteDI4LWV2ay5kdHMgfCAgICA0ICsrKysKIGFyY2gv
YXJtL2Jvb3QvZHRzL2lteDI4LmR0c2kgICAgfCAgICAzICsrLQogMiBmaWxlcyBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vYm9v
dC9kdHMvaW14MjgtZXZrLmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDI4LWV2ay5kdHMKaW5k
ZXggZGZmMjI3OS4uYWM3OTBiYiAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14Mjgt
ZXZrLmR0cworKysgYi9hcmNoL2FybS9ib290L2R0cy9pbXgyOC1ldmsuZHRzCkBAIC0zNjEsMyAr
MzYxLDcgQEAKIAkJZGVmYXVsdC1icmlnaHRuZXNzLWxldmVsID0gPDY+OwogCX07CiB9OworCism
ZGNwIHsKKwlzdGF0dXMgPSAib2theSI7Cit9OwpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vYm9vdC9k
dHMvaW14MjguZHRzaSBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDI4LmR0c2kKaW5kZXggZTQ1OWQ2
My4uZWE5OWQwOSAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14MjguZHRzaQorKysg
Yi9hcmNoL2FybS9ib290L2R0cy9pbXgyOC5kdHNpCkBAIC03OTQsOSArNzk0LDEwIEBACiAJCQl9
OwogCiAJCQlkY3A6IGRjcEA4MDAyODAwMCB7CisJCQkJY29tcGF0aWJsZSA9ICJmc2wtZGNwIjsK
IAkJCQlyZWcgPSA8MHg4MDAyODAwMCAweDIwMDA+OwogCQkJCWludGVycnVwdHMgPSA8NTIgNTMg
NTQ+OwotCQkJCWNvbXBhdGlibGUgPSAiZnNsLWRjcCI7CisJCQkJc3RhdHVzID0gImRpc2FibGVk
IjsKIAkJCX07CiAKIAkJCXB4cDogcHhwQDgwMDJhMDAwIHsKLS0gCjEuNy4yLjUKCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVs
IG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDov
L2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
