From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Typos and RSA
Date: Tue, 17 May 2016 15:18:44 -0700
Message-ID: <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com>
References: <573B8BA3.8020902@amd.com>
 <1468644.THAbu50UCt@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:55592 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbcEQWTt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 18:19:49 -0400
In-Reply-To: <1468644.THAbu50UCt@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/17/2016 03:16 PM, Stephan Mueller wrote:
>> I am working on hooking up RSA functionality to the akcipher API. It appears
>> > that no other code, to date, uses this API. Can anyone confirm or deny that
>> > conclusion?
> This is not correct. The asymmetric key API uses that code. So does the module 
> signing code.

Also you can have a look at testmgr.c for examples.
"git grep crypto_alloc_akcipher" is also useful.

Thanks,
-- 
TS
