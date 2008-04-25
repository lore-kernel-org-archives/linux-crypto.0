From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Fri, 25 Apr 2008 09:37:51 +0200
Message-ID: <20080425073751.GC4460@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208403403.4322.27.camel@caritas-dev.intel.com> <20080423223221.GB16683@Chamillionaire.breakpoint.cc> <1209093077.20936.24.camel@caritas-dev.intel.com> <20080425071258.GA4460@Chamillionaire.breakpoint.cc> <1209108087.20936.30.camel@caritas-dev.intel.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: "Huang, Ying" <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44831 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYDYHh4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Apr 2008 03:37:56 -0400
Content-Disposition: inline
In-Reply-To: <1209108087.20936.30.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang, Ying | 2008-04-25 15:21:27 [+0800]:

>Hi, Sebastian,
Hi Huang,

>> >So I think the reason maybe the read/write port throughput of CPU.
>> Ah so it is just a local problem you say? I may get my fingers on
>> another amd box....
>
>I mean the read/write port design difference between CPU
>micro-architecture. It is not a local problem. Sorry for my English.
No, that is what I meant somehow. It is possible that AMD improved this
in a later CPU generation. The AMD box I have is a pretty old one in
comparison to Intel's dual core. It is also possible that they are
aiming a different target and nothing changed :)

>Best Regards,
>Huang Ying

Sebastian
