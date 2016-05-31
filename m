From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] lib/mpi: mpi_read_raw_data(): purge redundant
 clearing of nbits
Date: Tue, 31 May 2016 18:18:52 +0800
Message-ID: <20160531101852.GK15376@gondor.apana.org.au>
References: <1464260732-4446-1-git-send-email-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58750 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcEaKS7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:18:59 -0400
Content-Disposition: inline
In-Reply-To: <1464260732-4446-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 26, 2016 at 01:05:31PM +0200, Nicolai Stange wrote:
> In mpi_read_raw_data(), unsigned nbits is calculated as follows:
> 
>  nbits = nbytes * 8;
> 
> and redundantly cleared later on if nbytes == 0:
> 
>   if (nbytes > 0)
>     ...
>   else
>     nbits = 0;
> 
> Purge this redundant clearing for the sake of clarity.
> 
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
