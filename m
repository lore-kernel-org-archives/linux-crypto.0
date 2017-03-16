From: Scott Wood <oss@buserror.net>
Subject: Re: [RFC 0/7] crypto: caam - add Queue Interface (QI) support
Date: Thu, 16 Mar 2017 15:49:30 -0500
Message-ID: <1489697370.2944.46.camel@buserror.net>
References: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
 <20170316084249.GB11653@gondor.apana.org.au>
 <DB4PR04MB0847AD372AFF9510CDCA3ECD98260@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>, Dan Douglass <dan.douglass@nxp.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Vakul Garg <vakul@nxp.com>, Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <DB4PR04MB0847AD372AFF9510CDCA3ECD98260@DB4PR04MB0847.eurprd04.prod.outlook.com>
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

T24gVGh1LCAyMDE3LTAzLTE2IGF0IDE0OjEzICswMDAwLCBIb3JpYSBHZWFudMSDIHdyb3RlOgo+
IE9uIDMvMTYvMjAxNyAxMDo0MyBBTSwgSGVyYmVydCBYdSB3cm90ZToKPiA+IAo+ID4gT24gRnJp
LCBNYXIgMDMsIDIwMTcgYXQgMDQ6NTI6MDZQTSArMDIwMCwgSG9yaWEgR2VhbnTEgyB3cm90ZToK
PiA+ID4gCj4gPiA+IFRoZSBwYXRjaHNldCBhZGRzIHN1cHBvcnQgZm9yIENBQU0gUXVldWUgSW50
ZXJmYWNlIChRSSksIHRoZSBhZGRpdGlvbmFsCj4gPiA+IGludGVyZmFjZSAoYmVzaWRlcyBqb2Ig
cmluZykgYXZhaWxhYmxlIGZvciBzdWJtaXR0aW5nIGpvYnMgdG8gdGhlIGVuZ2luZQo+ID4gPiBv
biBwbGF0Zm9ybXMgaGF2aW5nIERQQUEgKERhdGFwYXRoIEFjY2VsZXJhdGlvbiBBcmNoaXRlY3R1
cmUpLgo+ID4gPiAKPiA+ID4gUGF0Y2hlcyAxLTQgYXJlIFFNYW4gZGVwZW5kZW5jaWVzLgo+ID4g
PiBJIHdvdWxkIHByZWZlciB0byB0YWtlIHRoZW0gdGhyb3VnaCB0aGUgY3J5cHRvIHRyZWUsCj4g
PiA+IGJ1dCBJIGFtIG9wZW4gdG8gc3VnZ2VzdGlvbnMuCj4gPiA+IAo+ID4gPiBQYXRjaCA1IGFk
ZHMgYSBtaXNzaW5nIGRvdWJsZSBpbmNsdXNpb24gZ3VhcmQgaW4gZGVzY19jb25zdHIuaC4KPiA+
ID4gCj4gPiA+IFBhdGNoIDYgYWRkcyB0aGUgY2FhbS9xaSBqb2Igc3VibWlzc2lvbiBiYWNrZW5k
Lgo+ID4gPiAKPiA+ID4gUGF0Y2ggNyBhZGRzIGFsZ29yaXRobXMgKGFibGtjaXBoZXIgYW5kIGF1
dGhlbmMpIHRoYXQgcnVuIG9uIHRvcAo+ID4gPiBvZiBjYWFtL3FpLiBGb3Igbm93LCB0aGVpciBw
cmlvcml0eSBpcyBzZXQgbG93ZXIgdGhhbiBjYWFtL2pyLgo+ID4gSSdtIGZpbmUgd2l0aCB0aGUg
Y3J5cHRvIGJpdHMuCj4gPiAKPiBIZXJiZXJ0LAo+IAo+IFRoYW5rcyBmb3IgdGhlIHJldmlldy4K
PiBTaG91bGQgSSBzdWJtaXQgZm9ybWFsbHksIGkuZS4gd2l0aG91dCB0aGUgW1JGQ10gcHJlZml4
Pwo+IAo+IFNjb3R0LCBSb3ksCj4gCj4gRG8geW91IGhhdmUgYW55IGNvbW1lbnRzIHdydC4gc29j
L3FtYW4gcGF0Y2hlcyBvciB3aXRoIHRoZW0gZ29pbmcKPiB0aHJvdWdoIHRoZSBjcnlwdG8gdHJl
ZT8KCkdvaW5nIHRocm91Z2ggdGhlIGNyeXB0byB0cmVlIGlzIGZpbmUuCgotU2NvdHQKCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2Vy
bmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0
cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVs
Cg==
