From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/3] augment CPRNG to correctly implement continuous	test
 for FIPS, and support TEST_MODE flags
Date: Wed, 16 Sep 2009 16:57:49 -0400
Message-ID: <4AB1514D.4060504@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090916162559.GF11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbZIPVAd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 17:00:33 -0400
In-Reply-To: <20090916162559.GF11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2009 12:25 PM, Neil Horman wrote:
> patch 3/3: modify cprng to make contnuity check fips compliant and allow for a
> disabling of the continuity test when the RNG is placed in FIPS mode
>
> Signed-off-by: Neil Horman<nhorman@txudriver.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com
