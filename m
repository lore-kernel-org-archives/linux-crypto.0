From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - fix CTX_ENABLES bits shift direction issue
Date: Fri, 11 Dec 2015 07:22:12 -0800
Message-ID: <566AEA24.3000507@intel.com>
References: <1449812574-35124-1-git-send-email-pingchao.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Yang Pingchao <pingchao.yang@intel.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbbLKPZ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2015 10:25:28 -0500
In-Reply-To: <1449812574-35124-1-git-send-email-pingchao.yang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/10/2015 09:42 PM, Yang Pingchao wrote:
> AE CTX bits should be 8-15 in CTX_ENABLES, so the mask value 0xff should be
> left shifted 0x8
> 
> Reported-by:   Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_hal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
