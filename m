From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [patch] crypto: caam - writel() arguments are swapped
Date: Mon, 24 Feb 2014 18:41:42 -0600
Message-ID: <20140224184142.b8d3a2cfb35dfe5f31d332ee@freescale.com>
References: <20140221085131.GB13078@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Alex Porosanu <alexandru.porosanu@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	<linux-crypto@vger.kernel.org>, Steve Cornelius <sec@pobox.com>,
	<kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:30682
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbaBYAq7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Feb 2014 19:46:59 -0500
In-Reply-To: <20140221085131.GB13078@elgon.mountain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 21 Feb 2014 11:51:31 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> My guess is that this little endian configuration is never found in real
> life, 

it is, but the code has not been upstreamed.  Steve?

> but if it were then the writel() arguments are in the wrong order
> so the driver would crash immediately.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Meanwhile:

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Kim
