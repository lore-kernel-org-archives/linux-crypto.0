From: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 17:01:50 +0100
Message-ID: <49A56B6E.9090600@suse.de>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be> <49A56A2B.4040305@f-seidel.de> <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Frank Seidel <frank@f-seidel.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:53342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZBYQCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 11:02:11 -0500
In-Reply-To: <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven wrote:
> It's shorter.
> 
> Especially `pr_err' fits in the space of `printk', so you don't have to split
> lines that become to long due to adding the KERN_*.

Ah, i see. Thanks for the explanation :-)

Frank

