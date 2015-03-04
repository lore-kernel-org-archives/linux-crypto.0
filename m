From: Nicolae Rosia <nicolae.rosia@gmail.com>
Subject: Re: IPSec hmac(sha256) truncation bits length
Date: Wed, 4 Mar 2015 20:56:58 +0200
Message-ID: <CAH=tA9FD2z2LAPU51yuhvM8-K_Ep6h09uk3+ZEk0kCROp7ahug@mail.gmail.com>
References: <CAH=tA9Fnd6+gHsvjCv8oXqRVGLtdV9jr-KP1hxUGFg5orC5Qcw@mail.gmail.com>
	<CAH=tA9GQ643vpmk=wJUC1fmpD6A87SU-onhweMp8aYrTu+qsTA@mail.gmail.com>
	<20150304123834.c27417981d6ef63c0b310e11@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netdev@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Andreas Steffen <andreas.steffen@strongswan.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20150304123834.c27417981d6ef63c0b310e11@freescale.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thank you, Andreas and Kim.

Best regards,
Nicolae Rosia

On Wed, Mar 4, 2015 at 8:38 PM, Kim Phillips <kim.phillips@freescale.com> wrote:
> On Wed, 4 Mar 2015 20:28:26 +0200
> Nicolae Rosia <nicolae.rosia@gmail.com> wrote:
>
>> On Wed, Mar 4, 2015 at 7:13 PM, Nicolae Rosia <nicolae.rosia@gmail.com> wrote:
>> > I'm trying to understand why icv_truncbits is set to 96 for
>> > hmac(sha256) in xfrm_algo.c because
>> > RFC4868 [1] says that the truncation length for HMAC-SHA256 should be 128.
>
> See http://comments.gmane.org/gmane.linux.kernel.cryptoapi/6767
>
> Kim
