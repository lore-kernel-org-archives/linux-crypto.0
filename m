From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH 03/11] Optimized sha256 x86_64 assembly routine using
 Supplemental SSE3 instructions.
Date: Sun, 24 Mar 2013 14:26:30 +0200
Message-ID: <514EF0F6.4080604@iki.fi>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987750.8972.57.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363987750.8972.57.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 22.03.2013 23:29, Tim Chen wrote:
> Provides SHA256 x86_64 assembly routine optimized with SSSE3 instructions.
> Speedup of 40% or more has been measured over the generic implementation.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/sha256-ssse3-asm.S | 504 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 504 insertions(+)
>  create mode 100644 arch/x86/crypto/sha256-ssse3-asm.S
> 
> diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S

..snip..

> +
> +########################################################################
> +## void sha256_transform_ssse3(void *input_data, UINT32 digest[8], UINT64 num_blks)
> +## arg 1 : pointer to input data
> +## arg 2 : pointer to digest
> +## arg 3 : Num blocks
> +########################################################################
> +.text
> +.global sha256_transform_ssse3
> +.align 32
> +sha256_transform_ssse3:

Maybe use ENRTY/ENDPROC macros for exporting functions from assembly?

-Jussi
