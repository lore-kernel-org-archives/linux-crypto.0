From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH] Adding ADMA support for PPC460EX DMA engine.
Date: Fri, 23 Jul 2010 14:39:24 -0700
Message-ID: <8c2fc4da25db867b7daa7c4f618230b0@mail.gmail.com>
References: <1279846638-22323-1-git-send-email-tmarri@amcc.com>
	<201007230815.14464.sr@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tmarri@amcc.com, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, dan.j.williams@intel.com
To: Stefan Roese <sr@denx.de>, linuxppc-dev@lists.ozlabs.org
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201007230815.14464.sr@denx.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>As you describe above, a lot of the code seems to be copied from
>drivers/dma/ppc4xx/adma.c/h. Wouldn't it make more sense to factor out
the
>common code instead of duplicating it?



  Hi Stefan,
     Thanks for the review. There are definitely some functions can be
moved to a common file.

  Hi Dan,
 Could you also please review and see if there are any changes needed, so
I can include some changes as
Well in the modified patch.


Regards,
Marri
