From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 3/4] crypto: rsa: add a new rsa generic implementation
Date: Mon, 15 Jun 2015 19:26:40 -0700
Message-ID: <557F8960.3010604@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <3921303.7tkMvJ6vYE@tachyon.chronox.de> <557F809B.3060001@intel.com> <15593683.jmSB8WjLMD@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40328 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbbFPC0o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:26:44 -0400
In-Reply-To: <15593683.jmSB8WjLMD@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 07:19 PM, Stephan Mueller wrote:
>> I'm not familiar with the FIPS requirements. I checked the NIST
>> > recommendations witch states that RSA: |n| >= 2048 is acceptable. If FIPS
>> > allows 2K and 3K only then we need to change it.
> The reason for exclusive 2k/3k is the CAVS testing: there is only the ability 
> to test 2/3k. Longer key sizes are even not allowed as per SP800-131A in favor 
> of EC.

Ok I'll update it to only accept 2K & 3K. Thanks
