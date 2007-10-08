From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Mon, 8 Oct 2007 11:20:17 +0800
Message-ID: <20071008032017.GB32087@gondor.apana.org.au>
References: <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc> <20071005151051.GA13666@gondor.apana.org.au> <20071007214227.GA25656@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1599 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752549AbXJHDUU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 23:20:20 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IejAI-0005Fb-LJ
	for <linux-crypto@vger.kernel.org>; Mon, 08 Oct 2007 13:20:18 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IejAI-0008N4-00
	for <linux-crypto@vger.kernel.org>; Mon, 08 Oct 2007 11:20:18 +0800
Content-Disposition: inline
In-Reply-To: <20071007214227.GA25656@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 07, 2007 at 11:42:27PM +0200, Sebastian Siewior wrote:
> 
> I tried to deadlock and I did not succeed, maybe I did something wrong.
> 
> # fgrep sha modules.alias 
> alias sha256 padlock_sha
> alias sha1 padlock_sha
> alias sha384 sha512
> alias sha256 sha256_generic
> alias sha1 sha1_generic

Try reversing this.  modprobe aliases are added to the head
of the list so they'll come out in reverse.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
