From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - VF should never trigger SBR on PH
Date: Mon, 21 Sep 2015 08:27:11 -0700
Message-ID: <560021CF.1020106@intel.com>
References: <20150918155947.24663.97648.stgit@tstruk-mobl1>
 <20150921150453.GB2703@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	conor.mcloughlin@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbbIUPf7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 11:35:59 -0400
In-Reply-To: <20150921150453.GB2703@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/21/2015 08:04 AM, Herbert Xu wrote:
>> Don't allow to trigger SBR from a VF running in VMM context.
>> > 
>> > Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
>> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> Applied to crypto.

Thanks Herbert. Actually it's only needed for 4.3 when VF support was added.
Thanks
