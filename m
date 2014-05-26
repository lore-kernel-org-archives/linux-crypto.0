From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Date: Mon, 26 May 2014 07:44:15 +0200
Message-ID: <2006828.NMLXLGt5ck@myon.chronox.de>
References: <20140523211007.GA20955@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140523211007.GA20955@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 24. Mai 2014, 05:10:07 schrieb Herbert Xu:

Hi Herbert,

> Stephan Mueller <smueller@chronox.de> wrote:
> > +       memset(&drbg_algs[i], 0, sizeof(struct crypto_alg));
> > +       if (pr) {
> > +               memcpy(drbg_algs[i].cra_name, "drbg(pr(", 8);
> > +               memcpy(drbg_algs[i].cra_driver_name, "drbg_pr_", 8);
> > +               pos = 8;
> 
> You shouldn't use the brackets here since this not a real template.
> Just use one name for both cra_name and cra_driver_name.

Thanks for the hint: I would use the name specified for cra_driver_name also 
for cra_name
> 
> Cheers,


Ciao
Stephan
-- 
| Cui bono? |
