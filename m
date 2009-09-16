From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/3] add RNG api calls to set common flags
Date: Wed, 16 Sep 2009 16:56:18 -0400
Message-ID: <4AB150F2.6000001@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090916161116.GD11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZIPU7B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 16:59:01 -0400
In-Reply-To: <20090916161116.GD11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2009 12:11 PM, Neil Horman wrote:
> patch 1/3: Add flags infrastructure to rng api
>
> This patch adds api calls for get/set flags calls to the crypto rng api. This
> api allows algorithm implementations to register calls to respond to flag
> settings that are global and common to all rng's.  If a given algorithm has no
> external flags that it needs to respond to, it can opt to not register any
> calls, and as a result a default handler will be registered for each which
> universally returns EOPNOTSUPPORT.
>
> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com
