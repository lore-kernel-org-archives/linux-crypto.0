From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - fix leak on error path
Date: Tue, 16 Feb 2016 12:23:19 -0800
Message-ID: <56C38537.109@intel.com>
References: <1455145184-5610-1-git-send-email-tadeusz.struk@intel.com>
 <20160216202046.GD11908@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbcBPU12 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:27:28 -0500
In-Reply-To: <20160216202046.GD11908@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/16/2016 12:20 PM, Herbert Xu wrote:
> On Wed, Feb 10, 2016 at 02:59:44PM -0800, Tadeusz Struk wrote:
>> > Fix a leak on error path in qat asym
>> > 
>> > Reported-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
>> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> Appiled.

Thanks Herbert, should we also push it to stable?
Thanks,
-- 
TS
