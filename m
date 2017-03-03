From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC 5/7] crypto: caam - avoid double inclusion in desc_constr.h
Date: Fri, 3 Mar 2017 16:52:11 +0200
Message-ID: <1488552733-20806-6-git-send-email-horia.geanta@nxp.com>
References: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arm-kernel@lists.infradead.org,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>, Dan Douglass <dan.douglass@nxp.com>,
 linux-crypto@vger.kernel.org, Vakul Garg <vakul@nxp.com>,
 Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Scott Wood <oss@buserror.net>,
 Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
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

U2lnbmVkLW9mZi1ieTogSG9yaWEgR2VhbnTEgyA8aG9yaWEuZ2VhbnRhQG54cC5jb20+Ci0tLQog
ZHJpdmVycy9jcnlwdG8vY2FhbS9kZXNjX2NvbnN0ci5oIHwgNSArKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NhYW0vZGVz
Y19jb25zdHIuaCBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vZGVzY19jb25zdHIuaAppbmRleCBiOWM4
ZDk4ZWY4MjYuLmQ4ZTgzY2ExMDRlMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcnlwdG8vY2FhbS9k
ZXNjX2NvbnN0ci5oCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vZGVzY19jb25zdHIuaApAQCAt
NCw2ICs0LDkgQEAKICAqIENvcHlyaWdodCAyMDA4LTIwMTIgRnJlZXNjYWxlIFNlbWljb25kdWN0
b3IsIEluYy4KICAqLwogCisjaWZuZGVmIERFU0NfQ09OU1RSX0gKKyNkZWZpbmUgREVTQ19DT05T
VFJfSAorCiAjaW5jbHVkZSAiZGVzYy5oIgogI2luY2x1ZGUgInJlZ3MuaCIKIApAQCAtNDkxLDMg
KzQ5NCw1IEBAIHN0YXRpYyBpbmxpbmUgaW50IGRlc2NfaW5saW5lX3F1ZXJ5KHVuc2lnbmVkIGlu
dCBzZF9iYXNlX2xlbiwKIAogCXJldHVybiAocmVtX2J5dGVzID49IDApID8gMCA6IC0xOwogfQor
CisjZW5kaWYgLyogREVTQ19DT05TVFJfSCAqLwotLSAKMi40LjQKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcg
bGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmlu
ZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
