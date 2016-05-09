From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 9 May 2016 11:55:58 -0700
Message-ID: <b8a6fad7-629b-bc62-3094-5d4cc564397b@intel.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de>
 <4de27b5e-e719-9fee-6441-858fb9198274@intel.com>
 <6090436.ehl9Rue05E@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40670 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbcEIS4z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 14:56:55 -0400
In-Reply-To: <6090436.ehl9Rue05E@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/09/2016 11:50 AM, Stephan Mueller wrote:
> I think I see my error: pkcs1pad(rsa,HASH) -- I missed the hash part that 
> activates the decoding. Thank you for the pointer.
> 
> Once I completed my testing, I think I need to beef up the documentation a 
> bit.

Right, this can work in two modes. The pkcs1pad(rsa) only strips the padding.
Thanks,
-- 
TS
