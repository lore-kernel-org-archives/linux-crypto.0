From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and numa
Date: Mon, 17 Nov 2014 08:59:16 -0800
Message-ID: <20141117165916.GA5744@kroah.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
 <543E4DFF.9000101@redhat.com>
 <543E59B9.6060804@redhat.com>
 <20141024144521.GA20889@gondor.apana.org.au>
 <546A178C.6070908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Prarit Bhargava <prarit@redhat.com>,
	Nikolay Aleksandrov <nikolay@redhat.com>,
	bruce.w.allan@intel.com, qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaKQQ7R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 11:59:17 -0500
Content-Disposition: inline
In-Reply-To: <546A178C.6070908@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 17, 2014 at 07:43:08AM -0800, Tadeusz Struk wrote:
> On 10/24/2014 07:45 AM, Herbert Xu wrote:
> > On Wed, Oct 15, 2014 at 07:25:45AM -0400, Prarit Bhargava wrote:
> >>
> >>
> >> On 10/15/2014 06:35 AM, Nikolay Aleksandrov wrote:
> >>> On 14/10/14 03:24, Tadeusz Struk wrote:
> >>>> Hi,
> >>>> These two patches fix invalid (zero length) dma mapping and
> >>>> enforce numa configuration for maximum performance.
> >>>>
> >>>> Change log:
> >>>> v2 - Removed numa node calculation based bus number and use predefined
> >>>> functions instead.
> >>>>
> >>>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> >>>> ---
> >>>>
> >>>> Tadeusz Struk (2):
> >>>>        crypto: qat - Prevent dma mapping zero length assoc data
> >>>>        crypto: qat - Enforce valid numa configuration
> >>>>
> >>>>
> >>>>   drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
> >>>>   drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
> >>>>   drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
> >>>>   drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
> >>>>   drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
> >>>>   drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
> >>>>   drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
> >>>>   7 files changed, 32 insertions(+), 34 deletions(-)
> >>>>
> >>>
> >>> I just gave a quick run of these patches and they seem to fix the NUMA issue and
> >>> the 0 length warnings.
> >>>
> >>> Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>
> >>
> >> Thanks Nik :)
> >>
> >> Reviewed-by: Prarit Bhargava <prarit@redhat.com>
> > 
> > Patch applied to crypto and I will push this to stable.
> 
> Hi Greg,
> Any idea why this didn't make it to 3.17.3?

Because it showed up in Linus's tree _after_ 3.17.3-rc1 was released?
How can I go back in time?

confused,

greg k-h
