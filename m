From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v3 09/27] x86/acpi: Adapt assembly for PIE support
Date: Wed,  4 Oct 2017 14:19:45 -0700
Message-ID: <20171004212003.28296-10-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
 Matthias Kaehlcke <mka@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
 Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>,
 Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Bor
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

Q2hhbmdlIHRoZSBhc3NlbWJseSBjb2RlIHRvIHVzZSBvbmx5IHJlbGF0aXZlIHJlZmVyZW5jZXMg
b2Ygc3ltYm9scyBmb3IgdGhlCmtlcm5lbCB0byBiZSBQSUUgY29tcGF0aWJsZS4KClBvc2l0aW9u
IEluZGVwZW5kZW50IEV4ZWN1dGFibGUgKFBJRSkgc3VwcG9ydCB3aWxsIGFsbG93IHRvIGV4dGVu
ZGVkIHRoZQpLQVNMUiByYW5kb21pemF0aW9uIHJhbmdlIGJlbG93IHRoZSAtMkcgbWVtb3J5IGxp
bWl0LgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+
Ci0tLQogYXJjaC94ODYva2VybmVsL2FjcGkvd2FrZXVwXzY0LlMgfCAzMSArKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMTUg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2FjcGkvd2FrZXVwXzY0
LlMgYi9hcmNoL3g4Ni9rZXJuZWwvYWNwaS93YWtldXBfNjQuUwppbmRleCA1MGI4ZWQwMzE3YTMu
LjQ3MjY1OWMwZjgxMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2FjcGkvd2FrZXVwXzY0
LlMKKysrIGIvYXJjaC94ODYva2VybmVsL2FjcGkvd2FrZXVwXzY0LlMKQEAgLTE0LDcgKzE0LDcg
QEAKIAkgKiBIb29yYXksIHdlIGFyZSBpbiBMb25nIDY0LWJpdCBtb2RlIChidXQgc3RpbGwgcnVu
bmluZyBpbiBsb3cgbWVtb3J5KQogCSAqLwogRU5UUlkod2FrZXVwX2xvbmc2NCkKLQltb3ZxCXNh
dmVkX21hZ2ljLCAlcmF4CisJbW92cQlzYXZlZF9tYWdpYyglcmlwKSwgJXJheAogCW1vdnEJJDB4
MTIzNDU2Nzg5YWJjZGVmMCwgJXJkeAogCWNtcHEJJXJkeCwgJXJheAogCWpuZQlib2d1c182NF9t
YWdpYwpAQCAtMjUsMTQgKzI1LDE0IEBAIEVOVFJZKHdha2V1cF9sb25nNjQpCiAJbW92dwklYXgs
ICVlcwogCW1vdncJJWF4LCAlZnMKIAltb3Z3CSVheCwgJWdzCi0JbW92cQlzYXZlZF9yc3AsICVy
c3AKKwltb3ZxCXNhdmVkX3JzcCglcmlwKSwgJXJzcAogCi0JbW92cQlzYXZlZF9yYngsICVyYngK
LQltb3ZxCXNhdmVkX3JkaSwgJXJkaQotCW1vdnEJc2F2ZWRfcnNpLCAlcnNpCi0JbW92cQlzYXZl
ZF9yYnAsICVyYnAKKwltb3ZxCXNhdmVkX3JieCglcmlwKSwgJXJieAorCW1vdnEJc2F2ZWRfcmRp
KCVyaXApLCAlcmRpCisJbW92cQlzYXZlZF9yc2koJXJpcCksICVyc2kKKwltb3ZxCXNhdmVkX3Ji
cCglcmlwKSwgJXJicAogCi0JbW92cQlzYXZlZF9yaXAsICVyYXgKKwltb3ZxCXNhdmVkX3JpcCgl
cmlwKSwgJXJheAogCWptcAkqJXJheAogRU5EUFJPQyh3YWtldXBfbG9uZzY0KQogCkBAIC00NSw3
ICs0NSw3IEBAIEVOVFJZKGRvX3N1c3BlbmRfbG93bGV2ZWwpCiAJeG9ybAklZWF4LCAlZWF4CiAJ
Y2FsbAlzYXZlX3Byb2Nlc3Nvcl9zdGF0ZQogCi0JbW92cQkkc2F2ZWRfY29udGV4dCwgJXJheAor
CWxlYXEJc2F2ZWRfY29udGV4dCglcmlwKSwgJXJheAogCW1vdnEJJXJzcCwgcHRfcmVnc19zcCgl
cmF4KQogCW1vdnEJJXJicCwgcHRfcmVnc19icCglcmF4KQogCW1vdnEJJXJzaSwgcHRfcmVnc19z
aSglcmF4KQpAQCAtNjQsMTMgKzY0LDE0IEBAIEVOVFJZKGRvX3N1c3BlbmRfbG93bGV2ZWwpCiAJ
cHVzaGZxCiAJcG9wcQlwdF9yZWdzX2ZsYWdzKCVyYXgpCiAKLQltb3ZxCSQuTHJlc3VtZV9wb2lu
dCwgc2F2ZWRfcmlwKCVyaXApCisJbGVhcQkuTHJlc3VtZV9wb2ludCglcmlwKSwgJXJheAorCW1v
dnEJJXJheCwgc2F2ZWRfcmlwKCVyaXApCiAKLQltb3ZxCSVyc3AsIHNhdmVkX3JzcAotCW1vdnEJ
JXJicCwgc2F2ZWRfcmJwCi0JbW92cQklcmJ4LCBzYXZlZF9yYngKLQltb3ZxCSVyZGksIHNhdmVk
X3JkaQotCW1vdnEJJXJzaSwgc2F2ZWRfcnNpCisJbW92cQklcnNwLCBzYXZlZF9yc3AoJXJpcCkK
Kwltb3ZxCSVyYnAsIHNhdmVkX3JicCglcmlwKQorCW1vdnEJJXJieCwgc2F2ZWRfcmJ4KCVyaXAp
CisJbW92cQklcmRpLCBzYXZlZF9yZGkoJXJpcCkKKwltb3ZxCSVyc2ksIHNhdmVkX3JzaSglcmlw
KQogCiAJYWRkcQkkOCwgJXJzcAogCW1vdmwJJDMsICVlZGkKQEAgLTgyLDcgKzgzLDcgQEAgRU5U
UlkoZG9fc3VzcGVuZF9sb3dsZXZlbCkKIAkuYWxpZ24gNAogLkxyZXN1bWVfcG9pbnQ6CiAJLyog
V2UgZG9uJ3QgcmVzdG9yZSAlcmF4LCBpdCBtdXN0IGJlIDAgYW55d2F5ICovCi0JbW92cQkkc2F2
ZWRfY29udGV4dCwgJXJheAorCWxlYXEJc2F2ZWRfY29udGV4dCglcmlwKSwgJXJheAogCW1vdnEJ
c2F2ZWRfY29udGV4dF9jcjQoJXJheCksICVyYngKIAltb3ZxCSVyYngsICVjcjQKIAltb3ZxCXNh
dmVkX2NvbnRleHRfY3IzKCVyYXgpLCAlcmJ4Ci0tIAoyLjE0LjIuOTIwLmdjZjBjNjc5NzljLWdv
b2cKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4t
ZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0dHBzOi8vbGlzdHMu
eGVuLm9yZy94ZW4tZGV2ZWwK
