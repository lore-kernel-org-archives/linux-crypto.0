From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
Date: Fri, 13 Sep 2013 22:27:15 +0900
Message-ID: <201309132227.JEB13098.SOLFHFOOVFJMQt@I-love.SAKURA.ne.jp>
References: <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
	<20130912052806.GA15737@gondor.apana.org.au>
	<201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp>
	<20130912102953.GA18916@gondor.apana.org.au>
	<5231CF30.8050500@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, andr345@gmail.com,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	arthur.marsh@internode.on.net, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org
To: waiman.long@hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5231CF30.8050500@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Waiman Long wrote:
> I would like to report that I also have the same boot problem on a 
> RHEL6.4 box with the crypto patch. My workaround is to force kernel 
> build to have the crc_t10dif code built-in by changing the config file:
> 
> 4889c4889
> < CONFIG_CRYPTO_CRCT10DIF=m
> ---
>  > CONFIG_CRYPTO_CRCT10DIF=y
> 5002c5002
> < CONFIG_CRC_T10DIF=m
> ---
>  > CONFIG_CRC_T10DIF=y
> 
> This solved the boot problem without any additional patch.  Do you think 
> you should consider changing the configuration default to "y" instead of 
> "m" or doesn't allow the "m" option at all?

That was proposed but not accepted.
https://lkml.org/lkml/2013/7/17/543

You should choose CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y in your kernel config
if your CPU supports PCLMULQDQ.
