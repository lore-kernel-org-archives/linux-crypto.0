From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 4/6] crypto: talitos - fix GFP flag usage
Date: Wed, 16 Jul 2008 18:33:45 -0500
Message-ID: <BDCB5191-EEDE-4046-A741-80E6EF1333CF@kernel.crashing.org>
References: <20080716182215.36c1bd11.kim.phillips@freescale.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@ozlabs.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:47177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbYGPXeF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:34:05 -0400
In-Reply-To: <20080716182215.36c1bd11.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Jul 16, 2008, at 6:22 PM, Kim Phillips wrote:

> use GFP_ATOMIC when necessary; use atomic_t when allocating  
> submit_count.

why?

- k
