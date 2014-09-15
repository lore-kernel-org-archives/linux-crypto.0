From: behanw@converseincode.com
Subject: [PATCH v3 02/12] btrfs: LLVMLinux: Remove VLAIS
Date: Mon, 15 Sep 2014 00:30:24 -0700
Message-ID: <1410766234-1634-3-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
        qat-linux@intel.com, d.kasatkin@samsung.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        torvalds@linux-foundation.org, linux-ima-devel@lists.sourceforge.net,
        Behan Webster <behanw@converseincode.com>, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        serge@hallyn.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com,
        snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
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

RnJvbTogVmluw61jaXVzIFRpbnRpIDx2aW5pY2l1c3RpbnRpQGdtYWlsLmNvbT4KClJlcGxhY2Vk
IHRoZSB1c2Ugb2YgYSBWYXJpYWJsZSBMZW5ndGggQXJyYXkgSW4gU3RydWN0IChWTEFJUykgd2l0
aCBhIEM5OQpjb21wbGlhbnQgZXF1aXZhbGVudC4gVGhpcyBpcyB0aGUgb3JpZ2luYWwgVkxBSVMg
c3RydWN0LgoKc3RydWN0IHsKCXN0cnVjdCBzaGFzaF9kZXNjIHNoYXNoOwoJY2hhciBjdHhbY3J5
cHRvX3NoYXNoX2Rlc2NzaXplKHRmbSldOwp9IGRlc2M7CgpUaGlzIHBhdGNoIGluc3RlYWQgYWxs
b2NhdGVzIHRoZSBhcHByb3ByaWF0ZSBhbW91bnQgb2YgbWVtb3J5IHVzaW5nIGEKY2hhciBhcnJh
eSB1c2luZyB0aGUgU0hBU0hfREVTQ19PTl9TVEFDSyBtYWNyby4KClRoZSBuZXcgY29kZSBjYW4g
YmUgY29tcGlsZWQgd2l0aCBib3RoIGdjYyBhbmQgY2xhbmcuCgpTaWduZWQtb2ZmLWJ5OiBWaW7D
rWNpdXMgVGludGkgPHZpbmljaXVzdGludGlAZ21haWwuY29tPgpSZXZpZXdlZC1ieTogSmFuLVNp
bW9uIE3DtmxsZXIgPGRsOXBmQGdteC5kZT4KUmV2aWV3ZWQtYnk6IE1hcmsgQ2hhcmxlYm9pcyA8
Y2hhcmxlYm1AZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBCZWhhbiBXZWJzdGVyIDxiZWhhbndA
Y29udmVyc2VpbmNvZGUuY29tPgpDYzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+CkNjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+Ci0tLQog
ZnMvYnRyZnMvaGFzaC5jIHwgMTYgKysrKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDcg
aW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9idHJmcy9oYXNo
LmMgYi9mcy9idHJmcy9oYXNoLmMKaW5kZXggODU4ODlhYS4uNGJmNGQzYSAxMDA2NDQKLS0tIGEv
ZnMvYnRyZnMvaGFzaC5jCisrKyBiL2ZzL2J0cmZzL2hhc2guYwpAQCAtMzMsMTggKzMzLDE2IEBA
IHZvaWQgYnRyZnNfaGFzaF9leGl0KHZvaWQpCiAKIHUzMiBidHJmc19jcmMzMmModTMyIGNyYywg
Y29uc3Qgdm9pZCAqYWRkcmVzcywgdW5zaWduZWQgaW50IGxlbmd0aCkKIHsKLQlzdHJ1Y3Qgewot
CQlzdHJ1Y3Qgc2hhc2hfZGVzYyBzaGFzaDsKLQkJY2hhciBjdHhbY3J5cHRvX3NoYXNoX2Rlc2Nz
aXplKHRmbSldOwotCX0gZGVzYzsKKwlTSEFTSF9ERVNDX09OX1NUQUNLKHNoYXNoLCB0Zm0pOwor
CXUzMiAqY3R4ID0gKHUzMiAqKXNoYXNoX2Rlc2NfY3R4KHNoYXNoKTsKIAlpbnQgZXJyOwogCi0J
ZGVzYy5zaGFzaC50Zm0gPSB0Zm07Ci0JZGVzYy5zaGFzaC5mbGFncyA9IDA7Ci0JKih1MzIgKilk
ZXNjLmN0eCA9IGNyYzsKKwlzaGFzaC0+dGZtID0gdGZtOworCXNoYXNoLT5mbGFncyA9IDA7CisJ
KmN0eCA9IGNyYzsKIAotCWVyciA9IGNyeXB0b19zaGFzaF91cGRhdGUoJmRlc2Muc2hhc2gsIGFk
ZHJlc3MsIGxlbmd0aCk7CisJZXJyID0gY3J5cHRvX3NoYXNoX3VwZGF0ZShzaGFzaCwgYWRkcmVz
cywgbGVuZ3RoKTsKIAlCVUdfT04oZXJyKTsKIAotCXJldHVybiAqKHUzMiAqKWRlc2MuY3R4Owor
CXJldHVybiAqY3R4OwogfQotLSAKMS45LjEKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==
