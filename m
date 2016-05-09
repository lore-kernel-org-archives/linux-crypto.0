From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 9 May 2016 12:17:21 -0700
Message-ID: <ee26539d-0447-d9cc-a2d7-370cfe05781a@intel.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de>
 <6090436.ehl9Rue05E@tauon.atsec.com>
 <b8a6fad7-629b-bc62-3094-5d4cc564397b@intel.com>
 <10395258.qUa3tSVhS8@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:24509 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbcEITST (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 15:18:19 -0400
In-Reply-To: <10395258.qUa3tSVhS8@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/09/2016 12:02 PM, Stephan Mueller wrote:
> One followup: is the final memcmp() between the decrypted hash and the hash of 
> the message implemented in the RSA verify code path? At least I do not see it 
> right away.

It's in line #549
-- 
TS
