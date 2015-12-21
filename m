From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Renaming dh895xcc mmp fw
Date: Mon, 21 Dec 2015 07:35:10 -0800
Message-ID: <20151221153510.GB28556@kroah.com>
References: <1450371133-20595-1-git-send-email-ahsan.atta@intel.com>
 <E0A450CA4D390344969A8802152422FF44A1B879@irsmsx105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>
To: "Atta, Ahsan" <ahsan.atta@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47559 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbbLUPmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Dec 2015 10:42:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 22A4E21B24
	for <linux-crypto@vger.kernel.org>; Mon, 21 Dec 2015 10:35:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <E0A450CA4D390344969A8802152422FF44A1B879@irsmsx105.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 21, 2015 at 02:36:57PM +0000, Atta, Ahsan wrote:
> Renaming dh895xcc mmp fw
> 
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
