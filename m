From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] crypto: qat: Remove deprecated create_workqueue
Date: Sat, 11 Jun 2016 17:46:21 -0500
Message-ID: <20160611224621.GB31708@htj.duckdns.org>
References: <20160607211746.GA17667@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Conor McLoughlin <conor.mcloughlin@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	John Griffin <john.griffin@intel.com>,
	Wu Fengguang <fengguang.wu@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33509 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbcFKWqa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jun 2016 18:46:30 -0400
Content-Disposition: inline
In-Reply-To: <20160607211746.GA17667@Karyakshetra>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 02:47:47AM +0530, Bhaktipriya Shridhar wrote:
> alloc_workqueue replaces deprecated create_workqueue().
> 
> The workqueue device_reset_wq has workitem &reset_data->reset_work per
> adf_reset_dev_data. The workqueue  pf2vf_resp_wq is a workqueue for
> PF2VF responses has workitem &pf2vf_resp->pf2vf_resp_work per pf2vf_resp.
> The workqueue adf_vf_stop_wq is used to call adf_dev_stop()
> asynchronously.
> 
> Dedicated workqueues have been used in all cases since the workitems
> on the workqueues are involved in operation of crypto which can be used in
> the IO path which is depended upon during memory reclaim. Hence,
> WQ_MEM_RECLAIM has been set to gurantee forward progress under memory
> pressure.
> Since there are only a fixed number of work items, explicit concurrency
> limit is unnecessary.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
