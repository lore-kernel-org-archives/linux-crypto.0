From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and numa
Date: Fri, 24 Oct 2014 22:45:21 +0800
Message-ID: <20141024144521.GA20889@gondor.apana.org.au>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
 <543E4DFF.9000101@redhat.com>
 <543E59B9.6060804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	bruce.w.allan@intel.com, qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56506 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbaJXOpd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:45:33 -0400
Content-Disposition: inline
In-Reply-To: <543E59B9.6060804@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 15, 2014 at 07:25:45AM -0400, Prarit Bhargava wrote:
> 
> 
> On 10/15/2014 06:35 AM, Nikolay Aleksandrov wrote:
> > On 14/10/14 03:24, Tadeusz Struk wrote:
> >> Hi,
> >> These two patches fix invalid (zero length) dma mapping and
> >> enforce numa configuration for maximum performance.
> >>
> >> Change log:
> >> v2 - Removed numa node calculation based bus number and use predefined
> >> functions instead.
> >>
> >> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> >> ---
> >>
> >> Tadeusz Struk (2):
> >>        crypto: qat - Prevent dma mapping zero length assoc data
> >>        crypto: qat - Enforce valid numa configuration
> >>
> >>
> >>   drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
> >>   drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
> >>   drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
> >>   drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
> >>   drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
> >>   drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
> >>   drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
> >>   7 files changed, 32 insertions(+), 34 deletions(-)
> >>
> > 
> > I just gave a quick run of these patches and they seem to fix the NUMA issue and
> > the 0 length warnings.
> > 
> > Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>
> 
> Thanks Nik :)
> 
> Reviewed-by: Prarit Bhargava <prarit@redhat.com>

Patch applied to crypto and I will push this to stable.

Thanks everyone!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
