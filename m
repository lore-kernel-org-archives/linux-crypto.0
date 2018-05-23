From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 07/27] x86: pm-trace - Adapt assembly for PIE
 support
Date: Wed, 23 May 2018 12:54:01 -0700
Message-ID: <20180523195421.180248-8-thgarnie@google.com>
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

Q2hhbmdlIGFzc2VtYmx5IHRvIHVzZSB0aGUgbmV3IF9BU01fTU9WQUJTIG1hY3JvIGluc3RlYWQg
b2YgX0FTTV9NT1YgZm9yCnRoZSBhc3NlbWJseSB0byBiZSBQSUUgY29tcGF0aWJsZS4KClBvc2l0
aW9uIEluZGVwZW5kZW50IEV4ZWN1dGFibGUgKFBJRSkgc3VwcG9ydCB3aWxsIGFsbG93IHRvIGV4
dGVuZGVkIHRoZQpLQVNMUiByYW5kb21pemF0aW9uIHJhbmdlIGJlbG93IHRoZSAtMkcgbWVtb3J5
IGxpbWl0LgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5j
b20+Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vcG0tdHJhY2UuaCB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BtLXRyYWNlLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wbS10cmFj
ZS5oCmluZGV4IGJmYTMyYWE0MjhlNS4uOTcyMDcwODA2Y2U5IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wbS10cmFjZS5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BtLXRy
YWNlLmgKQEAgLTgsNyArOCw3IEBACiBkbyB7CQkJCQkJCQlcCiAJaWYgKHBtX3RyYWNlX2VuYWJs
ZWQpIHsJCQkJCVwKIAkJY29uc3Qgdm9pZCAqdHJhY2VkYXRhOwkJCQlcCi0JCWFzbSB2b2xhdGls
ZShfQVNNX01PViAiICQxZiwlMFxuIgkJXAorCQlhc20gdm9sYXRpbGUoX0FTTV9NT1ZBQlMgIiAk
MWYsJTBcbiIJCVwKIAkJCSAgICAgIi5zZWN0aW9uIC50cmFjZWRhdGEsXCJhXCJcbiIJXAogCQkJ
ICAgICAiMTpcdC53b3JkICVjMVxuXHQiCQlcCiAJCQkgICAgIF9BU01fUFRSICIgJWMyXG4iCQkJ
XAotLSAKMi4xNy4wLjQ0MS5nYjQ2ZmU2MGUxZC1nb29nCgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2
ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWls
bWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
