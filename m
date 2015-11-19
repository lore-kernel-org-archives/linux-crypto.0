From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Thu, 19 Nov 2015 12:36:14 +0200
Message-ID: <564DA61E.2070004@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost> <55687892.7050606@ti.com>
 <20150602125535.GS3140@localhost> <5570758E.6030302@ti.com>
 <20150612125837.GJ28601@localhost> <5587F1F4.1060905@ti.com>
 <20150624162401.GP19530@localhost> <564C8966.9080406@ti.com>
 <CAHp75VdhKmTVjRQp9q_4CXBuqjKvkBjDvgXYRDGmhdHzCW9ADA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Vinod Koul <vinod.koul@intel.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-crypto <linux-crypto@vger.kernel.org>,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine <dmaengine@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <CAHp75VdhKmTVjRQp9q_4CXBuqjKvkBjDvgXYRDGmhdHzCW9ADA@mail.gmail.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

T24gMTEvMTgvMjAxNSAwNTo0NiBQTSwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+IE9uIFdlZCwg
Tm92IDE4LCAyMDE1IGF0IDQ6MjEgUE0sIFBldGVyIFVqZmFsdXNpIDxwZXRlci51amZhbHVzaUB0
aS5jb20+IHdyb3RlOgo+PiBIaSBWaW5vZCwKPj4KPj4gYnJpbmdpbmcgdGhpcyBvbGQgdGhyZWFk
IGJhY2sgdG8gbGlmZSBhcyBJIGp1c3Qgc3RhcnRlZCB0byB3b3JrIG9uIHRoaXMuCj4gCj4gV2hh
dCBJIHJlbWVtYmVyIHdlIG5lZWQgdG8gY29udmVydCBkcml2ZXJzIHRvIHVzZSBuZXcgQVBJIG1l
YW53aGlsZSBpdAo+IGlzIGdvb2QgdG8ga2VlcCBvbGQgb25lIHRvIGF2b2lkIHBhdGNoIHN0b3Jt
IHdoaWNoIGRvZXMgbm90aGluZyB1c2VmdWwKPiAoSUlSQyBSdXNzZWwncyBvcGluaW9uKS4KCkkg
dGVuZCB0byBhZ3JlZS4gQnV0IHdlIG5lZWQgdG8gc3RhcnQgY29udmVydGluZyB0aGUgdXNlcnMg
YXQgc29tZSBwb2ludAplaXRoZXIgd2F5LgpBbm90aGVyIGlzc3VlIGlzIHRoZSBmYWN0IHRoYXQg
dGhlIGN1cnJlbnQgZG1hZW5naW5lIEFQSSBpcyB1c2luZyBhbGwgdGhlIGdvb2QKbmFtZXMgSSBj
YW4gdGhpbmsgb2YgOykKCj4gT24gdGhlIG90aGVyIGhhbmQgdGhlcmUgYXJlIGEgbG90IG9mIGRy
aXZlcnMgdGhhdCBhcmUgdXNlZCBvbiB0aGUgc2V0Cj4gb2YgcGxhdGZvcm1zIHN0YXJ0aW5nIGZy
b20gbGVnYWN5IGFuZCBhYmFuZG9uZWQgb25lcyAobGlrZSBBVlIzMikgdG8KPiByZWxhdGl2ZWx5
IG5ldyBhbmQgbmV3ZXN0Lgo+IAo+IEFuZCBJJ20gbm90IGEgZmFuIG9mIHRob3NlIHRob3VzYW5k
cyBvZiBBUEkgY2FsbHMgZWl0aGVyLgo+IAoKLS0gClDDqXRlcgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpBbHNhLWRldmVsIG1haWxpbmcgbGlzdApBbHNh
LWRldmVsQGFsc2EtcHJvamVjdC5vcmcKaHR0cDovL21haWxtYW4uYWxzYS1wcm9qZWN0Lm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2Fsc2EtZGV2ZWwK
