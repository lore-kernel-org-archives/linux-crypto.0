Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2DAC7EE29
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjFAKif (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjFAKid (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:38:33 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3EDF2;
        Thu,  1 Jun 2023 03:38:28 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q4fhH-00FdyF-9I; Thu, 01 Jun 2023 18:38:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Jun 2023 18:38:23 +0800
Date:   Thu, 1 Jun 2023 18:38:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dongsoo Lee <letrhee@nsr.re.kr>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, letrhee@gmail.com, letrhee@nsr.re.kr
Subject: Re: [PATCH v2 0/2] crypto: LEA block cipher implementation
Message-ID: <ZHh1H3yKPU68J7Uv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525121301.722682-1-letrhee@nsr.re.kr>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dongsoo Lee <letrhee@nsr.re.kr> wrote:
>
> We expect that the first application of the patch would be disk encryption on the Gooroom platform ('Gooroom' is a Korean word, meaning 'cloud') [3]. Currently, the Gooroom platform uses AES-XTS for disk encryption. The main reason for submitting this patch is to make disk encryption with LEA (e.g. LEA-XTS) available on there.

We don't add kernel algorithms without an in-kernel user.  Is
there an existing in-kernel user that can use this as is or are
you going to add one?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
