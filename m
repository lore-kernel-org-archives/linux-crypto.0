From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Tue, 25 Nov 2008 23:20:14 +0800
Message-ID: <20081125152014.GB29096@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au> <20081125085820.GA11401@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753275AbYKYPWF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081125085820.GA11401@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 25, 2008 at 09:58:21AM +0100, Ingo Molnar wrote:
> 
> Noticed the bug below while running our -Werror x86 randconfig build 
> tests against tip/master. Please double check my control flow 
> analysis.

Good catch, I'll apply this patch. Thanks Ingo!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
