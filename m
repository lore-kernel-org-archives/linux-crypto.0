From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and
 numa
Date: Fri, 05 Dec 2014 10:34:33 -0800
Message-ID: <5481FAB9.3000901@intel.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaLESkh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 13:40:37 -0500
In-Reply-To: <20141014012251.742.5500.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/13/2014 06:24 PM, Tadeusz Struk wrote:
> Hi,
> These two patches fix invalid (zero length) dma mapping and
> enforce numa configuration for maximum performance.
> 
> Change log:
> v2 - Removed numa node calculation based bus number and use predefined
> functions instead.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
> 
> Tadeusz Struk (2):
>       crypto: qat - Prevent dma mapping zero length assoc data
>       crypto: qat - Enforce valid numa configuration
> 
> 
>  drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
>  drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
>  drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
>  drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
>  drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
>  drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
>  7 files changed, 32 insertions(+), 34 deletions(-)
> 


Hi Herbert,
Looks like these two are not in cryptodev-2.6 yet.
Do you plan to merge it sometime soon or should I generate incremental
patches based on crypto-2.6 instead of cryptodev-2.6
Thanks,
Tadeusz
