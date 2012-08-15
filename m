From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Date: Wed, 15 Aug 2012 11:28:04 +0200
Message-ID: <20120815092804.GA14676@x1.osrc.amd.com>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120815114216.209814z4mq3hxqe8@www.81.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 15, 2012 at 11:42:16AM +0300, Jussi Kivilinna wrote:
> I started thinking about the performance on AMD Bulldozer.
> vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers
> on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on
> Intel sandy-bridge (where instructions have latency of 1 to 2). See:
> http://www.agner.org/optimize/instruction_tables.pdf
>
> It would be really good, if implementation could be tested on AMD CPU
> to determinate, if it causes performance regression. However I don't
> have access to machine with such CPU.

But I do. :)

And if you tell me exactly how to run the tests and on what kernel, I'll
try to do so.

HTH.

-- 
Regards/Gruss,
Boris.
