From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v2 07/23] x86: relocate_kernel - Adapt assembly
	for PIE support
Date: Thu, 10 Aug 2017 10:25:59 -0700
Message-ID: <20170810172615.51965-8-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
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
 Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
 Brian Gerst <brgerst@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@ucw.cz>
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
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
Ci0tLQogYXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TIHwgOCArKysrKy0tLQog
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvcmVsb2NhdGVfa2VybmVsXzY0LlMgYi9hcmNoL3g4Ni9rZXJu
ZWwvcmVsb2NhdGVfa2VybmVsXzY0LlMKaW5kZXggMzA3ZDNiYWM1ZjA0Li4yZWNiZGNiZTk4NWIg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUworKysgYi9h
cmNoL3g4Ni9rZXJuZWwvcmVsb2NhdGVfa2VybmVsXzY0LlMKQEAgLTIwMCw5ICsyMDAsMTEgQEAg
aWRlbnRpdHlfbWFwcGVkOgogCW1vdnEJJXJheCwgJWNyMwogCWxlYQlQQUdFX1NJWkUoJXI4KSwg
JXJzcAogCWNhbGwJc3dhcF9wYWdlcwotCW1vdnEJJHZpcnR1YWxfbWFwcGVkLCAlcmF4Ci0JcHVz
aHEJJXJheAotCXJldAorCWptcAkqdmlydHVhbF9tYXBwZWRfYWRkciglcmlwKQorCisJLyogQWJz
b2x1dGUgdmFsdWUgZm9yIFBJRSBzdXBwb3J0ICovCit2aXJ0dWFsX21hcHBlZF9hZGRyOgorCS5x
dWFkIHZpcnR1YWxfbWFwcGVkCiAKIHZpcnR1YWxfbWFwcGVkOgogCW1vdnEJUlNQKCVyOCksICVy
c3AKLS0gCjIuMTQuMC40MzQuZzk4MDk2ZmQ3YTgtZ29vZwoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRl
dmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
