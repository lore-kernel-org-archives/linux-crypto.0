From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Mon, 01 Dec 2014 06:53:41 -0800
Message-ID: <547C80F5.6000006@intel.com>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1> <20141201144026.GA18008@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1437 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaLAO5F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 09:57:05 -0500
In-Reply-To: <20141201144026.GA18008@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 12/01/2014 06:40 AM, Herbert Xu wrote:
>> +			nents = sg_nents(ctx->rsgl.sg);
>> > +			sg_mark_end(&sg[nents - 1]);
> Huh? You're getting nents from the RX side and using it to mark
> the TX side? This makes no sense because RX may have no relationship
> whatsoever with TX.

Yes, but there shouldn't be more nents with data to be processed in TX
than nents in RX and in most cases they should be equal. Or am I missing
something?
Thanks,
Tadeusz
