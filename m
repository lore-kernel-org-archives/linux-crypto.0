From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/mpi: purge mpi_set_buffer()
Date: Tue, 31 May 2016 18:18:36 +0800
Message-ID: <20160531101836.GJ15376@gondor.apana.org.au>
References: <1464260270-3525-1-git-send-email-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40013 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcEaKSr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:18:47 -0400
Content-Disposition: inline
In-Reply-To: <1464260270-3525-1-git-send-email-nicstange@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 26, 2016 at 12:57:50PM +0200, Nicolai Stange wrote:
> mpi_set_buffer() has no in-tree users and similar functionality is provided
> by mpi_read_raw_data().
> 
> Remove mpi_set_buffer().
> 
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
