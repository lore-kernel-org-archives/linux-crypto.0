From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 0/7] padata/pcrypt: cleanups
Date: Tue, 27 Jul 2010 07:13:47 +0200
Message-ID: <20100727051347.GI11081@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:45536 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0G0FKU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jul 2010 01:10:20 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset contains the following changes:

1. padata - Rename padata_alloc functions to not export underlined functions.

2. padata - Rearrange set_cpumask functions to have proper locking for all
these functions and to avoid to export underlined functions.

3. padata - Pass the padata cpumasks to the cpumask_change_notifier chain, so
users can access them without the need of a padata_get_cpumask function.

4. pcrypt - Rename the stuct pcrypt_instance. An instance refers usually to a
crypto instance in the crypto-layer, the struct pcrypt_instance is not related
to a crypto instance, so we rename it.

5. pcrypt - Update pcrypt cpumask acording to the padata cpumask notifier.
The padata cpumask change notifier passes a padata_cpumask to the
notifier chain, so we use this to update the pcrypt cpumask.

6. padata - Remove padata_get_cpumask. This function is a bit error prone
because the cpumask can change at any time, so we can't be sure to get the
right cpumask from that function.

7. padata - Update the API documentation.

Steffen
