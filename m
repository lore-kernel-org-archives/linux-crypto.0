From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 4/6] crypto: talitos - fix GFP flag usage
Date: Thu, 17 Jul 2008 07:26:14 -0500
Message-ID: <D59ED865-85CF-4C1E-9D79-D9DD0DE49505@kernel.crashing.org>
References: <20080716182215.36c1bd11.kim.phillips@freescale.com> <BDCB5191-EEDE-4046-A741-80E6EF1333CF@kernel.crashing.org> <20080717121758.GA25267@gondor.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kim Phillips <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYGQM0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 08:26:31 -0400
In-Reply-To: <20080717121758.GA25267@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Jul 17, 2008, at 7:17 AM, Herbert Xu wrote:

> On Wed, Jul 16, 2008 at 06:33:45PM -0500, Kumar Gala wrote:
>>
>> On Jul 16, 2008, at 6:22 PM, Kim Phillips wrote:
>>
>>> use GFP_ATOMIC when necessary; use atomic_t when allocating
>>> submit_count.
>>
>> why?
>
> You mean why are atomics required? Yes that is a good question.

Yep. the commit message isn't explaining why, just what :)

> Kim?

- k
