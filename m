From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 9 Sep 2015 09:31:00 -0700
Message-ID: <55F05EC4.5080408@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <20150909161526.2828.55032.stgit@tstruk-mobl1>
 <2806088.jJiH2yOvUX@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbIIQcl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:32:41 -0400
In-Reply-To: <2806088.jJiH2yOvUX@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 09:27 AM, Stephan Mueller wrote:
>> +int sg_len(struct scatterlist *sg)
> unsigned int?

No, because it can return -EINVAL if you call it before you set the key.
