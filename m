From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Tue, 20 Sep 2016 13:23:35 +0100
Message-ID: <20160920122335.GA14477@SILVIXA00369791-F22-1>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
 <20160920092618.GA20808@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49094 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbcITMXi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 08:23:38 -0400
Content-Disposition: inline
In-Reply-To: <20160920092618.GA20808@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

apologies for the duplicate. The previous email didn't get delivered to
the ML.

On Tue, Sep 20, 2016 at 05:26:18PM +0800, Herbert Xu wrote:
> Rather than duplicating the scratch buffer handling in every scomp
> algorithm, let's centralize this and put it into scomp.c.
Are you suggesting to hide the scratch buffers from the scomp
implementations and allocate them inside crypto_register_scomp?
Does that mean we have to go back to a scomp_alg with a flat buffer API
and linearize inside scomp?
If we take this direction, how do we support DMA from scomp
implementation? Scratch buffers are allocated using vmalloc.

Thanks,

--
Giovanni
