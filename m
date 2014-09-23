From: behanw@converseincode.com
Subject: [PATCH v4 09/12] crypto: LLVMLinux: Remove VLAIS usage
	from crypto/hmac.c
Date: Mon, 22 Sep 2014 21:42:14 -0700
Message-ID: <1411447337-22362-10-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: thomas.lendacky@amd.com,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        linux-ima-user@lists.sourceforge.net, qat-linux@intel.com,
        d.kasatkin@samsung.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        torvalds@linux-foundation.org, linux-ima-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, pageexec@freemail.hu,
        zohar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        serge@hallyn.com
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

RnJvbTogSmFuLVNpbW9uIE3DtmxsZXIgPGRsOXBmQGdteC5kZT4KClJlcGxhY2VkIHRoZSB1c2Ug
b2YgYSBWYXJpYWJsZSBMZW5ndGggQXJyYXkgSW4gU3RydWN0IChWTEFJUykgd2l0aCBhIEM5OQpj
b21wbGlhbnQgZXF1aXZhbGVudC4gVGhpcyBwYXRjaCBhbGxvY2F0ZXMgdGhlIGFwcHJvcHJpYXRl
IGFtb3VudCBvZiBtZW1vcnkKdXNpbmcgYSBjaGFyIGFycmF5IHVzaW5nIHRoZSBTSEFTSF9ERVND
X09OX1NUQUNLIG1hY3JvLgoKVGhlIG5ldyBjb2RlIGNhbiBiZSBjb21waWxlZCB3aXRoIGJvdGgg
Z2NjIGFuZCBjbGFuZy4KClNpZ25lZC1vZmYtYnk6IEphbi1TaW1vbiBNw7ZsbGVyIDxkbDlwZkBn
bXguZGU+ClNpZ25lZC1vZmYtYnk6IEJlaGFuIFdlYnN0ZXIgPGJlaGFud0Bjb252ZXJzZWluY29k
ZS5jb20+ClJldmlld2VkLWJ5OiBNYXJrIENoYXJsZWJvaXMgPGNoYXJsZWJtQGdtYWlsLmNvbT4K
QWNrZWQtYnk6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4KQ2M6IHBh
Z2VleGVjQGZyZWVtYWlsLmh1Ci0tLQogY3J5cHRvL2htYWMuYyB8IDI1ICsrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9jcnlwdG8vaG1hYy5jIGIvY3J5cHRvL2htYWMuYwppbmRleCA4
ZDk1NDRjLi5lMzkyMjE5IDEwMDY0NAotLS0gYS9jcnlwdG8vaG1hYy5jCisrKyBiL2NyeXB0by9o
bWFjLmMKQEAgLTUyLDIwICs1MiwxNyBAQCBzdGF0aWMgaW50IGhtYWNfc2V0a2V5KHN0cnVjdCBj
cnlwdG9fc2hhc2ggKnBhcmVudCwKIAlzdHJ1Y3QgaG1hY19jdHggKmN0eCA9IGFsaWduX3B0cihv
cGFkICsgc3MsCiAJCQkJCSBjcnlwdG9fdGZtX2N0eF9hbGlnbm1lbnQoKSk7CiAJc3RydWN0IGNy
eXB0b19zaGFzaCAqaGFzaCA9IGN0eC0+aGFzaDsKLQlzdHJ1Y3QgewotCQlzdHJ1Y3Qgc2hhc2hf
ZGVzYyBzaGFzaDsKLQkJY2hhciBjdHhbY3J5cHRvX3NoYXNoX2Rlc2NzaXplKGhhc2gpXTsKLQl9
IGRlc2M7CisJU0hBU0hfREVTQ19PTl9TVEFDSyhzaGFzaCwgaGFzaCk7CiAJdW5zaWduZWQgaW50
IGk7CiAKLQlkZXNjLnNoYXNoLnRmbSA9IGhhc2g7Ci0JZGVzYy5zaGFzaC5mbGFncyA9IGNyeXB0
b19zaGFzaF9nZXRfZmxhZ3MocGFyZW50KSAmCi0JCQkgICAgQ1JZUFRPX1RGTV9SRVFfTUFZX1NM
RUVQOworCXNoYXNoLT50Zm0gPSBoYXNoOworCXNoYXNoLT5mbGFncyA9IGNyeXB0b19zaGFzaF9n
ZXRfZmxhZ3MocGFyZW50KQorCQkmIENSWVBUT19URk1fUkVRX01BWV9TTEVFUDsKIAogCWlmIChr
ZXlsZW4gPiBicykgewogCQlpbnQgZXJyOwogCi0JCWVyciA9IGNyeXB0b19zaGFzaF9kaWdlc3Qo
JmRlc2Muc2hhc2gsIGlua2V5LCBrZXlsZW4sIGlwYWQpOworCQllcnIgPSBjcnlwdG9fc2hhc2hf
ZGlnZXN0KHNoYXNoLCBpbmtleSwga2V5bGVuLCBpcGFkKTsKIAkJaWYgKGVycikKIAkJCXJldHVy
biBlcnI7CiAKQEAgLTgxLDEyICs3OCwxMiBAQCBzdGF0aWMgaW50IGhtYWNfc2V0a2V5KHN0cnVj
dCBjcnlwdG9fc2hhc2ggKnBhcmVudCwKIAkJb3BhZFtpXSBePSAweDVjOwogCX0KIAotCXJldHVy
biBjcnlwdG9fc2hhc2hfaW5pdCgmZGVzYy5zaGFzaCkgPzoKLQkgICAgICAgY3J5cHRvX3NoYXNo
X3VwZGF0ZSgmZGVzYy5zaGFzaCwgaXBhZCwgYnMpID86Ci0JICAgICAgIGNyeXB0b19zaGFzaF9l
eHBvcnQoJmRlc2Muc2hhc2gsIGlwYWQpID86Ci0JICAgICAgIGNyeXB0b19zaGFzaF9pbml0KCZk
ZXNjLnNoYXNoKSA/OgotCSAgICAgICBjcnlwdG9fc2hhc2hfdXBkYXRlKCZkZXNjLnNoYXNoLCBv
cGFkLCBicykgPzoKLQkgICAgICAgY3J5cHRvX3NoYXNoX2V4cG9ydCgmZGVzYy5zaGFzaCwgb3Bh
ZCk7CisJcmV0dXJuIGNyeXB0b19zaGFzaF9pbml0KHNoYXNoKSA/OgorCSAgICAgICBjcnlwdG9f
c2hhc2hfdXBkYXRlKHNoYXNoLCBpcGFkLCBicykgPzoKKwkgICAgICAgY3J5cHRvX3NoYXNoX2V4
cG9ydChzaGFzaCwgaXBhZCkgPzoKKwkgICAgICAgY3J5cHRvX3NoYXNoX2luaXQoc2hhc2gpID86
CisJICAgICAgIGNyeXB0b19zaGFzaF91cGRhdGUoc2hhc2gsIG9wYWQsIGJzKSA/OgorCSAgICAg
ICBjcnlwdG9fc2hhc2hfZXhwb3J0KHNoYXNoLCBvcGFkKTsKIH0KIAogc3RhdGljIGludCBobWFj
X2V4cG9ydChzdHJ1Y3Qgc2hhc2hfZGVzYyAqcGRlc2MsIHZvaWQgKm91dCkKLS0gCjEuOS4xCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
