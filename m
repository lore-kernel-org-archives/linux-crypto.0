From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and
 dm-crypt
Date: Fri, 13 Jan 2017 18:41:28 +0800
Message-ID: <20170113104128.GA23497@gondor.apana.org.au>
References: <cover.1484215956.git.omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33451 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751356AbdAMKlh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 05:41:37 -0500
Content-Disposition: inline
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:59:52PM +0100, Ondrej Mosnacek wrote:
> 
> the goal of this patchset is to allow those skcipher API users that need to
> process batches of small messages (especially dm-crypt) to do so efficiently.

Please explain why this can't be done with the existing framework
using IV generators similar to the ones used for IPsec.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
