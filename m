Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C46C636CC
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 07:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjBHHU7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 02:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBHHU6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 02:20:58 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92FD9002
        for <linux-crypto@vger.kernel.org>; Tue,  7 Feb 2023 23:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1675840857;
  x=1707376857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xXEQ/1gzZzf0xXltXsedbeeCdTvLCEC3SWUc5hWEdBU=;
  b=NwQIXx35uBvW93LvJuRjNheF8zHyZNYsosA7KURdp3+D1jPMOwlO6zJb
   H/xFfrPyw0mZJGC1XCTadSSLnjT1bZq2HgyWI3yDwUBW7hTSMksxDsKzU
   E5XVBzV7VqPenMgIuixUwitx1GUCzdy+qywr5oUD64aXfLdOJxATi/epL
   m6a7beEFkAgZjvp+bbz8w6lmOrb4VGlIfwJ5CY/sLc0SKke+6HvqH/N3V
   EsOZNlqxFSc/yaj0LY20fOPVMM7g3cPnv8O5op6laS953bbgrpvTBTpob
   GQVwmT8AKPNFL2v/QV7QYsESZnrpRNllFBJYZVU7lArPFLwsxzTZFbqpP
   g==;
Date:   Wed, 8 Feb 2023 08:20:54 +0100
From:   Jesper Nilsson <Jesper.Nilsson@axis.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        "Lars Persson" <Lars.Persson@axis.com>,
        linux-arm-kernel <linux-arm-kernel@axis.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        "Longfang Liu" <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        "Corentin Labbe" <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "Arnaud Ebalard" <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>,
        "qat-linux@intel.com" <qat-linux@intel.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 13/32] crypto: artpec6 - Use request_complete helpers
Message-ID: <20230208072054.GM24334@axis.com>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlak-005vjY-N1@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1pMlak-005vjY-N1@formenos.hmeau.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 31, 2023 at 09:02:10AM +0100, Herbert Xu wrote:
> Use the request_complete helpers instead of calling the completion
> function directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
