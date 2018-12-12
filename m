Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:50910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbeLLG3y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 01:29:54 -0500
Date: Tue, 11 Dec 2018 22:29:50 -0800 (PST)
Message-Id: <20181211.222950.1995970751331458343.davem@davemloft.net>
To: amhetre@nvidia.com
Cc: herbert@gondor.apana.org.au, axboe@kernel.dk,
        adrian.hunter@intel.com, ulf.hansson@linaro.org,
        linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, vdumpa@nvidia.com,
        mmaddireddy@nvidia.com, Snikam@nvidia.com,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] scatterlist: Update size type to support greater then
 4GB size.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ashish Mhetre <amhetre@nvidia.com>
Date: Wed, 12 Dec 2018 11:54:13 +0530

> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
> index 68e91ef..0a07a29 100644
> --- a/include/linux/nvme.h
> +++ b/include/linux/nvme.h
> @@ -587,7 +587,7 @@ enum {
>  
>  struct nvme_sgl_desc {
>  	__le64	addr;
> -	__le32	length;
> +	__le64	length;
>  	__u8	rsvd[3];
>  	__u8	type;
>  };

Isn't this a device or protocol defined datastructure?  You can't just
change it like this.
