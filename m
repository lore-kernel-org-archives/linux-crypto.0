From: behanw@converseincode.com
Subject: [PATCH v4 05/12] crypto: LLVMLinux: Remove VLAIS from
	crypto/n2_core.c
Date: Mon, 22 Sep 2014 21:42:10 -0700
Message-ID: <1411447337-22362-6-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
        qat-linux@intel.com, d.kasatkin@samsung.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        torvalds@linux-foundation.org, linux-ima-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, serge@hallyn.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

RnJvbTogQmVoYW4gV2Vic3RlciA8YmVoYW53QGNvbnZlcnNlaW5jb2RlLmNvbT4KClJlcGxhY2Vk
IHRoZSB1c2Ugb2YgYSBWYXJpYWJsZSBMZW5ndGggQXJyYXkgSW4gU3RydWN0IChWTEFJUykgd2l0
aCBhIEM5OQpjb21wbGlhbnQgZXF1aXZhbGVudC4gVGhpcyBwYXRjaCBhbGxvY2F0ZXMgdGhlIGFw
cHJvcHJpYXRlIGFtb3VudCBvZiBtZW1vcnkKdXNpbmcgYSBjaGFyIGFycmF5IHVzaW5nIHRoZSBT
SEFTSF9ERVNDX09OX1NUQUNLIG1hY3JvLgoKVGhlIG5ldyBjb2RlIGNhbiBiZSBjb21waWxlZCB3
aXRoIGJvdGggZ2NjIGFuZCBjbGFuZy4KClNpZ25lZC1vZmYtYnk6IEJlaGFuIFdlYnN0ZXIgPGJl
aGFud0Bjb252ZXJzZWluY29kZS5jb20+ClJldmlld2VkLWJ5OiBNYXJrIENoYXJsZWJvaXMgPGNo
YXJsZWJtQGdtYWlsLmNvbT4KUmV2aWV3ZWQtYnk6IEphbi1TaW1vbiBNw7ZsbGVyIDxkbDlwZkBn
bXguZGU+CkFja2VkLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+
Ci0tLQogZHJpdmVycy9jcnlwdG8vbjJfY29yZS5jIHwgMTEgKysrKy0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jcnlwdG8vbjJfY29yZS5jIGIvZHJpdmVycy9jcnlwdG8vbjJfY29yZS5jCmluZGV4IDcy
NjNjMTAuLmY4ZTMyMDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3J5cHRvL24yX2NvcmUuYworKysg
Yi9kcml2ZXJzL2NyeXB0by9uMl9jb3JlLmMKQEAgLTQ0NSwxMCArNDQ1LDcgQEAgc3RhdGljIGlu
dCBuMl9obWFjX2FzeW5jX3NldGtleShzdHJ1Y3QgY3J5cHRvX2FoYXNoICp0Zm0sIGNvbnN0IHU4
ICprZXksCiAJc3RydWN0IG4yX2htYWNfY3R4ICpjdHggPSBjcnlwdG9fYWhhc2hfY3R4KHRmbSk7
CiAJc3RydWN0IGNyeXB0b19zaGFzaCAqY2hpbGRfc2hhc2ggPSBjdHgtPmNoaWxkX3NoYXNoOwog
CXN0cnVjdCBjcnlwdG9fYWhhc2ggKmZhbGxiYWNrX3RmbTsKLQlzdHJ1Y3QgewotCQlzdHJ1Y3Qg
c2hhc2hfZGVzYyBzaGFzaDsKLQkJY2hhciBjdHhbY3J5cHRvX3NoYXNoX2Rlc2NzaXplKGNoaWxk
X3NoYXNoKV07Ci0JfSBkZXNjOworCVNIQVNIX0RFU0NfT05fU1RBQ0soc2hhc2gsIGNoaWxkX3No
YXNoKTsKIAlpbnQgZXJyLCBicywgZHM7CiAKIAlmYWxsYmFja190Zm0gPSBjdHgtPmJhc2UuZmFs
bGJhY2tfdGZtOwpAQCAtNDU2LDE1ICs0NTMsMTUgQEAgc3RhdGljIGludCBuMl9obWFjX2FzeW5j
X3NldGtleShzdHJ1Y3QgY3J5cHRvX2FoYXNoICp0Zm0sIGNvbnN0IHU4ICprZXksCiAJaWYgKGVy
cikKIAkJcmV0dXJuIGVycjsKIAotCWRlc2Muc2hhc2gudGZtID0gY2hpbGRfc2hhc2g7Ci0JZGVz
Yy5zaGFzaC5mbGFncyA9IGNyeXB0b19haGFzaF9nZXRfZmxhZ3ModGZtKSAmCisJc2hhc2gtPnRm
bSA9IGNoaWxkX3NoYXNoOworCXNoYXNoLT5mbGFncyA9IGNyeXB0b19haGFzaF9nZXRfZmxhZ3Mo
dGZtKSAmCiAJCUNSWVBUT19URk1fUkVRX01BWV9TTEVFUDsKIAogCWJzID0gY3J5cHRvX3NoYXNo
X2Jsb2Nrc2l6ZShjaGlsZF9zaGFzaCk7CiAJZHMgPSBjcnlwdG9fc2hhc2hfZGlnZXN0c2l6ZShj
aGlsZF9zaGFzaCk7CiAJQlVHX09OKGRzID4gTjJfSEFTSF9LRVlfTUFYKTsKIAlpZiAoa2V5bGVu
ID4gYnMpIHsKLQkJZXJyID0gY3J5cHRvX3NoYXNoX2RpZ2VzdCgmZGVzYy5zaGFzaCwga2V5LCBr
ZXlsZW4sCisJCWVyciA9IGNyeXB0b19zaGFzaF9kaWdlc3Qoc2hhc2gsIGtleSwga2V5bGVuLAog
CQkJCQkgIGN0eC0+aGFzaF9rZXkpOwogCQlpZiAoZXJyKQogCQkJcmV0dXJuIGVycjsKLS0gCjEu
OS4xCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
