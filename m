Return-Path: <SRS0=qIdC=PB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18103 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbeLXIHH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Dec 2018 03:07:07 -0500
Subject: Re: [PATCH] scatterlist: Update size type to support greater then 4GB
 size.
To: Christoph Hellwig <hch@infradead.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <axboe@kernel.dk>, <adrian.hunter@intel.com>,
        <ulf.hansson@linaro.org>, <linux-crypto@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <vdumpa@nvidia.com>, <mmaddireddy@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <Snikam@nvidia.com>
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
 <20181212080652.GA14877@infradead.org>
From: Ashish Mhetre <amhetre@nvidia.com>
Message-ID: <c7dcdf51-3ade-90b5-aaf6-214e32aecd62@nvidia.com>
Date: Mon, 24 Dec 2018 13:37:00 +0530
MIME-Version: 1.0
In-Reply-To: <20181212080652.GA14877@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We don't have a real use-case for this. Understanding the consequences, 
we are questioning the patch in downstream itself.
Please ignore this patch for now.

On 12/12/18 1:36 PM, Christoph Hellwig wrote:
> scatterlist elements longer than 4GB sound odd.  Please submit it
> in a series with your actual user so that we can help figuring out
> if it really makes sense or if there is a better way to solve your
> problem.
> 
> As is this patch will massively increase the memory usage for all users
> of struct scatterlist, so you better have a really good reason.
> 
