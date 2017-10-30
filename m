From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: Include device.h instead of declaring struct
 device
Date: Mon, 30 Oct 2017 14:52:19 +0800
Message-ID: <20171030065219.GB20573@gondor.apana.org.au>
References: <20171026134208.31368-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50380 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdJ3Gwn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 02:52:43 -0400
Content-Disposition: inline
In-Reply-To: <20171026134208.31368-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 26, 2017 at 07:12:08PM +0530, PrasannaKumar Muralidharan wrote:
> Include linux/device.h instead of declaring struct device.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Nack.  We should not include a header file when a simple forward
declaration is enough.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
