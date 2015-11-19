From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: crypto: sahara - check return value of sg_nents_for_len
Date: Thu, 19 Nov 2015 10:30:24 +0100
Message-ID: <20151119093024.GB32146@Red>
References: <20151118230642.GA29804@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33637 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbKSJa3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 04:30:29 -0500
Received: by wmec201 with SMTP id c201so15785948wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2015 01:30:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151118230642.GA29804@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 19, 2015 at 02:06:42AM +0300, Dan Carpenter wrote:
> Hello LABBE Corentin,
> 
> The patch 6c2b74d4774f: "crypto: sahara - check return value of
> sg_nents_for_len" from Nov 4, 2015, leads to the following static
> checker warning:
> 
> 	drivers/crypto/sahara.c:480 sahara_hw_descriptor_create()
> 	warn: unsigned 'dev->nb_in_sg' is never less than zero.
> 
> drivers/crypto/sahara.c
>    479          dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
>    480          if (dev->nb_in_sg < 0) {
>                     ^^^^^^^^^^^^^^^^^
> Unsigned is never less than zero.
> 
>    481                  dev_err(dev->device, "Invalid numbers of src SG.\n");
>    482                  return dev->nb_in_sg;
>    483          }
> 
> There are several other similar bugs as well:
> 
> drivers/crypto/sahara.c:485 sahara_hw_descriptor_create() warn: unsigned 'dev->nb_out_sg' is never less than zero.
> drivers/crypto/sahara.c:804 sahara_sha_hw_links_create() warn: unsigned 'dev->nb_in_sg' is never less than zero.
> drivers/crypto/picoxcell_crypto.c:298 spacc_sg_to_ddt() warn: unsigned 'nents' is never less than zero.
> drivers/crypto/picoxcell_crypto.c:338 spacc_aead_make_ddts() warn: unsigned 'src_nents' is never less than zero.
> drivers/crypto/picoxcell_crypto.c:348 spacc_aead_make_ddts() warn: unsigned 'dst_nents' is never less than zero.
> 
> regards,
> dan carpenter

Thanks for the reporting

I will send a patch for solving this.

Regards
