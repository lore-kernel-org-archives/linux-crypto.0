From: Rishabh Hardas <rishabhhardas@gmail.com>
Subject: Re: [PATCH] staging/ccree: Declare compiled out fuctions static inline
Date: Tue, 22 Aug 2017 19:09:19 +0530
Message-ID: <20170822133910.GA20940@rishabh-linux>
References: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
 <20170816220909.GB29988@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20170816220909.GB29988@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

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

>From 717ec264a6212b8526c381d3673dd0ee45352266 Mon Sep 17 00:00:00 2001
From: Rishabh Hardas <rishabhhardas@gmail.com>
Date: Tue, 22 Aug 2017 18:56:45 +0530
Subject: [PATCH v2] staging/ccree: Declare compiled out fuctions static inline

Signed-off-by: Rishabh Hardas <rishabhhardas@gmail.com>
---

Changes in v2:
	Corrected my Name.
 drivers/staging/ccree/ssi_fips.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 369ddf9..63bcca7 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,8 +40,8 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }

 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
-void fips_handler(struct ssi_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static inline void fips_handler(struct ssi_drvdata *drvdata) {}

 #endif /* CONFIG_CRYPTO_FIPS */

--
1.9.1
