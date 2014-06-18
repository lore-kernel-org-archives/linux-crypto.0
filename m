From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] [TRIVIAL] Remove MPILIB_EXTRA
Date: Wed, 18 Jun 2014 16:18:36 +0200
Message-ID: <1403101116.1984.120.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-6-git-send-email-richard@nod.at>
	 <1391977123.25855.24.camel@x220> <1397552794.1985.19.camel@x220>
	 <20140415092147.GA4302@pd.tnic> <1403078994.1984.47.camel@x220>
	 <20140618094821.GA24024@pd.tnic>
	 <alpine.LNX.2.00.1406181237480.2303@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Richard Weinberger <richard@nod.at>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>,
	James Morris <james.l.morris@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1406181237480.2303@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Richard Weinberger <richard@nod.at>

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Bounced to trivial. Tested with make menuconfig and make oldconfig.
Since I'm sending this to Jiri myself I've upgraded my Acked-by to
Signed-off-by.

 crypto/asymmetric_keys/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 03a6eb95ab50..0320c7d4b3e1 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
-	select MPILIB_EXTRA
 	select MPILIB
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
-- 
1.9.3
