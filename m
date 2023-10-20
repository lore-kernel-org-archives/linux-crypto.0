Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FE6CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbjJTFyO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjJTFyN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:54:13 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E27CA;
        Thu, 19 Oct 2023 22:54:12 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiSV-0097ak-Ff; Fri, 20 Oct 2023 13:54:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:54:13 +0800
Date:   Fri, 20 Oct 2023 13:54:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     John Allen <john.allen@amd.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.lendacky@amd.com, mario.limonciello@amd.com
Subject: Re: [PATCH] crypto: ccp - Dump SEV command buffer registers on SEV
 command error
Message-ID: <ZTIWBU9i5OJeVgYV@gondor.apana.org.au>
References: <20231010204432.899126-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010204432.899126-1-john.allen@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 10, 2023 at 08:44:32PM +0000, John Allen wrote:
> PSP firmware may report additional error information in the SEV command
> buffer registers in situations where an error occurs as the result of an
> SEV command.  In this case, check if the command buffer registers have been
> modified and if so, dump the contents.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
