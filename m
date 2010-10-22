From: "Allyn, Mark A" <mark.a.allyn@intel.com>
Subject: Questions about ahash
Date: Fri, 22 Oct 2010 10:54:58 -0600
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316140FE940B@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0JVQzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Oct 2010 12:55:25 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Folks:

I am attempting to implement an ahash instance for a hardware crypto device.

I see that there is a sha1 generic in the soruces a crypto/sha1_generic.c which uses the shash interface. I was hoping to use that, but there is some stuff in the headers that is confusing.

In include/crypto/hash.h, there is a structure crypto_ahash which has pointers to the init, update, final, etc algorithms. These same algorithms are also referred to in the ahash_alg structure.

In the case of shash, the crypto_shash structure does not have pointers to the algorithms.

Why is the crypto_ahash structure so different? 

There is a function shash_desc_ctx, but there is no function ahash_des_ctx. In the crys_sha1_init() function of sha1_generic, you call shash_desc_ctx. If I want to use the ahash instead of shash for sha1, then do I use shash_desc_ctx, or do I have to come up with my own ahash_desc_ctx?

Thanks

Mark Allyn
