From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Wed, 15 Aug 2012 16:48:54 +0300
Message-ID: <20120815164854.11913imktb2fg90k@www.81.fi>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
 <20120815140016.76673zs818g2hagw@www.81.fi>
 <20120815125220.GB4409@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?b?TfxsbGVy?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120815125220.GB4409@x1.osrc.amd.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Borislav Petkov <bp@alien8.de>:

> Ok, here we go. Raw data below.

Thanks alot!

Twofish-avx appears somewhat slower than 3way, ~9% slower with 256byte  
blocks to ~3% slower with 8kb blocks.

>

<snip>

>
> Let me know if you need more tests.

I posted patch that optimize twofish-avx few weeks ago:  
http://marc.info/?l=linux-crypto-vger&m=134364845024825&w=2

I'd be interested to know, if this is patch helps on Bulldozer.

-Jussi

>
> HTH.
>
> --
> Regards/Gruss,
> Boris.
>
>
