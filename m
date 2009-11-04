From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH	implementation
Date: Tue, 03 Nov 2009 16:59:00 -0800
Message-ID: <4AF0D1D4.7090907@zytor.com>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu> <20091102142824.GA31981@gondor.apana.org.au> <20091102143258.GA23776@elte.hu> <1257227236.30470.1192.camel@yhuang-dev.sh.intel.com> <20091103090322.GA11988@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751869AbZKDBGK@vger.kernel.org>
In-Reply-To: <20091103090322.GA11988@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/03/2009 01:03 AM, Ingo Molnar wrote:
>>
>> .macro xmm_num opd xmm
>> .ifc \xmm,%xmm0
>> \opd = 0
>> .endif
>> .ifc \xmm,%xmm1
>> \opd = 1
>> .endif
>> .ifc \xmm,%xmm2
>> \opd = 2
>> .endif
>> .ifc \xmm,%xmm3
>> \opd = 3
>> .endif
>> .ifc \xmm,%xmm4
>> \opd = 4
>> .endif
>> .ifc \xmm,%xmm5
>> \opd = 5
>> .endif
>> .ifc \xmm,%xmm6
>> \opd = 6
>> .endif
>> .ifc \xmm,%xmm7
>> \opd = 7
>> .endif
>> .ifc \xmm,%xmm8
>> \opd = 8
>> .endif
>> .ifc \xmm,%xmm9
>> \opd = 9
>> .endif
>> .ifc \xmm,%xmm10
>> \opd = 10
>> .endif
>> .ifc \xmm,%xmm11
>> \opd = 11
>> .endif
>> .ifc \xmm,%xmm12
>> \opd = 12
>> .endif
>> .ifc \xmm,%xmm13
>> \opd = 13
>> .endif
>> .ifc \xmm,%xmm14
>> \opd = 14
>> .endif
>> .ifc \xmm,%xmm15
>> \opd = 15
>> .endif
>> .endm
>>
>> .macro PSHUFB_XMM xmm1 xmm2
>> xmm_num pshufb_opd1 \xmm1
>> xmm_num pshufb_opd2 \xmm2
>> .if (pshufb_opd1 < 8) && (pshufb_opd2 < 8)
>> .byte 0x66, 0x0f, 0x38, 0x00, 0xc0 | pshufb_opd1 | (pshufb_opd2<<3)
>> .elseif (pshufb_opd1 >= 8) && (pshufb_opd2 < 8)
>> .byte 0x66, 0x41, 0x0f, 0x38, 0x00, 0xc0 | (pshufb_opd1-8) | (pshufb_opd2<<3)
>> .elseif (pshufb_opd1 < 8) && (pshufb_opd2 >= 8)
>> .byte 0x66, 0x44, 0x0f, 0x38, 0x00, 0xc0 | pshufb_opd1 | ((pshufb_opd2-8)<<3)
>> .else
>> .byte 0x66, 0x45, 0x0f, 0x38, 0x00, 0xc0 | (pshufb_opd1-8) | ((pshufb_opd2-8)<<3)
>> .endif
>> .endm
> 
> Looks far too clever, i like it :-) We have quite a few assembly macros 
> in arch/x86/include/asm/. The above one could be put into calling.h for 
> example.
> 

I would really like to see something like that, with only one minor
tweak: please use submacros to generate the REX and MODRM bytes, since
we are *guaranteed* to want to do the same thing again.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
