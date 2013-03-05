From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/crypto/nx: fix init race, alignmasks and GCM bug
Date: Tue, 5 Mar 2013 08:30:10 +0800
Message-ID: <20130305003010.GD23819@kroah.com>
References: <CAM0nabG9SeyX7t77CABiDAzECrWa9g2bRmBTjfeoWFjFE8gPiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
To: Kent Yoder <shpedoikal@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM0nabG9SeyX7t77CABiDAzECrWa9g2bRmBTjfeoWFjFE8gPiA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 04, 2013 at 10:44:57AM -0600, Kent Yoder wrote:
>   Fixes a race on driver init with registering algorithms where the
> driver status flag wasn't being set before self testing started.
> 
>   Added the cra_alignmask field for CBC and ECB modes.
> 
>   Fixed a bug in GCM where AES block size was being used instead of
> authsize.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> ---
>  drivers/crypto/nx/nx-aes-cbc.c | 1 +
>  drivers/crypto/nx/nx-aes-ecb.c | 1 +
>  drivers/crypto/nx/nx-aes-gcm.c | 2 +-
>  drivers/crypto/nx/nx.c         | 4 ++--
>  4 files changed, 5 insertions(+), 3 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
