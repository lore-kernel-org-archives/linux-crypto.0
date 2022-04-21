Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55215C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 10:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245368AbiDUKEf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353741AbiDUKEf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 06:04:35 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F7A24BEA;
        Thu, 21 Apr 2022 03:01:43 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nhTd1-005D3V-Ej; Thu, 21 Apr 2022 20:01:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Apr 2022 18:01:35 +0800
Date:   Thu, 21 Apr 2022 18:01:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Log when resetting PSP SEV state
Message-ID: <YmErfyD9hc3wUMYE@gondor.apana.org.au>
References: <20220413155835.439785-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413155835.439785-1-pgonda@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 13, 2022 at 08:58:35AM -0700, Peter Gonda wrote:
> Currently when the PSP returns a SECURE_DATA_INVALID error on INIT or
> INIT_EX the driver retries the command once which should reset the PSP's
> state SEV related state, meaning the PSP will regenerate its keying
> material. This is logged with a dbg log but given this will change
> system state this should be logged at a higher priority and with more
> information.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: John Allen <john.allen@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
