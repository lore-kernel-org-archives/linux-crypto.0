From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
Date: Thu, 18 Feb 2010 17:48:14 -0800
Message-ID: <m1d402t2qp.fsf@fess.ebiederm.org>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:41507 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab0BSBsW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2010 20:48:22 -0500
In-Reply-To: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com> (Richard Hartmann's message of "Fri\, 19 Feb 2010 01\:22\:03 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Richard Hartmann <richih.mailinglist@gmail.com> writes:

>  	seq_printf(m, "name         : %s\n", alg->cra_name);
>  	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
>  	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
>  	seq_printf(m, "priority     : %d\n", alg->cra_priority);
>  	seq_printf(m, "refcnt       : %d\n", atomic_read(&alg->cra_refcnt));
>  	seq_printf(m, "selftest     : %s\n",
> -		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
> -		   "passed" : "unknown");
> +	           (alg->cra_flags & CRYPTO_ALG_TESTED) ?
> +	           "passed" : "unknown");

Why did you replaced a tab with spaces here??


Eric
