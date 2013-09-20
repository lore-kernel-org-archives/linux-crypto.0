From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] crypto: caam - map src buffer before access
Date: Fri, 20 Sep 2013 08:18:45 -0700
Message-ID: <20130920151845.GA4420@kroah.com>
References: <1379699647-10680-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Yashpal Dutta <yashpal.dutta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1379699647-10680-1-git-send-email-yashpal.dutta@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 20, 2013 at 11:24:07PM +0530, Yashpal Dutta wrote:
> KMap the buffers before copying trailing bytes during hmac into a session
> temporary buffer. This is required if pinned buffer from user-space is send
> during hmac and is safe even if hmac request is generated from within kernel.
> 
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
> Reviewed-by: Vakul Garg <vakul@freescale.com>
> Reviewed-by: Horia Geanta <horia.geanta@freescale.com> 
> ---
> Patch covers review comments on first version of patch.
> ./scripts/checkpatch.pl --strict 0001-crypto-caam-map-src-buffer-before-access.patch 
> 
> total: 0 errors, 0 warnings, 0 checks, 62 lines checked
> 
> The patch fixes driver crashes when a pinned buffer from user-space is sent to CAAM driver
> for HMAC processing.
> 
>  drivers/crypto/caam/sg_sw_sec4.h |   34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
