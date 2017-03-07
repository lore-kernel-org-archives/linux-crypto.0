From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 02/32] x86: Secure Encrypted Virtualization (SEV)
 support
Date: Tue, 7 Mar 2017 12:19:31 +0100
Message-ID: <20170307111931.3rz5ia3ewimfi7gq@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846754069.2349.4698319264278045964.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
 matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org,
 gary.hook@amd.com, linux-mm@kvack.org, hpa@zytor.com, cl@linux.com,
 tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au,
 mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com,
 xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org,
 piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com,
 ross.zwisler@linux.intel.com, labbott@fedoraproject.org, dyoung@redhat.com,
 thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de,
 toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org,
 pbonzini@redhat.com, bhelgaas@google.com, dan.j.williams@intel.com,
 andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
 herbert@gondor.apana.org.au, tony.luck@intel.com, pau
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <148846754069.2349.4698319264278045964.stgit@brijesh-build-machine>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

T24gVGh1LCBNYXIgMDIsIDIwMTcgYXQgMTA6MTI6MjBBTSAtMDUwMCwgQnJpamVzaCBTaW5naCB3
cm90ZToKPiBGcm9tOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPgo+IAo+
IFByb3ZpZGUgc3VwcG9ydCBmb3IgU2VjdXJlIEVuY3lycHRlZCBWaXJ0dWFsaXphdGlvbiAoU0VW
KS4gVGhpcyBpbml0aWFsCj4gc3VwcG9ydCBkZWZpbmVzIGEgZmxhZyB0aGF0IGlzIHVzZWQgYnkg
dGhlIGtlcm5lbCB0byBkZXRlcm1pbmUgaWYgaXQgaXMKPiBydW5uaW5nIHdpdGggU0VWIGFjdGl2
ZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQu
Y29tPgoKQnR3LAoKeW91IG5lZWQgdG8gYWRkIHlvdXIgU2lnbmVkLW9mZi1ieSBoZXJlIGFmdGVy
IFRvbSdzIHRvIGRlbm90ZSB0aGF0CnlvdSdyZSBoYW5kaW5nIHRoYXQgcGF0Y2ggZm9yd2FyZC4K
Ci0tIApSZWdhcmRzL0dydXNzLAogICAgQm9yaXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxp
eCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4NCAo
QUcgTsO8cm5iZXJnKQotLSAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KZGV2ZWwgbWFpbGluZyBsaXN0CmRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmcK
aHR0cDovL2RyaXZlcmRldi5saW51eGRyaXZlcnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8v
ZHJpdmVyZGV2LWRldmVsCg==
