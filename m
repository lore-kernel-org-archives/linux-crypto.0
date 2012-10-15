From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] crypto: tegra: remove include of <mach/clk.h>
Date: Mon, 15 Oct 2012 11:39:17 -0600
Message-ID: <507C4A45.4050900@wwwdotorg.org>
References: <1349216260-917-1-git-send-email-swarren@wwwdotorg.org> <20121015143328.GC25426@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:55319 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2JORjU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Oct 2012 13:39:20 -0400
In-Reply-To: <20121015143328.GC25426@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/15/2012 08:33 AM, Herbert Xu wrote:
> On Tue, Oct 02, 2012 at 04:17:40PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Nothing from this file is used, and the file will hopefully be deleted
>> soon.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks, applied to Tegra's for-3.8/cleanup.
