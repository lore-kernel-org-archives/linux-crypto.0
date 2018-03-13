From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 16/27] compiler: Option to add PROVIDE_HIDDEN
	replacement for weak symbols
Date: Tue, 13 Mar 2018 13:59:34 -0700
Message-ID: <20180313205945.245105-17-thgarnie@google.com>
References: <20180313205945.245105-1-thgarnie@google.com>
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
 Kate Stewart <kstewart@linuxfoundation.org>,
 Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
 "Raf
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20180313205945.245105-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
List-Id: linux-crypto.vger.kernel.org

UHJvdmlkZSBhbiBvcHRpb24gdG8gaGF2ZSBhIFBST1ZJREVfSElEREVOIChsaW5rZXIgc2NyaXB0
KSBlbnRyeSBmb3IKZWFjaCB3ZWFrIHN5bWJvbC4gVGhpcyBvcHRpb24gc29sdmUgYW4gZXJyb3Ig
aW4geDg2XzY0IHdoZXJlIHRoZSBsaW5rZXIKb3B0aW1pemVzIHBpZSBnZW5lcmF0ZSBjb2RlIHRv
IGJlIG5vbi1waWUgYmVjYXVzZSAtLWVtaXQtcmVsb2NzIHdhcyB1c2VkCmluc3RlYWQgb2YgLXBp
ZSAodG8gcmVkdWNlIGR5bmFtaWMgcmVsb2NhdGlvbnMpLgoKU2lnbmVkLW9mZi1ieTogVGhvbWFz
IEdhcm5pZXIgPHRoZ2FybmllQGdvb2dsZS5jb20+Ci0tLQogaW5pdC9LY29uZmlnICAgICAgICAg
ICAgfCAgNyArKysrKysrCiBzY3JpcHRzL2xpbmstdm1saW51eC5zaCB8IDE0ICsrKysrKysrKysr
KysrCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbml0
L0tjb25maWcgYi9pbml0L0tjb25maWcKaW5kZXggYzkyNGJhYmM2ZDQ3Li5mZTlmOWFkYTRkYjAg
MTAwNjQ0Ci0tLSBhL2luaXQvS2NvbmZpZworKysgYi9pbml0L0tjb25maWcKQEAgLTE5MjcsNiAr
MTkyNywxMyBAQCBjb25maWcgQVNOMQogCSAgaW5mb3JtIGl0IGFzIHRvIHdoYXQgdGFncyBhcmUg
dG8gYmUgZXhwZWN0ZWQgaW4gYSBzdHJlYW0gYW5kIHdoYXQKIAkgIGZ1bmN0aW9ucyB0byBjYWxs
IG9uIHdoYXQgdGFncy4KIAorY29uZmlnIFdFQUtfUFJPVklERV9ISURERU4KKwlib29sCisJaGVs
cAorCSAgR2VuZXJhdGUgbGlua2VyIHNjcmlwdCBQUk9WSURFX0hJRERFTiBlbnRyaWVzIGZvciBh
bGwgd2VhayBzeW1ib2xzLiBJdAorCSAgYWxsb3dzIHRvIHByZXZlbnQgbm9uLXBpZSBjb2RlIGJl
aW5nIHJlcGxhY2VkIGJ5IHRoZSBsaW5rZXIgaWYgdGhlCisJICBlbWl0LXJlbG9jcyBvcHRpb24g
aXMgdXNlZCBpbnN0ZWFkIG9mIHBpZSAodXNlZnVsIGZvciB4ODZfNjQgcGllKS4KKwogc291cmNl
ICJrZXJuZWwvS2NvbmZpZy5sb2NrcyIKIAogY29uZmlnIEFSQ0hfSEFTX1NZTkNfQ09SRV9CRUZP
UkVfVVNFUk1PREUKZGlmZiAtLWdpdCBhL3NjcmlwdHMvbGluay12bWxpbnV4LnNoIGIvc2NyaXB0
cy9saW5rLXZtbGludXguc2gKaW5kZXggMDhjYTA4ZTkxMDVjLi5jMDE1ZjUxNDJlY2YgMTAwNzU1
Ci0tLSBhL3NjcmlwdHMvbGluay12bWxpbnV4LnNoCisrKyBiL3NjcmlwdHMvbGluay12bWxpbnV4
LnNoCkBAIC0xNDYsNiArMTQ2LDE3IEBAIGthbGxzeW1zKCkKIAkke0NDfSAke2FmbGFnc30gLWMg
LW8gJHsyfSAke2FmaWxlfQogfQogCitnZW5fd2Vha19wcm92aWRlX2hpZGRlbigpCit7CisgICAg
ICAgIGlmIFsgLW4gIiR7Q09ORklHX1dFQUtfUFJPVklERV9ISURERU59IiBdOyB0aGVuCisgICAg
ICAgICAgICAgICAgbG9jYWwgcGF0dGVybj0icy9eXHNcKyB3IFwoXHdcK1wpJC9QUk9WSURFX0hJ
RERFTihcMSA9IC4pOy9ncCIKKyAgICAgICAgICAgICAgICBlY2hvIC1lICJTRUNUSU9OUyB7XG4u
ID0gX2VuZDsiID4gLnRtcF92bWxpbnV4X2hpZGRlbmxkCisgICAgICAgICAgICAgICAgJHtOTX0g
JHsxfSB8IHNlZCAtbiAiJHtwYXR0ZXJufSIgPj4gLnRtcF92bWxpbnV4X2hpZGRlbmxkCisgICAg
ICAgICAgICAgICAgZWNobyAifSIgPj4gLnRtcF92bWxpbnV4X2hpZGRlbmxkCisgICAgICAgICAg
ICAgICAgTERGTEFHU192bWxpbnV4PSIke0xERkxBR1Nfdm1saW51eH0gLVQgLnRtcF92bWxpbnV4
X2hpZGRlbmxkIgorICAgICAgICBmaQorfQorCiAjIENyZWF0ZSBtYXAgZmlsZSB3aXRoIGFsbCBz
eW1ib2xzIGZyb20gJHsxfQogIyBTZWUgbWtzeW1hcCBmb3IgYWRkaXRpb25hbCBkZXRhaWxzCiBt
a3N5c21hcCgpCkBAIC0yMzAsNiArMjQxLDkgQEAgbW9kcG9zdF9saW5rIHZtbGludXgubwogIyBt
b2Rwb3N0IHZtbGludXgubyB0byBjaGVjayBmb3Igc2VjdGlvbiBtaXNtYXRjaGVzCiAke01BS0V9
IC1mICIke3NyY3RyZWV9L3NjcmlwdHMvTWFrZWZpbGUubW9kcG9zdCIgdm1saW51eC5vCiAKKyMg
R2VuZXJhdGUgd2VhayBsaW5rZXIgc2NyaXB0CitnZW5fd2Vha19wcm92aWRlX2hpZGRlbiB2bWxp
bnV4Lm8KKwoga2FsbHN5bXNvPSIiCiBrYWxsc3ltc192bWxpbnV4PSIiCiBpZiBbIC1uICIke0NP
TkZJR19LQUxMU1lNU30iIF07IHRoZW4KLS0gCjIuMTYuMi42NjAuZzcwOTg4Nzk3MWItZ29vZwoK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZl
bCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0dHBzOi8vbGlz
dHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
