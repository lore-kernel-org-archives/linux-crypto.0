From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Mon, 26 Sep 2016 21:46:18 -0300
Message-ID: <20160927004618.GA5010@dublin>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754852AbcI0Aqf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 20:46:35 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8R0hEkf074512
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2016 20:46:34 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25q5c8fgqq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2016 20:46:34 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Mon, 26 Sep 2016 21:46:32 -0300
Content-Disposition: inline
In-Reply-To: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fri, Sep 23, 2016 at 04:31:56PM -0300, Marcelo Cerri wrote:
> The driver does not handle endianness properly when loading the input
> data.

Indeed. I tested in both endianesses and it's working fine. Thanks!

Herbert, can we go ahead with this fix?

> 
> Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
> ---
>  arch/powerpc/crypto/sha1-powerpc-asm.S | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/crypto/sha1-powerpc-asm.S b/arch/powerpc/crypto/sha1-powerpc-asm.S
> index 125e165..82ddc9b 100644
> --- a/arch/powerpc/crypto/sha1-powerpc-asm.S
> +++ b/arch/powerpc/crypto/sha1-powerpc-asm.S
> @@ -7,6 +7,15 @@
>  #include <asm/ppc_asm.h>
>  #include <asm/asm-offsets.h>
> 
> +#ifdef __BIG_ENDIAN__
> +#define LWZ(rt, d, ra)	\
> +	lwz	rt,d(ra)
> +#else
> +#define LWZ(rt, d, ra)	\
> +	li	rt,d;	\
> +	lwbrx	rt,rt,ra
> +#endif
> +
>  /*
>   * We roll the registers for T, A, B, C, D, E around on each
>   * iteration; T on iteration t is A on iteration t+1, and so on.
> @@ -23,7 +32,7 @@
>  #define W(t)	(((t)%16)+16)
> 
>  #define LOADW(t)				\
> -	lwz	W(t),(t)*4(r4)
> +	LWZ(W(t),(t)*4,r4)
> 
>  #define STEPD0_LOAD(t)				\
>  	andc	r0,RD(t),RB(t);		\
> @@ -33,7 +42,7 @@
>  	add	r0,RE(t),r15;			\
>  	add	RT(t),RT(t),r6;		\
>  	add	r14,r0,W(t);			\
> -	lwz	W((t)+4),((t)+4)*4(r4);	\
> +	LWZ(W((t)+4),((t)+4)*4,r4);	\
>  	rotlwi	RB(t),RB(t),30;			\
>  	add	RT(t),RT(t),r14
> 
> -- 
> 2.7.4
> 

-- 
Paulo Flabiano Smorigo
IBM Linux Technology Center
