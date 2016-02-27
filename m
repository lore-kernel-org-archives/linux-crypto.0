From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] MPI: Endianness fix
Date: Sat, 27 Feb 2016 20:33:28 +0100
Message-ID: <20160227193328.GB9123@gondor.apana.org.au>
References: <1455716819-6771-1-git-send-email-mmarek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org
To: Michal Marek <mmarek@suse.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43479 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcB0Tdg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 14:33:36 -0500
Content-Disposition: inline
In-Reply-To: <1455716819-6771-1-git-send-email-mmarek@suse.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 17, 2016 at 02:46:59PM +0100, Michal Marek wrote:
> The limbs are integers in the host endianness, so we can't simply
> iterate over the individual bytes. The current code happens to work on
> little-endian, because the order of the limbs in the MPI array is the
> same as the order of the bytes in each limb, but it breaks on
> big-endian.
> 
> Fixes: 0f74fbf77d45 ("MPI: Fix mpi_read_buffer")
> Signed-off-by: Michal Marek <mmarek@suse.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
