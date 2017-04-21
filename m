From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] n2rng: Combine substrings for two messages in
 n2rng_probe()
Date: Fri, 21 Apr 2017 10:53:50 -0400 (EDT)
Message-ID: <20170421.105350.706130715276809194.davem@davemloft.net>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
        <fef1883c-4338-5f8a-5dfe-e970b424fbc5@users.sourceforge.net>
        <20170421113641.GA14100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: elfring@users.sourceforge.net, linux-crypto@vger.kernel.org,
        mpm@selenic.com, shannon.nelson@oracle.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422861AbdDUScb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 14:32:31 -0400
In-Reply-To: <20170421113641.GA14100@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 21 Apr 2017 19:36:41 +0800

> On Wed, Apr 19, 2017 at 11:11:35AM +0200, SF Markus Elfring wrote:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Wed, 19 Apr 2017 10:50:04 +0200
>> 
>> The script "checkpatch.pl" pointed information out like the following.
>> 
>> WARNING: quoted string split across lines
>> 
>> Thus fix the affected source code places.
>> 
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> This patch doesn't seem to add any value so I'm not taking it.
> 
> Please don't send patches based purely on a checkpatch complaint.

Thank you Herbert.
