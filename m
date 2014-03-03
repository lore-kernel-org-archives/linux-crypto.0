From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106 - resend
Date: Mon, 03 Mar 2014 14:23:44 -0800
Message-ID: <1393885424.27116.114.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC7@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58296 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbaCCWXq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2014 17:23:46 -0500
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC7@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-02-28 at 17:00 -0600, McCaffrey, Timothy M wrote:
> See comments in part 1.
> 
> Signed off by: Timothy.McCaffrey@Unisys.com
> 
> diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> index 477e9d7..5855172 100644
> --- a/arch/x86/crypto/aesni-intel_asm.S
> +++ b/arch/x86/crypto/aesni-intel_asm.S


Tim,

The patch does not apply cleanly.  Your mail program may have converted
some tabs to space.

Thanks.

Tim Chen
