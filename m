From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [v3 PATCH 2/8] crypto: rsa - Generate fixed-length output
Date: Wed, 29 Jun 2016 11:23:06 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0319396ED@IRSMSX102.ger.corp.intel.com>
References: <20160629102649.GA26987@gondor.apana.org.au>
 <E1bICk5-00072W-Td@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	"Mat Martineau" <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:15764 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbcF2LXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:23:09 -0400
In-Reply-To: <E1bICk5-00072W-Td@gondolin.me.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> 
> This patch also changes DH to use the new interface.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/rsa.c        |    8 +++----
>  include/linux/mpi.h |    2 -
>  lib/mpi/mpicoder.c  |   55 ++++++++++++++++++++++++-----------------------
> -----
>  3 files changed, 31 insertions(+), 34 deletions(-)
> 

I don't see the DH change in this patch.

Regards,
Salvatore
