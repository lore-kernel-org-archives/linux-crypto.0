From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] crypto: qat - don't use userspace pointer
Date: Wed, 21 Oct 2015 14:46:43 -0700
Message-ID: <20151021214643.GA8346@kroah.com>
References: <20151021193044.30343.6431.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, stable@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45863 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbbJUVqs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 17:46:48 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 08A6720BDB
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2015 17:46:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20151021193044.30343.6431.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 21, 2015 at 12:30:45PM -0700, Tadeusz Struk wrote:
> Bugfix - don't dereference userspace pointer.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
