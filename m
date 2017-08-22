From: Rishabh Hardas <rishabhhardas@gmail.com>
Subject: Re: [PATCH] staging/ccree: Declare compiled out fuctions static
 inline
Date: Tue, 22 Aug 2017 16:51:16 +0530
Message-ID: <20170822112010.GA20667@rishabh-linux>
References: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
 <20170816220909.GB29988@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38681 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932350AbdHVLVd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 07:21:33 -0400
Content-Disposition: inline
In-Reply-To: <20170816220909.GB29988@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 16, 2017 at 03:09:09PM -0700, Greg KH wrote:
> On Mon, Jul 31, 2017 at 02:47:23PM +0530, RishabhHardas wrote:
> > From: RishabhHardas <rishabhhardas@gmail.com>
> > 
> > Sparse was giving out a warning for symbols 'cc_set_ree_fips_status' and 'fips_handler'
> > that they were not declared and need to be made static. This patch makes both the symbols
> > static inline, to remove the warnings.
> > 
> > Signed-off-by: RishabhHardas <rishabhhardas@gmail.com>
> 
> I doubt you sign your name on legal documents without a ' ' somewhere in
> it :(
> 
> Please fix up and resend.
> 
> thanks,
> 
> greg k-h
From: Rishabh Hardas <rishabhhardas@gmail.com>

Sparse was giving out a warning for symbols 'cc_set_ree_fips_status' and 'fips_handler'
that they were not declared and need to be made static. This patch makes both the symbols
static inline, to remove the warnings.

Signed-off-by: Rishabh Hardas <rishabhhardas@gmail.com>
---
 drivers/staging/ccree/ssi_fips.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 369ddf9..63bcca7 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,1 +40,1 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }

 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
-void fips_handler(struct ssi_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static inline void fips_handler(struct ssi_drvdata *drvdata) {}

 #endif /* CONFIG_CRYPTO_FIPS */
