From: Dimitrios Siganos <dimitris@siganos.org>
Subject: hmac(sha1)
Date: Wed, 03 Mar 2010 03:29:17 +0000
Message-ID: <4B8DD78D.6080707@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:46868
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0CCDfq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 22:35:46 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am trying to write a hmac(sha1) algorithm and I have a few questions. 
I have a HW crypto accelerator that does the actual crypto work. I have 
already successfully implemented sha1 by creating a 
CRYPTO_ALG_TYPE_DIGEST algorithm.

1) Can I implement hmac(sha1) as a CRYPTO_ALG_TYPE_DIGEST algorithm 
(i.e. use very similar code to sha1)?

2) Do I need to create a CRYPTO_ALG_TYPE_HASH algorithm?

3) Is it possible to implement hmac(sha1) as both CRYPTO_ALG_TYPE_DIGEST 
and CRYPTO_ALG_TYPE_HASH?

4) If I use a CRYPTO_ALG_TYPE_HASH, I need to understand the scatterwalk 
api, is there any help on the subject?

Regards,
Dimitris

