From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Mon, 01 Dec 2014 07:03:00 -0800
Message-ID: <547C8324.4000801@intel.com>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1> <20141201144026.GA18008@gondor.apana.org.au> <547C80F5.6000006@intel.com> <20141201150010.GA18277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbaLAPF6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 10:05:58 -0500
In-Reply-To: <20141201150010.GA18277@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/01/2014 07:00 AM, Herbert Xu wrote:
> As I said the two are arbitrary and we don't place any restrictions
> on them at all (apart from the fact that the TX length in bytes must
> obviously be longer than the RX bytes).
> 
> So you can have a 1-element TX list with a multi-element RX list.

Ok, I can look at the data, but do you think the idea with marking the
end of data in TX sgl is worthwhile or should I just forget about it.
Another question is - is an sgl with lots of empty buffers a valid input
from an algorithm implementation point of view?
Thanks,
Tadeusz
