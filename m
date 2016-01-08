From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - update init_esram for C3xxx dev type
Date: Fri, 8 Jan 2016 10:35:46 -0800
Message-ID: <56900182.2080808@intel.com>
References: <1452277194-4804-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: pingchao.yang@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:42476 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbcAHSjY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 13:39:24 -0500
In-Reply-To: <1452277194-4804-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/08/2016 10:19 AM, Tadeusz Struk wrote:
> There is no esram on C3xxx devices so we don't need to wait for
> it to initialize.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_hal.c | 3 +++
>  1 file changed, 3 insertions(+)
Hi Herbert,
This one is generated on top of Pingchao's patch "crypto: qat - fix timeout issues"
https://patchwork.kernel.org/patch/7972981/
Thanks
-- 
TS
