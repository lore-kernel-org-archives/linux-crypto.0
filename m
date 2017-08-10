From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v2 13/23] x86/power/64: Adapt assembly for PIE
	support
Date: Thu, 10 Aug 2017 10:26:05 -0700
Message-ID: <20170810172615.51965-14-thgarnie@google.com>
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
Ci0tLQogYXJjaC94ODYvcG93ZXIvaGliZXJuYXRlX2FzbV82NC5TIHwgNCArKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L3Bvd2VyL2hpYmVybmF0ZV9hc21fNjQuUyBiL2FyY2gveDg2L3Bvd2VyL2hpYmVybmF0
ZV9hc21fNjQuUwppbmRleCBjZThkYTNhMDQxMmMuLjZmZGQ3YmJjM2MzMyAxMDA2NDQKLS0tIGEv
YXJjaC94ODYvcG93ZXIvaGliZXJuYXRlX2FzbV82NC5TCisrKyBiL2FyY2gveDg2L3Bvd2VyL2hp
YmVybmF0ZV9hc21fNjQuUwpAQCAtMjQsNyArMjQsNyBAQAogI2luY2x1ZGUgPGFzbS9mcmFtZS5o
PgogCiBFTlRSWShzd3N1c3BfYXJjaF9zdXNwZW5kKQotCW1vdnEJJHNhdmVkX2NvbnRleHQsICVy
YXgKKwlsZWFxCXNhdmVkX2NvbnRleHQoJXJpcCksICVyYXgKIAltb3ZxCSVyc3AsIHB0X3JlZ3Nf
c3AoJXJheCkKIAltb3ZxCSVyYnAsIHB0X3JlZ3NfYnAoJXJheCkKIAltb3ZxCSVyc2ksIHB0X3Jl
Z3Nfc2koJXJheCkKQEAgLTExNSw3ICsxMTUsNyBAQCBFTlRSWShyZXN0b3JlX3JlZ2lzdGVycykK
IAltb3ZxCSVyYXgsICVjcjQ7ICAjIHR1cm4gUEdFIGJhY2sgb24KIAogCS8qIFdlIGRvbid0IHJl
c3RvcmUgJXJheCwgaXQgbXVzdCBiZSAwIGFueXdheSAqLwotCW1vdnEJJHNhdmVkX2NvbnRleHQs
ICVyYXgKKwlsZWFxCXNhdmVkX2NvbnRleHQoJXJpcCksICVyYXgKIAltb3ZxCXB0X3JlZ3Nfc3Ao
JXJheCksICVyc3AKIAltb3ZxCXB0X3JlZ3NfYnAoJXJheCksICVyYnAKIAltb3ZxCXB0X3JlZ3Nf
c2koJXJheCksICVyc2kKLS0gCjIuMTQuMC40MzQuZzk4MDk2ZmQ3YTgtZ29vZwoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5n
IGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1k
ZXZlbAo=
