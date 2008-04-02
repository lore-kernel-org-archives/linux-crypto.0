From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 15:22:58 +0800
Message-ID: <20080402072258.GA7720@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au> <20080402071722.GF32234@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44411 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751724AbYDBHXF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 03:23:05 -0400
Content-Disposition: inline
In-Reply-To: <20080402071722.GF32234@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 02, 2008 at 09:17:22AM +0200, Sebastian Siewior wrote:
> I'm not sure if they have SMP or multicore out / plans but I gave a
> little thought on this early morning: The only problem is if we get
> swapped to another cores before encryption process beginns and after key
> reset thing. If the scheduler decides to swap cores than EFLAGS should
> be reloaded and wer are fine. The only problem that I see with cpus > 1
> is that we might reload the key if it is not required. This could be
> solved with old_ctx pointer beeing a percpu. 

Yeah I think having a percpu would be good even if it isn't needed
right now.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
