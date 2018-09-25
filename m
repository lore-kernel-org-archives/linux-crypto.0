From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] hwrng: document the quality field
Date: Tue, 25 Sep 2018 12:35:18 -0400
Message-ID: <20180925162924.378725-1-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        matthias.bgg@gmail.com, Liam.Merwick@oracle.com,
        Jim.Quigley@oracle.com, linux-crypto@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>, dgilbert@redhat.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

quality field is currently documented as being 'per mill'.  In fact the
math involved is:

                add_hwgenerator_randomness((void *)rng_fillbuf, rc,
                                           rc * current_quality * 8 >> 10);

thus the actual definition is "bits of entropy per 1024 bits of input".

The current documentation seems to have confused multiple people
in the past, let's fix the documentation to match code.

An alternative is to change core to match driver expectations, replacing
	rc * current_quality * 8 >> 10
with
	rc * current_quality / 1000
but that has performance costs, so probably isn't a good option.

Fixes: 0f734e6e768 ("hwrng: add per-device entropy derating")
Reported-by: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---


 drivers/char/hw_random/core.c | 4 ++--
 include/linux/hw_random.h     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aaf9e5afaad4..95be7228f327 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -44,10 +44,10 @@ static unsigned short default_quality; /* = 0; default to "off" */
 
 module_param(current_quality, ushort, 0644);
 MODULE_PARM_DESC(current_quality,
-		 "current hwrng entropy estimation per mill");
+		 "current hwrng entropy estimation per 1024 bits of input");
 module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
-		 "default entropy content of hwrng per mill");
+		 "default entropy content of hwrng per 1024 bits of input");
 
 static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index bee0827766a3..c0b93e0ff0c0 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -33,7 +33,8 @@
  *			and max is a multiple of 4 and >= 32 bytes.
  * @priv:		Private data, for use by the RNG driver.
  * @quality:		Estimation of true entropy in RNG's bitstream
- *			(per mill).
+ *			(in bits of entropy per 1024 bits of input;
+ *			valid values: 1 to 1024, or 0 for unknown).
  */
 struct hwrng {
 	const char *name;
-- 
MST
