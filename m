From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC
 CRC32C accerlerator driver
Date: Wed, 09 Dec 2015 12:37:16 -0500 (EST)
Message-ID: <20151209.123716.1633991691492130781.davem@davemloft.net>
References: <20151209082748.GA26696@gondor.apana.org.au>
	<CAFd313z3zaXMAgKWa9KwQw1QxU4LuW_uoAz5_=42viYk2zaaOA@mail.gmail.com>
	<20151209084458.GA26803@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rsahu@apm.com, vinod.koul@intel.com, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com, linux-crypto@vger.kernel.org, kgondkar@apm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:34898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbLIRhX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 12:37:23 -0500
In-Reply-To: <20151209084458.GA26803@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 9 Dec 2015 16:44:58 +0800

> On Wed, Dec 09, 2015 at 02:13:32PM +0530, Rameshwar Sahu wrote:
>>
>> Yes, we are not upstream in-kernel users right now, but later client
>> ma upstream there patches.
> 
> Well I'd prefer to not take any crypto drivers that don't have
> in-kernel users.

+1
