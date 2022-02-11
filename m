Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82344C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346816AbiBKJjC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:39:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiBKJjB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:39:01 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B681E4D;
        Fri, 11 Feb 2022 01:39:00 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nISOI-0004XD-7b; Fri, 11 Feb 2022 20:38:59 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:38:58 +1100
Date:   Fri, 11 Feb 2022 20:38:58 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wojciech Ziemba <wojciech.ziemba@intel.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com
Subject: Re: [PATCH 0/3] Introduce support for QAT Dynamic Power Management
Message-ID: <YgYusvfoKMF5SoW9@gondor.apana.org.au>
References: <20220203135434.584967-1-wojciech.ziemba@intel.com>
 <YgYt5tFt+0CD/0V3@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgYt5tFt+0CD/0V3@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 11, 2022 at 08:35:34PM +1100, Herbert Xu wrote:
>
> All applied.  Thanks.

Oops, I applied the wrong patches.  Please ignore this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
