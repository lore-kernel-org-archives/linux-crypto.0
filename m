From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove incorrect __exit markup
Date: Thu, 12 Mar 2015 01:13:14 +1100
Message-ID: <20150311141314.GC5713@gondor.apana.org.au>
References: <20150309202549.GA9684@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150309202549.GA9684@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 09, 2015 at 01:25:49PM -0700, Dmitry Torokhov wrote:
> PCI bus is hot-pluggable, and even if it wasn't one can still unbind the
> device from driver via sysfs, so we should not make driver's remove
> method as __exit.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
