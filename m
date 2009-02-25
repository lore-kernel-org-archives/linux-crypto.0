From: Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 16:56:27 +0100
Message-ID: <49A56A2B.4040305@f-seidel.de>
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Frank Seidel <fseidel@suse.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
	lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:57746 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbZBYP4c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 10:56:32 -0500
In-Reply-To: <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven wrote:
> BTW, why are you using printk(KERN_INFO "..."), and not pr_info("...")?

Without special reason. Is pr_info preferred?

Thanks,
Frank
