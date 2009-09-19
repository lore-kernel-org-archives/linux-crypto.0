From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/1] add fips(ansi_cprng) (v2)
Date: Fri, 18 Sep 2009 21:12:49 -0400
Message-ID: <4AB43011.3010003@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090918183254.GA28540@hmsreliant.think-freely.org> <20090918183446.GB28540@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZISBNC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2009 21:13:02 -0400
In-Reply-To: <20090918183446.GB28540@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/18/2009 02:34 PM, Neil Horman wrote:
> Patch to add fips(ansi_cprng) alg, which is ansi_cprng plus a continuous test
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

That turned out to be a lot less messy than my puny mind was thinking it might be.
The solution actually looks quite elegant, especially like how much cleaner the
priming of the continuity test in fips mode is.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

