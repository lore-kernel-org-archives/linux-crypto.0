From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: testmgr - don't print info about missing test
 for gcm-aes-aesni
Date: Wed, 24 Jun 2015 08:47:27 -0700
Message-ID: <558AD10F.6020301@intel.com>
References: <20150624141422.30488.59869.stgit@tstruk-mobl1> <1441660.1IFzzoL80j@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbbFXPsA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 11:48:00 -0400
In-Reply-To: <1441660.1IFzzoL80j@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 06/24/2015 07:44 AM, Stephan Mueller wrote:
>> 	}, {
>> >+		.alg = "__driver-gcm-aes-aesni",
>> >+		.test = alg_test_null,
> Wouldn't fips_allowed = 1 be needed here?

Yes, you are right. I will send a v2 soon.
