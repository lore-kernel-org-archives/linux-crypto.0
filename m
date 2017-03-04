From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 01/32] x86: Add the Secure Encrypted
 Virtualization CPU feature
Date: Sat, 4 Mar 2017 11:11:13 +0100
Message-ID: <20170304101113.k6ontjjbljanm6tv@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846752953.2349.17505492128445909591.stgit@brijesh-build-machine>
 <20170303165915.3233fx7wo74vsslx@pd.tnic>
 <404fafd8-bbd6-b8c7-1abb-787ac083ea41@amd.com>
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
In-Reply-To: <404fafd8-bbd6-b8c7-1abb-787ac083ea41@amd.com>
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

T24gRnJpLCBNYXIgMDMsIDIwMTcgYXQgMDM6MDE6MjNQTSAtMDYwMCwgQnJpamVzaCBTaW5naCB3
cm90ZToKPiArbWVyZWx5IGVuYWJsZXMgU01FIChzZXRzIGJpdCAyMyBvZiB0aGUgTVNSX0s4X1NZ
U0NGRyksIHRoZW4gTGludXggY2FuCj4gYWN0aXZhdGUKPiArbWVtb3J5IGVuY3J5cHRpb24gYnkg
ZGVmYXVsdCAoQ09ORklHX0FNRF9NRU1fRU5DUllQVF9BQ1RJVkVfQllfREVGQVVMVD15KQo+IG9y
Cj4gK2J5IHN1cHBseWluZyBtZW1fZW5jcnlwdD1vbiBvbiB0aGUga2VybmVsIGNvbW1hbmQgbGlu
ZS4gIEhvd2V2ZXIsIGlmIEJJT1MKPiBkb2VzCj4gK25vdCBlbmFibGUgU01FLCB0aGVuIExpbnV4
IHdpbGwgbm90IGJlIGFibGUgdG8gYWN0aXZhdGUgbWVtb3J5IGVuY3J5cHRpb24sCj4gZXZlbgo+
ICtpZiBjb25maWd1cmVkIHRvIGRvIHNvIGJ5IGRlZmF1bHQgb3IgdGhlIG1lbV9lbmNyeXB0PW9u
IGNvbW1hbmQgbGluZQo+IHBhcmFtZXRlcgo+ICtpcyBzcGVjaWZpZWQuCgpUaGlzIGxvb2tzIGxp
a2UgYSB3cmFwYXJvdW5kLi4uCgokIHRlc3QtYXBwbHkuc2ggL3RtcC9icmlqZXNoLnNpbmdoLmRl
bHRhCmNoZWNraW5nIGZpbGUgRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9rZXJuZWwtcGFyYW1l
dGVycy50eHQKSHVuayAjMSBzdWNjZWVkZWQgYXQgMjE0NCAob2Zmc2V0IC05IGxpbmVzKS4KY2hl
Y2tpbmcgZmlsZSBEb2N1bWVudGF0aW9uL3g4Ni9hbWQtbWVtb3J5LWVuY3J5cHRpb24udHh0CnBh
dGNoOiAqKioqIG1hbGZvcm1lZCBwYXRjaCBhdCBsaW5lIDIzOiBEUkFNIGZyb20gcGh5c2ljYWwK
CllhcC4KCkxvb2tzIGxpa2UgZXhjaGFuZ2Ugb3IgeW91ciBtYWlsIGNsaWVudCBkZWNpZGVkIHRv
IGRvIHNvbWUgcGF0Y2ggZWRpdGluZwpvbiBpdHMgb3duLgoKUGxlYXNlIHNlbmQgaXQgdG8geW91
cnNlbGYgZmlyc3QgYW5kIHRyeSBhcHBseWluZy4KCi0tIApSZWdhcmRzL0dydXNzLAogICAgQm9y
aXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhh
cmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQotLSAKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZGV2ZWwgbWFpbGluZyBsaXN0
CmRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmcKaHR0cDovL2RyaXZlcmRldi5saW51eGRyaXZl
cnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8vZHJpdmVyZGV2LWRldmVsCg==
