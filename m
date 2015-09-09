From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 9 Sep 2015 09:46:36 -0700
Message-ID: <55F0626C.3050306@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <2806088.jJiH2yOvUX@tauon.atsec.com> <55F05EC4.5080408@intel.com>
 <1973388.rNzrp31mTc@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbbIIQsS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:48:18 -0400
In-Reply-To: <1973388.rNzrp31mTc@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 09:39 AM, Stephan Mueller wrote:
>> No, because it can return -EINVAL if you call it before you set the key.
> I see.
> 
> But, shouldn't there be an overflow check? Maybe not here, but in the cases 
> where the function is invoked. There is a kmalloc(src_len) without a check for 
> negative values.

Right, but because testmgr.c calls setkey before this I skipped the check.
