From: behanw@converseincode.com
Subject: [PATCH v3 03/12] crypto: LLVMLinux: Remove VLAIS from
	crypto/ccp/ccp-crypto-sha.c
Date: Mon, 15 Sep 2014 00:30:25 -0700
Message-ID: <1410766234-1634-4-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
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
        akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, serge@hallyn.com
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

RnJvbTogSmFuLVNpbW9uIE3DtmxsZXIgPGRsOXBmQGdteC5kZT4KClJlcGxhY2VkIHRoZSB1c2Ug
b2YgYSBWYXJpYWJsZSBMZW5ndGggQXJyYXkgSW4gU3RydWN0IChWTEFJUykgd2l0aCBhIEM5OQpj
b21wbGlhbnQgZXF1aXZhbGVudC4gVGhpcyBwYXRjaCBhbGxvY2F0ZXMgdGhlIGFwcHJvcHJpYXRl
IGFtb3VudCBvZiBtZW1vcnkKdXNpbmcgYSBjaGFyIGFycmF5IHVzaW5nIHRoZSBTSEFTSF9ERVND
X09OX1NUQUNLIG1hY3JvLgoKVGhlIG5ldyBjb2RlIGNhbiBiZSBjb21waWxlZCB3aXRoIGJvdGgg
Z2NjIGFuZCBjbGFuZy4KClNpZ25lZC1vZmYtYnk6IEphbi1TaW1vbiBNw7ZsbGVyIDxkbDlwZkBn
bXguZGU+ClNpZ25lZC1vZmYtYnk6IEJlaGFuIFdlYnN0ZXIgPGJlaGFud0Bjb252ZXJzZWluY29k
ZS5jb20+Ci0tLQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tc2hhLmMgfCAxMyArKysr
KystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLXNoYS5jIGIvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tc2hhLmMKaW5kZXggODczZjIzNC4uOTY1MzE1NyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tc2hhLmMKKysrIGIvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tc2hhLmMKQEAgLTE5OCwxMCArMTk4LDkgQEAgc3Rh
dGljIGludCBjY3Bfc2hhX3NldGtleShzdHJ1Y3QgY3J5cHRvX2FoYXNoICp0Zm0sIGNvbnN0IHU4
ICprZXksCiB7CiAJc3RydWN0IGNjcF9jdHggKmN0eCA9IGNyeXB0b190Zm1fY3R4KGNyeXB0b19h
aGFzaF90Zm0odGZtKSk7CiAJc3RydWN0IGNyeXB0b19zaGFzaCAqc2hhc2ggPSBjdHgtPnUuc2hh
LmhtYWNfdGZtOwotCXN0cnVjdCB7Ci0JCXN0cnVjdCBzaGFzaF9kZXNjIHNkZXNjOwotCQljaGFy
IGN0eFtjcnlwdG9fc2hhc2hfZGVzY3NpemUoc2hhc2gpXTsKLQl9IGRlc2M7CisKKwlTSEFTSF9E
RVNDX09OX1NUQUNLKHNkZXNjLCBzaGFzaCk7CisKIAl1bnNpZ25lZCBpbnQgYmxvY2tfc2l6ZSA9
IGNyeXB0b19zaGFzaF9ibG9ja3NpemUoc2hhc2gpOwogCXVuc2lnbmVkIGludCBkaWdlc3Rfc2l6
ZSA9IGNyeXB0b19zaGFzaF9kaWdlc3RzaXplKHNoYXNoKTsKIAlpbnQgaSwgcmV0OwpAQCAtMjE2
LDExICsyMTUsMTEgQEAgc3RhdGljIGludCBjY3Bfc2hhX3NldGtleShzdHJ1Y3QgY3J5cHRvX2Fo
YXNoICp0Zm0sIGNvbnN0IHU4ICprZXksCiAKIAlpZiAoa2V5X2xlbiA+IGJsb2NrX3NpemUpIHsK
IAkJLyogTXVzdCBoYXNoIHRoZSBpbnB1dCBrZXkgKi8KLQkJZGVzYy5zZGVzYy50Zm0gPSBzaGFz
aDsKLQkJZGVzYy5zZGVzYy5mbGFncyA9IGNyeXB0b19haGFzaF9nZXRfZmxhZ3ModGZtKSAmCisJ
CXNkZXNjLT50Zm0gPSBzaGFzaDsKKwkJc2Rlc2MtPmZsYWdzID0gY3J5cHRvX2FoYXNoX2dldF9m
bGFncyh0Zm0pICYKIAkJCUNSWVBUT19URk1fUkVRX01BWV9TTEVFUDsKIAotCQlyZXQgPSBjcnlw
dG9fc2hhc2hfZGlnZXN0KCZkZXNjLnNkZXNjLCBrZXksIGtleV9sZW4sCisJCXJldCA9IGNyeXB0
b19zaGFzaF9kaWdlc3Qoc2Rlc2MsIGtleSwga2V5X2xlbiwKIAkJCQkJICBjdHgtPnUuc2hhLmtl
eSk7CiAJCWlmIChyZXQpIHsKIAkJCWNyeXB0b19haGFzaF9zZXRfZmxhZ3ModGZtLCBDUllQVE9f
VEZNX1JFU19CQURfS0VZX0xFTik7Ci0tIAoxLjkuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs
