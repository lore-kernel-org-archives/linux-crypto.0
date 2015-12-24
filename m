From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v4] crypto: KEYS: convert public key and digsig asym to
 the akcipher api
Date: Wed, 23 Dec 2015 19:00:39 -0800
Message-ID: <567B5FD7.3090600@intel.com>
References: <20151223143352.5035.85876.stgit@tstruk-mobl1>
 <20151223145130.GA2598@gondor.apana.org.au> <567AB6AF.4040702@intel.com>
 <20151223202103.GA4717@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25126 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbbLXDEJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 22:04:09 -0500
In-Reply-To: <20151223202103.GA4717@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/23/2015 12:21 PM, Herbert Xu wrote:
> Why not just leave the MPIs in the structure and only remove them
> by adding a third patch?

Right, I think that's a better way of resolving this. v5 on it's way.
Thanks,
-- 
TS
