From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: x86: PIE support and option to extend KASLR
	randomization
Date: Fri, 22 Sep 2017 06:24:44 +0200
Message-ID: <20170922042444.GA235@x4>
References: <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com>
 <CAKv+Gu8Uw18pW9nK8aVdBoyuybAV6_mhtagVrje_cBUHMGY4WA@mail.gmail.com>
 <CAJcbSZGAsXwMNWnZUs28-3f--ssUYh75XW+aoQztPFYe0j52yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
 Peter Zijlstra <a.p.zijlstra@chello.nl>, Michal Hocko <mhocko@suse.com>,
 Len Brown <len.brown@intel.com>,
 Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>,
 Alexei Starovoitov <ast@kernel.org>, David Howells <dhowells@redhat.com>,
 Paul Gortmaker <paul.gortmaker@windriver.com>, Pavel Machek <pavel@ucw.cz>,
 "H . Peter Anvin" <hpa@zytor.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <keescook@chromium.org>, the arch/x86 maintainers <x86@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Matthew Wilcox <mawilcox@microsoft.com>, Peter Foley <pefoley2@pefoley.com>,
 Joerg Roedel <jor
To: Thomas Garnier <thgarnie@google.com>
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <CAJcbSZGAsXwMNWnZUs28-3f--ssUYh75XW+aoQztPFYe0j52yQ@mail.gmail.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

T24gMjAxNy4wOS4yMSBhdCAxNDoyMSAtMDcwMCwgVGhvbWFzIEdhcm5pZXIgd3JvdGU6Cj4gT24g
VGh1LCBTZXAgMjEsIDIwMTcgYXQgOToxMCBBTSwgQXJkIEJpZXNoZXV2ZWwKPiA8YXJkLmJpZXNo
ZXV2ZWxAbGluYXJvLm9yZz4gd3JvdGU6Cj4gPgo+ID4gT24gMjEgU2VwdGVtYmVyIDIwMTcgYXQg
MDg6NTksIEluZ28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPiB3cm90ZToKPiA+ID4KPiA+ID4g
KCBTb3JyeSBhYm91dCB0aGUgZGVsYXkgaW4gYW5zd2VyaW5nIHRoaXMuIEkgY291bGQgYmxhbWUg
dGhlIGRlbGF5IG9uIHRoZSBtZXJnZQo+ID4gPiAgIHdpbmRvdywgYnV0IGluIHJlYWxpdHkgSSd2
ZSBiZWVuIHByb2NyYXN0aW5hdGluZyB0aGlzIGlzIGR1ZSB0byB0aGUgcGVybWFuZW50LAo+ID4g
PiAgIG5vbi10cml2aWFsIGltcGFjdCBQSUUgaGFzIG9uIGdlbmVyYXRlZCBDIGNvZGUuICkKPiA+
ID4KPiA+ID4gKiBUaG9tYXMgR2FybmllciA8dGhnYXJuaWVAZ29vZ2xlLmNvbT4gd3JvdGU6Cj4g
PiA+Cj4gPiA+PiAxKSBQSUUgc29tZXRpbWUgbmVlZHMgdHdvIGluc3RydWN0aW9ucyB0byByZXBy
ZXNlbnQgYSBzaW5nbGUKPiA+ID4+IGluc3RydWN0aW9uIG9uIG1jbW9kZWw9a2VybmVsLgo+ID4g
Pgo+ID4gPiBXaGF0IGFnYWluIGlzIHRoZSB0eXBpY2FsIGZyZXF1ZW5jeSBvZiB0aGlzIG9jY3Vy
cmluZyBpbiBhbiB4ODYtNjQgZGVmY29uZmlnCj4gPiA+IGtlcm5lbCwgd2l0aCB0aGUgdmVyeSBs
YXRlc3QgR0NDPwo+ID4gPgo+ID4gPiBBbHNvLCB0byBtYWtlIHN1cmU6IHdoaWNoIHVud2luZGVy
IGRpZCB5b3UgdXNlIGZvciB5b3VyIG1lYXN1cmVtZW50cywKPiA+ID4gZnJhbWUtcG9pbnRlcnMg
b3IgT1JDPyBQbGVhc2UgdXNlIE9SQyBvbmx5IGZvciBmdXR1cmUgbnVtYmVycywgYXMKPiA+ID4g
ZnJhbWUtcG9pbnRlcnMgaXMgb2Jzb2xldGUgZnJvbSBhIHBlcmZvcm1hbmNlIG1lYXN1cmVtZW50
IFBPVi4KPiA+ID4KPiA+ID4+IDIpIEdDQyBkb2VzIG5vdCBvcHRpbWl6ZSBzd2l0Y2hlcyBpbiBQ
SUUgaW4gb3JkZXIgdG8gcmVkdWNlIHJlbG9jYXRpb25zOgo+ID4gPgo+ID4gPiBIb3BlZnVsbHkg
dGhpcyBjYW4gZWl0aGVyIGJlIGZpeGVkIGluIEdDQyBvciBhdCBsZWFzdCBpbmZsdWVuY2VkIHZp
YSBhIGNvbXBpbGVyCj4gPiA+IHN3aXRjaCBpbiB0aGUgZnV0dXJlLgo+ID4gPgo+ID4KPiA+IFRo
ZXJlIGFyZSBzb21ld2hhdCByZWxhdGVkIGNvbmNlcm5zIGluIHRoZSBBUk0gd29ybGQsIHNvIGl0
IHdvdWxkIGJlCj4gPiBnb29kIGlmIHdlIGNvdWxkIHdvcmsgd2l0aCB0aGUgR0NDIGRldmVsb3Bl
cnMgdG8gZ2V0IGEgbW9yZSBoaWdoIGxldmVsCj4gPiBhbmQgYXJjaCBuZXV0cmFsIGNvbW1hbmQg
bGluZSBvcHRpb24gKC1ta2VybmVsLXBpZT8gc291bmRzIHl1bW15ISkKPiA+IHRoYXQgc3RvcHMg
dGhlIGNvbXBpbGVyIGZyb20gbWFraW5nIGluZmVyZW5jZXMgdGhhdCBvbmx5IGhvbGQgZm9yCj4g
PiBzaGFyZWQgbGlicmFyaWVzIGFuZC9vciBvdGhlciBob3N0ZWQgZXhlY3V0YWJsZXMgKEdPVCBp
bmRpcmVjdGlvbnMsCj4gPiBhdm9pZGluZyB0ZXh0IHJlbG9jYXRpb25zIGV0YykuIFRoYXQgd2F5
LCB3ZSB3aWxsIGFsc28gYmUgYWJsZSB0byBkcm9wCj4gPiB0aGUgJ2hpZGRlbicgdmlzaWJpbGl0
eSBvdmVycmlkZSBhdCBzb21lIHBvaW50LCB3aGljaCB3ZSBjdXJyZW50bHkKPiA+IG5lZWQgdG8g
cHJldmVudCB0aGUgY29tcGlsZXIgZnJvbSByZWRpcmVjdGluZyBhbGwgZ2xvYmFsIHN5bWJvbAo+
ID4gcmVmZXJlbmNlcyB2aWEgZW50cmllcyBpbiB0aGUgR09ULgo+IAo+IE15IHBsYW4gd2FzIHRv
IGFkZCBhIC1tdGxzLXJlZz08ZnN8Z3M+IHRvIHN3aXRjaCB0aGUgZGVmYXVsdCBzZWdtZW50Cj4g
cmVnaXN0ZXIgZm9yIHN0YWNrIGNvb2tpZXMgYnV0IEkgY2FuIHNlZSBncmVhdCBiZW5lZml0cyBp
biBoYXZpbmcgYQo+IG1vcmUgZ2VuZXJhbCBrZXJuZWwgZmxhZyB0aGF0IHdvdWxkIGFsbG93IHRv
IGdldCByaWQgb2YgdGhlIEdPVCBhbmQKPiBQTFQgd2hlbiB5b3UgYXJlIGJ1aWxkaW5nIHBvc2l0
aW9uIGluZGVwZW5kZW50IGNvZGUgZm9yIHRoZSBrZXJuZWwuIEl0Cj4gY291bGQgYWxzbyBpbmNs
dWRlIG9wdGltaXphdGlvbnMgbGlrZSBmb2xkaW5nIHN3aXRjaCB0YWJsZXMgZXRjLi4uCj4gCj4g
U2hvdWxkIHdlIHN0YXJ0IGEgc2VwYXJhdGUgZGlzY3Vzc2lvbiBvbiB0aGF0PyBBbnlvbmUgdGhh
dCB3b3VsZCBiZQo+IG1vcmUgZXhwZXJpZW5jZWQgdGhhbiBJIHRvIHB1c2ggdGhhdCB0byBnY2Mg
JiBjbGFuZyB1cHN0cmVhbT8KCkp1c3Qgb3BlbiBhIGdjYyBidWcuIFNlZQpodHRwczovL2djYy5n
bnUub3JnL2J1Z3ppbGxhL3Nob3dfYnVnLmNnaT9pZD04MTcwOCBhcyBhbiBleGFtcGxlLgoKLS0g
Ck1hcmt1cwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xp
c3RzLnhlbi5vcmcveGVuLWRldmVsCg==
