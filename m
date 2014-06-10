From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v4 1/1] crypto: AES CTR x86_64 "by8" AVX optimization
Date: Tue, 10 Jun 2014 09:08:12 +0200
Message-ID: <CA+rthh_OLUWbpTc53AZvK3_Ldw4nzH=AZK6Sr5yabHTNrRoM2w@mail.gmail.com>
References: <1402335711.2363.8.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	James Guilford <james.guilford@intel.com>,
	"Tadeusz Struk,Huang Ying" <ying.huang@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35022 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbaFJHIO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jun 2014 03:08:14 -0400
Received: by mail-la0-f42.google.com with SMTP id el20so3714364lab.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2014 00:08:12 -0700 (PDT)
In-Reply-To: <1402335711.2363.8.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9 June 2014 19:41, chandramouli narayanan <mouli@linux.intel.com> wrote:
> [...]
> @@ -1493,6 +1521,14 @@ static int __init aesni_init(void)
>                 aesni_gcm_enc_tfm = aesni_gcm_enc;
>                 aesni_gcm_dec_tfm = aesni_gcm_dec;
>         }
> +       aesni_ctr_enc_tfm = aesni_ctr_enc;
> +#ifdef CONFIG_AS_AVX
> +       if (cpu_has_avx) {
> +               /* optimize performance of ctr mode encryption trasform */

The "trasform" typo is also still there. :/

> +               aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
> +               pr_info("AES CTR mode by8 optimization enabled\n");
> +       }
> +#endif
>  #endif
>
>         err = crypto_fpu_init();

Mathias
