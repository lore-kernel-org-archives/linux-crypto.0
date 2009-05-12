From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/2 v2] crypto: skip algs not flagged fips_allowed in
	fips mode
Date: Tue, 12 May 2009 15:09:59 -0400
Message-ID: <20090512190959.GG5019@hmsreliant.think-freely.org>
References: <200905110953.06678.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41578 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZELTKH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2009 15:10:07 -0400
Content-Disposition: inline
In-Reply-To: <200905110953.06678.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2009 at 09:53:06AM -0400, Jarod Wilson wrote:
> Because all fips-allowed algorithms must be self-tested before they
> can be used, they will all have entries in testmgr.c's alg_test_descs[].
> Skip self-tests for any algs not flagged as fips_approved and return
> -EINVAL when in fips mode.
> 
> Resending with properly updated patch v2 tag.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
