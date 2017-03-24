From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] crypto: caam - add Queue Interface (QI) support
Date: Fri, 24 Mar 2017 22:13:30 +0800
Message-ID: <20170324141330.GD14780@gondor.apana.org.au>
References: <20170317100602.2837-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Alexandru Porosanu <alexandru.porosanu@nxp.com>,
 Roy Pledge <roy.pledge@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>, Scott Wood <oss@buserror.net>,
 Dan Douglass <dan.douglass@nxp.com>, linux-crypto@vger.kernel.org,
 Vakul Garg <vakul.garg@nxp.com>, "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170317100602.2837-1-horia.geanta@nxp.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

T24gRnJpLCBNYXIgMTcsIDIwMTcgYXQgMTI6MDU6NTVQTSArMDIwMCwgSG9yaWEgR2VhbnTEgyB3
cm90ZToKPiBSRkMgLT4gdjE6Cj4gLXJlYmFzZWQgb24gbGF0ZXN0IGNyeXB0b2Rldi0yLjYgdHJl
ZQo+IG9wZW4tY29kZSB0c2tfY3B1c19hbGxvd2VkKCkgLSBzeW5jIHdpdGggY29tbWl0Cj4gMGM5
OGQzNDRmZTVjICJzY2hlZC9jb3JlOiBSZW1vdmUgdGhlIHRza19jcHVzX2FsbG93ZWQoKSB3cmFw
cGVyIgo+IC1hZGRyZXNzZWQgU2NvdHQncyBmZWVkYmFjayAtIHJlbW92ZWQgbW9zdCBvZiB0aGUg
YWNjZXNzb3JzCj4gYWRkZWQgaW4gc29jL3FtYW4gKHBhdGNoIDQpIGFuZCBpbnN0ZWFkIG9wZW4t
Y29kZWQgdGhlbSBpbiBjYWFtL3FpCj4gCj4gCj4gVGhlIHBhdGNoc2V0IGFkZHMgc3VwcG9ydCBm
b3IgQ0FBTSBRdWV1ZSBJbnRlcmZhY2UgKFFJKSwgdGhlIGFkZGl0aW9uYWwKPiBpbnRlcmZhY2Ug
KGJlc2lkZXMgam9iIHJpbmcpIGF2YWlsYWJsZSBmb3Igc3VibWl0dGluZyBqb2JzIHRvIHRoZSBl
bmdpbmUKPiBvbiBwbGF0Zm9ybXMgaGF2aW5nIERQQUEgKERhdGFwYXRoIEFjY2VsZXJhdGlvbiBB
cmNoaXRlY3R1cmUpLgo+IAo+IFBhdGNoZXMgMS00IGFyZSBRTWFuIGRlcGVuZGVuY2llcy4KPiBE
dXJpbmcgUkZDIHN0YWdlLCB3ZSBhZ3JlZWQgdG8gZ28gd2l0aCB0aGVtIHRocm91Z2ggdGhlIGNy
eXB0byB0cmVlOgo+IGh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZy9tc2cyNDEwNS5odG1sCj4gCj4gUGF0Y2ggNSBhZGRzIGEgbWlzc2luZyBk
b3VibGUgaW5jbHVzaW9uIGd1YXJkIGluIGRlc2NfY29uc3RyLmguCj4gCj4gUGF0Y2ggNiBhZGRz
IHRoZSBjYWFtL3FpIGpvYiBzdWJtaXNzaW9uIGJhY2tlbmQuCj4gCj4gUGF0Y2ggNyBhZGRzIGFs
Z29yaXRobXMgKGFibGtjaXBoZXIgYW5kIGF1dGhlbmMpIHRoYXQgcnVuIG9uIHRvcAo+IG9mIGNh
YW0vcWkuIEZvciBub3csIHRoZWlyIHByaW9yaXR5IGlzIHNldCBsb3dlciB0aGFuIGNhYW0vanIu
CgpBbGwgcGF0Y2hlcyBhcHBsaWVkLiAgVGhhbmtzLgotLSAKRW1haWw6IEhlcmJlcnQgWHUgPGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4KSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFwYW5h
Lm9yZy5hdS9+aGVyYmVydC8KUEdQIEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhl
cmJlcnQvcHVia2V5LnR4dAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QKbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtYXJtLWtlcm5lbAo=
