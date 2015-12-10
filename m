From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - enable VF irq after guest exits
 ungracefully
Date: Wed, 9 Dec 2015 21:26:58 -0800
Message-ID: <56690D22.7090605@intel.com>
References: <20151209195946.17574.50691.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: xin.zeng@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbbLJFaN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 00:30:13 -0500
In-Reply-To: <20151209195946.17574.50691.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 12/09/2015 11:59 AM, Tadeusz Struk wrote:
> From: Signed-off-by: Zeng Xin <xin.zeng@intel.com>
> 
> The VF bundle interrupt is not triggered any more in
> the case when guest is shut down with sample app running.
> Need to clear the flag interrupt bit when restarting to fix
> this irrecoverable state.
> 
> Signed-off-by: Zeng Xin <xin.zeng@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_transport.c      |    3 ++-
>  .../qat/qat_common/adf_transport_access_macros.h   |    5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)

Please ignore this one. I'll send a v2. 
-- 
TS
