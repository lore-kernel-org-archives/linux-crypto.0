From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Is kernel optimized with dead store removal?
Date: Thu, 25 Feb 2010 20:58:01 -0300
Message-ID: <20100225235801.GE5218@khazad-dum.debian.net>
References: <4B85A49E.6000803@gmail.com>
 <19334.22971.970220.245930@pilspetsen.it.uu.se>
 <4B8693B9.3060102@gmail.com>
 <19334.40943.479593.304961@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roel Kluin <roel.kluin@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19334.40943.479593.304961@pilspetsen.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 25 Feb 2010, Mikael Pettersson wrote:
>  > In the sha1_update() case I don't know whether the stack is recycled and
>  > leaked - it may be dependent on the calling function, but isn't it
>  > vulnerable?
> 
> It's only vulnerable if the data leaks to a less trusted domain.

If it is anything you wanted to protect badly enough that you already have
code to clobber it later, this *is* a security bug.

Not only you remove one layer of security, you also widen a lot the window
of opportunity to, e.g., http://en.wikipedia.org/wiki/Cold_boot_attack

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
