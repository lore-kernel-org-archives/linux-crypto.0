From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 5/5] crypto: AES CBC multi-buffer glue code
Date: Thu, 29 Oct 2015 09:19:23 -0700
Message-ID: <1446135563.14635.11.camel@schen9-desk2.jf.intel.com>
References: <cover.1445565339.git.tim.c.chen@linux.intel.com>
	 <1446067169.14635.7.camel@schen9-desk2.jf.intel.com>
	 <2511888.9MT8h10EQL@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2511888.9MT8h10EQL@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2015-10-29 at 03:03 +0100, Stephan Mueller wrote:
> Am Mittwoch, 28. Oktober 2015, 14:19:29 schrieb Tim Chen:
> 
> Hi Tim,
> 
> >+
> >+	/* check for dependent cpu features */
> >+	if (!cpu_has_aes) {
> >+		pr_err("aes_cbc_mb_mod_init: no aes support\n");
> >+		err = -ENODEV;
> >+		goto err1;
> >+	}
> 
> In your post 0/5, you say that this mechanism needs AVX2. In the existing 
> AESNI glue code I find
> 
> #ifdef CONFIG_X86_64
> #ifdef CONFIG_AS_AVX2
>         if (boot_cpu_has(X86_FEATURE_AVX2)) {
> 
> ...
> 
> Why would that CPU check not be needed here?

Good catch.  Will add check for avx2.

Tim

> 
> Ciao
> Stephan
