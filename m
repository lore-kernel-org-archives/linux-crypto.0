From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 1/4] MPILIB: add mpi_read_buf() and mpi_get_size()
 helpers
Date: Tue, 16 Jun 2015 14:40:18 +0800
Message-ID: <20150616064018.GA22118@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201836.15697.27743.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46275 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbFPGkc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:40:32 -0400
Content-Disposition: inline
In-Reply-To: <20150615201836.15697.27743.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:18:36PM -0700, Tadeusz Struk wrote:
> Added a mpi_read_buf() helper function to export MPI to a buf provided by
> the user, and a mpi_get_size() helper, that tells the user how big the buf is.
> Changed mpi_free to use kzfree instead of kfree because it is used to free
> crypto keys.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
