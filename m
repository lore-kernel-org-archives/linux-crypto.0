From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/5] crypto: AES CBC multi-buffer glue code
Date: Thu, 29 Oct 2015 03:03:54 +0100
Message-ID: <2511888.9MT8h10EQL@tauon.atsec.com>
References: <cover.1445565339.git.tim.c.chen@linux.intel.com> <1446067169.14635.7.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34446 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbJ2CEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Oct 2015 22:04:00 -0400
In-Reply-To: <1446067169.14635.7.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Oktober 2015, 14:19:29 schrieb Tim Chen:

Hi Tim,

>+
>+	/* check for dependent cpu features */
>+	if (!cpu_has_aes) {
>+		pr_err("aes_cbc_mb_mod_init: no aes support\n");
>+		err = -ENODEV;
>+		goto err1;
>+	}

In your post 0/5, you say that this mechanism needs AVX2. In the existing 
AESNI glue code I find

#ifdef CONFIG_X86_64
#ifdef CONFIG_AS_AVX2
        if (boot_cpu_has(X86_FEATURE_AVX2)) {

...

Why would that CPU check not be needed here?

Ciao
Stephan
