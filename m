From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: enable padlock on x86_64
Date: Tue, 21 Apr 2009 13:59:20 +0800
Message-ID: <20090421055920.GA14390@gondor.apana.org.au>
References: <49B83002.9040705@tobiasvolk.de> <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc> <20090314114732.GB3805@elte.hu> <20090314115307.GA28235@Chamillionaire.breakpoint.cc> <20090314132420.GB6080@gondor.apana.org.au> <20090420180931.7bd7ff02@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Ingo Molnar <mingo@elte.hu>, linux-crypto@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, mail@tobiasvolk.de
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49523 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752569AbZDUF7w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 01:59:52 -0400
Content-Disposition: inline
In-Reply-To: <20090420180931.7bd7ff02@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 20, 2009 at 06:09:31PM -0400, Chuck Ebbert wrote:
>
> #1 is in 2.6.30-rc now but I don't see #2 pending anywhere.

Thanks for the reminder.  I've now added it to cryptodev.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
