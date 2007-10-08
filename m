From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Mon, 8 Oct 2007 14:35:04 +0200
Message-ID: <20071008123504.GC31712@Chamillionaire.breakpoint.cc>
References: <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc> <20071005151051.GA13666@gondor.apana.org.au> <20071007214227.GA25656@Chamillionaire.breakpoint.cc> <20071008032017.GB32087@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51167 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbXJHMfG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 08:35:06 -0400
Content-Disposition: inline
In-Reply-To: <20071008032017.GB32087@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-08 11:20:17 [+0800]:

>On Sun, Oct 07, 2007 at 11:42:27PM +0200, Sebastian Siewior wrote:
>> 
>> I tried to deadlock and I did not succeed, maybe I did something wrong.
>> 
>> # fgrep sha modules.alias 
>> alias sha256 padlock_sha
>> alias sha1 padlock_sha
>> alias sha384 sha512
>> alias sha256 sha256_generic
>> alias sha1 sha1_generic
>
>Try reversing this.  modprobe aliases are added to the head
>of the list so they'll come out in reverse.

# fgrep sha modules.alias
alias sha1 sha1_generic
alias sha256 sha256_generic
alias sha384 sha512
alias sha1 padlock_sha
alias sha256 padlock_sha

Still no dead-lock.

>Cheers,

Sebastian
