From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 08/27] x86/CPU: Adapt assembly for PIE support
Date: Wed, 23 May 2018 12:54:02 -0700
Message-ID: <20180523195421.180248-9-thgarnie@google.com>
References: <20180523195421.180248-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-sparse@vger.kernel.org,
 linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com,
 xen-devel@lists.xenproject.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Garnier <thgarnie@google.com>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20180523195421.180248-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
List-Id: linux-crypto.vger.kernel.org

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSBvbmx5IHJlbGF0aXZlIHJlZmVyZW5jZXMg
b2Ygc3ltYm9scyBmb3IgdGhlCmtlcm5lbCB0byBiZSBQSUUgY29tcGF0aWJsZS4gVXNlIHRoZSBu
ZXcgX0FTTV9NT1ZBQlMgbWFjcm8gaW5zdGVhZCBvZgp0aGUgJ21vdiAkc3ltYm9sLCAlZHN0JyBj
b25zdHJ1Y3QuCgpQb3NpdGlvbiBJbmRlcGVuZGVudCBFeGVjdXRhYmxlIChQSUUpIHN1cHBvcnQg
d2lsbCBhbGxvdyB0byBleHRlbmRlZCB0aGUKS0FTTFIgcmFuZG9taXphdGlvbiByYW5nZSBiZWxv
dyB0aGUgLTJHIG1lbW9yeSBsaW1pdC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHYXJuaWVyIDx0
aGdhcm5pZUBnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5o
IHwgOSArKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmggYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wcm9jZXNzb3IuaAppbmRleCBjMTE5ZDQyM2VhY2IuLjgxYWU2
ODc3ZGYyOSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgKKysr
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgKQEAgLTUwLDcgKzUwLDcgQEAgc3Rh
dGljIGlubGluZSB2b2lkICpjdXJyZW50X3RleHRfYWRkcih2b2lkKQogewogCXZvaWQgKnBjOwog
Ci0JYXNtIHZvbGF0aWxlKCJtb3YgJDFmLCAlMDsgMToiOiI9ciIgKHBjKSk7CisJYXNtIHZvbGF0
aWxlKF9BU01fTU9WQUJTICIgJDFmLCAlMDsgMToiOiI9ciIgKHBjKSk7CiAKIAlyZXR1cm4gcGM7
CiB9CkBAIC03MTgsNiArNzE4LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHN5bmNfY29yZSh2b2lk
KQogCQk6IEFTTV9DQUxMX0NPTlNUUkFJTlQgOiA6ICJtZW1vcnkiKTsKICNlbHNlCiAJdW5zaWdu
ZWQgaW50IHRtcDsKKwl1bnNpZ25lZCBsb25nIHRtcDI7CiAKIAlhc20gdm9sYXRpbGUgKAogCQlV
TldJTkRfSElOVF9TQVZFCkBAIC03MjgsMTEgKzcyOSwxMyBAQCBzdGF0aWMgaW5saW5lIHZvaWQg
c3luY19jb3JlKHZvaWQpCiAJCSJwdXNoZnFcblx0IgogCQkibW92ICUlY3MsICUwXG5cdCIKIAkJ
InB1c2hxICVxMFxuXHQiCi0JCSJwdXNocSAkMWZcblx0IgorCQkibGVhcSAxZiglJXJpcCksICUx
XG5cdCIKKwkJInB1c2hxICUxXG5cdCIKIAkJImlyZXRxXG5cdCIKIAkJVU5XSU5EX0hJTlRfUkVT
VE9SRQogCQkiMToiCi0JCTogIj0mciIgKHRtcCksIEFTTV9DQUxMX0NPTlNUUkFJTlQgOiA6ICJj
YyIsICJtZW1vcnkiKTsKKwkJOiAiPSZyIiAodG1wKSwgIj0mciIgKHRtcDIpLCBBU01fQ0FMTF9D
T05TVFJBSU5UCisJCTogOiAiY2MiLCAibWVtb3J5Iik7CiAjZW5kaWYKIH0KIAotLSAKMi4xNy4w
LjQ0MS5nYjQ2ZmU2MGUxZC1nb29nCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVu
cHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZv
L3hlbi1kZXZlbA==
