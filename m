Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B65BC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 12:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiAKMGE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:06:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:45334 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239371AbiAKMGD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 07:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641902763; x=1673438763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JRk9zfpEfh7TMLOwa1VQX7FshiH5JyCeZcz+h+6TOkE=;
  b=Iuc0VqGVeZqdxB8XrbIQAo43GzGDrkPEKNMpkJ6+gMvoi55T5Jv+OpXH
   H2zDZjPVBK/wvvC/D4xLprBWyn5dGwI0qBU+C2WcF0PMpWfUeiNWGqmVM
   8b5ASFyhHaObZSx9M/z1m4VucHP2zq7qQ7duacT4rojALwNduOvEyDizd
   cjnC7+YP2j9RcW6CBx16QGaEgXz2Z/qbjSIqkNfEk6A8ogo/L68kpeSrL
   d5dcELp7ezO4VgvA+hhF0oAYt2abuyQqMrb3B1b2a1oS4vvTezhvcd/IH
   mBR9NJYrdcJbyAxniaHboeb56lrPhIvo1qnYp76+BIxBKzqj6aeQuoLpM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="224166752"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="224166752"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 04:06:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="613197572"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 04:05:57 -0800
Date:   Tue, 11 Jan 2022 12:05:51 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tomasz Kowalik <tomaszx.kowalik@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Mateuszx Potrola <mateuszx.potrola@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - fix a signedness bug in
 get_service_enabled()
Message-ID: <Yd1yn4FHaueG4Lv8@silpixa00400314>
References: <20220111071806.GD11243@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111071806.GD11243@kili>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 10:18:06AM +0300, Dan Carpenter wrote:
> The "ret" variable needs to be signed or there is an error message which
> will not be printed correctly.
> 
> Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Thanks Dan.
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

@Herbert, there are 2 other (identical) patches in the list that fix the
same issue:
    https://patchwork.kernel.org/project/linux-crypto/patch/YdWZm6QJAYbYTKAR@debian-BULLSEYE-live-builder-AMD64/
    https://patchwork.kernel.org/project/linux-crypto/patch/20220105152005.43305-1-jiapeng.chong@linux.alibaba.com/

Since none of them made into the pull request for 5.17, I'm fine with
taking this one as it is the only one which contains the Fixes tag.

Regards,

-- 
Giovanni
