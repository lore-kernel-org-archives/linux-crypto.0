From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 06/11] Create module providing optimized SHA256
 routines using SSSE3, AVX or AVX2 instructions.
Date: Mon, 25 Mar 2013 13:40:40 -0700
Message-ID: <1364244040.8972.71.camel@schen9-DESK>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com>
	 <1363987761.8972.60.camel@schen9-DESK>  <514F75BB.3080501@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299Ab3CYUk6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Mar 2013 16:40:58 -0400
In-Reply-To: <514F75BB.3080501@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2013-03-24 at 23:52 +0200, Jussi Kivilinna wrote:
> On 22.03.2013 23:29, Tim Chen wrote:
> > We added glue code and config options to create crypto
> > module that uses SSE/AVX/AVX2 optimized SHA256 x86_64 assembly routines.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> ..snip..
> 
> > diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> > new file mode 100644
> > index 0000000..5876a19
> > --- /dev/null
> > +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> 
> ..snip..
> 
> > +static int __init sha256_ssse3_mod_init(void)
> > +{
> > +	/* test for SSE3 first */
> > +	if (cpu_has_xmm3)
> > +		sha256_transform_asm = sha256_transform_ssse3;
> > +
> 
> This causes OOPS on my computer. Maybe use 'cpu_has_ssse3' instead?
> 

Thanks and appreciate your feedback.  I'll be sending an update of the
patch series to address the issues.

Tim
