From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qce: dma_map_sg can handle chained SG
Date: Wed, 4 Nov 2015 13:02:07 +0800
Message-ID: <20151104050207.GA25442@gondor.apana.org.au>
References: <20151001140106.GC27726@gondor.apana.org.au>
 <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
 <56388EFD.5080509@mm-sol.com>
 <20151103123655.GA5178@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, davem@davemloft.net,
	cristian.stoica@freescale.com, axboe@fb.com,
	dan.j.williams@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36708 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbKDFC3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Nov 2015 00:02:29 -0500
Content-Disposition: inline
In-Reply-To: <20151103123655.GA5178@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 03, 2015 at 01:36:55PM +0100, LABBE Corentin wrote:
>
> Herbert, do you prefer to drop the patch series and I send an updated one, or does I will send a new patch series for checking the return value of sg_nents_for_len() ?

Your patch has already been applied so please send any fixes on
top of it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
