From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error
	allocating crypto tfm
Date: Thu, 9 Apr 2009 10:35:47 +0800
Message-ID: <20090409023547.GA1878@gondor.apana.org.au>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com> <20090409021804.GA1756@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, arjan@linux.intel.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Jiri Slaby <jirislaby@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757146AbZDICgT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090409021804.GA1756@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 09, 2009 at 10:18:04AM +0800, Herbert Xu wrote:
>
> It looks like try_then_request_module has been broken such that it
> returns without waiting for the module to complete loading.  I'm
> looking into it.

OK, it's caused by

commit acae05156551fd7528fbb616271e672789388e3c
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Feb 8 10:42:01 2009 -0800

    module: create a request_module_nowait()

This should fix it.

module: try_then_request_module must wait

Since the whole point of try_then_request_module is to retry
the operation after a module has been loaded, we must wait for
the module to fully load.

Otherwise all sort of things start breaking, e.g., you won't
be able to read your encrypted disks on the first attempt.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index d5fa565..384ca8b 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -34,7 +34,7 @@ extern int __request_module(bool wait, const char *name, ...) \
 #define request_module(mod...) __request_module(true, mod)
 #define request_module_nowait(mod...) __request_module(false, mod)
 #define try_then_request_module(x, mod...) \
-	((x) ?: (__request_module(false, mod), (x)))
+	((x) ?: (__request_module(true, mod), (x)))
 #else
 static inline int request_module(const char *name, ...) { return -ENOSYS; }
 static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
