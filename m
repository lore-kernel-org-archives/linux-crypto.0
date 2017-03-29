From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 18/32] kvm: svm: Use the hardware provided GPA
 instead of page walk
Date: Wed, 29 Mar 2017 17:14:13 +0200
Message-ID: <20170329151413.l2on26mdyyskwqlu@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846776540.2349.3123530065053870721.stgit@brijesh-build-machine>
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
In-Reply-To: <148846776540.2349.3123530065053870721.stgit@brijesh-build-machine>
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

T24gVGh1LCBNYXIgMDIsIDIwMTcgYXQgMTA6MTY6MDVBTSAtMDUwMCwgQnJpamVzaCBTaW5naCB3
cm90ZToKPiBGcm9tOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPgo+IAo+
IFdoZW4gYSBndWVzdCBjYXVzZXMgYSBOUEYgd2hpY2ggcmVxdWlyZXMgZW11bGF0aW9uLCBLVk0g
c29tZXRpbWVzIHdhbGtzCj4gdGhlIGd1ZXN0IHBhZ2UgdGFibGVzIHRvIHRyYW5zbGF0ZSB0aGUg
R1ZBIHRvIGEgR1BBLiBUaGlzIGlzIHVubmVjZXNzYXJ5Cj4gbW9zdCBvZiB0aGUgdGltZSBvbiBB
TUQgaGFyZHdhcmUgc2luY2UgdGhlIGhhcmR3YXJlIHByb3ZpZGVzIHRoZSBHUEEgaW4KPiBFWElU
SU5GTzIuCj4gCj4gVGhlIG9ubHkgZXhjZXB0aW9uIGNhc2VzIGludm9sdmUgc3RyaW5nIG9wZXJh
dGlvbnMgaW52b2x2aW5nIHJlcCBvcgo+IG9wZXJhdGlvbnMgdGhhdCB1c2UgdHdvIG1lbW9yeSBs
b2NhdGlvbnMuIFdpdGggcmVwLCB0aGUgR1BBIHdpbGwgb25seSBiZQo+IHRoZSB2YWx1ZSBvZiB0
aGUgaW5pdGlhbCBOUEYgYW5kIHdpdGggZHVhbCBtZW1vcnkgbG9jYXRpb25zIHdlIHdvbid0IGtu
b3cKPiB3aGljaCBtZW1vcnkgYWRkcmVzcyB3YXMgdHJhbnNsYXRlZCBpbnRvIEVYSVRJTkZPMi4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29t
Pgo+IFJldmlld2VkLWJ5OiBCb3Jpc2xhdiBQZXRrb3YgPGJwQHN1c2UuZGU+CgpJIHRoaW5rIEkg
YWxyZWFkeSBhc2tlZCB5b3UgdG8gcmVtb3ZlIFJldmV3ZWQtYnkgdGFncyB3aGVuIHlvdSBoYXZl
IHRvCmNoYW5nZSBhbiBhbHJlYWR5IHJldmlld2VkIHBhdGNoIGluIG5vbi10cml2aWFsIG1hbm5l
ci4gV2h5IGRvZXMgdGhpcwpvbmUgc3RpbGwgaGF2ZSBteSBSZXZpZXdlZC1ieSB0YWc/CgotLSAK
UmVnYXJkcy9HcnVzcywKICAgIEJvcmlzLgoKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1l
bmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uLCBIUkIgMjEyODQgKEFHIE7D
vHJuYmVyZykKLS0gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmRldmVsIG1haWxpbmcgbGlzdApkZXZlbEBsaW51eGRyaXZlcnByb2plY3Qub3JnCmh0dHA6
Ly9kcml2ZXJkZXYubGludXhkcml2ZXJwcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaXZl
cmRldi1kZXZlbAo=
