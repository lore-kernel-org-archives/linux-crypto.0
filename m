From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Wed, 07 May 2008 13:12:14 +0800
Message-ID: <1210137134.4676.1.camel@caritas-dev.intel.com>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208403403.4322.27.camel@caritas-dev.intel.com>
	 <20080423223221.GB16683@Chamillionaire.breakpoint.cc>
	 <1209093077.20936.24.camel@caritas-dev.intel.com>
	 <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
	 <alpine.DEB.1.10.0805032323580.27385@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-zZjmy8x8D3O2HdK7Mmca"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: dean gaudet <dean@arctic.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754721AbYEGFHW@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805032323580.27385@twinlark.arctic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-zZjmy8x8D3O2HdK7Mmca
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

On Sat, 2008-05-03 at 23:25 -0700, dean gaudet wrote:
> one of the more important details in evaluating these changes would be the 
> family/model/stepping of the processors being microbenchmarked... could 
> you folks include /proc/cpuinfo with the results?

The file attached is /proc/cpuinfo of my testing machine.

Best Regards,
Huang Ying

> also -- please drop the #define for R16 to %rsp ... it obfuscates more 
> than it helps anything.
> 
> thanks
> -dean
> 
> On Wed, 30 Apr 2008, Sebastian Siewior wrote:
> 
> > * Huang, Ying | 2008-04-25 11:11:17 [+0800]:
> > 
> > >Hi, Sebastian,
> > Hi Huang,
> > 
> > sorry for the delay.
> > 
> > >I changed the patches to group the read or write together instead of
> > >interleaving. Can you help me to test these new patches? The new patches
> > >is attached with the mail.
> > The new results are attached.
> > 
> > >
> > >Best Regards,
> > >Huang Ying
> > 
> > Sebastian
> > 

--=-zZjmy8x8D3O2HdK7Mmca
Content-Disposition: attachment; filename=cpuinfo
Content-Type: text/plain; name=cpuinfo; charset=utf-8
Content-Transfer-Encoding: base64

cHJvY2Vzc29yCTogMA0KdmVuZG9yX2lkCTogR2VudWluZUludGVsDQpjcHUgZmFtaWx5CTogNg0K
bW9kZWwJCTogMTUNCm1vZGVsIG5hbWUJOiBJbnRlbChSKSBDb3JlKFRNKTIgQ1BVICAgICAgICAg
IDY0MDAgIEAgMi4xM0dIeg0Kc3RlcHBpbmcJOiAyDQpjcHUgTUh6CQk6IDIxMjguMDA2DQpjYWNo
ZSBzaXplCTogMjA0OCBLQg0KcGh5c2ljYWwgaWQJOiAwDQpzaWJsaW5ncwk6IDINCmNvcmUgaWQJ
CTogMA0KY3B1IGNvcmVzCTogMg0KZnB1CQk6IHllcw0KZnB1X2V4Y2VwdGlvbgk6IHllcw0KY3B1
aWQgbGV2ZWwJOiAxMA0Kd3AJCTogeWVzDQpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNy
IHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNo
IGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IGxtIGNv
bnN0YW50X3RzYyBhcmNoX3BlcmZtb24gcGVicyBidHMgcmVwX2dvb2QgcG5pIG1vbml0b3IgZHNf
Y3BsIHZteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBsYWhmX2xtDQpib2dvbWlwcwk6IDQyNTku
MTUNCmNsZmx1c2ggc2l6ZQk6IDY0DQpjYWNoZV9hbGlnbm1lbnQJOiA2NA0KYWRkcmVzcyBzaXpl
cwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbA0KcG93ZXIgbWFuYWdlbWVudDoN
Cg0KcHJvY2Vzc29yCTogMQ0KdmVuZG9yX2lkCTogR2VudWluZUludGVsDQpjcHUgZmFtaWx5CTog
Ng0KbW9kZWwJCTogMTUNCm1vZGVsIG5hbWUJOiBJbnRlbChSKSBDb3JlKFRNKTIgQ1BVICAgICAg
ICAgIDY0MDAgIEAgMi4xM0dIeg0Kc3RlcHBpbmcJOiAyDQpjcHUgTUh6CQk6IDIxMjguMDA2DQpj
YWNoZSBzaXplCTogMjA0OCBLQg0KcGh5c2ljYWwgaWQJOiAwDQpzaWJsaW5ncwk6IDINCmNvcmUg
aWQJCTogMQ0KY3B1IGNvcmVzCTogMg0KZnB1CQk6IHllcw0KZnB1X2V4Y2VwdGlvbgk6IHllcw0K
Y3B1aWQgbGV2ZWwJOiAxMA0Kd3AJCTogeWVzDQpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2Mg
bXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZs
dXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IGxt
IGNvbnN0YW50X3RzYyBhcmNoX3BlcmZtb24gcGVicyBidHMgcmVwX2dvb2QgcG5pIG1vbml0b3Ig
ZHNfY3BsIHZteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBsYWhmX2xtDQpib2dvbWlwcwk6IDQy
NTYuMDgNCmNsZmx1c2ggc2l6ZQk6IDY0DQpjYWNoZV9hbGlnbm1lbnQJOiA2NA0KYWRkcmVzcyBz
aXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbA0KcG93ZXIgbWFuYWdlbWVu
dDoNCg0K


--=-zZjmy8x8D3O2HdK7Mmca--
