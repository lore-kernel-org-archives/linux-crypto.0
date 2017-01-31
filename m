From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - zero esram only for DH85x devices
Date: Tue, 31 Jan 2017 13:35:15 +0000
Message-ID: <20170131133515.GA961@silv-gc1>
References: <20161222150024.6122-1-giovanni.cabiddu@intel.com>
 <20161230122011.GE15832@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28825 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdAaNfS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2017 08:35:18 -0500
Content-Disposition: inline
In-Reply-To: <20161230122011.GE15832@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Fri, Dec 30, 2016 at 08:20:11PM +0800, Herbert Xu wrote:
> On Thu, Dec 22, 2016 at 03:00:24PM +0000, Giovanni Cabiddu wrote:
> > Zero embedded ram in DH85x devices. This is not
> > needed for newer generations as it is done by HW.
> > 
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> 
> Patch applied.  Thanks.
We realized that two patches I submitted in December (and now applied
to cryptodev-2.6) are needed to avoid a null pointer dereference
when loading the qat driver on some specific c62x devices:

841d6d10b38a2508c640ce: crypto: qat - zero esram only for DH85x devices
4f78ce870a4da0cf4db265: crypto: qat - fix bar discovery for c62x

This problem was introduced in 4.5 when we sent the c62x driver and
we recommend it should go to the stable kernels, 4.8.17 and 4.9.6.
Should I re-send these two patches to stable after they are merged
in Linus’ tree?

Thanks,

-- 
Giovanni
