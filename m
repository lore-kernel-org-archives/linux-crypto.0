From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 10/11] pcmcia: fix return value of soc_pcmcia_regulator_set
Date: Thu, 10 Nov 2016 17:44:53 +0100
Message-ID: <20161110164454.293477-11-arnd@arndb.de>
References: <20161110164454.293477-1-arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ilya Dryomov <idryomov@gmail.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Jiri Kosina <jikos@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Marek <mmarek@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Young <sean@mess.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        x86@kernel.org, linux-kbuild@vger.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161110164454.293477-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The newly introduced soc_pcmcia_regulator_set() function sometimes returns
without setting its return code, as shown by this warning:

drivers/pcmcia/soc_common.c: In function 'soc_pcmcia_regulator_set':
drivers/pcmcia/soc_common.c:112:5: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This changes it to propagate the regulator_disable() result instead.

Fixes: ac61b6001a63 ("pcmcia: soc_common: add support for Vcc and Vpp regulators")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pcmcia/soc_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index 153f312..b6b316d 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -107,7 +107,7 @@ int soc_pcmcia_regulator_set(struct soc_pcmcia_socket *skt,
 
 		ret = regulator_enable(r->reg);
 	} else {
-		regulator_disable(r->reg);
+		ret = regulator_disable(r->reg);
 	}
 	if (ret == 0)
 		r->on = on;
-- 
2.9.0
