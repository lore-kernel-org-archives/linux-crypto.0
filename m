From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v4] crypto: KEYS: convert public key and digsig asym to
 the akcipher api
Date: Wed, 23 Dec 2015 06:58:55 -0800
Message-ID: <567AB6AF.4040702@intel.com>
References: <20151223143352.5035.85876.stgit@tstruk-mobl1>
 <20151223145130.GA2598@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbLWPCY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 10:02:24 -0500
In-Reply-To: <20151223145130.GA2598@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/23/2015 06:51 AM, Herbert Xu wrote:
>> > Changes in v4:
>> > - Flatten both patches into one to avoid bisect compilation problems.
> Why is this necessary?

Because the first patch modifies the struct public_key and removes the MPIs from it,
which the code modified in the second patch still uses. If bisect only takes the first
then the build will fail on the security/integrity/digsig_asymmetric.c as reported by
kbuild test robot:

>> security/integrity/digsig_asymmetric.c:95:5: error: 'struct public_key_signature' has no member named 'nr_mpi'
     pks.nr_mpi = 1;

Thanks,
-- 
TS
