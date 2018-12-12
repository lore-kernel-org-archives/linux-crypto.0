Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46384 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbeLLGq4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 01:46:56 -0500
Subject: Re: [PATCH] scatterlist: Update size type to support greater then 4GB
 size.
To: Ashish Mhetre <amhetre@nvidia.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, axboe@kernel.dk, adrian.hunter@intel.com,
        ulf.hansson@linaro.org, linux-crypto@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        vdumpa@nvidia.com, mmaddireddy@nvidia.com
Cc: linux-tegra@vger.kernel.org, Snikam@nvidia.com
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <39a4f02c-d054-2651-2381-a8d86cdf3c13@grimberg.me>
Date: Tue, 11 Dec 2018 22:46:52 -0800
MIME-Version: 1.0
In-Reply-To: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>   struct nvme_sgl_desc {
>   	__le64	addr;
> -	__le32	length;
> +	__le64	length;
>   	__u8	rsvd[3];
>   	__u8	type;
>   };

in what world changing a wire protocol for this make sense?

please get rid of this hunk, NVMe will never cross the 32 bit sg element 
size.
