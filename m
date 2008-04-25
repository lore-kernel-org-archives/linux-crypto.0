From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Fri, 25 Apr 2008 11:11:17 +0800
Message-ID: <1209093077.20936.24.camel@caritas-dev.intel.com>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208403403.4322.27.camel@caritas-dev.intel.com>
	 <20080423223221.GB16683@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-e4MwOGhfTpfFhDKhqpUs"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757105AbYDYDGl@vger.kernel.org>
In-Reply-To: <20080423223221.GB16683@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-e4MwOGhfTpfFhDKhqpUs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, Sebastian,

Thank you very much for your help. From the result you sent, the biggest
performance degradation is between step 4 and step 5. In that step, one
more register is saved before and restored after encryption/decryption.
So I think the reason maybe the read/write port throughput of CPU.

I changed the patches to group the read or write together instead of
interleaving. Can you help me to test these new patches? The new patches
is attached with the mail.

Best Regards,
Huang Ying

On Thu, 2008-04-24 at 00:32 +0200, Sebastian Siewior wrote:
> * Huang, Ying | 2008-04-17 11:36:43 [+0800]:
> 
> >Hi, Sebastian,
> Hi Huang,
> 
> >The files attached is the separated patches, from step1 to step 7. Thank
> >you very much for your help.
> I've run the following script:
> 
> |#!/bin/bash
> |check_error()
> |{
> |        r=$?
> |        if [ ! $r -eq 0 ]
> |        then
> |                exit 1
> |        fi
> |}
> |
> |modprobe tcrypt mode=200
> |modprobe tcrypt mode=200
> |dmesg -c > step-0.txt
> |
> |for ((i=1; i<=7; i++))
> |do
> |        quilt push step${i}.patch
> |        check_error
> |
> |        make
> |        check_error
> |
> |        rmmod aes_x86_64
> |        check_error
> |
> |        insmod arch/x86/crypto/aes-x86_64.ko
> |        check_error
> |
> |        modprobe tcrypt mode=200
> |        modprobe tcrypt mode=200
> |        dmesg -c > step-${i}.txt
> |done
> 
> and the result is attached.
> 
> >Best Regards,
> >Huang Ying
> 
> Sebastian

--=-e4MwOGhfTpfFhDKhqpUs
Content-Disposition: attachment; filename=patches.tbz2
Content-Type: application/x-bzip-compressed-tar; name=patches.tbz2
Content-Transfer-Encoding: base64

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
S5ENZrbkGgLk4oA2kU/4u5IpwoSAscFwKA==


--=-e4MwOGhfTpfFhDKhqpUs--
