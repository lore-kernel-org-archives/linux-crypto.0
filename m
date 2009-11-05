From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new
	instructions via gas macro
Date: Thu, 5 Nov 2009 09:40:28 -0500
Message-ID: <73c1f2160911050640u45f47e46yf6e18101231c2729@mail.gmail.com>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@elte.hu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757331AbZKEOkb@vger.kernel.org>
In-Reply-To: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 5, 2009 at 1:44 AM, Huang Ying <ying.huang@intel.com> wrote=
:
> It will take some time for binutils (gas) to support some newly added
> instructions, such as SSE4.1 instructions or the AES-NI instructions
> found in upcoming Intel CPU.
>
> To make the source code can be compiled by old binutils, .byte code i=
s
> used instead of the assembly instruction. But the readability and
> flexibility of raw .byte code is not good.
>
> This patch solves the issue of raw .byte code via generating it via
> assembly instruction like gas macro. The syntax is as close as
> possible to real assembly instruction.
>
> Some helper macros such as MODRM is not a full feature
> implementation. It can be extended when necessary.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
> =C2=A0arch/x86/include/asm/inst.h | =C2=A0150 +++++++++++++++++++++++=
+++++++++++++++++++++
> =C2=A01 file changed, 150 insertions(+)
>
> --- /dev/null
> +++ b/arch/x86/include/asm/inst.h
> @@ -0,0 +1,150 @@
> +/*
> + * Generate .byte code for some instructions not supported by old
> + * binutils.
> + */
> +#ifndef X86_ASM_INST_H
> +#define X86_ASM_INST_H
> +
> +#ifdef __ASSEMBLY__
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro XMM_NUM opd xmm
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm0
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 0
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm1
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 1
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm2
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 2
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm3
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 3
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm4
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 4
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm5
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 5
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm6
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 6
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm7
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 7
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm8
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 8
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm9
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 9
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm10
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 10
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm11
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 11
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm12
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 12
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm13
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 13
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm14
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 14
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .ifc \xmm,%xmm15
> + =C2=A0 =C2=A0 =C2=A0 \opd =3D 15
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x66
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro PFX_REX opd1 opd2
> + =C2=A0 =C2=A0 =C2=A0 .if (\opd1 | \opd2) & 8
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8)=
 >> 1)
> + =C2=A0 =C2=A0 =C2=A0 .endif
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro MODRM mod opd1 opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte \mod | (\opd1 & 7) | ((\opd2 & 7) << 3)
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro PSHUFB_XMM xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM pshufb_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM pshufb_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX pshufb_opd1 pshufb_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0x00
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 pshufb_opd1 pshufb_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro PCLMULQDQ imm8 xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM clmul_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM clmul_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX clmul_opd1 clmul_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x3a, 0x44
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 clmul_opd1 clmul_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte \imm8
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESKEYGENASSIST rcon xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aeskeygen_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aeskeygen_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aeskeygen_opd1 aeskeygen_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x3a, 0xdf
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aeskeygen_opd1 aeskeygen_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte \rcon
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESIMC xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesimc_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesimc_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aesimc_opd1 aesimc_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0xdb
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aesimc_opd1 aesimc_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESENC xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesenc_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesenc_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aesenc_opd1 aesenc_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0xdc
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aesenc_opd1 aesenc_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESENCLAST xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesenclast_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesenclast_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aesenclast_opd1 aesenclast_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0xdd
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aesenclast_opd1 aesenclast_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESDEC xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesdec_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesdec_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aesdec_opd1 aesdec_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0xde
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aesdec_opd1 aesdec_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +
> + =C2=A0 =C2=A0 =C2=A0 .macro AESDECLAST xmm1 xmm2
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesdeclast_opd1 \xmm1
> + =C2=A0 =C2=A0 =C2=A0 XMM_NUM aesdeclast_opd2 \xmm2
> + =C2=A0 =C2=A0 =C2=A0 PFX_OPD_SIZE
> + =C2=A0 =C2=A0 =C2=A0 PFX_REX aesdeclast_opd1 aesdeclast_opd2
> + =C2=A0 =C2=A0 =C2=A0 .byte 0x0f, 0x38, 0xdf
> + =C2=A0 =C2=A0 =C2=A0 MODRM 0xc0 aesdeclast_opd1 aesdeclast_opd2
> + =C2=A0 =C2=A0 =C2=A0 .endm
> +#endif
> +
> +#endif

It would be nice to document which version of GAS added support for
each instruction, so that if/when that version becomes the minimum
supported these macros can be removed.

--
Brian Gerst
