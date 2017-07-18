From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC 07/22] x86: relocate_kernel - Adapt assembly for
	PIE support
Date: Tue, 18 Jul 2017 15:33:18 -0700
Message-ID: <20170718223333.110371-8-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com,
 xen-devel@lists.xenproject.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
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
Ci0tLQogYXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TIGIvYXJjaC94ODYva2VybmVsL3JlbG9j
YXRlX2tlcm5lbF82NC5TCmluZGV4IDk4MTExYjM4ZWJmZC4uZGE4MTdkMTYyOGFjIDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvcmVsb2NhdGVfa2VybmVsXzY0LlMKKysrIGIvYXJjaC94ODYv
a2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TCkBAIC0xODYsNyArMTg2LDcgQEAgaWRlbnRpdHlf
bWFwcGVkOgogCW1vdnEJJXJheCwgJWNyMwogCWxlYQlQQUdFX1NJWkUoJXI4KSwgJXJzcAogCWNh
bGwJc3dhcF9wYWdlcwotCW1vdnEJJHZpcnR1YWxfbWFwcGVkLCAlcmF4CisJbGVhcQl2aXJ0dWFs
X21hcHBlZCglcmlwKSwgJXJheAogCXB1c2hxCSVyYXgKIAlyZXQKIAotLSAKMi4xMy4yLjkzMi5n
NzQ0OWU5NjRjLWdvb2cKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0
dHBzOi8vbGlzdHMueGVuLm9yZy94ZW4tZGV2ZWwK
