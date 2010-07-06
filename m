From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH v3]crypto:hifn_795x.c Fix warning: variable 'ctx' set but not used
Date: Tue, 6 Jul 2010 22:58:53 +0400
Message-ID: <20100706185853.GA27664@ioremap.net>
References: <1278441397-10960-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, jkosina@suse.cz, kim.phillips@freescale.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from matrixpower.ru ([195.178.208.66]:39462 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0GFTcv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 15:32:51 -0400
Content-Disposition: inline
In-Reply-To: <1278441397-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 06, 2010 at 11:36:37AM -0700, Justin P. Mattock (justinmattock@gmail.com) wrote:
> The below patch gets rid of an unused variable ctx reported by
> GCC when building the kernel.
>   CC [M]  drivers/crypto/hifn_795x.o
> drivers/crypto/hifn_795x.c: In function 'hifn_flush':
> drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
> drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
> drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Looks good, thank you.
I can only wonder how I wanted to use it in that context...

-- 
	Evgeniy Polyakov
