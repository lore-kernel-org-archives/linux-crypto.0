From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] Fix late crypto work queue initialization
Date: Tue, 25 Mar 2014 16:40:56 -0700
Message-ID: <1395790856.2970.33.camel@schen9-DESK>
References: <1395100347.2970.14.camel@schen9-DESK>
	 <20140321144040.GD25820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140321144040.GD25820@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2014-03-21 at 22:40 +0800, Herbert Xu wrote:
> On Mon, Mar 17, 2014 at 04:52:26PM -0700, Tim Chen wrote:
> > The crypto algorithm modules utilizing the crypto daemon could
> > be used early when the system start up.  Using module_init
> > does not guarantee that the daemon's work queue is initialized
> > when the cypto alorithm depending on crypto_wq starts.  It is necessary
> > to initialize the crypto work queue earlier at the subsystem
> > init time to make sure that it is initialized
> > when used.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Patch applied.

Herbert,

Probably this patch should go to the stable patches as well.
Copying Greg.

Thanks.

Tim
