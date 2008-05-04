From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Sun, 4 May 2008 20:56:10 +0200
Message-ID: <20080504185610.GA31398@Chamillionaire.breakpoint.cc>
References: <481BAD7A.3010003@swiss-it.ch> <20080503062113.GB30328@Chamillionaire.breakpoint.cc> <481C5029.9040406@swiss-it.ch>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken R?egsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47370 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbYEDS4M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 May 2008 14:56:12 -0400
Content-Disposition: inline
In-Reply-To: <481C5029.9040406@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken R?egsegger | 2008-05-03 13:44:41 [+0200]:

>Sebastian Siewior wrote:
>Hello Sebastian,
Hello, 

>Additionaly I just saw, that ecb(des) encryption test nr 5 passes but it
>seems that the setkey operation fails with:
>
>setkey() failed flags=100100
That is okey, that one has to fail. The algorithm should not allow
weak keys.

>-Adrian

Sebastian
