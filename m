From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] AMCC Crypto4xx Device Driver v7
Date: Sun, 21 Jun 2009 21:53:11 +0800
Message-ID: <20090621135311.GA3185@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B07D83E96@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kim.phillips@freescale.com, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47582 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbZFUNxg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 09:53:36 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B07D83E96@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Shasi Pulijala <spulijala@amcc.com> wrote:
> Hi,
>        I am re-sending this patch as a patch series of 3, I am assuming the earlier one did not go through the mailing lists
> because it was over the size limit.

Actually the original patch came through the list and to me :)

However I'm not against splitting it up, but if you are going to
do it please make sure that each patch compiles by itself since
we want a bisectable tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
