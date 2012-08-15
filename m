From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Wed, 15 Aug 2012 14:00:16 +0300
Message-ID: <20120815140016.76673zs818g2hagw@www.81.fi>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
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
In-Reply-To: <20120815092804.GA14676@x1.osrc.amd.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Borislav Petkov <bp@alien8.de>:

> On Wed, Aug 15, 2012 at 11:42:16AM +0300, Jussi Kivilinna wrote:
>> I started thinking about the performance on AMD Bulldozer.
>> vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers
>> on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on
>> Intel sandy-bridge (where instructions have latency of 1 to 2). See:
>> http://www.agner.org/optimize/instruction_tables.pdf
>>
>> It would be really good, if implementation could be tested on AMD CPU
>> to determinate, if it causes performance regression. However I don't
>> have access to machine with such CPU.
>
> But I do. :)
>
> And if you tell me exactly how to run the tests and on what kernel, I'll
> try to do so.
>

Twofish-avx (CONFIG_TWOFISH_AVX_X86_64) is available in 3.6-rc1. For  
testing you need CRYPTO_TEST build as module. You should turn off  
turbo-core, freq-scaling, etc.

Testing twofish-avx ('async twofish' speed test):
  modprobe twofish-avx-x86_64
  modprobe tcrypt mode=504 sec=1

Testing twofish-x86_64-3way ('sync twofish' speed test):
  modprobe twofish-x86_64-3way
  modprobe tcrypt mode=202 sec=1

Loading tcrypt will block until tests are complete, after which  
modprobe will return with error. This is expected. Results are in  
kernel log.

-Jussi

> HTH.
>
> --
> Regards/Gruss,
> Boris.
>
>
