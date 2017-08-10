From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC v2 09/23] x86: pm-trace - Adapt assembly for PIE
	support
Date: Thu, 10 Aug 2017 10:26:01 -0700
Message-ID: <20170810172615.51965-10-thgarnie@google.com>
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

Q2hhbmdlIGFzc2VtYmx5IHRvIHVzZSB0aGUgbmV3IF9BU01fR0VUX1BUUiBtYWNybyBpbnN0ZWFk
IG9mIF9BU01fTU9WIGZvcgp0aGUgYXNzZW1ibHkgdG8gYmUgUElFIGNvbXBhdGlibGUuCgpQb3Np
dGlvbiBJbmRlcGVuZGVudCBFeGVjdXRhYmxlIChQSUUpIHN1cHBvcnQgd2lsbCBhbGxvdyB0byBl
eHRlbmRlZCB0aGUKS0FTTFIgcmFuZG9taXphdGlvbiByYW5nZSBiZWxvdyB0aGUgLTJHIG1lbW9y
eSBsaW1pdC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHYXJuaWVyIDx0aGdhcm5pZUBnb29nbGUu
Y29tPgotLS0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL3BtLXRyYWNlLmggfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9wbS10cmFjZS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcG0tdHJh
Y2UuaAppbmRleCA3YjdhYzQyYzM2NjEuLmEzODAxMjYxZjBkZCAxMDA2NDQKLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vcG0tdHJhY2UuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wbS10
cmFjZS5oCkBAIC03LDcgKzcsNyBAQAogZG8gewkJCQkJCQkJXAogCWlmIChwbV90cmFjZV9lbmFi
bGVkKSB7CQkJCQlcCiAJCWNvbnN0IHZvaWQgKnRyYWNlZGF0YTsJCQkJXAotCQlhc20gdm9sYXRp
bGUoX0FTTV9NT1YgIiAkMWYsJTBcbiIJCVwKKwkJYXNtIHZvbGF0aWxlKF9BU01fR0VUX1BUUigx
ZiwgJTApICJcbiIJCVwKIAkJCSAgICAgIi5zZWN0aW9uIC50cmFjZWRhdGEsXCJhXCJcbiIJXAog
CQkJICAgICAiMTpcdC53b3JkICVjMVxuXHQiCQlcCiAJCQkgICAgIF9BU01fUFRSICIgJWMyXG4i
CQkJXAotLSAKMi4xNC4wLjQzNC5nOTgwOTZmZDdhOC1nb29nCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4t
ZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
