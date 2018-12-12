Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50812 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLIHA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 03:07:00 -0500
Date: Wed, 12 Dec 2018 00:06:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ashish Mhetre <amhetre@nvidia.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, axboe@kernel.dk,
        adrian.hunter@intel.com, ulf.hansson@linaro.org,
        linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, vdumpa@nvidia.com,
        mmaddireddy@nvidia.com, linux-tegra@vger.kernel.org,
        Snikam@nvidia.com
Subject: Re: [PATCH] scatterlist: Update size type to support greater then
 4GB size.
Message-ID: <20181212080652.GA14877@infradead.org>
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

scatterlist elements longer than 4GB sound odd.  Please submit it
in a series with your actual user so that we can help figuring out
if it really makes sense or if there is a better way to solve your
problem.

As is this patch will massively increase the memory usage for all users
of struct scatterlist, so you better have a really good reason.
