From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - adf_dev_stop should not be called in atomic
 context
Date: Fri, 1 Apr 2016 10:51:34 -0700
Message-ID: <56FEB526.4050604@intel.com>
References: <20160329172036.2482.65213.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:26709 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbcDAR4a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Apr 2016 13:56:30 -0400
In-Reply-To: <20160329172036.2482.65213.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 03/29/2016 10:20 AM, Tadeusz Struk wrote:
> VFs call adf_dev_stop() from a PF to VF interrupt bottom half.
> This causes an oops "scheduling while atomic", because it tries
> to aquire a mutex to unregister crypto algorithms.
> This patch fixes the issue by calling adf_dev_stop() asynchronusely.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_vf_isr.c |   31 +++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)

This patch in not correct. Please drop it.
I'll sent a v2 early next week.
Thanks,
-- 
TS
