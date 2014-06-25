From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 1/4] crypto: qat: Fix random config build warnings
Date: Wed, 25 Jun 2014 06:52:16 -0700
Message-ID: <53AAD410.4090400@intel.com>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com> <20140624221924.3872.42454.stgit@tstruk-mobl1.intel.com> <20140625133658.GA10122@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10578 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbaFYNzg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:55:36 -0400
In-Reply-To: <20140625133658.GA10122@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/25/2014 06:36 AM, Herbert Xu wrote:
>>  	struct icp_qat_fw_la_resp *qat_resp = resp;
>> >  	struct qat_crypto_request *qat_req =
>> > -			(void *)(dma_addr_t)qat_resp->opaque_data;
>> > +				(void *)(__force long)qat_resp->opaque_data;
> Why not just get rid of the (__force long) altogether?
It complains when cross compiled for 32bit.
Regards.
Tadeusz
